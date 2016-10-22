class nginx (
  $message  = "Hello from nginx class with parameters",
  $package  = $nginx::params::package,
  $owner    = $nginx::params::owner,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir   = $nginx::params::logdir,
  $user     = $nginx::params::user,
) inherits nginx::params {

  notify { "My message is ------- ${message}": } 

  File {
    owner => $owner,
    group => $group,
    mode  => '0664',
  }

  package { $package:
    ensure => present,
    before => [File['/etc/nginx/nginx.conf','/etc/nginx/conf.d/default.conf']],
  }

  file { $docroot:
    ensure => directory,
    mode   => '0775',
  }

  file { "${docroot}/index.html":
    ensure  => file,
    #source => 'puppet:///modules/nginx/index.html',
    content => epp('nginx/index.html.epp'),
  }

  file { "${confdir}/nginx.conf":
    ensure   => file,
    #source  => 'puppet:///modules/nginx/nginx.conf',
    #require => Package['nginx'],
    #notify  => Service['nginx'],
    content  => epp('nginx/nginx.conf.epp',
                    {
                      user   => $user,
                      logdir => $logdir,
                    }),
  }

  file { "${blockdir}/default.conf":
    ensure   => file,
    #source  => 'puppet:///modules/nginx/default.conf',
    #require => Package['nginx'],
    #notify  => Service['nginx'],
    content  => epp('nginx/default.conf.epp',
                    {
                      docroot => $docroot,
                    }),
  }

  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [File['/etc/nginx/nginx.conf','/etc/nginx/conf.d/default.conf']],
  }

  nginx::vhost { 'misspiggy.puppet.com':
    docroot => $docroot,
  }

  nginx::vhost { 'oscar.puppet.com':
    docroot => '/var/www',
    port    => '8080',
  }
}
