# ParadeOps Deployment Guide (Quick Start)

## 🚀 Deploy to Cloud (Free) - 30 Minutes

### Prerequisites
- Node.js installed (v14+)
- MongoDB running locally (for data export)
- GitHub account
- Git installed

---

## Step 1: MongoDB Atlas Setup (Free Database)

1. **Create Account**: https://www.mongodb.com/cloud/atlas/register
2. **Create Free Cluster**:
   - Choose AWS - Singapore region
   - Cluster name: `ParadeOps-Cluster`
3. **Create Database User**:
   - Username: `paradeops_admin`
   - Password: Generate strong password (save it!)
4. **Network Access**: Allow from Anywhere (0.0.0.0/0)
5. **Get Connection String**:
   ```
   mongodb+srv://paradeops_admin:YOUR_PASSWORD@paradeops-cluster.xxxxx.mongodb.net/paradeops_db?retryWrites=true&w=majority
   ```

### Export & Import Data

```powershell
# Export from local MongoDB
cd E:\SDP_Project
mongodump --db=paradeops_db --out=.\mongodb_backup

# Import to Atlas (replace with YOUR connection string)
mongorestore --uri="mongodb+srv://paradeops_admin:PASSWORD@cluster.mongodb.net" --db=paradeops_db .\mongodb_backup\paradeops_db
```

---

## Step 2: Push Code to GitHub

```powershell
# Navigate to project
cd E:\SDP_Project

# Check git status
git status

# Add all files
git add .

# Commit
git commit -m "Prepare for production deployment"

# Push to GitHub
git push origin main
```

**নতুন repository হলে:**
```powershell
# Initialize git
git init
git add .
git commit -m "Initial commit - ParadeOps"

# Create GitHub repository at: https://github.com/new
# Then add remote and push:
git remote add origin https://github.com/YOUR_USERNAME/ParadeOps.git
git branch -M main
git push -u origin main
```

---

## Step 3: Deploy Backend to Render.com

1. **Create Account**: https://render.com (Sign in with GitHub)

2. **Create Web Service**:
   - Dashboard → "New +" → "Web Service"
   - Connect GitHub repository: `ParadeOps`
   - Settings:
     ```
     Name: paradeops-backend
     Region: Singapore
     Branch: main
     Root Directory: backend
     Runtime: Node
     Build Command: npm install
     Start Command: node src/server.js
     Instance Type: Free
     ```

3. **Environment Variables** (Add these):
   ```
   MONGODB_URI = your_atlas_connection_string
   JWT_SECRET = generate_secure_32_char_secret
   NODE_ENV = production
   PORT = 5000
   CORS_ORIGIN = https://paradeops.netlify.app
   ```

4. **Deploy**: Click "Create Web Service" (wait 5-10 minutes)

5. **Your Backend URL**: `https://paradeops-backend.onrender.com`

6. **Test**: Visit `https://paradeops-backend.onrender.com/health`

---

## Step 4: Update Frontend Config

**File**: `frontend/config.js`

Change line 7:
```javascript
// Change from:
const API_BASE_URL = 'http://localhost:5000';

// To:
const API_BASE_URL = 'https://paradeops-backend.onrender.com';
```

Save and commit:
```powershell
git add frontend/config.js
git commit -m "Update API URL for production"
git push origin main
```

---

## Step 5: Deploy Frontend to Netlify

### Method 1: Drag & Drop (Easiest)

1. **Go to**: https://www.netlify.com
2. **Sign Up** with GitHub
3. **Deploy**: 
   - "Add new site" → "Deploy manually"
   - Drag entire `frontend` folder
   - Wait 1-2 minutes
4. **Live at**: `https://random-name-12345.netlify.app`

### Method 2: GitHub Auto-Deploy

1. Netlify Dashboard → "Add new site" → "Import project"
2. Select GitHub repository
3. Settings:
   - Base directory: `frontend`
   - Build command: (leave empty)
   - Publish directory: `.`
4. Deploy!

### Change Site Name (Optional)

- Site settings → "Change site name" → `paradeops`
- New URL: `https://paradeops.netlify.app`

---

## Step 6: Update Backend CORS

Go back to Render.com:
1. Your service → Environment → Edit `CORS_ORIGIN`
2. Change to: `https://paradeops.netlify.app`
3. Manual Deploy → "Deploy latest commit"

---

## Step 7: Test Everything! 🎉

1. **Visit**: `https://paradeops.netlify.app/login.html`
2. **Login**: 
   - Service Number: `BSM001`
   - Password: (your database password)
3. **Test Features**:
   - ✅ Dashboard loads
   - ✅ Submit leave application
   - ✅ Mark attendance
   - ✅ View reports

---

## 🎯 Your Live URLs

```
Frontend: https://paradeops.netlify.app
Backend:  https://paradeops-backend.onrender.com
Database: MongoDB Atlas (Cloud)
```

---

## ⚠️ Common Issues

### Backend Not Starting on Render
- Check Logs in Render dashboard
- Verify MongoDB connection string
- Ensure `node src/server.js` is the start command

### CORS Error in Browser
- Backend CORS_ORIGIN must match frontend URL exactly
- Include `https://` protocol
- Redeploy backend after changing

### Login Failing
- Check browser console for errors
- Verify API_BASE_URL in config.js
- Test backend health endpoint

### MongoDB Connection Timeout
- Atlas Network Access: Allow 0.0.0.0/0
- Connection string must include `/paradeops_db`
- Password must be URI-encoded (special characters)

---

## 📱 Share Your Project

Demo credentials:
- BSM: `BSM001` / password
- Adjutant: (check your database)
- Soldier: (any soldier service number)

---

## 💰 Cost Summary

- MongoDB Atlas: **FREE** (512MB)
- Render Backend: **FREE** (750 hours/month, sleeps after 15min)
- Netlify Frontend: **FREE** (100GB bandwidth)
- **Total: ৳0/month**

---

## 🔄 Updates & Redeployment

### Update Backend Code:
```powershell
git add backend/
git commit -m "Update backend"
git push origin main
# Render auto-deploys from GitHub
```

### Update Frontend Code:
```powershell
git add frontend/
git commit -m "Update frontend"
git push origin main
# If using GitHub deploy: Netlify auto-deploys
# If using manual: Re-drag frontend folder to Netlify
```

---

## 🛠️ Local Development

```powershell
# Terminal 1: Start MongoDB
mongod

# Terminal 2: Start Backend
cd E:\SDP_Project\backend
npm start

# Terminal 3: Start Frontend
cd E:\SDP_Project
python -m http.server 8000

# Access: http://localhost:8000/login.html
```

---

## 📝 Next Steps

1. ✅ Setup complete!
2. 📧 Optional: Configure email notifications
3. 🔒 Optional: Custom domain with SSL
4. 📱 Optional: Mobile app development
5. 📊 Optional: Advanced analytics

---

For detailed guide, see [HOSTING_GUIDE.md](HOSTING_GUIDE.md)

**Need Help?** Check troubleshooting section in detailed guide.
