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

  $iop_repo_uri = $iop::yum::iop_repo_uri
  $iop_utils_repo_uri = $iop::yum::iop_utils_repo_uri
  $ssl_verify = $iop::yum::ssl_verify
  $gpg_check = $iop::yum::gpg_check
  file { $iop::params::ambari_server_repoinfo:
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template($iop::params::ambari_repoinfo_template),
    require => Package['ambari-server'],
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