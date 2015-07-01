# == Define Resource Type: iop::ambari::repo
#
# This type will add repo definitions to Ambari. 
#
# Parameters:
#
# $repoid::                        The ID of the repository, which will be used
#                                  as the repository filename as well as the ID
#                                  within Yum.  If this is not provided the
#                                  value of $name for this resource will be
#                                  used instead.  Values will be evaluated
#                                  against ^[A-Za-z0-9_-.]+$ to check for
#                                  validity.
#                                  Defaults to '' (will use $name).
#                                  type:string
#
# $reponame::                      The friendly name of the repository within 
#                                  Yum.  If this is not provided the
#                                  value of $name for this resource will be
#                                  used instead.  Values will be evaluated
#                                  against ^[A-Za-z0-9_-.]+$ to check for
#                                  validity.
#                                  Defaults to '' (will use $name).
#                                  type:string
#
# $baseurl::                       The URI of the Yum repository.  
#                                  Required, no default
#                                  type:string
#
# $gpgcheck::                      Flag that instructs Yum to check package
#                                  signatures prior to installation. Setting
#                                  this to false is almost always a bad idea.
#                                  Defaults to true.
#                                  type:boolean
#
# $sslverify::                     Flag that instructs Yum to check the validity
#                                  of the certificate provided by the remote
#                                  repository (e.g. https server certificate).
#                                  Setting this to false is almost always a
#                                  bad idea.
#                                  Defaults to true.
#                                  type:boolean
#
# $order::                         The order of this repository within the
#                                  repository list.  Valid values are 10-89.  
#                                  Defaults to '20'
#                                  type:string
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
# * Simple usage
#
#  iop::ambari::repo { 'iop':
#    repoid    => 'IOP-4.0',
#    reponame  => 'IOP',
#    baseurl   => 'http://ibm-open-platform.ibm.com/repos/IOP/RHEL6/x86_64/4.0',
#    gpgcheck  => true,
#    sslverify => true,
#    order     => '20'
#  }
#
#
define iop::ambari::repo(
  $repoid    = undef,
  $reponame  = undef,
  $baseurl   = undef,
  $gpgcheck  = true,
  $sslverify = true,
  $order     = '20',
) {
  
  if $repoid {
    validate_re($repoid, $iop::params::repo_name_regex, "Invalid repoid: \$repoid='${repoid}'; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_repoid = $repoid
  } else {
    validate_re($name, $iop::params::repo_name_regex, "Invalid repoid: \$name='${name}'; specify \$repoid to override; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_repoid = $name
  }
  
  if $reponame {
    validate_re($reponame, $iop::params::repo_name_regex, "Invalid reponame: \$reponame='${reponame}'; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_reponame = $reponame
  } else {
    validate_re($name, $iop::params::repo_name_regex, "Invalid reponame: \$name='${name}'; specify \$reponame to override; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_reponame = $name
  }
  
  validate_string($baseurl)
  validate_bool($gpgcheck)
  validate_bool($sslverify)
  validate_re($order, $iop::params::repo_order_regex, "Invalid order: \$order='${order}'; use a numeric value between 10 and 89")
  
  if $iop::ambari_server == true {
    concat::fragment { "iop-server-repo-${name}":
      target  => $iop::params::ambari_server_repoinfo,
      content => template($iop::params::ambari_repoinfo_template_repo),
      order   => $order,
    }
  }
  
  if $iop::ambari_agent == true {
    concat::fragment { "iop-agent-repo-${name}":
      target  => $iop::params::ambari_agent_repoinfo,
      content => template($iop::params::ambari_repoinfo_template_repo),
      order   => $order,
    }
  }
}
