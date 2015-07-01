# Ambari Server setup
class iop::ambari::server {
  include iop::params
  require iop::users::ambari
  require iop::yum
  
  package { 'ambari-server':
    ensure  => installed,
    require => File[$iop::params::ambari_repo_file],
    notify  => Exec['ambar_server_setup'],
  }
  
  $ambari_user = $iop::users::ambari::username
  $java_home   = $iop::java_home
  file { 'ambari_server_config':
    path    => '/etc/ambari-server/conf/ambari.properties',
    owner   => $iop::users::ambari::username,
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/etc/ambari-server/conf/ambari.properties.erb"),
    require => Package['ambari-server'],
    notify  => Exec['ambar_server_setup'],
  }


  concat { $iop::params::ambari_server_repoinfo:
    owner   => $iop::users::ambari::username,
    group   => 'root',
    mode    => '0755',
    require => Package['ambari-server'],
  }
  
  concat::fragment { 'iop-server-prefix-repo':
    target  => $iop::params::ambari_server_repoinfo,
    content => template($iop::params::ambari_repoinfo_template_begin),
    order   => '00',
  }

  concat::fragment { 'iop-server-suffix-repo':
    target  => $iop::params::ambari_server_repoinfo,
    content => template($iop::params::ambari_repoinfo_template_end),
    order   => '99',
  }
  
  exec { 'ambar_server_setup':
    command     => 'service ambari-server setup -s',
    cwd         => '/root',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    user        => 'root',
    umask       => '022',
    refreshonly => true,
    require     => File['ambari_server_config'],
    before      => Service['ambari-server'],
  }
  
  service { 'ambari-server':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    # ambari-server service doesn't return LSB exit codes, even though ambari-agent does
    status     => '/sbin/service ambari-server status | /bin/grep "^Ambari Server running$" >/dev/null',
    require    => File['ambari_server_config'],
  }
}