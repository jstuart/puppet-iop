# == Define Resource Type: iop::ambari::addon
#
# This type will add packages containing Ambari metadata to Ambari Server. This 
# will ensure that Ambari Server is installed prior to installing the package
# and the the Ambari Server service is restarted after it is installed.
#
# TODO: add support for installation methods other than direct RPM installation
#
# Parameters:
#
# $rpm_uri::                       The URI of the RPM that contains the Ambari
#                                  metadata.  
#                                  Required, no default
#                                  type:string
#
# $ensure::                        A valid value of the ensure parameter for 
#                                  the Puppet 'package' type.
#                                  Defaults to 'installed'.
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
#  iop::ambari::addon { 'some-addon':
#    rpm_uri => 'http://host.example.com/rpms/somefile.rpm',
#    ensure  => 'installed',
#  }
#
#
define iop::ambari::addon (
  $rpm_uri = undef,
  $ensure  = 'installed',
) {
  validate_string($rpm_uri)
  validate_string($ensure)

  package { "${name}-package":
    ensure   => $ensure,
    provider => 'rpm',
    source   => $rpm_uri,
    require  => Package[$iop::params::ambari_server_package],
    notify   => Service[$iop::params::ambari_server_service],
  }
}