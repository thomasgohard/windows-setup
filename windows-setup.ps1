#Requires -RunAsAdministrator

$apps = @(
	@{ id = "" }
);

foreach ($app in $apps) {
	Get-InstallStatus($app.id);
}

function Get-InstallStatus($appId) {
    $status = "Not installed";
	$installedApps = winget list --id "$appId" | Select-Object -Last 1;

    if ($installedApps.Contains($appId)) {
        $status = "Installed"
    }

    return $status;
}