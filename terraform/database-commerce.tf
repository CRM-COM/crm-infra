resource "mysql_database" "commerce" {
  name = "commerce"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}

resource "mysql_grant" "migration_commerce" {
  database = "${mysql_database.commerce.name}"
  user = "${mysql_user.migration.user}"
  host = "${mysql_user.migration.host}"
  privileges = ["ALL"]
}

resource "mysql_user" "commerce_rw" {
  host = "%"
  user = "commerce_rw"
  plaintext_password = "${random_string.commerce_rw_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "commerce_rw" {
  database = "${mysql_database.commerce.name}"
  user = "${mysql_user.commerce_rw.user}"
  host = "${mysql_user.commerce_rw.host}"
  privileges = ["DELETE","INSERT","SELECT","UPDATE"]
}

resource "random_string" "commerce_rw_password" {
  length = 16
}

resource "kubernetes_secret" "commerce_rw_db_password" {
  "metadata" {
    name = "database-commerce-rw"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.commerce_rw.user}"
    password = "${random_string.commerce_rw_password.result}"
  }
}
