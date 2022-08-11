$connectionName = "AzureRunAsConnection"
Write-Output  "Logging in to Azure..." -verbose
$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName  
	
Connect-AzAccount `
	-ServicePrincipal `
	-TenantId $servicePrincipalConnection.TenantId `
	-ApplicationId $servicePrincipalConnection.ApplicationId `
	-CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

Connect-AzureAD
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "<Password>"
New-AzureADUser -AccountEnabled $true -DisplayName "Runbook" -PasswordProfile $PasswordProfile
