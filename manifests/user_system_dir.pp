# @summary Creates a directory to store a rootless quadlet in the system path.
#
# @param user Username to create directory for
#
define quadlets::user_system_dir (
  String[1] $user = $title,
) {
  # First puppet run maintains a file for each user of rootless quadlets

  include quadlets

  file { "/var/lib/quadlets-users-fact.d/${user}":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  # Next puppet run the quadlets.users facts will be populated.

}
