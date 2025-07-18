# bootstrap-all.ps1
param(
  [string] $RepoRoot = (Get-Location).Path,
  [string] $MainBranch = "main"
)

Set-Location $RepoRoot
Write-Host "🚀 Starting full monorepo bootstrap..."

# 1) Ensure main is up to date
git checkout $MainBranch
git pull origin $MainBranch

# 2) Define feature branches and skeletons
$features = @{
  "architect-openapi"       = @("api/docs/.gitkeep")
  "backend-transactions"    = @("backend/src/.gitkeep")
  "frontend-dashboard"      = @("frontend/src/.gitkeep")
  "ci-cd-workflows"         = @(".github/workflows/ci.yml") 
  "qa-tests"                = @("tests/jest/.gitkeep")
  "ui-assets"               = @("frontend/assets/.gitkeep")
}

foreach ($branch in $features.Keys) {
  # checkout or create
  if (git show-ref --quiet refs/heads/$branch) {
    git checkout $branch
  } else {
    git checkout $MainBranch
    git checkout -b $branch
  }

  # make skeleton files
  foreach ($path in $features[$branch]) {
    $full = Join-Path $RepoRoot $path
    $dir  = Split-Path $full -Parent
    New-Item -ItemType Directory -Force $dir | Out-Null
    New-Item -ItemType File -Force $full   | Out-Null
  }

  # commit & push
  git add .
  git commit -m "chore($branch): init skeleton"
  git push -u origin $branch
}

# 3) Merge all features into main
git checkout $MainBranch
foreach ($branch in $features.Keys) {
  git fetch origin $branch
  git merge --no-ff origin/$branch -m "chore: merge $branch into main"
}
git push origin $MainBranch

# 4) Scaffold Frontend (Vite+React)
if (-Not (Test-Path "$RepoRoot/frontend/package.json")) {
  Write-Host "✨ Scaffolding Vite+React in ./frontend"
  cd frontend
  npm init vite@latest . -- --template react
  npm install
  cd $RepoRoot
}

# 5) Scaffold Backend (NestJS)
if (-Not (Test-Path "$RepoRoot/backend/package.json")) {
  Write-Host "✨ Scaffolding NestJS in ./backend"
  cd backend
  npm init @nestjs/app@latest . -- --no-git
  npm install
  cd $RepoRoot
}

Write-Host "✅ Done! You now have a monorepo with:"
Write-Host "   - main branch containing all skeletons"
Write-Host "   - frontend scaffolded (npm run dev)"
Write-Host "   - backend scaffolded (npm run start:dev)"
