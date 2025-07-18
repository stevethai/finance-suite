# start-all.ps1
param(
  [string] $RepoRoot = (Get-Location).Path
)

# 1) Backend
Write-Host "▶️ Starting backend..."
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$RepoRoot\backend`"; npm install; npm run start:dev"

# 2) Frontend
Write-Host "▶️ Starting frontend..."
Start-Process pwsh -ArgumentList "-NoExit","-Command","cd `"$RepoRoot\frontend`"; npm install; npm run dev"

Write-Host "`n✅ Both servers launched in separate windows!"
