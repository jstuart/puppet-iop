class iop::groups::ambari (
  $name = 'ambari',
  $gid  = '1200',
) {
  validate_string($name)
  validate_re($iop::groups::ambari::name, $iop::params::user_regex, "Invalid username: \$name='${iop::groups::ambari::name}'")
  
  validate_string($gid)
  validate_re($iop::groups::ambari::gid, '^\d+$', "Invalid GID: \$gid='${iop::groups::ambari::gid}'")
  
  group { 'ambari':
    ensure => present,
    name   => $iop::groups::ambari::name,
    gid    => $iop::groups::ambari::gid,
  }
}