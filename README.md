# terraform-vault-okta

Terraform configuration to configure Vault with Okta using the OIDC auth plugin

## Setting up Okta OIDC Auth

For this to work, you'll need to be an Okta administrator:

### Setting up Groups

Let's create two groups: `vault_admins` or something similar. These groups will be given permissions to do things within Vault. Within those groups, let's add some users in the Okta Admin console.

### Configuring the Authorization Server

Okta has a default authorization server that you can either edit or create another one. You get to this setting by going to `Security > API > Authorization Servers`. For this, we'll create a new one.

#### New Authorization Server for Vault

Click `Add Authorization Server`. For name enter `Vault`, for audience enter `api://vault`, and then enter a meaningful description.

#### Update Groups Claim

Now click into the authz server you just created and go to the `Claims` tab. We need to add a `groups` claim so Vault knows what group this user belongs to.

In the `Claims` tab, click on `Add Claim` with the following attributes:

* Name: `groups`
* Include in Token Type: `ID Token` `Always`
* Value Type: Groups
* Filter: `Starts with:` `vault_`
* Include in: `The following scopes:` `profile`

Click `Create`

#### Access Policy

This policy grants Vault access to read the necessary scopes to the authorization

In the `Access Policy` tab, click `Add Policy` and give it the following attributes:

* Name: `Vault Policy`
* Description: `Default policy for Vault`
* Assign to: `All clients`

In that policy, we need to add a rule with the following attributes:

* Rule Name: `default`
* Grant Type: `Authorization Code` `Implicit`
* User is: `Any user assigned the app`
* Scopes requested: `Any Scopes`

The rest of the config is dependent on your standards.

#### Terraform Variables

Take note of the following fields from this step, which we'll input into Terraform:

* `Issuer URI` will be plugged in as `oidc_discovery_url` and `bound_issuer` in the OIDC path config
* `Audience` will be plugged in as one of the `bound_audiences` in the role config

### Vault Okta Application

We need to actually create a new web application for Vault to pop open the UI for Okta when requested.

Under `Applications` click, `Add Application > Create New App` with the following attributes:

* Platform: `Web`
* Sign on method: `OpenID Connect`

Then in the configuration:

* Application Name: `Vault`
* Application logo: `<upload some vault logo from the internet>
* Login Redirect URIs: `https://<vault-domain>:8200/ui/vault/<vault-path>/oidc/callback`

Note the `<vault-path>` denoted in the login URI is whatever value you are planning on using for the mount path for the OIDC plugin. In our case we used `okta_oidc`

Click `Save`

Now edit the general settings to ensure:

* Allowed Grant Types: `Implicit (Hybrid)` `Allow ID Token with implicit grant type`
* Login initiated by: `App Only`

Click the `Sign On` tab and edit:

* `OpenID Connect ID Token` to include the same `groups` claim we added in the authorization server with the filter `vault\_`

Under `Assignments` add all the users or groups you want assigned to use Vault.

Under `Okta API Scopes` you'll need to grant the application acess to the following:

* `okta.groups.read`
* `okta.users.read.self`

#### Terraform Variables

Take note of the following fields from this step, which we'll input into Terraform:

* Login Redirect URI will be plugged into the role config as one of `allowed_redirect_uris`
* Client ID and Client Secret will be plugged into the path config as `oidc_client_id` and `oidc_client_secret` respectively
* Under `Sign On > OpenID Connect ID Token` the `Audience` field which looks like `0oa...` is passed in as a second value in the `bound_audiences` list in the role config.
* The groups you created that are prefixed by `vault\_` can be passed in as the `allowed_groups` variable in the role config.

## Deploy

First export the following variables to point at your Vault cluster

```
export VAULT_ADDR=https://<vault-domain>:8200
export VAULT_CACERT=<path-to-ca-cert>
```

Then we use terraform to apply the changes:

```
terraform apply
```
