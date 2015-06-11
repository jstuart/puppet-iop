class iop::ambari::server (
  
) {
  require iop::users::ambari
  require iop::yum
  
  package { 'ambari-server': }

  $iop_repo_uri = $iop::yum::iop_repo_uri
  $iop_utils_repo_uri = $iop::yum::iop_utils_repo_uri  
  file { '/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml':
    content => template("${module_name}/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml.erb"),
  }
}