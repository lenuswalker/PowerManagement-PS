#Power Management PowerShell Script

#Import AudioDeviceCmdlets
Import-Module AudioDeviceCmdlets

#Check Machine Type to see if it is a laptop

$ChassisTypes = (Get-WmiObject -Class Win32_SystemEnclosure).ChassisTypes
 
Switch($ChassisTypes) {
 
    3 { $Chassis = "Desktop" }
    4 { $Chassis = "Desktop" }
    5 { $Chassis = "Desktop" }
    6 { $Chassis = "Desktop" }
    7 { $Chassis = "Desktop" }
    8 { $Chassis = "Laptop" }
    9 { $Chassis = "Laptop" }
    10 { $Chassis = "Laptop" }
    11 { $Chassis = "Laptop" }
    12 { $Chassis = "Laptop" }
    14 { $Chassis = "Laptop" }
    15 { $Chassis = "Desktop" }
    16 { $Chassis = "Desktop" }
    18 { $Chassis = "Laptop" }
    21 { $Chassis = "Laptop" }
    23 { $Chassis = "Server" }
    31 { $Chassis = "Laptop" }
 
}

#Define apps to open and close
$appsToClose = @("C:\Program Files (x86)\ASUS\GPU TweakII\GPUTweakII.exe"
            #,"C:\Program Files\PowerToys\PowerToys.exe"
            ,"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterMacroButtons.exe"
            ,"C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8.exe"
            ,"C:\Program Files (x86)\Intel\Driver and Support Assistant\DSAService.exe"
            ,"C:\Program Files (x86)\Intel\Driver and Support Assistant\DSAUpdateService.exe"
            ,"C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe"
            ,"C:\Program Files (x86)\Battle.net\Battle.net.exe"
            ,"C:\Program Files\WindowsApps\28017CharlesMilette.TranslucentTB_9.0.0.0_x86__v826wp6bftszj\TranslucentTB\TranslucentTB.exe")

$appsToStart = @("C:\Program Files (x86)\ASUS\GPU TweakII\GPUTweakII.exe"
                #,"C:\Program Files\PowerToys\PowerToys.exe"
                ,"C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8.exe"
                ,"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterMacroButtons.exe"
                ,"C:\Program Files\WindowsApps\28017CharlesMilette.TranslucentTB_9.0.0.0_x86__v826wp6bftszj\TranslucentTB\TranslucentTB.exe")


#Do Stuff
If($Chassis -eq "Laptop") {
 
    $PowerStatus = (Get-WmiObject -Class BatteryStatus  -Namespace root\wmi -ErrorAction SilentlyContinue).PowerOnLine
    
    #Do stuff when on battery
    If($PowerStatus -ne $True) {
        
        
        #Set Screen Brightness to 15%
        $brightness = 15
        (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,$brightness)
            
        #Start the defined app if it is not running.
        foreach ($app in $appsToClose) {
            $appName = (Get-ChildItem $app).BaseName
            if(! ((Get-Process $appName -ea SilentlyContinue) -eq $null)){
                Stop-Process -Name $appName -Force
            }
        }

        #Set Default Laptop Audio
        Set-AudioDevice -ID "{0.0.0.00000000}.{e8f51808-5570-4543-8c84-5faa7ef1ed1b}"

    #Do stuff when on AC 
    } else {
    
        # Set Screen Brightness to 100%
        $brightness = 100
        (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,$brightness)

        # Start the defined app if it is not running.
        foreach ($app in $appsToStart) {
            $appName = (Get-ChildItem $app).BaseName
            if((Get-Process $appName -ea SilentlyContinue) -eq $null){
                #Starting a special windows store app
                if($appName -eq "TranslucentTB") {
                    Start-Process shell:AppsFolder\28017CharlesMilette.TranslucentTB_v826wp6bftszj!App
                }
                #Start all other apps
                else {
                    Start-Process $app -WindowStyle Minimized
                }
            }
        }

        #Set Default Voicemeeter Audio
        Set-AudioDevice -ID "{0.0.0.00000000}.{9b0402ee-7854-415c-be21-b789613f143f}"
        
    }
 
}

