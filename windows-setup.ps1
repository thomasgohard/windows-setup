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
		$cursorPosition = $host.UI.RawUI.CursorPosition

		Write-Host "Not installed. " -NoNewline
		$lineLength = $host.UI.RawUI.CursorPosition.X - $cursorPosition.X
		$host.UI.RawUI.CursorPosition = $cursorPosition

		$packageAvailable = Find-WinGetPackage -ID $app.id -Exact
		if ($null -eq $packageAvailable) {
			Write-Host "Application not available from $appSource."
		} else {
			Write-Host "Application found in $appSource. " -NoNewline
			$host.UI.RawUI.CursorPosition = $cursorPosition

			Install-WinGetPackage -ID $app.id -Exact
			$host.UI.RawUI.CursorPosition = $cursorPosition

			Write-Host "$($app.id) installed." -NoNewline
			for ($i = 0; $i -lt 9; $i++) {
				Write-Host " " -NoNewline
			}
			Write-Host ""
		}
	}
}