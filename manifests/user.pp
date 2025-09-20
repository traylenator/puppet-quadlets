# @summary 
#
#
# @param user Specify which user to run as
#
#
define quadlets::user (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Quadlets::Quadlet_user] $user = undef,
) {

  include quadlets

  $_username = $user['name']

  if $_username != $title {
    fail('The username key to the user parameter should match the name of this resource')
  }

  $_file_group = pick($user['group'], $user['name'])
  $_user_homedir = pick($user['homedir'], "/home/${user['name']}")
  $_create_dir = pick($user['create_dir'], true)
  $_manage_user = pick($user['manage_user'], true)
  $_manage_linger = pick($user['manage_linger'], true)

  if $_create_dir {
    $_components = split($quadlets::quadlet_user_dir, '/')
    $_dirs = $_components.reduce([]) |$_accum, $_part| {
      $_accum + [$_accum ? {
          []      => "${_user_homedir}/${_part}",
          default => "${_accum[-1]}/${_part}"
        }
      ]
    }
    file{ $_dirs:
      ensure => directory,
      owner  => $_username,
      group  => $_file_group,
    }
  }
  if $_manage_user {
    user{$_username:
      ensure     => present,
      managehome => true,
    }
  }
  if $_manage_linger {
    loginctl_user{$_username:
        linger => enabled,
    }
  }
}
