resource "mysql_database" "backoffice" {
  name = "backoffice"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}




resource "mysql_grant" "migration_backoffice" {
  database = "${mysql_database.backoffice.name}"
  user = "${mysql_user.migration.user}"
  host = "${mysql_user.migration.host}"
  privileges = ["ALL"]
}

resource "mysql_user" "backoffice_rw" {
  host = "%"
  user = "backoffice_rw"
  plaintext_password = "${random_string.backoffice_rw_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "backoffice_rw" {
  database = "${mysql_database.backoffice.name}"
  user = "${mysql_user.backoffice_rw.user}"
  host = "${mysql_user.backoffice_rw.host}"
  privileges = ["DELETE","INSERT","SELECT","UPDATE"]
}



resource "random_string" "backoffice_rw_password" {
  length = 16
}



resource "kubernetes_secret" "backoffice_rw_db_password" {
  "metadata" {
    name = "database-backoffice-rw"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.backoffice_rw.user}"
    password = "${random_string.backoffice_rw_password.result}"
  }
}
