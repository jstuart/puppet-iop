class iop::params {
  
  # Yum related params
  $gpg_key_iop = '/etc/pki/rpm-gpg/RPM-GPG-KEY-IOP'
  $gpg_key_hdp = '/etc/pki/rpm-gpg/RPM-GPG-KEY-IOP'
  $ambari_repo_file = '/etc/yum.repos.d/ambari.repo'
  
  # Constants
  $user_regex = '^[a-zA-Z][a-zA-Z0-9]*$'
}