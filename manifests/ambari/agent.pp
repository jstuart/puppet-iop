class iop::ambari::agent (
  
) inherits iop::params {
  require iop::users::ambari
  require iop::yum
  
    package { 'ambari-agent': 
      require => File[$ambari_repo_file],
    }
}