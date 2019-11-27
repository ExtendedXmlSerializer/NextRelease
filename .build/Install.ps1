choco install docfx -y
Install-Module -Name PowerShellForGitHub

git checkout master -q
git submodule update --rebase --remote

Set-AppveyorBuildVariable "DEPLOY_RELEASE_ENABLED" $false