if($release)
{
    $headers = @{
        "Authorization" = "Bearer $env:API_APPVEYOR_TOKEN"
        "Content-type" = "application/json"
        "Accept" = "application/json"
    }
    $build = @{
        nextBuildNumber = 1
    }
    $json = $build | ConvertTo-Json
    Invoke-RestMethod -Method Put "https://ci.appveyor.com/api/projects/$env:APPVEYOR_ACCOUNT_NAME/$env:APPVEYOR_PROJECT_SLUG/settings/build-number" -Body $json -Headers $headers
}

if($documentation)
{
    $key = ("-----BEGIN RSA PRIVATE KEY-----`n" +
            $env:DEPLOY_KEY.Replace(' ', "`n") +
            "`n-----END RSA PRIVATE KEY-----`n")
    Set-Content "$Home\.ssh\id_rsa" $key
    git clone "git@github.com:ExtendedXmlSerializer/documentation.git" -b gh-pages .wwwroot -q
    Copy-Item .wwwroot/.git documentation/.wwwroot -recurse
    CD documentation/.wwwroot
    git config user.email $env:DEPLOY_EMAIL
    git config user.name $env:DEPLOY_USER
    git config core.safecrlf false
    git add -A 2>&1
    git commit -m "AppVeyor Continuous Deployment Documentation Update v$($env:APPVEYOR_BUILD_VERSION)" -q
    git push origin gh-pages -q
}