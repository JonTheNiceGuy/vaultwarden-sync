#!/bin/bash

if [ -z "${1:-}" ] || ! [ -w "$1" ] || ! [ -s "$1" ]
then
    echo "Failed to load file $1" >&2
    exit 1
fi

TEMPFILE="$(mktemp)"

LDAP_JSON=$(
    jq -n \
    --arg ssl "${LDAP_ssl:-false}" \
    --arg startTls "${LDAP_startTls:-false}" \
    --arg sslAllowUnauthorized "${LDAP_sslAllowUnauthorized:-false}" \
    --arg port "${LDAP_port:-389}" \
    --arg currentUser "${LDAP_currentUser:-false}" \
    --arg ad "${LDAP_ad:-false}" \
    --arg pagedSearch "${LDAP_pagedSearch:-true}" \
    --arg username "${LDAP_username:-null}" \
    --arg password "${LDAP_password:-null}" \
    --arg hostname "${LDAP_hostname:-null}" \
    --arg rootPath "${LDAP_rootPath:-null}" \
    '{
        ssl: (
            if $ssl == "true" then true 
            elif $ssl == "false" then false
            elif $ssl == "null" then null
            else $ssl
            end
        ),
        startTls: (
            if $startTls == "true" then true 
            elif $startTls == "false" then false
            elif $startTls == "null" then null
            else $startTls
            end
        ),
        sslAllowUnauthorized: (
            if $sslAllowUnauthorized == "true" then true 
            elif $sslAllowUnauthorized == "false" then false
            elif $sslAllowUnauthorized == "null" then null
            else $sslAllowUnauthorized
            end
        ),
        port: ($port | tostring),
        currentUser: (
            if $currentUser == "true" then true 
            elif $currentUser == "false" then false
            elif $currentUser == "null" then null
            else $currentUser
            end
        ),
        ad: (
            if $ad == "true" then true 
            elif $ad == "false" then false
            elif $ad == "null" then null
            else $ad
            end
        ),
        pagedSearch: (
            if $pagedSearch == "true" then true 
            elif $pagedSearch == "false" then false
            elif $pagedSearch == "null" then null
            else $pagedSearch
            end
        ),
        username: (
            if $username == "true" then true 
            elif $username == "false" then false
            elif $username == "null" then null
            else $username
            end
        ),
        password: (
            if $password == "true" then true 
            elif $password == "false" then false
            elif $password == "null" then null
            else $password
            end
        ),
        hostname: (
            if $hostname == "true" then true 
            elif $hostname == "false" then false
            elif $hostname == "null" then null
            else $hostname
            end
        ),
        rootPath: (
            if $rootPath == "true" then true 
            elif $rootPath == "false" then false
            elif $rootPath == "null" then null
            else $rootPath
            end
        ),
    }'
)

GSUITE_JSON=$(
    jq -n \
    --arg privateKey "${GSUITE_privateKey:-null}" \
    --arg domain "${GSUITE_domain:-null}" \
    --arg adminUser "${GSUITE_adminUser:-null}" \
    --arg customer "${GSUITE_customer:-null}" \
    '{
        privateKey: (
            if $privateKey == "true" then true 
            elif $privateKey == "false" then false
            elif $privateKey == "null" then null
            else $privateKey
            end
        ),
        domain: (
            if $domain == "true" then true 
            elif $domain == "false" then false
            elif $domain == "null" then null
            else $domain
            end
        ),
        adminUser: (
            if $adminUser == "true" then true 
            elif $adminUser == "false" then false
            elif $adminUser == "null" then null
            else $adminUser
            end
        ),
        customer: (
            if $customer == "true" then true 
            elif $customer == "false" then false
            elif $customer == "null" then null
            else $customer
            end
        )
    }'
)

