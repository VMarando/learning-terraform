provider "vault" {
  address          = "http://4.247.162.33:8200/"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = ""
      secret_id = ""
    }
  }
}

# to fetch value from HashiCorp Vault
# link to official documents https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}
