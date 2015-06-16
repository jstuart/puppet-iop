# Common parameters for the IOP module
class iop::params {
  
  # Yum related params
  $gpg_key_iop = '/etc/pki/rpm-gpg/RPM-GPG-KEY-IOP'
  $gpg_key_hdp = '/etc/pki/rpm-gpg/RPM-GPG-KEY-HDP'
  $ambari_repo_file = '/etc/yum.repos.d/ambari.repo'
  
  # Ambari repo related params
  $ambari_repoinfo_template = "${module_name}/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml.erb"
  $ambari_server_repoinfo = '/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml'
  $ambari_agent_repoinfo = '/var/lib/ambari-agent/cache/stacks/BigInsights/4.0/repos/repoinfo.xml'
  
  # Constants
  $user_regex = '^[a-zA-Z][a-zA-Z0-9_-]*$'
  $uid_regex  = '^\d+$'
}