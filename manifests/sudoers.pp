# == Define Resource Type: iop::sudoers
#
# This type will add sudo configuration to the system for a given user. 
#
# Parameters:
#
# $user::                          Username that this sudo configuration will
#                                  apply to.  If this is not provided the
#                                  value of $name for this resource will be
#                                  used instead.  Values will be evaluated
#                                  against ^[a-zA-Z][a-zA-Z0-9]*$ to check for
#                                  validity.
#                                  Defaults to '' (will use $name).
#                                  type:string
#
# $no_req_tty::                    Flag to disable the sudo TTY requirement for 
#                                  this user.
#                                  Defaults to false.
#                                  type:boolean
#
# $as_others::                     Flag to allow this user to execute commands 
#                                  as users other than 'root' using sudo -u.
#                                  Defaults to false.
#                                  type:boolean
#
# $no_passwd::                     Flag to allow this user to execute commands 
#                                  using sudo without requiring a password.
#                                  Defaults to true.
#                                  type:boolean
#
# $ensure::                        Status of the sudoers configuration.  Valid
#                                  values are 'present', 'absent', or 'file'.
#                                  Defaults to 'present'.
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
#  iop::sudoers { 'username': }
#
# * Complex usage
#
#  iop::sudoers { 'username-sudo-config':
#    user        => 'username',
#    no_req_tty  => true,
#    as_others   => true,
#    no_passwd   => true,
#  }
#
# * Removal
#  iop::sudoers { 'username':
#    ensure => absent,
#  }
#
#
define iop::sudoers(
  $user       = '',
  $no_req_tty = false,
  $as_others  = false,
  $no_passwd  = true,
  $ensure     = present,
) {
  validate_string($user)
  validate_bool($no_req_tty)
  validate_bool($as_others)
  validate_bool($no_passwd)
  validate_re($ensure, '^(present|absent|file)$', "The value of \$ensure must be 'present', 'absent', or 'file'.")
  
  # Allow user to be blank
  if $user != '' {
    validate_re($user, $iop::params::user_regex, "Invalid username: \$user='${user}'")
    $username = $user
  } else {
    validate_re($user, $iop::params::user_regex, "Invalid username: \$name='${name}'; specify \$user to override")
    $username = $name
  }
  
  file { "/etc/sudoers.d/${username}":
    ensure  => $ensure,
    content => template("${module_name}/etc/sudoers.d/user_template.erb")
  }
}