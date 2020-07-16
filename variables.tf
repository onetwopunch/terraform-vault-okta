variable "vault_addr" {
  type        = string
  description = "Vault address in the form of https://domain:8200"
}

variable "okta_discovery_url" {
  type        = string
  description = "Okta Authz server Issuer URI: i.e. https://<org>.okta.com/oauth2/<id>"
}

variable "okta_allowed_groups" {
  type        = list
  description = "Okta group for Vault admins"
  default     = ["vault_admins"]
}

variable "okta_mount_path" {
  type        = string
  description = "Mount path for Okta auth"
  default     = "okta_oidc"
}

variable "okta_client_id" {
  type        = string
  description = "Okta Vault app client ID"
}

variable "okta_client_secret" {
  type        = string
  description = "Okta Vault app client secret"
}

variable "okta_bound_audiences" {
  type        = list
  description = "A list of allowed token audiences"
}

variable "cli_port" {
  type        = number
  description = "Port to open locally to login with the CLI"
  default     = 8250
}

variable "roles" {
  type    = map
  default = {}

  description = <<EOF
Map of Vault role names to their bound groups and token policies. Structure looks like this:

```
roles = {
  okta_admin = {
    token_policies = ["admin"]
    bound_groups = ["vault_admins"]
  },
  okta_devs  = {
    token_policies = ["devs"]
    bound_groups = ["vault_devs"]
  }
}
```
EOF
}
