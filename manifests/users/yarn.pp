# Yarn user
class iop::users::yarn (
  $username = 'yarn',
  $uid      = '1204',
  $home     = '/home/yarn',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Yarn:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-yarn':
    username    => $iop::users::yarn::username,
    uid         => $iop::users::yarn::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::yarn::home,
  }
}