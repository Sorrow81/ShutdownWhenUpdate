# Parameters ###################
$script_folder = "C:\Rust"          #Your script_folder
$check_interval = 300               #Interval to check server in seconds
################################

$host.ui.RawUI.WindowTitle = "SwuCheckServer"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProcessNameToCheck = @("RustDedicated", "SwuStartServer")
while ($TRUE){
	Write-Host "Check RustDedicated is running..."
	$RustDedicatedIsRunning = Get-Process -Name $ProcessNameToCheck[0] -ErrorAction SilentlyContinue
	$StartServerIsRunning = Get-Process powershell | Where-Object {$_.MainWindowTitle -match $ProcessNameToCheck[1]} 
	if (!$RustDedicatedIsRunning -and !$StartServerIsRunning) {
		Write-Host "RustDedicated KO..."
		Write-Host "Start server"
		$argList = "-file `"$($script_folder)\swr_startserver.ps1`""
		Start-Process powershell -ArgumentList $argList
	} else {
		Write-Host "RustDedicated OK"
	}

	Write-Host "Sleep $($check_interval) seconds..."
	Start-Sleep -s $check_interval
}