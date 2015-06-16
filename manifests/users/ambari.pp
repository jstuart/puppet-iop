# Ambari User
#
# $auth_keys must be a hash with name as the top level key,
# with a sub key called 'key' that contains the RSA public
# key, without the leading ssh-rsa and trailing comment.
# Note that you almost certainly do not want to specify any
# options beyond key. 
# 
# Example auth_keys YAML:
#
# ---
# user@host: 
#   key: AAAA....
#
class iop::users::ambari (
  $username    = 'ambari',
  $uid         = '1200',
  $home        = '/home/ambari',
  $shell       = '/bin/bash',
  $key_mgmt    = 'manual', # 'manual','automatic','none'
  $private_key = '',
  $public_key  = '',
  $auth_keys   = {},
  $purge_ssh_keys = true,
) {
  validate_string($iop::users::ambari::username)
  validate_re($iop::users::ambari::username, $iop::params::user_regex, "Invalid username: \$name='${iop::users::ambari::username}'")
  
  validate_string($iop::users::ambari::uid)
  validate_re($iop::users::ambari::uid, $iop::params::uid_regex, "Invalid UID: \$uid='${iop::users::ambari::uid}'")

  validate_absolute_path($iop::users::ambari::home)
  validate_absolute_path($iop::users::ambari::shell)
  
  validate_string($iop::users::ambari::key_mgmt)
  validate_re($iop::users::ambari::key_mgmt, '^(manual|automatic|none)$')
  
  if $key_mgmt == 'manual' {
    validate_string($iop::users::ambari::private_key)
    validate_string($iop::users::ambari::public_key)
  }
  
  validate_hash($iop::users::ambari::auth_keys)
  validate_bool($iop::users::ambari::purge_ssh_keys)
  
  require iop::groups::ambari
  
  user { 'ambari':
    ensure         => present,
    name           => $iop::users::ambari::username,
    uid            => $iop::users::ambari::uid,
    gid            => $iop::groups::ambari::gid,
    comment        => 'IOP - Ambari',
    managehome     => true,
    shell          => $iop::users::ambari::shell,
    home           => $iop::users::ambari::home,
    purge_ssh_keys => $iop::users::ambari::purge_ssh_keys
  }
  
  file { 'ambari_ssh':
    ensure  => directory,
    path    => "${iop::users::ambari::home}/.ssh",
    mode    => '0700',
    owner   => $iop::users::ambari::username,
    group   => $iop::groups::ambari::groupname,
    require => User[$iop::users::ambari::username],
  }

  if $iop::users::ambari::key_mgmt == 'manual' {
    file { 'ambari_ssh_private_key':
      ensure  => file,
      path    => "${iop::users::ambari::home}/.ssh/id_rsa",
      owner   => $iop::users::ambari::username,
      group   => $iop::groups::ambari::groupname,
      mode    => '0600',
      content => $iop::users::ambari::private_key,
      require => File[ambari_ssh],
    }
    
    file { 'ambari_ssh_public_key':
      ensure  => file,
      path    => "${iop::users::ambari::home}/.ssh/id_rsa.pub",
      owner   => $iop::users::ambari::username,
      group   => $iop::groups::ambari::groupname,
      mode    => '0600',
      content => $iop::users::ambari::public_key,
      require => File[ambari_ssh],
    }
  } elsif $iop::users::ambari::key_mgmt == 'automatic' {
    exec { 'ambari_ssh_keygen':
      command => "ssh-keygen -t rsa -q -f ${iop::users::ambari::home}/.ssh/id_rsa -N ''",
      path    => '/usr/bin',
      user    => $iop::users::ambari::username,
      creates => "${iop::users::ambari::home}/.ssh/id_rsa",
      require => [Package['openssh-server'], File[ambari_ssh]],
    }
    # automatically import auth keys via facts/puppetdb?
  }
  
  ensure_packages([ 'openssh-server' ])
  
  create_resources(ssh_authorized_key, $iop::users::ambari::auth_keys, {
    ensure => present,
    type   => 'ssh-rsa',
    user   => $iop::users::ambari::username,
  })
  
  iop::sudoers { 'ambari_sudo_config':
    user       => $iop::users::ambari::username,
    no_req_tty => true,
    as_others  => true,
    no_passwd  => true,
  }
}