#Requires -Version 5.1
#Requires -RunAsAdministrator
#Requires -Module Cobalt

$computerName = ""
$appSource = "WinGet"
$apps = @(
	@{ id = "Git.Git"; name = "Git" },
	@{ id = "GitHub.cli"; name = "GitHub CLI" },
	@{ id = "ScummVM.ScummVM"; name = "ScummVM" }
)
$overwritingCharacter = " "
$rebootNeeded = $false

Write-Host "Setting computer name: " -NoNewline
if ($env:COMPUTERNAME -ne $computerName) {
	Rename-Computer -NewName $computerName
}
Write-Host "Done."

Write-Host "Installing applications:"
foreach ($app in $apps) {
	Write-Host "`t$($app.name): " -NoNewline
	
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
			$lineLength = $host.UI.RawUI.CursorPosition.X - $cursorPosition.X
			$host.UI.RawUI.CursorPosition = $cursorPosition

			Install-WinGetPackage -ID $app.id -Exact
			$host.UI.RawUI.CursorPosition = $cursorPosition

			Write-Host "installed." -NoNewline
			$charsToOverwrite = [math]::Max(0, $lineLength - ($host.UI.RawUI.CursorPosition.X - $cursorPosition.X))
			$overwriteString = $overwritingCharacter * $charsToOverwrite
			Write-Host $overwriteString
		}
	}
}