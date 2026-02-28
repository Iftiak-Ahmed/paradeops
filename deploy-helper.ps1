# ParadeOps Deployment Helper Script
# এই script deployment এর সময় কাজে লাগবে

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "ParadeOps Deployment Helper" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Function 1: Generate JWT Secret
function Generate-JWTSecret {
    Write-Host "Generating secure JWT secret..." -ForegroundColor Yellow
    $secret = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
    Write-Host "Your JWT Secret: $secret" -ForegroundColor Green
    Write-Host "Copy this to your .env file or Render environment variables" -ForegroundColor Gray
    return $secret
}

# Function 2: Export MongoDB Data
function Export-MongoData {
    Write-Host "Exporting MongoDB data..." -ForegroundColor Yellow
    $backupPath = ".\mongodb_backup"
    
    if (Test-Path $backupPath) {
        Remove-Item $backupPath -Recurse -Force
    }
    
    mongodump --db=paradeops_db --out=$backupPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Data exported successfully to $backupPath" -ForegroundColor Green
    } else {
        Write-Host "✗ Export failed. Is MongoDB running?" -ForegroundColor Red
    }
}

# Function 3: Import to MongoDB Atlas
function Import-ToAtlas {
    param([string]$AtlasUri)
    
    if (-not $AtlasUri) {
        $AtlasUri = Read-Host "Enter your MongoDB Atlas connection string"
    }
    
    Write-Host "Importing to MongoDB Atlas..." -ForegroundColor Yellow
    mongorestore --uri="$AtlasUri" --db=paradeops_db .\mongodb_backup\paradeops_db
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Data imported to Atlas successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Import failed. Check connection string and network access" -ForegroundColor Red
    }
}

# Function 4: Test Local Backend
function Test-LocalBackend {
    Write-Host "Testing local backend..." -ForegroundColor Yellow
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5000/health" -Method GET -ErrorAction Stop
        $content = $response.Content | ConvertFrom-Json
        
        Write-Host "✓ Backend is running!" -ForegroundColor Green
        Write-Host "  Status: $($content.status)" -ForegroundColor Gray
        Write-Host "  Time: $($content.timestamp)" -ForegroundColor Gray
    } catch {
        Write-Host "✗ Backend not responding. Is it running?" -ForegroundColor Red
        Write-Host "  Start with: cd backend; npm start" -ForegroundColor Yellow
    }
}

# Function 5: Check Git Status
function Check-GitStatus {
    Write-Host "Checking Git status..." -ForegroundColor Yellow
    
    $gitStatus = git status --porcelain
    
    if ($gitStatus) {
        Write-Host "Uncommitted changes found:" -ForegroundColor Yellow
        git status --short
        Write-Host ""
        Write-Host "Commit before deploying:" -ForegroundColor Cyan
        Write-Host "  git add ." -ForegroundColor Gray
        Write-Host "  git commit -m 'Prepare for deployment'" -ForegroundColor Gray
        Write-Host "  git push origin main" -ForegroundColor Gray
    } else {
        Write-Host "✓ Git is clean - ready to deploy!" -ForegroundColor Green
    }
}

# Function 6: Update Frontend Config for Production
function Update-FrontendConfig {
    param([string]$BackendUrl)
    
    if (-not $BackendUrl) {
        $BackendUrl = Read-Host "Enter your backend URL (e.g., https://paradeops-backend.onrender.com)"
    }
    
    Write-Host "Updating frontend config..." -ForegroundColor Yellow
    
    $configPath = ".\frontend\config.js"
    $content = Get-Content $configPath -Raw
    
    # Update API_BASE_URL
    $content = $content -replace "const API_BASE_URL = 'http://localhost:5000';", "const API_BASE_URL = '$BackendUrl';"
    
    Set-Content $configPath -Value $content
    
    Write-Host "✓ Configuration updated!" -ForegroundColor Green
    Write-Host "  Backend URL: $BackendUrl" -ForegroundColor Gray
    Write-Host "  Remember to commit and push this change!" -ForegroundColor Yellow
}

# Function 7: Create GitHub Repository (Instructions)
function Show-GitHubInstructions {
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "GitHub Repository Setup" -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Go to: https://github.com/new" -ForegroundColor White
    Write-Host "2. Repository name: ParadeOps" -ForegroundColor White
    Write-Host "3. Description: Military Leave Management System" -ForegroundColor White
    Write-Host "4. Choose: Private (recommended) or Public" -ForegroundColor White
    Write-Host "5. Click 'Create repository'" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run these commands:" -ForegroundColor Cyan
    Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/ParadeOps.git" -ForegroundColor Gray
    Write-Host "  git branch -M main" -ForegroundColor Gray
    Write-Host "  git push -u origin main" -ForegroundColor Gray
    Write-Host ""
}

# Main Menu
Write-Host "Select an option:" -ForegroundColor White
Write-Host "1. Generate JWT Secret" -ForegroundColor White
Write-Host "2. Export MongoDB Data (for Atlas migration)" -ForegroundColor White
Write-Host "3. Import Data to MongoDB Atlas" -ForegroundColor White
Write-Host "4. Test Local Backend" -ForegroundColor White
Write-Host "5. Check Git Status" -ForegroundColor White
Write-Host "6. Update Frontend Config for Production" -ForegroundColor White
Write-Host "7. Show GitHub Setup Instructions" -ForegroundColor White
Write-Host "8. Run All Pre-Deployment Checks" -ForegroundColor White
Write-Host "0. Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter choice (0-8)"

switch ($choice) {
    "1" { Generate-JWTSecret }
    "2" { Export-MongoData }
    "3" { Import-ToAtlas }
    "4" { Test-LocalBackend }
    "5" { Check-GitStatus }
    "6" { Update-FrontendConfig }
    "7" { Show-GitHubInstructions }
    "8" { 
        Write-Host "Running all checks..." -ForegroundColor Cyan
        Write-Host ""
        Test-LocalBackend
        Write-Host ""
        Check-GitStatus
        Write-Host ""
        Write-Host "✓ Pre-deployment checks complete!" -ForegroundColor Green
    }
    "0" { Write-Host "Goodbye!" -ForegroundColor Cyan }
    default { Write-Host "Invalid choice" -ForegroundColor Red }
}

Write-Host ""
Write-Host "For full deployment guide, see DEPLOYMENT.md" -ForegroundColor Gray
Write-Host ""
