# @summary Manage Moodle database and database user
#
# @param create_db Whether to create the database
# @param create_db_user Whether to create the database user and grant privileges
# @param dbname Name of the database
# @param dbhost Database host
# @param dbuser Database username
# @param dbpass Database password
# @param dbcollate Database collate
# @param dbcharset Database charset
#
define moodle::db (
  Boolean $create_db,
  Boolean $create_db_user,
  String  $dbname,
  String  $dbhost,
  String  $dbuser,
  String  $dbpass,
  String  $dbcollate,
  String  $dbcharset,
) {
  ## Set up DB using puppetlabs-mysql defined type
  if $create_db {
    mysql_database { "${dbhost}/${dbname}":
      name    => $dbname,
      collate => $dbcollate,
      charset => $dbcharset,
    }
  }

  if $create_db_user {
    mysql_user { "${dbuser}@${dbhost}":
      password_hash => mysql::password($dbpass),
    }

    mysql_grant { "${dbuser}@${dbhost}/${dbname}.*":
      table      => "${dbname}.*",
      user       => "${dbuser}@${dbhost}",
      privileges => ['ALL'],
    }
  }
}
