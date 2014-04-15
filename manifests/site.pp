include 'golang'
package { 'bzr':
  ensure => 'present'
}

class {'::mongodb::globals':
  manage_package_repo => true,
}->
class {'::mongodb::server': 
  auth => true
}->
mongodb::db { 'ath2014':
  user => 'ath2014',
  password => hiera('mongo_password') 
}

$users_default = { 
    ensure => "present",
    managehome => true,
    gid => "sudo",
    shell => "/bin/bash",
}
$ath2014_user_password = hiera("ath2014_user_password") 
$users = {
  "ath2014" => {
    password => generate('/bin/sh', '-c', "openssl passwd -1 ${ath2014_user_password} | tr -d '\n'") 
  }
}
create_resources(user, $users, $users_default) 

cron { mongobackup: 
  command => "mongodump --db ath2014 --out /backup/`date +%Y-%m-%d`",
  user => "root",
  hour => 0,
  minute => 0
}

class { 'haproxy': }
haproxy::frontend { 'web':
    ipaddress => '0.0.0.0', 
    ports     => '80',
    options   => { 
      'default_backend' => 'ath2014'
    }
}

haproxy::backend { 'ath2014':
  options => {
    'server' => 'localhost 127.0.0.1:3000'
  }
}

