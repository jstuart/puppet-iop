# HBase user
class iop::users::hbase (
  $username = 'hbase',
  $uid      = '1207',
  $home     = '/home/hbase',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # HBase:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-hbase':
    username    => $iop::users::hbase::username,
    uid         => $iop::users::hbase::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::hbase::home,
  }
}