AZURE_JSON=$(
    jq -n \
    --arg privateKey "${AZURE_privateKey:-null}" \
    --arg identityAuthority "${AZURE_identityAuthority:-null}" \
    --arg tenant "${AZURE_tenant:-null}" \
    --arg applicationId "${AZURE_applicationId:-null}" \
    '{
        privateKey: (
            if $privateKey == "true" then true 
            elif $privateKey == "false" then false
            elif $privateKey == "null" then null
            else $privateKey
            end
        ),
        identityAuthority: (
            if $identityAuthority == "true" then true 
            elif $identityAuthority == "false" then false
            elif $identityAuthority == "null" then null
            else $identityAuthority
            end
        ),
        tenant: (
            if $tenant == "true" then true 
            elif $tenant == "false" then false
            elif $tenant == "null" then null
            else $tenant
            end
        ),
        applicationId: (
            if $applicationId == "true" then true 
            elif $applicationId == "false" then false
            elif $applicationId == "null" then null
            else $applicationId
            end
        )
    }'
)

OKTA_JSON=$(
    jq -n \
    --arg orgUrl "${OKTA_orgUrl:-null}" \
    --arg token "${OKTA_token:-null}" \
    '{
        orgUrl: (
            if $orgUrl == "true" then true 
            elif $orgUrl == "false" then false
            elif $orgUrl == "null" then null
            else $orgUrl
            end
        ),
        token: (
            if $token == "true" then true 
            elif $token == "false" then false
            elif $token == "null" then null
            else $token
            end
        )
    }'
)

ONELOGIN_JSON=$(
    jq -n \
    --arg region "${ONELOGIN_region:-null}" \
    --arg clientSecret "${ONELOGIN_clientSecret:-null}" \
    --arg clientId "${ONELOGIN_clientId:-null}" \
    '{
        region: (
            if $region == "true" then true 
            elif $region == "false" then false
            elif $region == "null" then null
            else $region
            end
        ),
        clientSecret: (
            if $clientSecret == "true" then true 
            elif $clientSecret == "false" then false
            elif $clientSecret == "null" then null
            else $clientSecret
            end
        ),
        clientId: (
            if $clientId == "true" then true 
            elif $clientId == "false" then false
            elif $clientId == "null" then null
            else $clientId
            end
        )
    }'
)

