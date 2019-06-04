# infrastructure

/terraform - creates basic infrastructure in GCP project
/environment - configuration files for environments

Sealed secrets: 

kubectl create secret generic --dry-run --output json keycloak --namespace=backend --from-literal={key}={value} > keycloakSecret.json

cat keycloakSecret.json | kubeseal --cert crmSecretsCert.crt > keycloak-sealed.json