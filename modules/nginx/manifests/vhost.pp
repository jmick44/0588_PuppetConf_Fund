define nginx::vhost (
  $docroot,
  $port = '80',
){

  file { "${docroot}/${title}":
    ensure => directory,
  }

  file { "${docroot}/${title}/${title}.conf":
    ensure  => file,
    content => "port = ${port}",
  }
}

