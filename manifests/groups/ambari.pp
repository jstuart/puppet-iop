# Ambari Group
class iop::groups::ambari (
  $groupname = 'ambari',
  $gid       = '1200',
) {
  include iop::params
  
  validate_string($iop::groups::ambari::groupname)
  validate_re($iop::groups::ambari::groupname, $iop::params::user_regex, "Invalid username: \$name='${iop::groups::ambari::groupname}'")
  
  validate_string($iop::groups::ambari::gid)
  validate_re($iop::groups::ambari::gid, $iop::params::uid_regex, "Invalid GID: \$gid='${iop::groups::ambari::gid}'")
  
  group { 'ambari':
    ensure => present,
    name   => $iop::groups::ambari::groupname,
    gid    => $iop::groups::ambari::gid,
  }
}