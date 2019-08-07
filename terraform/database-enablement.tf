resource "mysql_database" "enablement" {
  name = "enablement"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}




resource "mysql_grant" "migration_enablement" {
  database = "${mysql_database.enablement.name}"
  user = "${mysql_user.migration.user}"
  host = "${mysql_user.migration.host}"
  privileges = ["ALL"]
}

resource "mysql_user" "enablement_rw" {
  host = "%"
  user = "enablement_rw"
  plaintext_password = "${random_string.enablement_rw_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "enablement_rw" {
  database = "${mysql_database.enablement.name}"
  user = "${mysql_user.enablement_rw.user}"
  host = "${mysql_user.enablement_rw.host}"
  privileges = ["DELETE","INSERT","SELECT","UPDATE"]
}



resource "random_string" "enablement_rw_password" {
  length = 16
}



resource "kubernetes_secret" "enablement_rw_db_password" {
  "metadata" {
    name = "database-enablement-rw"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.enablement_rw.user}"
    password = "${random_string.enablement_rw_password.result}"
  }
}
