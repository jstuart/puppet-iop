# Hadoop Group
class iop::groups::hadoop (
  $groupname = 'hadoop',
  $gid       = '1201',
) {
  iop::lgroup { 'iop-group-hadoop':
    groupname => $iop::groups::hadoop::groupname,
    gid       => $iop::groups::hadoop::gid,
  }
}