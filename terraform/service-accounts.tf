
resource "google_service_account" "incoming-messages-publisher" {
  account_id = "incoming-messages-publisher"
  display_name = "Incoming message publisher"

}

resource "google_service_account" "incoming-messages-audit-reader" {
  account_id = "incoming-messages-audit-reader"
  display_name = "Incoming message audit reader"

}


resource "google_service_account" "dispatcher-service" {
  account_id = "dispatcher-service"
  display_name = "Dispatcher service queues access"

}

resource "google_service_account" "twilio-delivery-service" {
  account_id = "twilio-delivery-service"
  display_name = "Twilio Dispatcher service queues access"

}



resource "google_service_account_key" "dispatcher-service" {
  service_account_id = "${google_service_account.dispatcher-service.name}"

}




resource "google_service_account_key" "twilio-delivery-service" {
  service_account_id = "${google_service_account.twilio-delivery-service.name}"

}
resource "google_service_account_key" "incoming-messages-publisher" {
  service_account_id = "${google_service_account.incoming-messages-publisher.name}"

}


resource "google_service_account_key" "incoming-messages-audit-reader" {
  service_account_id = "${google_service_account.incoming-messages-audit-reader.name}"

}


resource "kubernetes_secret" "incoming-messages-publisher" {
  "metadata" {
    namespace = "backend"
    name = "gcp-incoming-messages-publisher"

  }
  data {
    serviceaccount.json = "${base64decode("${google_service_account_key.incoming-messages-publisher.private_key}")}"
  }
}


resource "kubernetes_secret" "incoming-messages-audit-reader" {
  "metadata" {
    namespace = "backend"
    name = "gcp-incoming-messages-audit-reader"

  }
  data {
    serviceaccount.json = "${base64decode("${google_service_account_key.incoming-messages-audit-reader.private_key}")}"
  }
}


resource "kubernetes_secret" "dispatcher-service" {
  "metadata" {
    namespace = "backend"
    name = "gcp-dispatcher-service"

  }
  data {
    serviceaccount.json = "${base64decode("${google_service_account_key.dispatcher-service.private_key}")}"
  }
}

resource "kubernetes_secret" "twilio-delivery-service" {
  "metadata" {
    namespace = "backend"
    name = "gcp-twilio-delivery-service"

  }
  data {
    serviceaccount.json = "${base64decode("${google_service_account_key.twilio-delivery-service.private_key}")}"
  }
}