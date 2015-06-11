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
  $name        = 'ambari',
  $uid         = '1200',
  $home        = '/home/ambari',
  $shell       = '/bin/bash',
  $key_mgmt    = 'manual', # 'manual','automatic','none'
  $private_key = '',
  $public_key  = '',
  $auth_keys   = {},
  $purge_ssh_keys = true,
) {
  validate_string($name)
  validate_re($iop::users::ambari::name, $iop::params::user_regex, "Invalid username: \$name='${iop::users::ambari::name}'")
  
  validate_string($uid)
  validate_re($iop::users::ambari::uid, '^\d+$', "Invalid UID: \$uid='${iop::users::ambari::uid}'")

  validate_absolute_path($iop::users::ambari::home)
  validate_absolute_path($iop::users::ambari::shell)
  
  validate_string($key_mgmt)
  validate_re($key_mgmt, '^(manual|automatic|none)$')
  
  if $key_mgmt == 'manual' {
    validate_string($private_key)
    validate_string($public_key)
  }
  
  validate_hash($auth_keys)
  validate_bool($purge_ssh_keys)
  
  require iop::groups::ambari
  
  user { 'ambari':
    ensure         => present,
    name           => $iop::users::ambari::name,
    uid            => $iop::users::ambari::uid,
    gid            => $iop::groups::ambari::gid,
    comment        => 'IOP - Ambari',
    managehome     => true,
    shell          => $iop::users::ambari::shell,
    home           => $iop::users::ambari::home,
    purge_ssh_keys => $iop::users::ambari::purge_ssh_keys
  }
  
  file { 'ambari_ssh':
    path    => "${$iop::users::ambari::home}/.ssh",
    ensure  => directory,
    mode    => '0700',
    owner   => $iop::users::ambari::name,
    group   => $iop::users::ambari::name,
    require => User[$iop::users::ambari::name],
  }

  if $key_mgmt == 'manual' {
    file { 'ambari_ssh_private_key':
      path    => "${iop::users::ambari::home}/.ssh/id_rsa",
      ensure  => file,
      owner   => $iop::users::ambari::name,
      group   => $iop::users::ambari::name,
      mode    => '0600',
      content => $iop::users::ambari::private_key,
      require => File[ambari_ssh],
    }
    
    file { 'ambari_ssh_public_key':
      path    => "${iop::users::ambari::home}/.ssh/id_rsa.pub",
      ensure  => file,
      owner   => $iop::users::ambari::name,
      group   => $iop::users::ambari::name,
      mode    => '0600',
      content => $iop::users::ambari::public_key,
      require => File[ambari_ssh],
    }
  } elsif $key_mgmt == 'automatic' {  
    exec { 'ambari_ssh_keygen':
      command => "ssh-keygen -t rsa -q -f ${iop::users::ambari::home}/.ssh/id_rsa -N ''",
      path    => '/usr/bin',
      user    => $iop::users::ambari::name,
      creates => "${iop::users::ambari::home}/.ssh/id_rsa",
      require => [Package['openssh-server'], File[ambari_ssh]],
    }
    # automatically import auth keys via facts/puppetdb?
  }
  
  ensure_packages([ 'openssh-server' ])
  
  create_resources(ssh_authorize_keys, $auth_keys, {
    ensure => present,
    type   => 'ssh-rsa',
    user   => $iop::users::ambari::name,
  })
  
  iop::sudoers { 'ambari_sudo_config':
    user        => $iop::users::ambari::name,
    no_req_tty  => true,
    as_others   => true,
    no_passwd   => true,
  }
}