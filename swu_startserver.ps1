# Config #######################
$server_identity = "default"        #Changes path to your server data rust/server/my_server_identity. Useful for running multiple instances
$server_hostname = "Rust Server"    #The displayed name of your server
$server_maxplayers = 32             #Maximum amount of players allowed to connect to your server at a time
$server_seed = 1                    #Is the map generation seed
$server_worldsize = 1900            #Defines the size of the map generated (min 1000, max 6000)
$server_level = "Procedural Map"    #Sets the map of the server (Procedural Map) values: Barren, Craggy Island, Hapis, Savas Island
$server_port = 28015                #Sets the port the server will use. (default 28015 UDP)
$server_tickrate = 30               #Server refresh rate - Not recommended to go above 30
$rcon_port = 28016                  #Port to listen to for RCON
$rcon_password = "your_password"    #Sets the RCON password
$server_description = ""            #Command used to write a server description. Make \n to make a new line
$server_headerimage = ""            #Sets the serverbanner - picture must be 500x256
$server_url = ""                    #Sets the server 'Webpage'
################################

# Parameters ###################
$install_folder = "C:\Rust"         #Your install directory
$steam_folder = "C:\Rust\steamcmd"  #Your steamcmd folder
$token = ""                         #Token Github (not required)
################################

$host.ui.RawUI.WindowTitle = "SwuStartServer"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "##############################################################"
Write-Host "                       Mise a jour Rust"
Write-Host "##############################################################"
&"$($steam_folder)\steamcmd.exe" +login anonymous +force_install_dir "$($install_folder)" +app_update 258550 +quit

Write-Host " "
Write-Host "##############################################################"
Write-Host "                       Mise a jour uMod"
Write-Host "##############################################################"

$base64Token = [System.Convert]::ToBase64String([char[]]$token)
$headers = @{
	"Authorization" = 'Basic {0}' -f $base64Token;
	"User-Agent" = "ShutdownWhenRestart"; 
}
$response = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repositories/94599577/releases/latest" -Header $headers;
$newBuild = $response.name
$browser_download_url = $response.assets.browser_download_url

if (!(Test-Path "$($install_folder)\dl")) {
    New-Item -ItemType directory -Path "$($install_folder)\dl"
}

function uModUpdate {
    Write-Host "Download uMod '$($newBuild)'"
    Invoke-RestMethod -Method Get -Uri $browser_download_url -OutFile "$($install_folder)\dl\Oxide.Rust-$($newBuild).zip"
    Try {
	    Expand-Archive "$($install_folder)\dl\Oxide.Rust-$($newBuild).zip" -DestinationPath "$($install_folder)" -Force -ErrorAction Stop
    } Catch {
	    Write-Warning "An instance of RustDedicated.exe is already run!"
	    Write-Warning "Please stop your server and relaunch scripts!"
	    Start-Sleep -s 5
	    Exit
    }
    Write-Host "Success! uMod '$($newBuild)' is up to date."
}

$zip = Get-ChildItem -Path "$($install_folder)\dl" -Filter *.zip | Where-Object {$_.Name -like "Oxide.Rust*" }
if ($zip) {
    $currentVersion = $zip.BaseName.Split('-')[-1]
    $currentVersionSplitted = $currentVersion.Split('.');
    $newBuildSplitted = $newBuild.Split('.');
        
    for ($i = 0; $i -le 2; $i++) {
        if ($newBuildSplitted[$i] -gt $currentVersionSplitted[$i]) {
            $updateNeeded = $TRUE
        }
    }
    if ($updateNeeded) {
        uModUpdate
        Remove-Item -Path $zip.FullName -Force
     } else {
        Write-Host "uMod '$($newBuild)' is already up to date."
     }
} else {
    uModUpdate
}

Write-Host " "
Write-Host "##############################################################"
Write-Host "                     Demarrage du Serveur"
Write-Host "##############################################################"
Write-Host "Starting server '$($server_identity)' [$($server_level)] on port '$($server_port)'"
Write-Host "WebSocket RCon Started on '$($rcon_port)' with password '$($rcon_password)'"

$argList = "-batchmode +server.ip 0.0.0.0  +server.identity `"$($server_identity)`" +server.hostname `"$($server_hostname)`" +server.maxplayers $server_maxplayers +server.seed $server_seed +server.worldsize $server_worldsize +server.level `"$($server_level)`" +server.port $($server_port) +rcon.port $($rcon_port) +rcon.password `"$($rcon_password)`" +rcon.web 1 +server.description `"$($server_description)`" +server.headerimage `"$($server_headerimage)`" +server.url `"$($server_url)`" -logfile $($server_identity).log"
Start-Process -FilePath "$($install_folder)\RustDedicated.exe" -ArgumentList $argList