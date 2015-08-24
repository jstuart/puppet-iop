# Ambari Group
class iop::groups::ambari (
  $groupname = 'ambari',
  $gid       = '1200',
) {
  iop::lgroup { 'ambari':
    groupname => $iop::groups::ambari::groupname,
    gid       => $iop::groups::ambari::gid,
  }
}