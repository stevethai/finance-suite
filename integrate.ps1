param(
    [string[]] $branches = @(
        "architect-openapi",
        "backend-transactions",
        "frontend-dashboard",
        "ci-cd-workflows",
        "qa-tests",
        "ui-assets",
        "feature/transactions-api",
        "feature/dashboard-ui"
    )
)

Write-Host "🔄 Integrating branches into main..." -ForegroundColor Cyan

git checkout main
git pull origin main

foreach ($b in $branches) {
  Write-Host "➕ Merging $b" -ForegroundColor Yellow
  git fetch origin $b
  git merge origin/$b --no-ff -m "chore: merge $b into main"
}

git push origin main

Write-Host "✅ All branches merged into main!" -ForegroundColor Green
