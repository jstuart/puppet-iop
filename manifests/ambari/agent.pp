class iop::ambari::agent {
  include iop::params
  require iop::users::ambari
  require iop::yum
  
  package { 'ambari-agent':
    require => File[$iop::params::ambari_repo_file],
  }
  
  $ambari_server_fqdn = $iop::ambari_server_fqdn
  file { 'ambari_agent_config':
    path    => '/etc/ambari-agent/conf/ambari-agent.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/etc/ambari-agent/conf/ambari-agent.ini.erb"),
    require => Package['ambari-agent'],
  }
    
  $iop_repo_uri = $iop::yum::iop_repo_uri
  $iop_utils_repo_uri = $iop::yum::iop_utils_repo_uri
  $ssl_verify = $iop::yum::ssl_verify
  $gpg_check = $iop::yum::gpg_check
  file { $iop::params::ambari_agent_repoinfo:
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template($iop::params::ambari_repoinfo_template),
    require => Package['ambari-agent'],
  }
  
  service { 'ambari-agent':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => File['ambari_agent_config'],
  }
}