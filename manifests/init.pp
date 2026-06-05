# @summary Install and configure Moodle using Hiera-managed configuration data
#
# This class installs Moodle and configures all settings via Hiera.
#
# @param install_dir Installation directory for Moodle
# @param download_base Base URL for Moodle downloads
# @param moodle_version Moodle version to install
# @param default_lang Default language for Moodle
# @param www_owner Web server user (OS-dependent via Hiera)
# @param www_group Web server group (OS-dependent via Hiera)
# @param dataroot Moodle data directory path
# @param create_db Whether to create the database
# @param create_db_user Whether to create the database user
# @param dbtype Database type
# @param dbhost Database host
# @param dbname Database name
# @param dbuser Database username
# @param dbpass Database password
# @param dbport Database port
# @param dbsocket Database socket (legacy integer/string/undef)
# @param prefix Database table prefix
# @param fullname Full site name
# @param shortname Short site name
# @param summary Site description
# @param adminuser Admin username
# @param adminpass Admin password
# @param adminemail Admin email address
# @param wwwrooturl Base URL of the Moodle site (defaults to http://fqdn if not set)
#
class moodle (
  String  $install_dir,
  String  $download_base,
  String  $moodle_version,
  String  $default_lang,
  String  $www_owner,
  String  $www_group,
  String  $dataroot,
  Boolean $create_db,
  Boolean $create_db_user,
  String  $dbtype,
  String  $dbhost,
  String  $dbname,
  String  $dbuser,
  String  $dbpass,
  Integer $dbport,
  Variant[String, Integer, Undef] $dbsocket,
  String  $prefix,
  String  $fullname,
  String  $shortname,
  String  $summary,
  String  $adminuser,
  String  $adminpass,
  String  $adminemail,
  Optional[String] $wwwrooturl = undef,
) {
  $effective_wwwrooturl = $wwwrooturl ? {
    undef   => "http://${facts['networking']['fqdn']}",
    default => $wwwrooturl,
  }

  $download_url = "${download_base}/moodle-${moodle_version}.tgz"

  moodle::instance { $install_dir:
    install_dir    => $install_dir,
    download_url   => $download_url,
    default_lang   => $default_lang,
    wwwrooturl     => $effective_wwwrooturl,
    www_owner      => $www_owner,
    www_group      => $www_group,
    dataroot       => $dataroot,
    create_db      => $create_db,
    create_db_user => $create_db_user,
    dbtype         => $dbtype,
    dbhost         => $dbhost,
    dbname         => $dbname,
    dbuser         => $dbuser,
    dbpass         => $dbpass,
    dbport         => $dbport,
    dbsocket       => $dbsocket,
    prefix         => $prefix,
    fullname       => $fullname,
    shortname      => $shortname,
    summary        => $summary,
    adminuser      => $adminuser,
    adminpass      => $adminpass,
    adminemail     => $adminemail,
  }
}
