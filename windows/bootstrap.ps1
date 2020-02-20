###
# Installing chocolatey, boxstarter and scoop

# ensure Execution Policy
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Set-ExecutionPolicy Unrestricted -Force
}
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

#installing chocolatey
if (!(Test-Path 'C:\ProgramData\chocolatey\bin\choco.exe')) {
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

# installing boxstarter
if (!(Test-Path 'C:\ProgramData\Boxstarter\BoxstarterShell.ps1')) {
    . { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
}

# installing scoop
iwr -useb get.scoop.sh | iex

###
# installing necessary platforms
cinst -y javaruntime
cinst -y java.jdk
cinst -y nodejs.install
cinst -y python
cisnt -y git.install
cinst -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures
cinst -y sysinternals

$dotnet = @("dotnet4.5", 
	    "dotnet4.6", "dotnet4.6.1", "dotnet4.6.2", 
	    "dotnet4.7", "dotnet4.7.1",
	    "netfx-4.5.1-devpack", "netfx-4.5.2-devpack",
	    "netfx-4.6.1-devpack",
	    "netfx-4.7-devpack", "netfx-4.7.1-devpack", "netfx-4.7.2-devpack"
	   )

foreach ($item in $dotnet){
	cinst -y $item --cacheLocation="c:\temp"
}


###
# Setup boxstarter
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot


###
# Temp Config
Disable-UAC
Disable-MicrosoftUpdate


###
# Configure Windows
Disable-InternetExplorerESC
Disable-GameBarTips
Enable-RemoteDesktop
Disable-Bing-Search
Update-ExecutionPolicy Unrestricted

Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol

Set-WindowsExplorerOptions `
	-EnableShowHiddenFilesFoldersDrives `
	-EnableShowFileExtensions `
	-EnableShowFullPathInTitleBar `
	-DisableOpenFileExplorerToQuickAccess `
	-DisableShowRecentFileFilesInQuickAccess `
	-DisableShowRecentFoldersInQuickAccess `

# declutter Windows
$declutterapps = @("*Autodesk*",
		   "BubbleWitch",
		   "*Dell*",
		   "*DisneyMagicKingdom",
		   "*Dropbox*",
		   "*Facebook*",
		   "*HiddenCityMysteryofShadows*"
		   "*Keeper*",
		   "king.com.CandyCrush",
		   "*MarchofEmpires*",
		   "*Minecraft*",
                   "*Netflix*",
		   "Microsoft.3DBuilder",
		   "Micorosoft.BingFinance",
		   "Microsoft.BingNews",
		   "Microsoft.BingSports",
		   "Microsoft.BingWeather",
		   "Microsoft.CommsPhone",
		   "Microsoft.Messaging",
		   "Microsoft.MicrosoftOfficeHub",
		   "Microsoft.MicorosoftStickyNotes",
		   "Microsoft.OneConnect",
		   "Microsoft.Office.OneNote",
		   "Microsoft.Office.Sway",
		   "Microsoft.People",
#		   "Microsoft.SkypeApp",
		   "Windows.Getstarted",
		   "Microsoft.WindowsAlarms",
		   "Microsoft.windowscommunicationapps",
		   "Microsoft.WindowsFeedbackHub",
		   "Microsoft.WindowsMaps",
		   "Microsoft.WindowsPhone",
		   "Microsoft.WindowsSoundRecorder",
		   "Micorosoft.Windows.Photos",
		   "Microsoft.XboxApp",
		   "Micorosoft.XboxIdentityProvider",
		   "Microsoft.ZuneMusic",
		   "Micorsoft.ZuneVideo",
#		   "*Plex*",
		   "*Solitaire*",
		   "TuneIn.TuneInRadio",
		   "*Twitter*",
		   )
		   
foreach ($item in $declutterapps){
	Write-Host "removing $item from system"
	GetAppxPackage $item | Remove-AppxPackage -ErrorAction SilentlyContinue
}


# Installting OS Updates
Install-WindowsUpdate -Full -AcceptEula

###
# launch ansible configuration
# @TODO

###
# installing additional software
cinst -y itunes --cacheLocation="c:\temp"
# cinst -y microsoft-teams.install

###
# Cleanup
Enable-MicrosoftUpdate
Enable-UAC
