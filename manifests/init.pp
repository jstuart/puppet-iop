# Class: iop
#
# This module manages the configuration of IBM Open Platform with Apache Hadoop.
#
# Notes:
#  * This is designed specifically for Enterprise Linux 6 based systems. Others
#    will not work.
#  * You must obtain the software yourself, agreeing to any and all terms required
#    by IBM.  See [Obtaining software for the IBM Open Platform with Apache Hadoop](http://www-01.ibm.com/support/knowledgecenter/SSPT3X_4.0.0/com.ibm.swg.im.infosphere.biginsights.install.doc/doc/bi_inst_iop.html)
#  * This module does not support the removal of software.
#
# Parameters:
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
# * Simple usage
#
#     include iop
#
class iop (
  $ambari_server      = false,
  $ambari_agent       = false,
  $ambari_server_fqdn = '',
  $install_java       = true,
  $java_packages      = ['java-1.7.0-openjdk-devel'],
  $java_home          = '/usr/lib/jvm/java-1.7.0',
) {
  validate_bool($ambari_server)
  validate_bool($ambari_agent)
  validate_string($ambari_server_fqdn)  
  if $ambari_agent == true {
    validate_re($ambari_server_fqdn, '^.+$', 'The parameter $ambari_server_fqdn is required when $ambari_agent is true.') 
  }

  validate_bool($install_java)
  if $install_java == true {
    validate_array($java_packages)
    if size($java_packages) < 1 {
      fail('The parameter $java_packages must have at least one element when $install_java is true.')
    }
  }
  
  validate_absolute_path($java_home)

  # Use Open JDK
  # ensure_packages(['java-1.7.0-openjdk', 'java-1.7.0-openjdk-devel'])
  # /usr/lib/jvm/java-1.7.0/ or /usr/lib/jvm/jre-1.7.0/
  # /usr/lib/jvm/java-1.7.0-openjdk.x86_64/ or /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/
  
  
  
  if $install_java == true {
    ensure_packages($java_packages)
  }

  if $ambari_server == true or $ambari_agent == true {
    include iop::yum
    include iop::groups::ambari
    include iop::users::ambari
  }
  if $ambari_server == true {
    include iop::ambari::server
  }
  if $ambari_agent == true {
    include iop::ambari::agent
  }
}
