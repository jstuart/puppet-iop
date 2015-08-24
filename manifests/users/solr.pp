# Solr user
class iop::users::solr (
  $username = 'solr',
  $uid      = '1212',
  $home     = '/home/solr',
) {
  # Requires Hadoop Group
  require iop::groups::hadoop

  # Solr:
  #   Has named group
  #   Primary group is 'hadoop'
  iop::luser { 'iop-user-solr':
    username    => $iop::users::solr::username,
    uid         => $iop::users::solr::uid,
    primary_gid => $iop::groups::hadoop::gid,
    home        => $iop::users::solr::home,
  }
}