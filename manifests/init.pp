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
  $ambari_server         = false,
  $ambari_agent          = false,
  $ambari_server_fqdn    = '',
  $install_java          = true,
  $java_packages         = ['java-1.7.0-openjdk-devel'],
  $java_home             = '/usr/lib/jvm/java-1.7.0',
  $provision_local_users = true,
) {
  validate_bool($iop::ambari_server)
  validate_bool($iop::ambari_agent)
  validate_string($iop::ambari_server_fqdn)
  if $iop::ambari_agent == true {
    validate_re($iop::ambari_server_fqdn, '^.+$', 'The parameter $ambari_server_fqdn is required when $ambari_agent is true.')
  }

  validate_bool($iop::install_java)
  if $iop::install_java == true {
    validate_array($iop::java_packages)
    if size($iop::java_packages) < 1 {
      fail('The parameter $java_packages must have at least one element when $install_java is true.')
    }
  }
  
  validate_absolute_path($iop::java_home)
  
  validate_bool($iop::provision_local_users)

  # Use Open JDK
  # ensure_packages(['java-1.7.0-openjdk', 'java-1.7.0-openjdk-devel'])
  # /usr/lib/jvm/java-1.7.0/ or /usr/lib/jvm/jre-1.7.0/
  # /usr/lib/jvm/java-1.7.0-openjdk.x86_64/ or /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/
  
  
  
  if $iop::install_java == true {
    ensure_packages($java_packages)
  }
  
  if $iop::provision_local_users == true {
    include iop::localusers
  }

  if $iop::ambari_server == true or $iop::ambari_agent == true {
    include iop::yum
    include iop::groups::ambari
    include iop::users::ambari
    
    # Add the IOP repo to Ambari
    iop::ambari::repo { 'iop-4.0':
      repoid    => 'IOP-4.0',
      reponame  => 'IOP-4.0',
      baseurl   => $iop::yum::iop_4_0_repo_uri,
      gpgcheck  => $iop::yum::gpg_check,
      sslverify => $iop::yum::ssl_verify,
      iopvers   => ['4.0'],
      order     => '10'
    }
    
    # Add the IOP-UTIL repo to Ambari
    iop::ambari::repo { 'iop-utils-1.0':
      repoid    => 'IOP-UTILS-1.0',
      reponame  => 'IOP-UTILS-1.0',
      baseurl   => $iop::yum::iop_utils_1_0_repo_uri,
      gpgcheck  => $iop::yum::gpg_check,
      sslverify => $iop::yum::ssl_verify,
      iopvers   => ['4.0'],
      order     => '11'
    }
    
    # Add the IOP repo to Ambari
    iop::ambari::repo { 'iop-4.1':
      repoid    => 'IOP-4.1',
      reponame  => 'IOP-4.1',
      baseurl   => $iop::yum::iop_4_1_repo_uri,
      gpgcheck  => $iop::yum::gpg_check,
      sslverify => $iop::yum::ssl_verify,
      iopvers   => ['4.1'],
      order     => '10'
    }
    
    # Add the IOP-UTIL repo to Ambari
    iop::ambari::repo { 'iop-utils-1.1':
      repoid    => 'IOP-UTILS-1.1',
      reponame  => 'IOP-UTILS-1.1',
      baseurl   => $iop::yum::iop_utils_1_1_repo_uri,
      gpgcheck  => $iop::yum::gpg_check,
      sslverify => $iop::yum::ssl_verify,
      iopvers   => ['4.1'],
      order     => '11'
    }
  }
  if $iop::ambari_server == true {
    include iop::ambari::server
  }
  if $iop::ambari_agent == true {
    include iop::ambari::agent
  }
}
