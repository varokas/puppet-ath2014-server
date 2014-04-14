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
