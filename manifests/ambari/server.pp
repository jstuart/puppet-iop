# Ambari Server setup
class iop::ambari::server {
  include iop::params
  require iop::users::ambari
  require iop::yum
  
  package { $iop::params::ambari_server_package:
    ensure  => installed,
    require => File[$iop::params::ambari_repo_file],
    notify  => Exec['ambari_server_setup'],
  }
  
  # This is kind of a hack, but since we only care about two of the properties in the configuration
  # and it gets rewritten and reordered all the time, we'll just check for our values and replace the
  # file if they're not there.  This approach is leaves much to be desired as all we're really trying
  # to do is run some sane defaults before running setup for the first time.  It seems like we could
  # very easily hit a scenario where we'd blow away changes that we'd intentionally made. 
  $ambari_user = $iop::users::ambari::username
  $java_home   = $iop::java_home
  $check_command = "grep '^ambari-server.user=${ambari_user}\$' '${iop::params::ambari_server_properties}' >/dev/null 2>&1 && grep '^java.home=${java_home}\$' '${iop::params::ambari_server_properties}' >/dev/null 2>&1"
  
  exec { 'ambari_server_config_rm':
    path    => '/bin',
    user    => 'root',
    command => "rm -f '${iop::params::ambari_server_properties}'",
    unless  => $check_command,
    require => Package[$iop::params::ambari_server_package],
    before  => File['ambari_server_config'],
  }
  
  # Replace = false, so run only when exec has removed the file.
  file { 'ambari_server_config':
    path    => $iop::params::ambari_server_properties,
    owner   => $iop::users::ambari::username,
    group   => 'root',
    mode    => '0644',
    replace => 'no',
    content => template("${module_name}/etc/ambari-server/conf/ambari.properties.erb"),
    require => [Package[$iop::params::ambari_server_package], Exec['ambari_server_config_rm']],
    before  => Exec['ambari_server_setup'],
    notify  => Exec['ambari_server_setup'],
  }

  concat { $iop::params::ambari_server_repoinfo_4_0:
    owner   => $iop::users::ambari::username,
    group   => 'root',
    mode    => '0755',
    require => Package[$iop::params::ambari_server_package],
  }
  
  concat::fragment { 'iop-server-prefix-repo-4_0':
    target  => $iop::params::ambari_server_repoinfo_4_0,
    content => template($iop::params::ambari_repoinfo_4_0_template_begin),
    order   => '00',
  }

  concat::fragment { 'iop-server-suffix-repo-4_0':
    target  => $iop::params::ambari_server_repoinfo_4_0,
    content => template($iop::params::ambari_repoinfo_4_0_template_end),
    order   => '99',
  }
  
  concat { $iop::params::ambari_server_repoinfo_4_1:
    owner   => $iop::users::ambari::username,
    group   => 'root',
    mode    => '0755',
    require => Package[$iop::params::ambari_server_package],
  }
  
  concat::fragment { 'iop-server-prefix-repo-4_1':
    target  => $iop::params::ambari_server_repoinfo_4_1,
    content => template($iop::params::ambari_repoinfo_4_1_template_begin),
    order   => '00',
  }

  concat::fragment { 'iop-server-suffix-repo-4_1':
    target  => $iop::params::ambari_server_repoinfo_4_1,
    content => template($iop::params::ambari_repoinfo_4_1_template_end),
    order   => '99',
  }
  
  exec { 'ambari_server_setup':
    command     => 'service ambari-server setup -s',
    cwd         => '/root',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    user        => 'root',
    umask       => '022',
    refreshonly => true,
    require     => Package[$iop::params::ambari_server_package],
    before      => Service[$iop::params::ambari_server_service],
  }
  
  service { $iop::params::ambari_server_service:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    # ambari-server service doesn't return LSB exit codes, even though ambari-agent does
    status     => '/sbin/service ambari-server status | /bin/grep "^Ambari Server running$" >/dev/null',
    require    => File['ambari_server_config'],
  }
}