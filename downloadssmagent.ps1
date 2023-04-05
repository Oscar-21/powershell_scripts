$progressPreference = 'silentlyContinue'

$sct_install_source = 'https://s3.amazonaws.com/publicsctdownload/Windows/aws-schema-conversion-tool-1.0.671.zip'
$sct_download_path = "$env:USERPROFILE\Desktop\aws-schema-conversion-tool-1.0.671.zip"
$sct_unzip_path = "$env:USERPROFILE\Desktop\aws-schema-conversion-tool-1.0.671"
$sct_install_path = "`"C:\Program Files\AWS Schema Conversion Tool`""

Invoke-WebRequest -Uri $sct_install_source -OutFile $sct_download_path

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
  param([string]$zipfile, [string]$outpath)
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Unzip "$env:USERPROFILE\Desktop\aws-schema-conversion-tool-1.0.671.zip" "$env:USERPROFILE\Desktop\aws-schema-conversion-tool-1.0.671"


$sct_msi_path = "`"$env:USERPROFILE\Desktop\aws-schema-conversion-tool-1.0.671/AWS Schema Conversion Tool-1.0.671.msi`""

$DataStamp = get-date -Format yyyyMMddTHHmmss
$logFile = '{0}-{1}.log' -f $sct_msi_path,$DataStamp
$MSIArguments = @(
    "/i"
    ('"{0}"' -f $sct_msi_path)
    "/qn"
    "/norestart"
    "/L*v"
    $logFile
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 

Start-Process `
  -FilePath $env:USERPROFILE\Desktop\aws-schema-conversion-tool-1.0.671/AWS Schema Conversion Tool-1.0.671.msi`
  -ArgumentList "/S"

rm -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe

$install_path = "`"C:\Program Files (x86)\Microsoft SQL Server Management Studio 19`""
$params = " /Install /Passive SSMSInstallRoot=$install_path"

Invoke-WebRequest `
  https://aka.ms/ssmsfullsetup `
  -OutFile $env:USERPROFILE\Desktop\SSMS-Setup-ENU.exe

Start-Process `
  -FilePath $env:USERPROFILE\Desktop\SSMS-Setup-ENU.exe `
  -ArgumentList $params -Wait

