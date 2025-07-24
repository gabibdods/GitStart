$repository = Read-Host "Name"
New-Item -Path "C:\Users\$env:UserName" -Name "_$repository" -ItemType "Directory"


Set-Location -Path "C:\Users\$env:UserName\_$repository"

git init

git clone https://github.com/gabibdods/NewRepositoryTemplate

Remove-Item -Path .\NewRepositoryTemplate\.git -Recurse -Force

Move-Item -Path .\NewRepositoryTemplate\* -Destination .

Remove-Item -Path .\NewRepositoryTemplate -Recurse -Force


git add .

git status

git commit -m "created license and rights"

gh repo create $repository --public --source=. --remote=origin --push

git push --set-upstream origin main


Write-Host "enable in Settings -> Pull Requests: Automatically delete head branches" -ForegroundColor Black -BackgroundColor DarkYellow
gh api `
	-X PATCH /repos/gabibdods/$repository `
	-f delete_branch_on_merge=true

Write-Host "disable in Settings -> Default Branch: Wikis, Issues, Sponsorships, Discussions, Projects" -ForegroundColor Black -BackgroundColor Green
gh api `
	-X PATCH /repos/gabibdods/$repository `
	-f has_wiki=false `
	-f has_issues=false `
	-f has_projects=false `
	-f has_discussions=false

Write-Host "create in Branch -> Branch Protection Rule: Lock branch" -ForegroundColor Black -BackgroundColor DarkYellow

Write-Host "disable in Home Page: Release, Packages, Deployments" -ForegroundColor Black -BackgroundColor DarkBlue

Write-Host "enable in Settings -> General: Require contributors to sign off on web-based commits" -ForegroundColor Black -BackgroundColor DarkYellow
