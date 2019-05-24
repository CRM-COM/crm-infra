resource "google_sql_database_instance" "main_sql" {
  name = "${random_string.dbname_prefix.result}-${var.environment}-main-db"
  database_version = "${var.database_version}"

  "settings" {
    tier = "${var.mysql_node_type}"
    disk_autoresize = true
    database_flags = [
      {
        name = "character_set_server"
        value = "utf8mb4"
      }
    ]
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name = "all" // temporary until cloud proxy gets installed
        value = "0.0.0.0/0"
      }
    }
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "03:00"
    }
  }
}


//resource "google_sql_database_instance" "failover" {
//  count                = "${var.environment == "prod" ? 1 : 0}"
//  name                 = "${random_string.dbname_prefix.result}-${var.environment}-failover-db"
//  master_instance_name = "${google_sql_database_instance.main_sql.name}"
//  database_version     = "${var.database_version}"
//
//  settings {
//    tier                   = "${var.mysql_node_type}"
//    disk_autoresize        = true
//    replication_type       = "SYNCHRONOUS"
//    crash_safe_replication = true
//
//    ip_configuration {
//      ipv4_enabled = true
//      authorized_networks {
//        name = "all" // temporary until cloud proxy gets installed
//        value = "0.0.0.0/0"
//      }
//    }
//
//    database_flags = [
//      {
//        name  = "character_set_server"
//        value = "utf8mb4"
//      },
//    ]
//
//    maintenance_window {
//      day          = "7"
//      hour         = "3"
//      update_track = "stable"
//    }
//  }
//
//  replica_configuration {
//    failover_target = true
//  }
//
//  timeouts {
//    create = "60m"
//    update = "60m"
//    delete = "60m"
//  }
//}

#
# Read-only Replica Instance
#
//resource "google_sql_database_instance" "replica" {
//  name                 = "${random_string.dbname_prefix.result}-${var.environment}-replica-db"
//  master_instance_name = "${google_sql_database_instance.main_sql.name}"
//  database_version     = "${var.database_version}"
//
//  settings {
//    tier            = "${var.mysql_node_type}"
//    disk_autoresize = true
//
//    ip_configuration {
//      ipv4_enabled        = true
//      authorized_networks {
//        name = "all" // temporary until cloud proxy gets installed
//        value = "0.0.0.0/0"
//      }
//    }
//
//    database_flags = [
//      {
//        name  = "character_set_server"
//        value = "utf8mb4"
//      },
//    ]
//
//    maintenance_window {
//      day          = "7"
//      hour         = "3"
//      update_track = "stable"
//    }
//
//    replication_type       = "SYNCHRONOUS"
//    crash_safe_replication = true
//  }
//
//  timeouts {
//    create = "60m"
//    update = "60m"
//    delete = "60m"
//  }
//}


resource "random_string" "dbname_prefix" {
  length = 3
  min_lower = 3
}

resource "random_string" "mysql_admin_password" {
  length = 16
}

resource "google_sql_user" "admin_mysql_user" {
  instance = "${google_sql_database_instance.main_sql.name}"
  name = "mysqladmin"
  password = "${random_string.mysql_admin_password.result}"
}

output "mysql_admin_password" {
  value = "${random_string.mysql_admin_password.result}"
  sensitive = true
}

