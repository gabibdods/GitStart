# Setting variables
param(
	[string]$owner = 'gabibdods',
	[string]$repository,
	[string]$token = $env:GITHUB_PAT,
	[string]$branch = 'main'
)
if (-not $repository) {
    $repository = Read-Host "Name"
}
if (-not $token) {
	Write-Error "GITHUB_PAT error!"
    exit 1
}

$headers = @{
    Authorization = "Bearer $Token"
    Accept = "application/vnd.github+json"
}



# Using template
New-Item -Path "C:\Users\$env:UserName" -Name "_$repository" -ItemType "Directory"

Set-Location -Path "C:\Users\$env:UserName\_$repository"

git init

git clone https://github.com/gabibdods/NewRepositoryTemplate

Remove-Item -Path .\NewRepositoryTemplate\.git -Recurse -Force

Remove-Item -Path .\NewRepositoryTemplate\Example.txt -Recurse -Force

Move-Item -Path .\NewRepositoryTemplate\* -Destination .

Remove-Item -Path .\NewRepositoryTemplate -Recurse -Force

git config --global commit.gpgsign true



# Creating the repository
git add .

git commit -m "created license and rights"

$create = @{
  name = $repository
  description = ''
  private = $false
  auto_init = $false
} | ConvertTo-Json

Invoke-RestMethod `
	-Uri "https://api.github.com/user/repos" `
	-Method Post `
	-Headers $headers `
	-Body $create
	
git remote add origin "https://github.com/$owner/$repository.git"

git push --set-upstream origin main



# Configuring security
Write-Host "Hide Wikis, Issues, Sponsorships, !Preserving, Discussions and Projects from Features" -ForegroundColor Black -BackgroundColor DarkYellow

Write-Host "Enable Automatically delete head branches from Pull Requests" -ForegroundColor Black -BackgroundColor Green

$hide = @{
	has_wiki = $false
	has_issues = $false
	has_discussions = $false
	has_projects = $false
	delete_branch_on_merge = $true
} | ConvertTo-Json

Invoke-RestMethod `
	-Uri "https://api.github.com/repos/$owner/$repository" `
	-Method Patch `
	-Headers $headers `
	-Body $hide

Write-Host "Enable Require contributors to sign off on web-based commits from General" -ForegroundColor Black -BackgroundColor DarkYellow

$security = @{
    web_commit_signoff_required = $true
} | ConvertTo-Json

Invoke-RestMethod `
	-Uri "https://api.github.com/repos/$owner/$repository" `
	-Method Patch `
	-Headers $headers `
	-Body $security

Write-Host "Create Require signed commits, Lock branch; then save from main in Branch Protection Rule" -ForegroundColor Black -BackgroundColor DarkBlue

$baseProtection = @{
  required_status_checks = $null
  enforce_admins = $false
  required_pull_request_reviews = $null
  restrictions = $null
  lock_branch = $true
} | ConvertTo-Json

Invoke-RestMethod `
  -Uri "https://api.github.com/repos/$owner/$repository/branches/$branch/protection" `
  -Method Put `
  -Headers $headers `
  -Body $baseProtection

Invoke-RestMethod `
  -Uri "https://api.github.com/repos/$owner/$repository/branches/$branch/protection/required_signatures" `
  -Method Post `
  -Headers $headers `

Write-Host "disable in Home Page: !Release, !Packages, !Deployments" -ForegroundColor Black -BackgroundColor DarkYellow

# SIG # Begin signature block
# MIIFTAYJKoZIhvcNAQcCoIIFPTCCBTkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+bbEENeFjJ0W8GBORVE6+qd7
# J8KgggLyMIIC7jCCAdagAwIBAgIQWSj70TfSk4BFW3uYTtJmvTANBgkqhkiG9w0B
# AQUFADAPMQ0wCwYDVQQDDARQU0NTMB4XDTI1MDgwMzIzNDA0N1oXDTI2MDgwNDAw
# MDA0N1owDzENMAsGA1UEAwwEUFNDUzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAJnlMgf2FSRqdEqJV7nJHDbEz6H4Z6ts8kShiQydp9ldXP4aYIEttfSq
# uwTpAga+k/jZXKDVCAFFn4y/qjmgFG+Dx/F16fN8mYd4CRWayLXxbToYpFMXGae2
# Ifz1Aesg71amgPduYwGL7Lm1/wnHBS4lKiuf1+x+0pN/8ZxhOJGZ+Y9V82bCpFuX
# MuZViQFGbLGCpDTQ+kkT9RTMtdQS1BzuBpyzm62kD370GzoLVw6UTI9O4d0YDZtf
# BQPOGxy3o3mn3WTnjUi9A1pSrYV2fUOUSINbnJUBS5IdvqpDoA+A77CkySbgpeJJ
# yfN9lBCqsTGT1KxGV/1oPrwDjFF383UCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBRxx5o2bdOn35Y8TCAYmD4q
# PLfQdzANBgkqhkiG9w0BAQUFAAOCAQEAAgpanXiC7DhJnaqNvoRpYbawRGobG5oT
# wSkdKkmWVphfd8ybywxadfVmXsLH87DrRBj2cG/SGM7HCT76W7rHIIH6bCAqvg/R
# CVa9lEzdC3sWcPkiV8NJsvjpu5XkMsTncvWLaZ2XvAED3MgX3i13/H2cSmIqC8rp
# eSv+RDPPFWPwx+W8Tmi6J5KF+tmEC4iiN4c+8FXMdMfhlBy1bKOH55xDWGkL3dH2
# thvIosMYzJTmq8zJsGOT6/ZrcY+TQYMLOc78OdZJz0Yx9KAYTD/mhJqyvHgGnY56
# LRLH9Z+HQT2XtxNCktRz7p6JZu7pzaCX8xfVdl8P3PfhQq9DxMY7jDGCAcQwggHA
# AgEBMCMwDzENMAsGA1UEAwwEUFNDUwIQWSj70TfSk4BFW3uYTtJmvTAJBgUrDgMC
# GgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYK
# KwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG
# 9w0BCQQxFgQU64MoOQI+TWqeUVCZUh+Kv/jZmHkwDQYJKoZIhvcNAQEBBQAEggEA
# OIwlEVFFESklIqCaQeZQ2GRMdJcEZdSzMgq1zmZsHD2hcMX1pMg18n39eY49tpBA
# sTuShORJm56ixRw4AhFCSHkbSSvWp0jktGz380ub/meY2GF+Wi089ba/40rBWPHN
# AC7VT3HtWDfqOz7/mH5bMyCG6x3fuqV189FWdwHSrVjZYaZ0PPqRhx4LPHxvrk6B
# tFp/KhgGLppnwscmP7uQF/8DZxEI2eMtywwFLqJlMv/vEAa376f/HoE3ttM0rt3Y
# +LfdHVnZBLvb5MrbrTDWGl0oN9iUgdZ3FeeVcZoBlRNEmLT3WuQgnMzGZNhg7w9I
# 5Egy28TTsENVPzOOuGk9EQ==
# SIG # End signature block
