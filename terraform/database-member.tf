resource "mysql_database" "member" {
  name = "member"
  default_character_set = "utf8mb4"
  default_collation = "utf8mb4_general_ci"

  depends_on = ["google_sql_user.admin_mysql_user"]
}




resource "mysql_grant" "migration_member" {
  database = "${mysql_database.member.name}"
  user = "${mysql_user.migration.user}"
  host = "${mysql_user.migration.host}"
  privileges = ["ALL"]
}

resource "mysql_user" "member_rw" {
  host = "%"
  user = "member_rw"
  plaintext_password = "${random_string.member_rw_password.result}"
  depends_on = ["google_sql_user.admin_mysql_user"]

}

resource "mysql_grant" "member_rw" {
  database = "${mysql_database.member.name}"
  user = "${mysql_user.member_rw.user}"
  host = "${mysql_user.member_rw.host}"
  privileges = ["DELETE","INSERT","SELECT","UPDATE"]
}



resource "random_string" "member_rw_password" {
  length = 16
}



resource "kubernetes_secret" "member_rw_db_password" {
  "metadata" {
    name = "database-member-rw"
    namespace = "backend"

  }
  data {
    username = "${mysql_user.member_rw.user}"
    password = "${random_string.member_rw_password.result}"
  }
}
