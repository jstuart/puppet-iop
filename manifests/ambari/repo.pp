define iop::ambari::repo(
  $repoid    = undef,
  $reponame  = undef,
  $baseurl   = undef,
  $gpgcheck  = true,
  $sslverify = true,
  $order     = '20',
) {
  
  if $repoid {
    validate_re($iop::params::repo_name_regex, $repoid, "Invalid repoid: \$repoid='${repoid}'; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_repoid = $repoid
  } else {
    validate_re($iop::params::repo_name_regex, $name, "Invalid repoid: \$name='${name}'; specify \$repoid to override; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_repoid = $name
  }
  
  if $reponame {
    validate_re($iop::params::repo_name_regex, $reponame, "Invalid reponame: \$reponame='${reponame}'; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_reponame = $reponame
  } else {
    validate_re($iop::params::repo_name_regex, $name, "Invalid reponame: \$name='${name}'; specify \$reponame to override; valid characters are A-Z, a-z, 0-9, _, -, and .")
    $real_reponame = $name
  }
  
  validate_string($baseurl)
  validate_bool($gpgcheck)
  validate_bool($sslverify)
  validate_re($iop::params::repo_order_regex, $order, "Invalid order: \$order='${order}'; use a numeric value between 10 and 89")
  
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