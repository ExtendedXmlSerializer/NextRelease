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
    if ($LastExitCode -ne 0) {
		$host.SetShouldExit($LastExitCode)
        throw ("Exec: " + $errorMessage)		
    }
}

if ($env:APPVEYOR_FORCED_BUILD)
{
	$env:APPVEYOR_REPO_BRANCH = "$env:APPVEYOR_REPO_TAG_NAME"
	
	git checkout -b $env:APPVEYOR_REPO_TAG_NAME "tags/$($env:APPVEYOR_REPO_TAG_NAME)"
}

Get-ChildItem Env:


git submodule update --init -q