#Start-Process powershell -Verb runAs
#Set-ExecutionPolicy RemoteSigned

Function rebuildCMSProject($solDir, $solFile, $pubUrl)
{
    #$fs = New-Object -ComObject Scripting.FileSystemObject
    #$f = $fs.GetFile("C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe")
    #$msbuildPath = $f.shortpath 

    if (![System.IO.Directory]::Exists("$pubUrl"))
    {
        New-Item -Path $pubUrl -ItemType directory
        #[System.IO.Directory]::CreateDirectory("$pubUrl")
    }

    $msbuild = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
    #$MSBuildLogger="/flp1:Append;LogFile=Build.log;Verbosity=Normal; /flp2:LogFile=BuildErrors.log;Verbosity=Normal;errorsonly"
    $devenv = "C:\Program Files\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"

    if ($solFile.EndsWith(".sln")) 
    {
        $solFileAbsPath = "$solDir\$solFile"
        $filename = [System.IO.Path]::GetFileName($solFile); 
        #$releaseProfile="Release"
        #$releaseCommandLine= '"{0}" "{1}" /build "{2}"' -f $devenv, $solFileAbsPath, $releaseProfile

        if(Test-Path $solFileAbsPath) 
        {
            Write-Host "Rebuilding $solFileAbsPath" -ForegroundColor DarkGreen
            & $msbuild $solFileAbsPath /t:rebuild /p:DeleteExistingFiles=True /p:Configuration=Release /t:WebPublish /p:WebPublishMethod=FileSystem /p:publishUrl=$pubUrl
            #& $devenv $solFileAbsPath /Rebuild
                
            if($LASTEXITCODE -eq 0)
            {
                Write-Host "Build SUCCESS" -ForegroundColor Green
                Clear-Host
                break
            }
            else
            {
                Write-Host "Build FAILED" -ForegroundColor Red
                    
                $action = Read-Host "Enter Y to Fix then continue, N to Terminate, I to Ignore and continue the build"
                    
                if($action -eq "Y")
                {
                    & $devenv $solFileAbsPath
                    wait-process -name devenv    
                }
                else 
                {
                    if($action -eq "I")
                    {
                        Write-Host "Ignoring build failure..."
                        #break
                    }
                    else
                    {
                        Write-Host "Terminating Build..." -ForegroundColor Red
                        break
                    }
                }
            }
        }
        else
        {
            Write-Host "File does not exist : $solFileAbsPath"
            Start-Sleep -s 5
            break
        }
    }

    #$publishBuild_CMSApp =  $solutionPath + "\src\website\CMS\CMSApp.csproj /property:SolutionDir=" + $solDir + " /p:Configuration=Release /p:Platform=AnyCPU /t:WebPublish /p:WebPublishMethod=FileSystem /p:DeleteExistingFiles=True  /p:publishUrl=" + $pubUrl
    #Invoke-Expression "$msbuildPath $publishBuild_CMSApp"

    #$publishBuild_App_Code = $solutionPath + "\src\website\CMS\CMSApp_AppCode.csproj /property:SolutionDir=" + $solDir + " /p:Configuration=Release /p:Platform=AnyCPU /t:WebPublish /p:WebPublishMethod=FileSystem /p:DeleteExistingFiles=False  /p:publishUrl=" + $pubUrl
    #Invoke-Expression "$msbuildPath $publishBuild_App_Code"

    #$publishBuild_MVC = $solutionPath + "\src\website\CMS\CMSApp_MVC.csproj /property:SolutionDir=" + $solDir + " /p:Configuration=Release /p:Platform=AnyCPU /t:WebPublish /p:WebPublishMethod=FileSystem /p:DeleteExistingFiles=False /p:publishUrl=" + $pubUrl
    #Invoke-Expression "$msbuildPath $publishBuild_MVC"

    #$publishPath = $publishdir
    #copy-item $precompilePath $publishPath -Recurse -Force
}

$today = Get-Date -format dd-MMMM-yyyy

$emCanSolutionDir = "C:\Projects\emerald-can"
$emCanPrecompilePath = $emCanSolutionPath + "\precompiled"
$emCanArtifactPath = "emerald-can.sln"
$emCanPublishdir = "${emCanPublishdir}\application"
$emCanPublishBakDir = "C:\Deployment Backup\EM\CA\" + $today
rebuildCMSProject $emCanSolutionDir $emCanArtifactPath $emCanPublishBakDir

$emUsSolutionDir = "C:\Projects\emerald-us"
$emUsPrecompilePath = $emUsSolutionPath + "\precompiled"
$emUsArtifactPath = "emerald-us.sln" 
$emUsPublishdir = "${emUsPublishdir}\application"
$emUsPublishBakDir = "C:\Deployment Backup\EM\US\" + $today
rebuildCMSProject $emUsSolutionDir $emUsArtifactPath $emUsPublishBakDir

$emUkSolutionDir = "C:\Projects\emerald-uk"
$emUkPrecompilePath = $emUkSolutionPath + "\precompiled"
$emUkArtifactPath = "emerald-uk.sln"
$emUkPublishdir = "${emUkPublishdir}\application"
$emUkPublishBakDir = "C:\Deployment Backup\EM\UK\" + $today
rebuildCMSProject $emUkSolutionDir $emUkArtifactPath $emUkPublishBakDir

$scCanSolutionDir = "C:\Projects\scenic-can"
$scCanPrecompilePath = $scCanSolutionPath + "\precompiled"
$scCanArtifactPath = "scenic-can.sln"
$scCanPublishdir = "${scCanPublishdir}\application"
$scCanPublishBakDir= "C:\Deployment Backup\ST\CA\" + $today
rebuildCMSProject $scCanSolutionDir $scCanArtifactPath $scCanPublishBakDir

$scUsSolutionDir = "C:\Projects\scenic-us"
$scUsPrecompilePath = $scUsSolutionPath + "\precompiled"
$scUsArtifactPath = "scenic-us.sln"
$scUsPublishdir = "${scUsPublishdir}\application"
$scUsPublishBakDir = "C:\Deployment Backup\ST\US\" + $today
rebuildCMSProject $scUsSolutionDir $scUsArtifactPath $scUsPublishBakDir

$scUkSolutionDir = "C:\Projects\scenic-uk"
$scUkPrecompilePath = $scUkSolutionPath + "\precompiled"
$scUkArtifactPath = "scenic-uk.sln"
$scUkPublishdir = "${scUkPublishdir}\application"
$scUkPublishBakDir = "C:\Deployment Backup\ST\UK\" + $today
rebuildCMSProject $scUkSolutionDir $scUkArtifactPath $scUkPublishBakDir