# Local user account
define iop::luser (
  $username     = '',
  $uid          = undef,
  $shell        = '/bin/bash',
  $create_home  = true,
  $home         = '',
  $create_group = true,
  $primary_gid  = '',
  $add_groups   = [],
) {
  include ::iop::params
  validate_string($username)
  validate_re($uid, '^\d+$', 'The value of $uid must be numeric.')
  validate_absolute_path($shell)
  validate_bool($create_home)
  validate_string($home)
  validate_bool($create_group)
  validate_string($primary_gid)
  if $create_group == false or $primary_gid != '' {
    validate_re($primary_gid, '^\d+$', "Invalid primary group GID (${name}): \$primary_gid='${primary_gid}'; make value '' to use create group, if \$create_group is true")
  }
  validate_array($add_groups)

  if $username != '' {
    validate_re($username, $::iop::params::user_regex, "Invalid username: \$username='${username}'")
    $real_username = $username
  } else {
    validate_re($name, $::iop::params::user_regex, "Invalid username: \$name='${name}'; specify \$username to override")
    $real_username = $name
  }
  
  if $create_home {
    if $home != '' {
      validate_absolute_path($home)
      $real_home = $home
    } else {
      $real_home = "${::iop::params::homedir_base}/${real_username}"
    }
  } else {
    $real_home = ''
  }

  if $primary_gid != '' {
    $real_gid = $primary_gid
    if $create_group == true {
      $real_groups = flatten([$add_groups, $real_username])
    } else {
      $real_groups = $add_groups
    }
  } else {
    $real_gid = $uid
    $real_groups = $add_groups
  }

  if $create_group {
    iop::lgroup { $name:
      groupname => $real_username,
      gid       => $uid,
    }
    $req_group = [Iop::Lgroup[$name]]
  } else {
    $req_group = []
  }

  if $create_home {
    file { "${name}-home":
      ensure => directory,
      path   => $real_home,
      owner  => $uid,
      group  => $real_gid,
      mode   => '0750',
    }
    $req_home = [File[$real_home]]
  } else {
    $req_home = []
  }

  user { $name:
    ensure     => present,
    name       => $real_username,
    uid        => $uid,
    gid        => $real_gid,
    groups     => $real_groups,
    comment    => "puppet - ${module_name}",
    managehome => $create_home,
    shell      => $shell,
    home       => $real_home,
    require    => flatten([$req_home, $req_group]),
  }
}