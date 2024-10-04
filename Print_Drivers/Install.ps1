###############################
#TOSHIBA Universal Printer 2  #
################################
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$drivername = "Xerox_UPD_0"


###################
#Staging Drivers   #
###################
C:\Windows\SysNative\pnputil.exe /add-driver "$psscriptroot\Drivers\x3UNIVP.inf" /install

#######################
#Installing Drivers   #
#######################

Add-PrinterDriver -Name $drivername


####################################
#Check if PrinterDriver Exists     #
####################################
$printDriverExists = Get-PrinterDriver -name $DriverName -ErrorAction SilentlyContinue




SLEEP 360