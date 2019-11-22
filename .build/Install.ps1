# Taken from psake https://github.com/psake/psake
<#
.SYNOPSIS
    This is a helper function that runs a scriptblock and checks the PS variable $lastexitcode
    to see if an error occcured. If an error is detected then an exception is thrown.
    This function allows you to run command-line programs without having to
    explicitly check the $lastexitcode variable.
.EXAMPLE
    Exec { svn info $repository_trunk } "Error executing SVN. Please verify SVN command-line client is installed"
#>
function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ($msgs.error_bad_command -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

$release       = $env:APPVEYOR_REPO_TAG -eq "true" -and $env:APPVEYOR_REPO_TAG_NAME
$documentation = $false; # $release -or $env:APPVEYOR_REPO_BRANCH  -eq "documentation-debug"
Set-AppveyorBuildVariable "DEPLOY_RELEASE_ENABLED" $env:APPVEYOR_REPO_TAG

if ($release)
{
	Install-Module -Name PowerShellForGitHub
}

if($documentation)
{
    git checkout $env:APPVEYOR_REPO_BRANCH -q
    choco install docfx -y
}

git submodule -q update --init
git submodule update --rebase --remote