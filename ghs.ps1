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
Write-Host "Hide Wikis, Issues, Sponsorships, Archiving, Discussions and Projects from Features" -ForegroundColor Black -BackgroundColor DarkYellow

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

Write-Host "disable in Home Page: Release, Packages, Deployments" -ForegroundColor Black -BackgroundColor DarkYellow
