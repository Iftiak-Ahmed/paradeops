# ParadeOps - Complete Hosting Guide
## আপনার Project Live করুন (Step-by-Step)

---

## Table of Contents
1. [Hosting Options Overview](#hosting-options-overview)
2. [Option 1: Free Cloud Hosting (Recommended for Students)](#option-1-free-cloud-hosting)
3. [Option 2: VPS Hosting (Professional)](#option-2-vps-hosting)
4. [Option 3: Local Network Hosting](#option-3-local-network-hosting)
5. [Domain Name Setup (Optional)](#domain-name-setup)
6. [Troubleshooting](#troubleshooting)

---

## Hosting Options Overview

| Option | Cost | Difficulty | Access | Best For |
|--------|------|----------|--------|----------|
| **Free Cloud Hosting** | Free | Easy | Internet (Global) | Academic projects, demos |
| **VPS Hosting** | $5-10/month | Medium | Internet (Global) | Production, military use |
| **Local Network** | Free | Very Easy | LAN only | Testing, local battalion |

**Recommendation for SDP:** Start with **Option 1 (Free Cloud Hosting)** for your presentation/demo.

---

## Option 1: Free Cloud Hosting (Recommended)

এই method ব্যবহার করে আপনি **সম্পূর্ণ বিনামূল্যে** internet এ project live করতে পারবেন।

### Components:
- **Frontend:** Netlify/Vercel (Free)
- **Backend:** Render.com (Free tier)
- **Database:** MongoDB Atlas (Free tier - 512MB)

### Total Time: 30-45 minutes

---

### Step 1: MongoDB Atlas Setup (Database)

#### 1.1: Create MongoDB Atlas Account

1. যান: https://www.mongodb.com/cloud/atlas/register
2. Sign up করুন (email দিয়ে বা Google account দিয়ে)
3. Email verify করুন

#### 1.2: Create Free Cluster

1. "Build a Database" বা "Create" button এ click করুন
2. **FREE tier (M0 Sandbox)** select করুন
3. Provider: **AWS** (recommended)
4. Region: **Singapore** বা **Mumbai** select করুন (closest to Bangladesh)
5. Cluster Name দিন: `ParadeOps-Cluster`
6. "Create Cluster" click করুন (2-3 minutes সময় নিবে)

#### 1.3: Create Database User

1. Left sidebar থেকে **"Database Access"** এ যান
2. "Add New Database User" click করুন
3. Authentication Method: **Password**
4. Username দিন: `paradeops_admin`
5. Password generate করুন (strong password automatic create করবে)
   - **Important:** এই password কপি করে রাখুন! পরে লাগবে
6. Database User Privileges: **"Atlas admin"** select করুন
7. "Add User" click করুন

#### 1.4: Allow Network Access

1. Left sidebar থেকে **"Network Access"** এ যান
2. "Add IP Address" click করুন
3. "Allow Access from Anywhere" click করুন (0.0.0.0/0)
   - Academic project এর জন্য OK, but production এ specific IP use করবেন
4. "Confirm" click করুন

#### 1.5: Get Connection String

1. Left sidebar থেকে **"Database"** এ ফিরে যান
2. আপনার cluster এ **"Connect"** button এ click করুন
3. "Connect your application" select করুন
4. Driver: **Node.js**, Version: **4.1 or later**
5. Connection string কপি করুন (এরকম দেখতে):
   ```
   mongodb+srv://paradeops_admin:<password>@paradeops-cluster.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
6. `<password>` এর জায়গায় আপনার actual password দিন

**Example:**
```
mongodb+srv://paradeops_admin:MyStrongPass123@paradeops-cluster.abc12.mongodb.net/paradeops_db?retryWrites=true&w=majority
```

⚠️ **Important:** শেষে `/paradeops_db` যোগ করতে ভুলবেন না! এটা database name।

---

### Step 2: Data Migration (Local → Cloud)

আপনার local MongoDB data cloud এ transfer করতে হবে।

#### 2.1: Export Local Data

Windows PowerShell খুলুন:

```powershell
# Navigate to project folder
cd E:\SDP_Project

# Create backup folder
New-Item -ItemType Directory -Force -Path .\mongodb_backup

# Export all collections
mongodump --db=paradeops_db --out=.\mongodb_backup
```

**Output:** আপনার `mongodb_backup` folder এ সব data export হবে।

#### 2.2: Import to MongoDB Atlas

```powershell
# Replace with YOUR Atlas connection string
$atlasUri = "mongodb+srv://paradeops_admin:YOUR_PASSWORD@paradeops-cluster.xxxxx.mongodb.net"

# Import data
mongorestore --uri="$atlasUri" --db=paradeops_db .\mongodb_backup\paradeops_db
```

**Verification:**
1. MongoDB Atlas dashboard এ যান
2. Cluster → "Browse Collections" click করুন
3. `paradeops_db` database এ 4 collections দেখতে পাবেন:
   - users (508 documents)
   - leaves
   - leavetypes (4 documents)
   - soldier_attendance (505 documents)

---

### Step 3: Backend Hosting (Render.com)

#### 3.1: Prepare Backend Code

আপনার backend folder এ `.env` file তৈরি করুন:

**File:** `E:\SDP_Project\backend\.env`

```env
PORT=5000
MONGODB_URI=mongodb+srv://paradeops_admin:YOUR_PASSWORD@paradeops-cluster.xxxxx.mongodb.net/paradeops_db?retryWrites=true&w=majority
JWT_SECRET=your_secure_random_secret_key_here_min_32_chars
NODE_ENV=production
```

**Generate JWT Secret:**
```powershell
# PowerShell command to generate random secret
-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | % {[char]$_})
```

#### 3.2: Update server.js for Production

**File:** `backend/src/server.js` এ CORS update করুন:

```javascript
// CORS configuration for production
app.use(cors({
  origin: process.env.NODE_ENV === 'production' 
    ? ['https://your-frontend-url.netlify.app', 'https://your-custom-domain.com'] 
    : '*',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']
}));
```

#### 3.3: Create Render Account

1. যান: https://render.com/
2. "Get Started" click করুন
3. Sign up with GitHub account (recommended) or email

#### 3.4: Create Web Service

1. Dashboard থেকে "New +" → "Web Service" click করুন
2. "Deploy an existing image" **নয়**, "Build and deploy from a Git repository" select করুন

#### 3.5: Connect GitHub Repository

**যদি GitHub এ code না থাকে:**

1. GitHub এ নতুন repository তৈরি করুন:
   - যান: https://github.com/new
   - Repository name: `ParadeOps`
   - Private/Public select করুন
   - "Create repository" click করুন

2. Local code push করুন:

```powershell
# Navigate to project
cd E:\SDP_Project

# Initialize git (if not already)
git init

# Create .gitignore
@"
node_modules/
.env
*.log
mongodb_backup/
"@ | Out-File -FilePath .gitignore -Encoding UTF8

# Add all files
git add .

# Commit
git commit -m "Initial commit - ParadeOps project"

# Add remote (replace with YOUR repo URL)
git remote add origin https://github.com/your-username/ParadeOps.git

# Push
git branch -M main
git push -u origin main
```

3. Render এ ফিরে যান, GitHub repository select করুন

#### 3.6: Configure Web Service

**Settings:**

| Field | Value |
|-------|-------|
| **Name** | `paradeops-backend` |
| **Region** | Singapore (closest to BD) |
| **Branch** | `main` |
| **Root Directory** | `backend` |
| **Runtime** | `Node` |
| **Build Command** | `npm install` |
| **Start Command** | `node src/server.js` |
| **Instance Type** | `Free` |

#### 3.7: Environment Variables

"Advanced" section এ যান, Environment Variables যোগ করুন:

| Key | Value |
|-----|-------|
| `MONGODB_URI` | Your Atlas connection string |
| `JWT_SECRET` | Your generated secret |
| `NODE_ENV` | `production` |
| `PORT` | `5000` |

#### 3.8: Deploy

1. "Create Web Service" click করুন
2. Deployment শুরু হবে (5-10 minutes)
3. Logs দেখুন deployment success হয়েছে কিনা

**Your backend URL:** `https://paradeops-backend.onrender.com`

#### 3.9: Test Backend

Browser এ যান:
```
https://paradeops-backend.onrender.com/health
```

**Expected Response:**
```json
{
  "status": "ok",
  "timestamp": "2026-02-28T12:34:56.789Z"
}
```

---

### Step 4: Frontend Hosting (Netlify)

#### 4.1: Update Frontend API URLs

সব frontend HTML files এ API URL update করতে হবে।

**Create a config file:**

**File:** `frontend/config.js`

```javascript
// API Configuration
const API_BASE_URL = 'https://paradeops-backend.onrender.com';

// API Endpoints
const API_ENDPOINTS = {
  AUTH: {
    LOGIN: `${API_BASE_URL}/api/auth/login`,
    LOGOUT: `${API_BASE_URL}/api/auth/logout`,
    REGISTER: `${API_BASE_URL}/api/auth/register`,
    VERIFY: `${API_BASE_URL}/api/auth/verify`,
    CHANGE_PASSWORD: `${API_BASE_URL}/api/auth/change-password`
  },
  USERS: {
    GET_ALL: `${API_BASE_URL}/api/users`,
    GET_BY_ID: (id) => `${API_BASE_URL}/api/users/${id}`,
    UPDATE: (id) => `${API_BASE_URL}/api/users/${id}`
  },
  LEAVES: {
    GET_ALL: `${API_BASE_URL}/api/leaves`,
    CREATE: `${API_BASE_URL}/api/leaves`,
    APPROVE: (id) => `${API_BASE_URL}/api/leaves/${id}/approve`,
    REJECT: (id) => `${API_BASE_URL}/api/leaves/${id}/reject`,
    DELETE: (id) => `${API_BASE_URL}/api/leaves/${id}`
  },
  ATTENDANCE: {
    INIT_DATE: `${API_BASE_URL}/api/attendance/init-date`,
    MARK: `${API_BASE_URL}/api/attendance/mark`,
    GET: `${API_BASE_URL}/api/attendance`,
    SUMMARY: `${API_BASE_URL}/api/attendance/summary`,
    DATES: `${API_BASE_URL}/api/attendance/dates`
  }
};
```

#### 4.2: Update HTML Files

প্রতিটি HTML file এর `<head>` section এ config.js যোগ করুন:

```html
<head>
    <!-- Existing meta tags -->
    <script src="../config.js"></script>
    <!-- Rest of head content -->
</head>
```

এবং JavaScript code এ `http://localhost:5000` replace করুন `API_ENDPOINTS` দিয়ে।

**Example (login.html):**

Before:
```javascript
const response = await fetch('http://localhost:5000/api/auth/login', {
```

After:
```javascript
const response = await fetch(API_ENDPOINTS.AUTH.LOGIN, {
```

#### 4.3: Create Netlify Account

1. যান: https://www.netlify.com/
2. "Sign up" click করুন
3. GitHub account দিয়ে sign up করুন (recommended)

#### 4.4: Deploy Frontend

**Method 1: Drag & Drop (Easiest)**

1. Netlify dashboard এ "Add new site" → "Deploy manually" click করুন
2. আপনার `E:\SDP_Project\frontend` **পুরো folder** drag করে drop করুন
3. Deployment শুরু হবে (1-2 minutes)
4. Site live হয়ে যাবে: `https://random-name-12345.netlify.app`

**Method 2: GitHub (Automatic Deployment)**

1. "Add new site" → "Import an existing project" click করুন
2. GitHub select করুন
3. Repository select করুন
4. Settings:
   - Base directory: `frontend`
   - Build command: (leave empty - static site)
   - Publish directory: `.` (dot)
5. "Deploy site" click করুন

#### 4.5: Configure Site Name

1. Site settings → "Change site name" click করুন
2. Name দিন: `paradeops` (if available)
3. URL হবে: `https://paradeops.netlify.app`

#### 4.6: Update Backend CORS

Backend এর CORS configuration এ Netlify URL যোগ করুন:

**File:** `backend/src/server.js`

```javascript
app.use(cors({
  origin: ['https://paradeops.netlify.app'],
  credentials: true
}));
```

Render dashboard এ যান → "Manual Deploy" → "Deploy latest commit" click করুন।

---

### Step 5: Final Testing

#### 5.1: Test Complete Flow

1. Netlify URL open করুন: `https://paradeops.netlify.app/login.html`
2. Login করুন:
   - Service Number: `BSM001` (or any existing user)
   - Password: `password123` (or whatever you set)
3. Test করুন:
   - Leave application submit
   - Attendance marking
   - Reports generation

#### 5.2: Check Browser Console

- F12 press করুন (Developer Tools)
- Console tab এ কোন error নেই তো check করুন
- Network tab এ API calls সফল হচ্ছে কিনা দেখুন (Status 200)

#### 5.3: Performance Check

- Dashboard load time check করুন (should be < 2 seconds)
- API response time check করুন (should be < 1 second)

---

## Option 2: VPS Hosting (Professional Deployment)

Professional/production deployment জন্য VPS (Virtual Private Server) ব্যবহার করুন।

### Recommended Providers:

| Provider | Price | Location | Features |
|----------|-------|----------|----------|
| **DigitalOcean** | $6/month | Singapore | Easy setup, good docs |
| **Linode** | $5/month | Singapore | Reliable, cheap |
| **AWS Lightsail** | $5/month | Mumbai | AWS ecosystem |
| **Vultr** | $6/month | Singapore | Fast performance |

### Step-by-Step VPS Setup (DigitalOcean Example)

#### Step 1: Create Droplet

1. যান: https://www.digitalocean.com/
2. Sign up করুন (GitHub student pack থাকলে $200 free credit)
3. "Create" → "Droplets" click করুন
4. Choose:
   - **Image:** Ubuntu 22.04 LTS
   - **Plan:** Basic - $6/month (1GB RAM, 25GB SSD)
   - **Datacenter:** Singapore
   - **Authentication:** SSH key (recommended) or Password
5. Hostname দিন: `paradeops-server`
6. "Create Droplet" click করুন

**আপনার server IP পাবেন:** `123.45.67.89` (example)

#### Step 2: Connect to Server

Windows PowerShell থেকে:

```powershell
# SSH connection
ssh root@123.45.67.89

# Enter password (if using password auth)
```

#### Step 3: Server Setup

```bash
# Update system
apt update && apt upgrade -y

# Install Node.js (v18 LTS)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt update
apt install -y mongodb-org

# Start MongoDB
systemctl start mongod
systemctl enable mongod

# Install Nginx
apt install -y nginx

# Install PM2 (process manager)
npm install -g pm2

# Verify installations
node --version    # Should show v18.x.x
npm --version     # Should show 9.x.x
mongod --version  # Should show MongoDB 6.0
nginx -v          # Should show nginx version
```

#### Step 4: Deploy Backend

```bash
# Create app directory
mkdir -p /var/www/paradeops
cd /var/www/paradeops

# Clone from GitHub (if using Git)
git clone https://github.com/your-username/ParadeOps.git .

# Or upload files using SFTP (WinSCP, FileZilla)

# Navigate to backend
cd backend

# Install dependencies
npm install --production

# Create .env file
nano .env
```

**.env content:**
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/paradeops_db
JWT_SECRET=your_secure_32_char_secret_key
NODE_ENV=production
```

Save: `Ctrl+X`, then `Y`, then `Enter`

```bash
# Start backend with PM2
pm2 start src/server.js --name paradeops-backend

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup systemd
```

#### Step 5: Import Database

```bash
# From your local machine, upload backup
# Using PowerShell:
scp -r E:\SDP_Project\mongodb_backup root@123.45.67.89:/tmp/

# On server:
mongorestore --db=paradeops_db /tmp/mongodb_backup/paradeops_db
```

#### Step 6: Configure Nginx (Frontend + Reverse Proxy)

```bash
# Create Nginx config
nano /etc/nginx/sites-available/paradeops
```

**Nginx config:**
```nginx
server {
    listen 80;
    server_name 123.45.67.89;  # Replace with your IP or domain

    # Frontend (Static files)
    root /var/www/paradeops/frontend;
    index login.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Backend API (Reverse proxy)
    location /api/ {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Save and exit.

```bash
# Enable site
ln -s /etc/nginx/sites-available/paradeops /etc/nginx/sites-enabled/

# Test config
nginx -t

# Restart Nginx
systemctl restart nginx
```

#### Step 7: Update Frontend API URLs

Frontend এর `config.js` update করুন:

```javascript
const API_BASE_URL = 'http://123.45.67.89';  // Your server IP
```

#### Step 8: Setup Firewall

```bash
# Allow SSH, HTTP, HTTPS
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw enable
```

#### Step 9: SSL Certificate (Optional but Recommended)

```bash
# Install Certbot
apt install -y certbot python3-certbot-nginx

# Get SSL certificate (Replace with your domain)
certbot --nginx -d yourdomain.com

# Auto-renewal test
certbot renew --dry-run
```

#### Step 10: Access Your Application

Open browser এ যান:
- **With IP:** `http://123.45.67.89/login.html`
- **With Domain:** `https://yourdomain.com/login.html`

---

## Option 3: Local Network Hosting (LAN)

Battalion এর internal network এ deploy করার জন্য।

### Requirements:
- Windows Server or Windows 10/11 PC (always-on)
- Local network access

### Step 1: Find Your IP Address

```powershell
# Get IP address
ipconfig

# Look for "IPv4 Address": 192.168.1.XXX
```

### Step 2: Configure Backend

**File:** `backend/.env`

```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/paradeops_db
JWT_SECRET=your_secret_key
```

### Step 3: Start Backend

```powershell
cd E:\SDP_Project\backend
npm start
```

### Step 4: Start Frontend

```powershell
cd E:\SDP_Project
python -m http.server 8000
```

### Step 5: Configure Windows Firewall

```powershell
# Allow port 8000 (Frontend)
New-NetFirewallRule -DisplayName "ParadeOps Frontend" -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Allow

# Allow port 5000 (Backend)
New-NetFirewallRule -DisplayName "ParadeOps Backend" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

### Step 6: Access from Other Computers

**Same network এর যেকোনো computer থেকে:**

```
http://192.168.1.XXX:8000/login.html
```

Replace `192.168.1.XXX` with your actual IP address.

### Step 7: Keep Running 24/7 (Optional)

**Using PM2 (Node.js Process Manager):**

```powershell
# Install PM2
npm install -g pm2

# Start backend with PM2
cd E:\SDP_Project\backend
pm2 start src/server.js --name paradeops-backend

# Start frontend with PM2
pm2 start "python -m http.server 8000" --name paradeops-frontend

# Save configuration
pm2 save

# Setup startup (Windows)
pm2 startup
```

---

## Domain Name Setup (Optional)

### Free Domain Options:

1. **Freenom** (tk, ml, ga, cf, gq domains) - FREE
   - যান: https://www.freenom.com/
   - Domain search করুন: `paradeops.tk`
   - Free registration (12 months)

2. **No-IP** (Dynamic DNS) - FREE
   - যান: https://www.noip.com/
   - Sign up করুন
   - Create hostname: `paradeops.ddns.net`
   - Point to your IP address

### Paid Domain (Professional):

1. **Namecheap** - $10/year for .com
   - যান: https://www.namecheap.com/
   - Search: `paradeops.com`
   - Purchase domain

### Connect Domain to Hosting:

**For Netlify:**
1. Netlify dashboard → Domain settings
2. "Add custom domain" click করুন
3. Domain name enter করুন
4. Netlify এর nameservers আপনার domain registrar এ add করুন

**For Render:**
1. Render dashboard → Settings → Custom Domains
2. Domain add করুন
3. CNAME record add করুন domain এ

**For VPS:**
1. Domain registrar এ A record add করুন:
   - Type: A
   - Name: @
   - Value: Your VPS IP (123.45.67.89)
   - TTL: Automatic

---

## Troubleshooting

### Problem 1: Backend Not Connecting to Database

**Error:** `MongooseServerSelectionError`

**Solution:**
```bash
# Check MongoDB running
systemctl status mongod

# Restart MongoDB
systemctl restart mongod

# Check connection string
echo $MONGODB_URI
```

### Problem 2: CORS Error in Browser

**Error:** `Access to fetch has been blocked by CORS policy`

**Solution:**
Update `backend/src/server.js`:
```javascript
app.use(cors({
  origin: ['https://your-frontend.netlify.app', 'http://localhost:8000'],
  credentials: true
}));
```

Redeploy backend.

### Problem 3: JWT Token Error

**Error:** `Invalid or expired token`

**Solution:**
1. Clear browser LocalStorage:
   ```javascript
   localStorage.clear();
   ```
2. Login again
3. Check JWT_SECRET same in backend .env

### Problem 4: Render Service Sleeping

**Problem:** Free Render services sleep after 15 minutes of inactivity

**Solution:**
1. Use uptime monitoring (free):
   - যান: https://uptimerobot.com/
   - Add monitor: Your Render URL
   - Check every 5 minutes
   
2. Or upgrade to paid plan ($7/month - always active)

### Problem 5: Netlify Deployment Failed

**Error:** `Deploy failed`

**Solution:**
1. Check folder structure (frontend folder only)
2. Remove node_modules folder
3. Check .gitignore not blocking files
4. Redeploy manually

### Problem 6: MongoDB Atlas Connection Timeout

**Error:** `ETIMEDOUT` or `ECONNREFUSED`

**Solution:**
1. MongoDB Atlas → Network Access
2. Add "Allow from Anywhere" (0.0.0.0/0)
3. Wait 1-2 minutes for update
4. Retry connection

### Problem 7: Slow Loading/Performance

**Solutions:**
1. **Enable Gzip compression** (Backend):
   ```javascript
   const compression = require('compression');
   app.use(compression());
   ```

2. **Optimize images** (Frontend):
   - Use compressed images
   - Lazy loading

3. **Add indexes** (Database):
   ```javascript
   // In model schemas
   service_number: { type: String, index: true }
   ```

### Problem 8: Login Not Working After Deployment

**Checklist:**
- [ ] Backend API URL correct in frontend config.js
- [ ] MongoDB connection successful
- [ ] JWT_SECRET set in environment
- [ ] CORS configured for frontend URL
- [ ] Network tab shows 200 response (not 401/403/500)

---

## Post-Deployment Checklist

### Security:
- [ ] Change all default passwords
- [ ] Set strong JWT_SECRET (32+ characters)
- [ ] Enable HTTPS/SSL certificate
- [ ] Configure firewall rules
- [ ] Set MongoDB authentication
- [ ] Remove .env from Git repository

### Performance:
- [ ] Enable Gzip compression
- [ ] Add database indexes
- [ ] Setup CDN (optional)
- [ ] Enable caching headers

### Monitoring:
- [ ] Setup uptime monitoring (UptimeRobot)
- [ ] Configure error logging
- [ ] Setup backup schedule
- [ ] Monitor resource usage

### Documentation:
- [ ] Update README.md with live URLs
- [ ] Document environment variables
- [ ] Create user guide
- [ ] Note login credentials for demo

---

## Live URLs (Example)

After deployment, আপনার links এরকম হবে:

```
Frontend (Netlify): https://paradeops.netlify.app
Backend (Render):   https://paradeops-backend.onrender.com
Database (Atlas):   mongodb+srv://...mongodb.net/paradeops_db

Login URL: https://paradeops.netlify.app/login.html
```

---

## Cost Summary

### Free Hosting (Students):
| Service | Cost | Limits |
|---------|------|--------|
| MongoDB Atlas | FREE | 512MB storage |
| Render (Backend) | FREE | 750 hours/month (sleeps after 15min) |
| Netlify (Frontend) | FREE | 100GB bandwidth/month |
| **Total** | **$0/month** | Good for demos |

### Paid Hosting (Production):
| Service | Cost | Features |
|---------|------|----------|
| MongoDB Atlas | $0-9/month | 2-10GB storage |
| Render (Backend) | $7/month | Always active, no sleep |
| Netlify (Frontend) | $0 | (Free tier enough) |
| Domain (.com) | $10/year | Professional look |
| **Total** | **~$8-16/month** | Production-ready |

### VPS Hosting:
| Provider | Cost | Specs |
|----------|------|-------|
| DigitalOcean | $6/month | 1GB RAM, 25GB SSD |
| Domain | $10/year | .com domain |
| **Total** | **~$7/month** | Full control |

---

## Final Notes

### For Academic Presentation:
✅ **Use Option 1 (Free Cloud Hosting)** - Perfect for demos  
✅ Setup takes 30-45 minutes  
✅ Works from anywhere with internet  
✅ Professional-looking URLs  

### For Actual Military Deployment:
✅ **Use Option 2 (VPS Hosting)** - More control, secure  
✅ Can be hosted on military network  
✅ Full data control  
✅ Better performance  

### For Testing/Development:
✅ **Use Option 3 (Local Network)** - Fastest setup  
✅ No internet required  
✅ Good for battalion LAN  

---

## Need Help?

**Common Issues:**
- Backend not starting: Check MongoDB connection
- Frontend not loading: Check API_BASE_URL in config.js
- Login failing: Check CORS configuration
- Slow performance: Check network/server location

**Resources:**
- Render Documentation: https://render.com/docs
- Netlify Documentation: https://docs.netlify.com
- MongoDB Atlas Docs: https://docs.atlas.mongodb.com

**Support:**
- Render Community: https://community.render.com
- Netlify Community: https://answers.netlify.com

---

**🎉 Congratulations!** Your ParadeOps system is now live on the internet!

Share your live URL:
```
https://paradeops.netlify.app/login.html
```

**Demo Credentials:**
- BSM: Service# `BSM001`, Password (your set password)
- Soldier: Service# (any existing), Password (your set password)

---

**END OF HOSTING GUIDE**
