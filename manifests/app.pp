# @summary Install and configure a Moodle application instance
#
# @param install_dir Absolute path where Moodle will be installed (must end in /moodle)
# @param download_url URL to download the Moodle archive
# @param default_lang Default language for Moodle
# @param wwwrooturl Base URL of the Moodle site
# @param www_owner Web server user
# @param www_group Web server group
# @param dataroot Directory for Moodle data files
# @param dbtype Database type (e.g. mariadb, mysqli)
# @param dbhost Database host
# @param dbname Database name
# @param dbuser Database username
# @param dbpass Database password
# @param dbport Database port
# @param dbsocket Database socket
# @param prefix Table prefix
# @param fullname Full site name
# @param shortname Short site name
# @param summary Site summary
# @param adminuser Admin username
# @param adminpass Admin password
# @param adminemail Admin email address
#
define moodle::app (
  String $install_dir,
  String $download_url,
  String $default_lang,
  String $wwwrooturl,
  String $www_owner,
  String $www_group,
  String $dataroot,
  String $dbtype,
  String $dbhost,
  String $dbname,
  String $dbuser,
  String $dbpass,
  Integer $dbport,
  Variant[String, Integer, Undef] $dbsocket,
  String $prefix,
  String $fullname,
  String $shortname,
  String $summary,
  String $adminuser,
  String $adminpass,
  String $adminemail,
) {
  if $install_dir !~ /\/moodle$/ {
    fail("${install_dir} must end with /moodle")
  }

  $staging_dir = '/var/staging/moodle'

  file { $staging_dir:
    ensure => directory,
  }

  archive { 'moodle.tgz':
    path         => "${staging_dir}/moodle.tgz",
    source       => $download_url,
    extract      => true,
    extract_path => getparent($install_dir),
    creates      => "${install_dir}/install.php",
    user         => $www_owner,
    group        => $www_group,
    cleanup      => false,
    require      => File[$staging_dir],
  }

  file { $dataroot:
    ensure => directory,
    owner  => $www_owner,
    group  => $www_group,
    mode   => '2777',
  }

  file { $install_dir:
    ensure => directory,
    owner  => $www_owner,
    group  => $www_group,
    mode   => '0755',
  }

  exec { 'run-installer':
    command   => template('moodle/install_cmd.erb'),
    user      => $www_owner,
    group     => $www_group,
    logoutput => true,
    path      => ['/usr/bin', '/usr/local/bin'],
    creates   => "${install_dir}/config.php",
    require   => [Archive['moodle.tgz'], File[$install_dir, $dataroot]],
  }
}
