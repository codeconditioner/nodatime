# Static code analysis scripts to run code analysis and send results to SonarCloud.io
# https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+MSBuild

[CmdletBinding()]
Param(
    [Parameter(Position=1)]
    [switch] $startSonar = $false,
    [switch] $publishSonar = $false,
    # SQ records analysis history, each having its version label
    [string] $version,
    # SonarCloud.io auth, generated in SQ administration
    [string] $authToken
)

if ($startSonar) {
    Write-Host "Starting SonarQube analysis of nodatime project (version=$version)... in $pwd"

    dotnet-sonarscanner begin `
        /key:nodatime `
        /name:"Noda Time" `
        /version:"$version" `
        /o:codeconditioner `
        /d:"sonar.host.url=https://sonarqube.com" `
        /d:"sonar.login=$authToken" `
        /d:"sonar.c.file.suffixes=-" `
        /d:"sonar.cpp.file.suffixes=-" `
        /d:"sonar.objc.file.suffixes=-" `
        /d:"sonar.cs.opencover.reportsPaths=results.xml"

    Write-Host "SonarQube analysis initialized. Awaiting dotnet build..."
}

if ($publishSonar) {
    Write-Host "Completing SonarQube analysis - publishing results to the server... in $pwd"
    dotnet-sonarscanner end /d:"sonar.login=$authToken"
    Write-Host "SonarQube analysis completed successfully!"
} 