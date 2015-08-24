# Spark user
class iop::users::spark (
  $username = 'spark',
  $uid      = '1211',
  $home     = '/home/spark',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Spark:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-spark':
    username    => $iop::users::spark::username,
    uid         => $iop::users::spark::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::spark::home,
  }
}