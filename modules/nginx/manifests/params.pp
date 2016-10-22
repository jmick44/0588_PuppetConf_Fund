class nginx::params { 
  case $::osfamily {
    'redhat','debian' : {
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $docroot = '/var/www'
      $confdir = '/etc/nginx'
      $blockdir = '/etc/nginx/conf.d'
      $logdir = '/var/log/nginx'
      $service = 'nginx'
    }
    default : {
      fail("This osfamily is not supported")
    }
  }

  $user = $::osfamily ? {
    'redhat' => 'nginx',
    'Debian' => 'www-data',
    default  => 'fail',
  }

  if $user == 'fail' {
    fail("This osfamily is not supported")
  }
}
