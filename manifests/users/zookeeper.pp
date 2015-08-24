# Zookeeper user
class iop::users::zookeeper (
  $username = 'zookeeper',
  $uid      = '1202',
  $home     = '/home/zookeeper',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Zookeeper:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-zookeeper':
    username    => $iop::users::zookeeper::username,
    uid         => $iop::users::zookeeper::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::zookeeper::home,
  }
}