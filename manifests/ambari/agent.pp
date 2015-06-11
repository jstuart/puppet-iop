class iop::ambari::agent (
  
) {
  require iop::users::ambari
  require iop::yum
  
    package { 'ambari-agent': }
}