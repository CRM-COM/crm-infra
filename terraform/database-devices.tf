resource "mysql_database" "devices" {
  name = "devices"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}



resource "mysql_user" "devices_ro" {
  user = "devices_ro"
  host = "%"
  plaintext_password = "${random_string.devices_reader_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "migration_devices" {
  database = "${mysql_database.devices.name}"
  user = "${mysql_user.migration.user}"
  host = "${mysql_user.migration.host}"
  privileges = ["ALL"]
}



resource "mysql_grant" "devices_ro" {
  database = "${mysql_database.devices.name}"
  user = "${mysql_user.devices_ro.user}"
  host = "${mysql_user.devices_ro.host}"
  privileges = ["SELECT"]
}


resource "random_string" "devices_reader_password" {
  length = 16
}


resource "random_string" "devices_writer_password" {
  length = 16
}


resource "kubernetes_secret" "devices_ro_db_password" {
  "metadata" {
    name = "database-devices-ro"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.devices_ro.user}"
    password = "${random_string.devices_reader_password.result}"
  }
}


resource "mysql_user" "devices_rw" {
  user = "devices_rw"
  host = "%"
  plaintext_password = "${random_string.devices_writer_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "devices_rw" {
  database = "${mysql_database.devices.name}"
  user = "${mysql_user.devices_rw.user}"
  host = "${mysql_user.devices_rw.host}"
  privileges = ["SELECT","INSERT","UPDATE","DELETE"]
}


resource "kubernetes_secret" "devices_rw_db_password" {
  "metadata" {
    name = "database-devices-rw"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.devices_rw.user}"
    password = "${random_string.devices_writer_password.result}"
  }
}