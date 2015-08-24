# HDFS user
class iop::users::hdfs (
  $username = 'hdfs',
  $uid      = '1203',
  $home     = '/home/hdfs',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # HDFS:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-hdfs':
    username    => $iop::users::hdfs::username,
    uid         => $iop::users::hdfs::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::hdfs::home,
  }
}