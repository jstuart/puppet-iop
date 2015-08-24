# Mapred user
class iop::users::mapred (
  $username = 'mapred',
  $uid      = '1205',
  $home     = '/home/mapred',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Mapred:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-mapred':
    username    => $iop::users::mapred::username,
    uid         => $iop::users::mapred::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::mapred::home,
  }
}