class iop::yum (
  # IOP RPM installation
  $install_iop_package = false,
  $iop_install_uri     = '',

  # Repository addresses
  $ambari_repo_uri     = 'http://ibm-open-platform.ibm.com/repos/Ambari/RHEL6/x86_64/1.7',
  $iop_repo_uri        = 'http://ibm-open-platform.ibm.com/repos/IOP/RHEL6/x86_64/4.0',
  $iop_utils_repo_uri  = 'http://ibm-open-platform.ibm.com/repos/IOP-UTILS/RHEL6/x86_64/1.0',
) {
  
  validate_bool($install_iop_package)
  validate_string($iop_install_uri)
  validate_string($ambari_repo_uri)
  validate_string($iop_repo_uri)
  validate_string($iop_utils_repo_uri)
  
  # Install the IOP GPG Key
  file { $iop::params::gpg_key_iop:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    #source => "puppet:///modules/${module_name}/etc/pki/rpm-gpg/RPM-GPG-KEY-IOP",
    content => template("${module_name}/etc/pki/rpm-gpg/RPM-GPG-KEY-IOP"),
    notify  => Exec['import-iop-gpg-key'],
  }
  
  exec { 'import-iop-gpg-key':
    command     => "rpm --import ${iop::params::gpg_key_iop}",
    cwd         => '/etc/pki/rpm-gpg',
    path        => '/bin',
    user        => 'root',
    umask       => '022',
    refreshonly => true,
    require     => File[$iop::params::gpg_key_iop],
  }
  
  # Install the HDP GPG Key
  file { $iop::params::gpg_key_hdp:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    #source => "puppet:///modules/${module_name}/etc/pki/rpm-gpg/RPM-GPG-KEY-HDP",
    content => template("${module_name}/etc/pki/rpm-gpg/RPM-GPG-KEY-HDP"),
    notify  => Exec['import-hdp-gpg-key']
  }
  
  exec { 'import-hdp-gpg-key':
    command     => "rpm --import ${iop::params::gpg_key_hdp}",
    cwd         => '/etc/pki/rpm-gpg',
    path        => '/bin',
    user        => 'root',
    umask       => '022',
    refreshonly => true,
    require     => File[$iop::params::gpg_key_hdp],
  }
  
  if true == $install_iop_package {
    fail ("TODO: This doesn't work yet")
    package { $iop_install_uri:
      ensure => present,
      #...
      before => File[$iop::params::ambari_repo_file],
    }
  }
  
  # RPM is unsigned so there is no dependency on GPG keys needed here
  file { $iop::params::ambari_repo_file:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    content => template("${module_name}/etc/yum.repos.d/ambari.repo.erb"),
  }
  
}