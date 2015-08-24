# Oozie user
class iop::users::oozie (
  $username = 'oozie',
  $uid      = '1206',
  $home     = '/home/oozie',
  $users_groups = ['users'],
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Oozie:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-oozie':
    username    => $iop::users::oozie::username,
    uid         => $iop::users::oozie::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::oozie::home,
    add_groups  => $iop::users::oozie::users_groups,
  }
}