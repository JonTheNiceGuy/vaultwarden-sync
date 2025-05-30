# Vaultwarden-sync

This is a container which includes the
[Bitwarden Directory Connector](https://github.com/bitwarden/directory-connector),
and some scripts to configure it. The following variables can be set to configure
various features.

You are encouraged to setup the GUI application. Configure and test a single
synchronization, and then provide the configuration from the file detailed
[in the Bitwarden Directory Sync Documentation](https://bitwarden.com/help/directory-sync-shared/#location)

You can either define these values directly as environment variables when invoking
the container, or you can mount a configuration file as
`/etc/bitwarden-sync/auth.env` which must use these formats:

```
export KEY_name=value
export KEY_name="value"
```

## Directories

You will need to find the UUID for the active account, and that will be used as
the key to find the relevant section. For example, if the active account has a
UUID of `00000000-aaaa-1111-bbbb-222222222222` the setting would be in

```
{
    "00000000-aaaa-1111-bbbb-222222222222": {
        "directoryConfigurations": {
            "ldap": {},
            "gsuite": {},
            "azure": {},
            "okta": {},
            "oneLogin": {}
        }
    }
}
```

You should set `DIRECTORY` to the type of directory you intend to use.

### LDAP (`DIRECTORY`: `ldap`. Default if not defined)

* `LDAP_ssl` or `LDAP_startTls` (true for one of these, false for both if not defined)
* `LDAP_sslAllowUnauthorized` (true or false)
* `LDAP_port` (TCP port to use)
* `LDAP_currentUser` (true or false)
* `LDAP_ad` (true or false)
* `LDAP_pagedSearch` (true or false)
* `LDAP_username` (Full CN of the user to authenticate with, e.g. `CN=ldap_service@example.org,OU=users,DC=example,DC=org`)
* `LDAP_password` (Password string)
* `LDAP_hostname` (DNS name or IP address)
* `LDAP_rootPath` (The path to start LDAP searches, e.g. `DC=example,DC=org`)

If you need to use stunnel to contact the LDAP service, also set these two values

* `LDAP_cert` (base64 encoded certificate file in PEM format)
* `LDAP_key` (base64 encoded private key in PEM format)

### Google Suite (`DIRECTORY`: `gsuite`)

* `GSUITE_privateKey`
* `GSUITE_domain`
* `GSUITE_adminUser`
* `GSUITE_customer`

### Azure Active Directory (`DIRECTORY`: `azure`)

* `AZURE_privateKey`
* `AZURE_identityAuthority`
* `AZURE_tenant`
* `AZURE_applicationId`

### Okta (`DIRECTORY`: `okta`)

* `OKTA_orgUrl`
* `OKTA_token`

### oneLogin (`DIRECTORY`: `oneLogin`)

* `ONELOGIN_region`
* `ONELOGIN_clientSecret`
* `ONELOGIN_clientId`

## Synchronization Settings

As with the Directory Settings, you will need to find the UUID for the active
account, to find the relevant section. Again, assuming the active account is
`00000000-aaaa-1111-bbbb-222222222222` the setting would be in

```
{
    "00000000-aaaa-1111-bbbb-222222222222": {
        "directorySettings": {
            "sync": {}
        }
    }
}
```

* `SYNC_users`
* `SYNC_groups`
* `SYNC_interval`
* `SYNC_removeDisabled`
* `SYNC_overwriteExisting`
* `SYNC_largeImport`
* `SYNC_useEmailPrefixSuffix`
* `SYNC_creationDateAttribute`
* `SYNC_revisionDateAttribute`
* `SYNC_emailPrefixAttribute`
* `SYNC_memberAttribute`
* `SYNC_userObjectClass`
* `SYNC_groupObjectClass`
* `SYNC_userEmailAttribute`
* `SYNC_groupNameAttribute`
* `SYNC_groupPath`
* `SYNC_userPath`
* `SYNC_groupFilter`
* `SYNC_userFilter`