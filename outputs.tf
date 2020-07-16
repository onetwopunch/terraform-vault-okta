output "roles" {
  description = "Role names created by this module"
  value       = keys(vault_jwt_auth_backend_role.okta_role)
}

output "path" {
  description = "Okta OIDC auth path"
  value       = vault_jwt_auth_backend.okta_oidc.path
}