SYNC_JSON=$(
    jq -n \
    --arg users "${SYNC_users:-null}" \
    --arg groups "${SYNC_groups:-null}" \
    --arg interval "${SYNC_interval:-5}" \
    --arg removeDisabled "${SYNC_removeDisabled:-null}" \
    --arg overwriteExisting "${SYNC_overwriteExisting:-null}" \
    --arg largeImport "${SYNC_largeImport:-null}" \
    --arg useEmailPrefixSuffix "${SYNC_useEmailPrefixSuffix:-null}" \
    --arg creationDateAttribute "${SYNC_creationDateAttribute:-null}" \
    --arg revisionDateAttribute "${SYNC_revisionDateAttribute:-null}" \
    --arg emailPrefixAttribute "${SYNC_emailPrefixAttribute:-null}" \
    --arg memberAttribute "${SYNC_memberAttribute:-null}" \
    --arg userObjectClass "${SYNC_userObjectClass:-null}" \
    --arg groupObjectClass "${SYNC_groupObjectClass:-null}" \
    --arg userEmailAttribute "${SYNC_userEmailAttribute:-null}" \
    --arg groupNameAttribute "${SYNC_groupNameAttribute:-null}" \
    --arg groupPath "${SYNC_groupPath:-null}" \
    --arg userPath "${SYNC_userPath:-null}" \
    --arg groupFilter "${SYNC_groupFilter:-null}" \
    --arg userFilter "${SYNC_userFilter:-null}" \
    '{
        users: (
            if $users == "true" then true 
            elif $users == "false" then false
            elif $users == "null" then null
            else $users
            end
        ),
        groups: (
            if $groups == "true" then true 
            elif $groups == "false" then false
            elif $groups == "null" then null
            else $groups
            end
        ),
        interval: (
            if $interval == "true" then true 
            elif $interval == "false" then false
            elif $interval == "null" then null
            else $interval
            end
        ),
        removeDisabled: (
            if $removeDisabled == "true" then true 
            elif $removeDisabled == "false" then false
            elif $removeDisabled == "null" then null
            else $removeDisabled
            end
        ),
        overwriteExisting: (
            if $overwriteExisting == "true" then true 
            elif $overwriteExisting == "false" then false
            elif $overwriteExisting == "null" then null
            else $overwriteExisting
            end
        ),
        largeImport: (
            if $largeImport == "true" then true 
            elif $largeImport == "false" then false
            elif $largeImport == "null" then null
            else $largeImport
            end
        ),
        useEmailPrefixSuffix: (
            if $useEmailPrefixSuffix == "true" then true 
            elif $useEmailPrefixSuffix == "false" then false
            elif $useEmailPrefixSuffix == "null" then null
            else $useEmailPrefixSuffix
            end
        ),
        creationDateAttribute: (
            if $creationDateAttribute == "true" then true 
            elif $creationDateAttribute == "false" then false
            elif $creationDateAttribute == "null" then null
            else $creationDateAttribute
            end
        ),
        revisionDateAttribute: (
            if $revisionDateAttribute == "true" then true 
            elif $revisionDateAttribute == "false" then false
            elif $revisionDateAttribute == "null" then null
            else $revisionDateAttribute
            end
        ),
        emailPrefixAttribute: (
            if $emailPrefixAttribute == "true" then true 
            elif $emailPrefixAttribute == "false" then false
            elif $emailPrefixAttribute == "null" then null
            else $emailPrefixAttribute
            end
        ),
        memberAttribute: (
            if $memberAttribute == "true" then true 
            elif $memberAttribute == "false" then false
            elif $memberAttribute == "null" then null
            else $memberAttribute
            end
        ),
        userObjectClass: (
            if $userObjectClass == "true" then true 
            elif $userObjectClass == "false" then false
            elif $userObjectClass == "null" then null
            else $userObjectClass
            end
        ),
        groupObjectClass: (
            if $groupObjectClass == "true" then true 
            elif $groupObjectClass == "false" then false
            elif $groupObjectClass == "null" then null
            else $groupObjectClass
            end
        ),
        userEmailAttribute: (
            if $userEmailAttribute == "true" then true 
            elif $userEmailAttribute == "false" then false
            elif $userEmailAttribute == "null" then null
            else $userEmailAttribute
            end
        ),
        groupNameAttribute: (
            if $groupNameAttribute == "true" then true 
            elif $groupNameAttribute == "false" then false
            elif $groupNameAttribute == "null" then null
            else $groupNameAttribute
            end
        ),
        groupPath: (
            if $groupPath == "true" then true 
            elif $groupPath == "false" then false
            elif $groupPath == "null" then null
            else $groupPath
            end
        ),
        userPath: (
            if $userPath == "true" then true 
            elif $userPath == "false" then false
            elif $userPath == "null" then null
            else $userPath
            end
        ),
        groupFilter: (
            if $groupFilter == "true" then true 
            elif $groupFilter == "false" then false
            elif $groupFilter == "null" then null
            else $groupFilter
            end
        ),
        userFilter: (
            if $userFilter == "true" then true 
            elif $userFilter == "false" then false
            elif $userFilter == "null" then null
            else $userFilter
            end
        )
    }'   
)

jq  --argjson ldap      "$LDAP_JSON" \
    --argjson gsuite    "$GSUITE_JSON" \
    --argjson azure     "$AZURE_JSON" \
    --argjson okta      "$OKTA_JSON" \
    --argjson oneLogin  "$ONELOGIN_JSON" \
    --argjson sync      "$SYNC_JSON" \
    --arg     directory "${DIRECTORY:-ldap}" \
    '
        .authenticatedAccounts[0] as $id |
        .[$id].directoryConfigurations.ldap = $ldap |
        .[$id].directoryConfigurations.gsuite = $gsuite |
        .[$id].directoryConfigurations.azure = $azure |
        .[$id].directoryConfigurations.okta = $okta |
        .[$id].directoryConfigurations.oneLogin = $oneLogin |
        .[$id].directorySettings.sync = $sync |
        .[$id].directorySettings.directoryType = (
            if   $directory == "ldap"     then "0"
            elif $directory == "azure"    then "1"
            elif $directory == "gsuite"   then "2"
            elif $directory == "okta"     then "3"
            elif $directory == "oneLogin" then "4"
            else null
            end
        )
    ' \
    "$1" > "$TEMPFILE"

mv "$TEMPFILE" "$1"