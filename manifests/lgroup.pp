# Create a local group
define iop::lgroup (
  $groupname = '',
  $gid       = undef,
) {
  include ::iop::params
  validate_string($groupname)
  validate_re($gid, '^\d+$', 'The value of $gid must be numeric.')

  if $groupname != '' {
    validate_re($groupname, $::iop::params::user_regex, "Invalid groupname: \$groupname='${groupname}'")
    $real_groupname = $groupname
  } else {
    validate_re($name, $::iop::params::user_regex, "Invalid groupname: \$name='${name}'; specify \$groupname to override")
    $real_groupname = $name
  }

  group { $name:
    ensure => present,
    name   => $real_groupname,
    gid    => $gid,
  }
}