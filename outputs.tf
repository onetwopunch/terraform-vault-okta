/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "roles" {
  description = "Role names created by this module"
  value       = keys(vault_jwt_auth_backend_role.okta_role)
}

output "path" {
  description = "Okta OIDC auth path"
  value       = vault_jwt_auth_backend.okta_oidc.path
}

output "accessor" {
  value       = vault_jwt_auth_backend.okta_oidc.accessor
}
