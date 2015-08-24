# Sqoop user
class iop::users::sqoop (
  $username = 'sqoop',
  $uid      = '1214',
  $home     = '/home/sqoop',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Sqoop:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-sqoop':
    username    => $iop::users::sqoop::username,
    uid         => $iop::users::sqoop::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::sqoop::home,
  }
}