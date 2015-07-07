# Common parameters for the IOP module
class iop::params {
  
  # Yum related params
  $gpg_key_iop = '/etc/pki/rpm-gpg/RPM-GPG-KEY-IOP'
  $gpg_key_hdp = '/etc/pki/rpm-gpg/RPM-GPG-KEY-HDP'
  $ambari_repo_file = '/etc/yum.repos.d/ambari.repo'
  
  # Ambari repo related params
  $ambari_repoinfo_template_begin = "${module_name}/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml.begin.erb"
  $ambari_repoinfo_template_repo = "${module_name}/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml.bodypart.erb"
  $ambari_repoinfo_template_end = "${module_name}/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml.end.erb"
  $ambari_server_repoinfo = '/var/lib/ambari-server/resources/stacks/BigInsights/4.0/repos/repoinfo.xml'
  $ambari_agent_repoinfo = '/var/lib/ambari-agent/cache/stacks/BigInsights/4.0/repos/repoinfo.xml'
  $ambari_server_properties = '/etc/ambari-server/conf/ambari.properties'
  
  # Names
  $ambari_server_package = 'ambari-server'
  $ambari_server_service = 'ambari-server'
  
  # Constants
  $user_regex = '^[a-zA-Z][a-zA-Z0-9_-]*$'
  $uid_regex  = '^\d+$'
  $repo_name_regex = '^[A-Za-z0-9-_.]+$'
  $repo_order_regex = '^[1-8][0-9]$'
}