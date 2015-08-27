# Ambari QA user
class iop::users::ambari_qa (
  $username     = 'ambari-qa',
  $uid          = '1210',
  $home         = '/home/ambari-qa',
  $users_groups = ['users'],
) {
  # Requires Hadoop Group
  require iop::groups::hadoop
  
  # Ambari QA:
  #   No named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-ambari-qa':
    username     => $iop::users::ambari_qa::username,
    uid          => $iop::users::ambari_qa::uid,
    create_group => false,
    primary_gid  => $iop::groups::hadoop::gid,
    home         => $iop::users::ambari_qa::home,
    add_groups   => $iop::users::ambari_qa::users_groups,
  }
}