# Azure setup

- `ARM_SUBSCRIPTION_ID`: Dashboard > Subscriptions copy Subscription ID
- `ARM_TENANT_ID`: Dashboard > Azure Active Directory > Overview copy Tenant ID
- Go to Dashboard > Azure Active Directory > Enterprise Applications and create a new application
- `ARM_CLIENT_ID`: Dashboard > Azure Active Directory > Enterprise Applications > CloudERP copy Apllication ID
- `ARM_CLIENT_SECRET`: Dashboard > Azure Active Directory > App Registrations > CloudERP > Certificates & secrets > Client secrets > New client secret copy Secret ID
- Go to Dashboard > Azure Active Directory > Enterprise Applications > CloudERP > Properties set Visible to users to no

## IKEv2 Linux setup

Needs ESP Custom Cipher `aes256gcm16`

## TODO

- Fix DNS for VPN
- Fix VPN DNS Certificate
- Automate VPN user addition/removal
- Support for VPN CRL
- Fix in-VPN DNS
- SQL server static IP & domain
- Appserver static IP & domain
- Monitoring & logging of appserver, sqlserver & VPN
- Monitoring, logging & health dashboard
- Alerting
- IAM user groups
- Automate IAM user management
- Automate basic tasks (reboot/reset/backup/restore/etc.)
- Test restore
- Move terraform state to Azure
- GitHub Action for terraform
- SQL "testing" database panic button
- Optional SQL automations
- IAM user per VPN machine?
- VM & SQL server reservation
- Billing IAM account & e-mails
- Use pre-bought licenses

