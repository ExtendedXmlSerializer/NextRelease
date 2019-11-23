Param([Parameter(Mandatory=$true)]
      [String]$Owner, 
      [Parameter(Mandatory=$true)]
      [String]$Repository,
      [String]$Template = @"
{{#releases}}
# [{{ name }}]({{ html_url }})
> {{ published_at }} UTC
##### ``{{ tag_name }}``

{{ body }}
{{/releases}}
"@)
Install-Module Poshstache -Force
Install-Module -Name PowerShellForGitHub -Force

$releases = @{ releases = Get-GitHubRelease -DisableTelemetry -OwnerName $Owner -RepositoryName $Repository -NoStatus | Sort-Object published_at -Descending } | ConvertTo-Json
ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject $releases
