class iop::ambari::server (
  
) inherits iop::params {
  require iop::users::ambari
  require iop::yum
  
  package { 'ambari-server': 
    require => File[$ambari_repo_file],
  }

  $iop_repo_uri = $iop::yum::iop_repo_uri
  $iop_utils_repo_uri = $iop::yum::iop_utils_repo_uri  
  file { '/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml.erb"),
    require => Package['ambari-server'],
  }
}