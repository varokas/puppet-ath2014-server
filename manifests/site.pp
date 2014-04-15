include 'golang'

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
