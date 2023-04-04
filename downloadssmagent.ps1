$progressPreference = 'silentlyContinue'
Invoke-WebRequest `
    https://amazon-ssm-us-east-1.s3.us-east-1.amazonaws.com/latest/windows_amd64/AmazonSSMAgentSetup.exe `
    -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe

Start-Process `
    -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe `
    -ArgumentList "/S"


rm -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe