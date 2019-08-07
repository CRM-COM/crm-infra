resource "mysql_database" "merchandise" {
  name = "merchandise"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}




resource "mysql_grant" "migration_merchandise" {
  database = "${mysql_database.merchandise.name}"
  user = "${mysql_user.migration.user}"
  host = "${mysql_user.migration.host}"
  privileges = ["ALL"]
}

resource "mysql_user" "merchandise_rw" {
  host = "%"
  user = "merchandise_rw"
  plaintext_password = "${random_string.merchandise_rw_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "merchandise_rw" {
  database = "${mysql_database.merchandise.name}"
  user = "${mysql_user.merchandise_rw.user}"
  host = "${mysql_user.merchandise_rw.host}"
  privileges = ["DELETE","INSERT","SELECT","UPDATE"]
}



resource "random_string" "merchandise_rw_password" {
  length = 16
}



resource "kubernetes_secret" "merchandise_rw_db_password" {
  "metadata" {
    name = "database-merchandise-rw"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.merchandise_rw.user}"
    password = "${random_string.merchandise_rw_password.result}"
  }
}
