$progressPreference = 'silentlyContinue'
$desktop = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders').Desktop
$url = 'https://s3.amazonaws.com/publicsctdownload/Windows/aws-schema-conversion-tool-1.0.latest.zip'
$zip_path = $desktop + $(Split-Path -Path $url -Leaf)
Invoke-WebRequest -Uri $url -OutFile $zip_path
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip { param([string]$zipfile, [string]$outpath) [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath) }
$sct_unzip_path = Join-Path -Path $desktop -ChildPath 'aws-schema-conversion-tool-1.0.latest'
Unzip $zip_path $sct_unzip_path
$sct_msi_path =  Join-Path -Path $desktop -ChildPath 'aws-schema-conversion-tool-1.0.latest/AWS Schema Conversion Tool-1.0.671.msi'
msiexec /i $sct_msi_path /q /passive  /l*v "install.log"