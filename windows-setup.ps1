#Requires -Version 5.1
#Requires -RunAsAdministrator
#Requires -Module Cobalt

$appSource = "WinGet"
$apps = @(
	@{ id = "Git.Git" },
	@{ id = "GitHub.cli" }
)

Write-Host "Installing applications:"
foreach ($app in $apps) {
	Write-Host "`t$($app.id): " -NoNewline
	
	$packageDetails = Get-WinGetPackage -ID $app.id -Exact
	if ($null -ne $packageDetails) {
		Write-Host "Already installed."
	} else {
		Write-Host "Not installed. " -NoNewline

		$packageAvailable = Find-WinGetPackage -ID $app.id -Exact
		if ($null -eq $packageAvailable) {
			Write-Host "Application not available from $appSource."
		} else {
			Write-Host "Application found in $appSource. " -NoNewline

			Install-WinGetPackage -ID $app.id -Exact

			Write-Host "$($app.id) installed."
		}
	}
}