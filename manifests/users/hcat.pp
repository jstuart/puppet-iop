# HCat user
class iop::users::hcat (
  $username = 'hcat',
  $uid      = '1215',
  $home     = '/home/hcat',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # HCat:
  #   No named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-hcat':
    username     => $iop::users::hcat::username,
    uid          => $iop::users::hcat::uid,
    create_group => false,
    primary_gid  => $iop::groups::hadoop::gid,
    home         => $iop::users::hcat::home,
  }
}