[cmdletbinding()]
param(
    [string]
    [Parameter(Mandatory = $true, Position = 0)]
    $gallery
)

# Get previous version of Az
if($gallery -eq "LocalRepo"){
    $versions = (find-module Az -Repository PSGallery -AllVersions).Version | Sort-Object -Descending
    $previousVersion = $versions[0]
}else{
    $versions = (find-module Az -Repository $gallery -AllVersions).Version | Sort-Object -Descending
    $previousVersion = $versions[1]
}

# Install previous version of Az
Write-Host 'Installing the previous version of Az:', $previousVersion
Install-Module -Name Az -Repository $gallery -RequiredVersion $previousVersion -Scope CurrentUser -AllowClobber -Force

#Update Az
Write-Host "Installing latest Az"
Update-Module -Name Az -Scope CurrentUser -Force
        
# Check details of Az 
Write-Host "Check latest version of Az"
Get-Module -Name Az.* -ListAvailable

# Check Az version
Import-Module -MinimumVersion '2.6.0' -Name 'Az' -Force -Scope 'Global'
$azVersion = (get-module Az).Version
Write-Host "Current version of Az", $azVersion

if ([System.Version]$azVersion -le [System.Version]$previousVersion) {
    throw "Update Az failed"
}