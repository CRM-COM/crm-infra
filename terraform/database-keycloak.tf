resource "mysql_user" "keycloak" {
  user = "keycloak"
  host = "%"
  plaintext_password = "${random_string.keycloak_user_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]
}

resource "random_string" "keycloak_user_password" {
  length = 16
}

resource "kubernetes_secret" "keycloak_db_password" {
  "metadata" {
    name = "database-keycloak"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.keycloak.user}"
    password = "${random_string.keycloak_user_password.result}"
  }
}

resource "mysql_database" "keycloak" {
  name = "keycloak"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}
