# Kafka user
class iop::users::kafka (
  $username = 'kafka',
  $uid      = '1217',
  $home     = '/home/kafka',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Kafka:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-kafka':
    username    => $iop::users::kafka::username,
    uid         => $iop::users::kafka::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::kafka::home,
  }
}