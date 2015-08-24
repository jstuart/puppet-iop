# Ambari Monitoring System user
class iop::users::ams (
  $username = 'ams',
  $uid      = '1216',
  $home     = '/home/ams',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Ambari Monitoring System:
  #   No named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-ams':
    username     => $iop::users::ams::username,
    uid          => $iop::users::ams::uid,
    create_group => false,
    primary_gid  => $iop::groups::hadoop::gid,
    home         => $iop::users::ams::home,
  }
}