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
$response = Invoke-RestMethod https://api.github.com/repos/$Owner/$Repository/releases | Sort-Object published_at -Descending
ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject (@{ releases = $response } | ConvertTo-Json)