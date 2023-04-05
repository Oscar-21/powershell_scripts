$progressPreference = 'silentlyContinue'
$desktop = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders').Desktop
$zip_path = Join-Path -Path $desktop -ChildPath 'aws-schema-conversion-tool-1.0.latest.zip'
$Url = 'https://s3.amazonaws.com/publicsctdownload/Windows/aws-schema-conversion-tool-1.0.latest.zip'
$DownloadZipFile = $desktop + $(Split-Path -Path $Url -Leaf)
Invoke-WebRequest -Uri $Url -OutFile $DownloadZipFile
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
  param([string]$zipfile, [string]$outpath)
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
$sct_unzip_path = Join-Path -Path $desktop -ChildPath 'aws-schema-conversion-tool-1.0.latest'
Unzip $zip_path $sct_unzip_path
$sct_msi_path =  Join-Path -Path $desktop -ChildPath 'aws-schema-conversion-tool-1.0.latest/AWS Schema Conversion Tool-1.0.671.msi'
msiexec /i "C:\Users\austi\OneDrive\Desktop\aws-schema-conversion-tool-1.0.latest\AWS Schema Conversion Tool-1.0.671.msi" /q /passive  /l*v "install.log"