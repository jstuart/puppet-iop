# Hive user
class iop::users::hive (
  $username = 'hive',
  $uid      = '1209',
  $home     = '/home/hive',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Hive:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-hive':
    username    => $iop::users::hive::username,
    uid         => $iop::users::hive::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::hive::home,
  }
}