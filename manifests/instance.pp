# @summary Configure a Moodle instance (database + application)
#
# @param install_dir Installation directory for Moodle
# @param download_url URL to download Moodle archive
# @param default_lang Default language
# @param wwwrooturl Base URL of the Moodle site
# @param www_owner Web server user
# @param www_group Web server group
# @param dataroot Moodle data directory
# @param create_db Whether to create the database
# @param create_db_user Whether to create the database user
# @param dbtype Database type
# @param dbhost Database host
# @param dbname Database name
# @param dbuser Database username
# @param dbpass Database password
# @param dbport Database port
# @param dbsocket Database socket (legacy int/string/undef)
# @param prefix Table prefix
# @param fullname Full site name
# @param shortname Short site name
# @param summary Site summary
# @param adminuser Admin username
# @param adminpass Admin password
# @param adminemail Admin email address
#
define moodle::instance (
  String  $install_dir,
  String  $download_url,
  String  $default_lang,
  String  $wwwrooturl,
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
) {
  moodle::db { "${dbhost}/${dbname}":
    create_db      => $create_db,
    create_db_user => $create_db_user,
    dbname         => $dbname,
    dbhost         => $dbhost,
    dbuser         => $dbuser,
    dbpass         => $dbpass,
  }

  moodle::app { $install_dir:
    install_dir  => $install_dir,
    download_url => $download_url,
    default_lang => $default_lang,
    wwwrooturl   => $wwwrooturl,
    www_owner    => $www_owner,
    www_group    => $www_group,
    dataroot     => $dataroot,
    dbtype       => $dbtype,
    dbhost       => $dbhost,
    dbname       => $dbname,
    dbuser       => $dbuser,
    dbpass       => $dbpass,
    dbport       => $dbport,
    dbsocket     => $dbsocket,
    prefix       => $prefix,
    fullname     => $fullname,
    shortname    => $shortname,
    summary      => $summary,
    adminuser    => $adminuser,
    adminpass    => $adminpass,
    adminemail   => $adminemail,
    require      => Moodle::Db["${dbhost}/${dbname}"],
  }
}
