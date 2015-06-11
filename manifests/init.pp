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
  $ambari_server = false,
  $ambari_agent  = false,
) {
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
