# Flume user
class iop::users::flume (
  $username = 'flume',
  $uid      = '1208',
  $home     = '/home/flume',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Flume:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-flume':
    username    => $iop::users::flume::username,
    uid         => $iop::users::flume::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::flume::home,
  }
}