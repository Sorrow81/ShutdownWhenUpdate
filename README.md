You need a solution to automatically update Rust and uMod on your server, you've come to the right place.

## How to use

Download **ShutdownWhenUpdate.cs** on [uMod](https://umod.org/plugins) and put it in your Oxide plugins folder.

Download powershell scripts files, **swu_checkserver.ps1** and **swu_startserver.ps1** and put it in your script folder.

Configure **swu_checkserver.ps1**

```ps1
# Parameters ###################
$script_folder = "C:\Rust"          #Your script_folder
$check_interval = 300               #Interval to check server in seconds
################################
```

Configure **swu_startserver.ps1**

```ps1
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
```

Right click on **swu_checkserver.ps1** and Execute with Powershell.