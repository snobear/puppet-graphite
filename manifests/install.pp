# == Class: graphite::install
#
# Class to install graphite as a package
#
class graphite::install {
  $root_dir = $::graphite::root_dir
  $gr_user = $::graphite::gr_user
  $gr_group = $::graphite::gr_group

  package { 'whisper':
    ensure   => installed,
    provider => pip,
  }

  $carbon_pip_args = [
    "--install-option=\"--prefix=${root_dir}\"",
    "--install-option=\"--install-lib=${root_dir}/lib\"",
  ]
  $carbon_pip_args_str = join($carbon_pip_args, ' ')

  exec { 'graphite/install carbon':
    command => "/usr/bin/pip install ${carbon_pip_args_str} carbon",
    creates => "${root_dir}/bin/carbon-cache.py",
  }

  $graphite_pip_args = [
    "--install-option=\"--prefix=${root_dir}\"",
    "--install-option=\"--install-lib=${root_dir}/webapp\""
  ]
  $graphite_pip_args_str = join($graphite_pip_args, ' ')

  exec { 'graphite/install graphite-web':
    command => "/usr/bin/pip install ${graphite_pip_args_str} graphite-web",
    creates => "${root_dir}/webapp/graphite/manage.py",
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => $gr_user,
    group  => $gr_group,
  }

}
