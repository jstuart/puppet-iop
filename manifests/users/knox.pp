# Knox user
class iop::users::knox (
  $username = 'knox',
  $uid      = '1213',
  $home     = '/home/knox',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Knox:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-knox':
    username    => $iop::users::knox::username,
    uid         => $iop::users::knox::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::knox::home,
  }
}