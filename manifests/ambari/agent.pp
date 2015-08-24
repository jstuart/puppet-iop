# Ambari Agent setup
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
    notify  => Service['ambari-agent'],
  }

  concat { $iop::params::ambari_agent_repoinfo_4_0:
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['ambari-agent'],
  }
  
  concat::fragment { 'iop-agent-prefix-repo-4_0':
    target  => $iop::params::ambari_agent_repoinfo_4_0,
    content => template($iop::params::ambari_repoinfo_4_0_template_begin),
    order   => '00',
  }

  concat::fragment { 'iop-agent-suffix-repo-4_0':
    target  => $iop::params::ambari_agent_repoinfo_4_0,
    content => template($iop::params::ambari_repoinfo_4_0_template_end),
    order   => '99',
  }
  
  concat { $iop::params::ambari_agent_repoinfo_4_1:
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['ambari-agent'],
  }
  
  concat::fragment { 'iop-agent-prefix-repo-4_1':
    target  => $iop::params::ambari_agent_repoinfo_4_1,
    content => template($iop::params::ambari_repoinfo_4_1_template_begin),
    order   => '00',
  }

  concat::fragment { 'iop-agent-suffix-repo-4_1':
    target  => $iop::params::ambari_agent_repoinfo_4_1,
    content => template($iop::params::ambari_repoinfo_4_1_template_end),
    order   => '99',
  }
  
  service { 'ambari-agent':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => File['ambari_agent_config'],
  }
}