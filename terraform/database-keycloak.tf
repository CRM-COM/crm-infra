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
    namespace = "infra"

  }
  data {
    username = "${mysql_user.keycloak.user}"
    password = "${random_string.keycloak_user_password.result}"
  }
}

resource "mysql_grant" "keycloak_user" {
  database = "${mysql_database.keycloak.name}"
  user = "${mysql_user.keycloak.user}"
  host = "${mysql_user.keycloak.host}"
  privileges = ["ALL"]
}

resource "mysql_database" "keycloak" {
  name = "keycloak"
  default_character_set = "utf8"
  default_collation = "utf8_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}
