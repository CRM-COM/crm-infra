resource "mysql_user" "migration" {
  user = "migration"
  host = "%"
  plaintext_password = "${random_string.migration_user_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]
}





resource "random_string" "migration_user_password" {
  length = 16
}



resource "kubernetes_secret" "migration_db_password" {
  "metadata" {
    name = "database-migration"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.migration.user}"
    password = "${random_string.migration_user_password.result}"
  }
}

