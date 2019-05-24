resource "mysql_database" "messages" {
  name = "messages"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"
  depends_on = ["google_sql_user.admin_mysql_user"]
}


resource "mysql_grant" "migration_messages" {
  database = "${mysql_database.messages.name}"
  user = "${mysql_user.migration.user}"
  host = "${mysql_user.migration.host}"
  privileges = ["ALL"]
}



resource "random_string" "messages_writer_password" {
  length = 16
}


resource "mysql_user" "messages_rw" {
  user = "messages_rw"
  host = "%"
  plaintext_password = "${random_string.messages_writer_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "messages_rw" {
  database = "${mysql_database.messages.name}"
  user = "${mysql_user.messages_rw.user}"
  host = "${mysql_user.messages_rw.host}"
  privileges = ["SELECT","INSERT","UPDATE","DELETE"]
}


resource "kubernetes_secret" "messages_rw_db_password" {
  "metadata" {
    name = "database-messages-rw"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.messages_rw.user}"
    password = "${random_string.messages_writer_password.result}"
  }
}