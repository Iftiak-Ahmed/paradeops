# ParadeOps - Complete Technical Documentation
## For All Stakeholders (Developers, Testers, Project Managers, Viva Examiners)

---

## 📋 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Technology Stack](#2-technology-stack)
3. [System Architecture](#3-system-architecture)
4. [Database Layer - MongoDB](#4-database-layer---mongodb)
5. [Backend Layer - Node.js/Express API](#5-backend-layer---nodejsexpress-api)
6. [Frontend Layer - HTML/JavaScript](#6-frontend-layer---htmljavascript)
7. [Authentication & Security](#7-authentication--security)
8. [API Communication](#8-api-communication)
9. [Complete Data Flow Examples](#9-complete-data-flow-examples)
10. [Role-Based Access Control](#10-role-based-access-control)
11. [Deployment & Running](#11-deployment--running)
12. [Testing Scenarios](#12-testing-scenarios)
13. [Common Issues & Solutions](#13-common-issues--solutions)

---

## 1. Project Overview

### 1.1 What is ParadeOps?

**ParadeOps** is a **Military Personnel Management System** specifically designed for Bangladesh Army units. It manages:

- ✅ Daily attendance tracking
- ✅ Leave applications & approvals
- ✅ Soldier status monitoring (Present/Leave/AWOL/On Duty)
- ✅ Company-wise reporting
- ✅ Role-based dashboards for different ranks

### 1.2 Problem Statement

**Before ParadeOps:**
- Manual pen-and-paper attendance registers
- Slow leave approval process (physical forms)
- No real-time visibility of unit strength
- Difficult to generate reports
- No centralized data storage

**After ParadeOps:**
- Digital attendance in seconds
- Instant leave application & approval
- Real-time dashboard for commanders
- Automated report generation
- Secure cloud/local database

### 1.3 Key Features

| Feature | Description |
|---------|-------------|
| **Multi-Role System** | 5 different user types with specific permissions |
| **Real-time Updates** | Immediate data refresh across all dashboards |
| **Secure Authentication** | JWT-based token system with bcrypt password hashing |
| **Leave Management** | Complete workflow from application to approval/rejection |
| **Attendance Tracking** | Daily parade state with multiple activity checkpoints |
| **Report Generation** | Automated reports for CO, Adjutant, Company Commanders |

---

## 2. Technology Stack

### 2.1 Frontend Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| **HTML5** | Standard | Structure & Layout |
| **CSS3** | Standard | Styling & Animations |
| **JavaScript (Vanilla)** | ES6+ | Logic & Interactivity |
| **jwt-decode** | 3.1.2 | Token decoding |
| **Fetch API** | Browser Native | HTTP Requests |

**Why No Framework?**
- ✅ Lightweight (fast loading)
- ✅ No build process required
- ✅ Easy to deploy (just HTML files)
- ✅ Can run on any web server

### 2.2 Backend Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| **Node.js** | v14+ | JavaScript Runtime |
| **Express.js** | 4.18.2 | Web Framework |
| **Mongoose** | 8.0.0 | MongoDB ODM |
| **bcryptjs** | 2.4.3 | Password Hashing |
| **jsonwebtoken** | 9.0.2 | JWT Authentication |
| **cors** | 2.8.5 | Cross-Origin Requests |
| **dotenv** | 16.3.1 | Environment Variables |

### 2.3 Database

| Technology | Version | Purpose |
|------------|---------|---------|
| **MongoDB** | 5.0+ | NoSQL Database |
| **MongoDB Compass** | Latest | Database GUI (optional) |

### 2.4 Development Tools

- **VS Code** - Code Editor
- **Postman** - API Testing
- **Git** - Version Control
- **PowerShell** - Terminal (Windows)

---

## 3. System Architecture

### 3.1 Three-Tier Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENT TIER                          │
│                (User's Web Browser)                         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Frontend - HTML/CSS/JavaScript                     │   │
│  │  Port: 8000                                         │   │
│  │  - Login Page                                       │   │
│  │  - Dashboards (Soldier, Commander, Adjutant, etc.) │   │
│  │  - Leave Application Forms                          │   │
│  │  - Report Generation Pages                          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          │ HTTP/HTTPS
                          │ REST API Calls
                          │ JSON Data Exchange
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION TIER                         │
│                   (Backend Server)                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Backend - Node.js/Express API                      │   │
│  │  Port: 5000                                         │   │
│  │                                                     │   │
│  │  ┌────────────┐  ┌────────────┐  ┌──────────────┐ │   │
│  │  │  Routes    │  │Controllers │  │ Middleware   │ │   │
│  │  │            │  │            │  │              │ │   │
│  │  │ /api/auth  │─▶│authControl │─▶│authenticate  │ │   │
│  │  │ /api/users │─▶│userControl │  │Token        │ │   │
│  │  │ /api/leaves│─▶│leaveControl│  │              │ │   │
│  │  │/api/attend │  │attendControl│  │              │ │   │
│  │  └────────────┘  └────────────┘  └──────────────┘ │   │
│  │                                                     │   │
│  │  ┌──────────────────────────────────────────────┐ │   │
│  │  │         Mongoose Models                      │ │   │
│  │  │  - User.js                                   │ │   │
│  │  │  - Leave.js                                  │ │   │
│  │  │  - Attendance.js                             │ │   │
│  │  └──────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          │ TCP/IP Socket
                          │ MongoDB Wire Protocol
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA TIER                             │
│                  (Database Server)                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  MongoDB Database                                   │   │
│  │  Port: 27017                                        │   │
│  │  Database: paradeops_db                             │   │
│  │                                                     │   │
│  │  Collections:                                       │   │
│  │  ├─ users (508 documents)                           │   │
│  │  ├─ leaves (0 documents)                            │   │
│  │  ├─ leavetypes (4 documents)                        │   │
│  │  └─ soldier_attendance (505 documents)              │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Request/Response Flow

**Example: User Login**

```
1. User Browser (http://localhost:8000/login.html)
   │
   │ User enters: service_number = "1111002", password = "Test@123"
   │ Clicks "Login" button
   │
   ▼
2. JavaScript (login.html)
   │
   │ Validates form inputs
   │ Sends POST request:
   │   URL: http://localhost:5000/api/auth/login
   │   Body: { service_number: "1111002", password: "Test@123" }
   │   Headers: { 'Content-Type': 'application/json' }
   │
   ▼
3. Express Router (authRoutes.js)
   │
   │ Matches route: POST /api/auth/login
   │ Forwards to authController.login()
   │
   ▼
4. Authentication Controller (authController.js)
   │
   │ Step 1: Find user in database by service_number
   │ Step 2: Compare password with stored hash using bcrypt
   │ Step 3: If match → Generate JWT token
   │ Step 4: Return token + user data
   │
   ▼
5. Mongoose Model (User.js)
   │
   │ Query: User.findByServiceNumber("1111002")
   │ Returns: User object with password_hash
   │
   ▼
6. MongoDB Database (paradeops_db.users)
   │
   │ Searches collection for: { service_number: "1111002" }
   │ Returns document with all user fields
   │
   ▼
   ◄── Response flows back up ──◄
   │
7. Backend sends JSON response:
   {
     "success": true,
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
     "user": {
       "service_number": "1111002",
       "name": "Refa Jahan",
       "role": "coy_comd",
       "company": "Radio"
     }
   }
   │
   ▼
8. Frontend JavaScript (login.html)
   │
   │ Receives response
   │ Stores token in localStorage
   │ Redirects to appropriate dashboard based on role
   │
   ▼
9. User sees their dashboard
```

---

## 4. Database Layer - MongoDB

### 4.1 Why MongoDB?

**NoSQL Benefits:**
- ✅ Flexible schema (easy to add fields)
- ✅ JSON-like documents (matches JavaScript objects)
- ✅ Fast read/write operations
- ✅ Horizontal scaling capability
- ✅ No complex JOIN operations

**vs Traditional SQL:**
```
SQL (PostgreSQL):
- Fixed schema (ALTER TABLE required)
- Rows & Columns
- Complex JOINs
- Relational integrity

MongoDB:
- Dynamic schema
- Documents & Collections
- Embedded documents or references
- Flexible structure
```

### 4.2 Database Structure

**Database:** `paradeops_db`

**Collections:** 4 main collections

#### Collection 1: `users`

**Purpose:** Store all user accounts

**Document Example:**
```json
{
  "_id": ObjectId("507f1f77bcf86cd799439011"),
  "service_number": "1111002",
  "name": "Refa Jahan",
  "rank": "Lieutenant",
  "company": "Radio",
  "role": "coy_comd",
  "email": "refa@army.mil",
  "phone": "01712345678",
  "password_hash": "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy",
  "createdAt": ISODate("2026-01-15T10:30:00Z"),
  "updatedAt": ISODate("2026-02-20T15:45:00Z")
}
```

**Key Points:**
- `_id`: MongoDB auto-generated unique identifier
- `service_number`: Army service number (unique index)
- `password_hash`: Bcrypt encrypted (60 characters, one-way)
- `role`: Determines dashboard access and permissions
- `timestamps`: Auto-managed by Mongoose

#### Collection 2: `leaves`

**Purpose:** Leave applications and their status

**Document Example:**
```json
{
  "_id": ObjectId("507f1f77bcf86cd799439022"),
  "user_id": ObjectId("507f1f77bcf86cd799439011"),
  "leave_type_id": ObjectId("507f1f77bcf86cd799439033"),
  "start_date": ISODate("2026-03-01T00:00:00Z"),
  "end_date": ISODate("2026-03-10T00:00:00Z"),
  "total_days": 10,
  "reason": "Family emergency in hometown",
  "address_during_leave": "123 Main Street, Dhaka",
  "contact_number": "01712345678",
  "status": "approved",
  "approved_by": ObjectId("507f1f77bcf86cd799439044"),
  "rejection_reason": null,
  "createdAt": ISODate("2026-02-25T09:00:00Z"),
  "updatedAt": ISODate("2026-02-26T14:30:00Z")
}
```

**Key Points:**
- `user_id`: Reference to user who applied
- `leave_type_id`: Reference to type of leave
- `status`: Workflow state (pending → approved/rejected)
- `approved_by`: Reference to commander who approved

#### Collection 3: `leavetypes`

**Purpose:** Define available leave types and limits

**All Documents:**
```json
[
  { "_id": ObjectId("..."), "type_name": "Annual", "max_days": 60 },
  { "_id": ObjectId("..."), "type_name": "Casual", "max_days": 10 },
  { "_id": ObjectId("..."), "type_name": "Recreational", "max_days": 15 },
  { "_id": ObjectId("..."), "type_name": "Medical", "max_days": 30 }
]
```

#### Collection 4: `soldier_attendance`

**Purpose:** Daily attendance tracking

**Document Example:**
```json
{
  "_id": ObjectId("507f1f77bcf86cd799439055"),
  "date": "2026-02-28",
  "service_number": "1111003",
  "name": "Ahmed Hassan",
  "rank": "Sergeant",
  "company": "Radio",
  "morning_pt": "present",
  "office": "present",
  "games": "absent",
  "roll_call": "present",
  "leave": "",
  "awol": "",
  "last_updated": ISODate("2026-02-28T06:15:00Z"),
  "createdAt": ISODate("2026-02-28T00:00:00Z"),
  "updatedAt": ISODate("2026-02-28T06:15:00Z")
}
```

**Key Points:**
- One document per soldier per day
- Composite unique index: `{service_number, date}`
- Activity tracking: morning_pt, office, games, roll_call
- Special statuses: leave, awol

### 4.3 Database Indexes

**Why Indexes?**
- Fast data retrieval (like book index)
- Without index: Linear scan (O(n))
- With index: Binary search (O(log n))

**Current Indexes:**

```javascript
// users collection
{
  "_id": 1,                    // Default primary key
  "service_number": 1          // Unique index for fast login
}

// leavetypes collection
{
  "_id": 1,                    // Default primary key
  "type_name": 1               // Unique index
}

// soldier_attendance collection
{
  "_id": 1,                    // Default primary key
  "service_number_1_date_1": 1, // Composite unique index
  "date": 1                    // Fast date queries
}

// leaves collection
{
  "_id": 1                     // Default primary key
}
```

### 4.4 Mongoose ODM (Object Document Mapper)

**What is Mongoose?**
- Like an ORM for MongoDB
- Provides schema validation
- Simplifies queries
- Manages relationships

**Example: Without Mongoose**
```javascript
// Raw MongoDB driver
const MongoClient = require('mongodb').MongoClient;
const client = await MongoClient.connect('mongodb://localhost:27017');
const db = client.db('paradeops_db');
const users = await db.collection('users').find({role: 'soldier'}).toArray();
```

**With Mongoose:**
```javascript
// Mongoose (cleaner, safer)
const User = require('./models/User');
const users = await User.find({role: 'soldier'});
```

**Benefits:**
1. **Schema Validation**
   ```javascript
   const userSchema = new mongoose.Schema({
     service_number: { type: String, required: true, unique: true },
     rank: { type: String, required: true }
   });
   // MongoDB will reject invalid data
   ```

2. **Type Casting**
   ```javascript
   // Automatically converts strings to numbers, dates, etc.
   user.age = "25";  // Mongoose converts to number 25
   ```

3. **Middleware (Hooks)**
   ```javascript
   userSchema.pre('save', function(next) {
     // Runs before saving
     this.updatedAt = new Date();
     next();
   });
   ```

4. **Population (Like SQL JOIN)**
   ```javascript
   // Fetch leave with full user details
   const leave = await Leave.findById(id)
     .populate('user_id', 'name rank')
     .populate('leave_type_id', 'type_name');
   
   // Result: leave.user_id = { name: "Ahmed", rank: "Sergeant" }
   ```

### 4.5 Database Connection

**File:** `backend/database/database.js`

```javascript
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    // Connection string format:
    // mongodb://[host]:[port]/[database_name]
    const conn = await mongoose.connect(
      process.env.MONGODB_URI || 'mongodb://localhost:27017/paradeops_db'
    );

    console.log('✓ MongoDB connected successfully');
  } catch (error) {
    console.error('✗ MongoDB connection failed:', error.message);
    process.exit(1);  // Exit if database connection fails
  }
};

module.exports = connectDB;
```

**Connection Process:**
1. Read connection string from environment variable or use default
2. Mongoose attempts connection to MongoDB
3. If successful: Proceed with server startup
4. If failed: Log error and exit process

**Connection String Parts:**
- `mongodb://` - Protocol
- `localhost` - Host (database server address)
- `27017` - Port (default MongoDB port)
- `paradeops_db` - Database name

---

## 5. Backend Layer - Node.js/Express API

### 5.1 What is Node.js?

**Node.js** = JavaScript runtime built on Chrome's V8 engine

**Why Node.js for Backend?**
- ✅ Same language (JavaScript) for frontend & backend
- ✅ Non-blocking I/O (handles many requests simultaneously)
- ✅ Fast execution (V8 engine compiles JS to machine code)
- ✅ Large package ecosystem (npm)
- ✅ Event-driven architecture

**Traditional vs Node.js:**
```
Traditional (PHP, Java):
- Request 1 → Wait for database → Response 1
- Request 2 → Wait for database → Response 2
- Blocking I/O

Node.js:
- Request 1 → Send to database, continue
- Request 2 → Send to database, continue
- Responses return asynchronously
- Non-blocking I/O
```

### 5.2 Express.js Framework

**Express.js** = Minimal web framework for Node.js

**Why Express?**
- ✅ Simple routing
- ✅ Middleware support
- ✅ Template engine integration
- ✅ Error handling
- ✅ Industry standard

**Basic Express App:**
```javascript
const express = require('express');
const app = express();

// Middleware
app.use(express.json());  // Parse JSON bodies

// Route
app.get('/api/users', (req, res) => {
  res.json({ message: 'Get all users' });
});

// Start server
app.listen(5000, () => {
  console.log('Server running on port 5000');
});
```

### 5.3 Backend Folder Structure

```
backend/
├── database/
│   └── database.js              # MongoDB connection
├── src/
│   ├── server.js                # Main entry point
│   ├── controllers/             # Business logic
│   │   ├── authController.js    # Login, register, password change
│   │   ├── userController.js    # User CRUD operations
│   │   ├── leaveController.js   # Leave management
│   │   └── attendanceController.js # Attendance tracking
│   ├── models/                  # Mongoose schemas
│   │   ├── User.js              # User schema
│   │   ├── Leave.js             # Leave & LeaveType schemas
│   │   └── Attendance.js        # Attendance schema
│   ├── routes/                  # API endpoint definitions
│   │   ├── authRoutes.js        # /api/auth/*
│   │   ├── userRoutes.js        # /api/users/*
│   │   ├── leaveRoutes.js       # /api/leaves/*
│   │   └── attendanceRoutes.js  # /api/attendance/*
│   └── middleware/              # Request interceptors
│       └── auth.js              # JWT verification
├── .env                         # Environment variables
└── package.json                 # Dependencies & scripts
```

**Separation of Concerns:**
- **Routes:** Define URL endpoints
- **Controllers:** Implement business logic
- **Models:** Define data structure & database queries
- **Middleware:** Process requests before reaching controllers

### 5.4 Server Entry Point

**File:** `backend/src/server.js`

```javascript
require('dotenv').config();  // Load environment variables
const express = require('express');
const cors = require('cors');
const connectDB = require('../database/database');

// Import routes
const authRoutes = require('./routes/authRoutes');
const leaveRoutes = require('./routes/leaveRoutes');
const userRoutes = require('./routes/userRoutes');
const attendanceRoutes = require('./routes/attendanceRoutes');

const app = express();
const PORT = process.env.PORT || 5000;

// Connect to MongoDB
connectDB().then(async () => {
  // Seed default leave types
  const mongoose = require('mongoose');
  const LeaveType = mongoose.model('LeaveType');
  const defaults = [
    { type_name: 'Annual', max_days: 60 },
    { type_name: 'Casual', max_days: 10 },
    { type_name: 'Recreational', max_days: 15 },
    { type_name: 'Medical', max_days: 30 }
  ];
  for (const lt of defaults) {
    await LeaveType.findOneAndUpdate(
      { type_name: lt.type_name },
      { $set: { max_days: lt.max_days } },
      { upsert: true, new: true }
    );
  }
  console.log('Leave types seeded/updated successfully');
});

// Middleware
app.use(cors({ origin: '*', credentials: true }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/leaves', leaveRoutes);
app.use('/api/users', userRoutes);
app.use('/api/attendance', attendanceRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    error: err.message || 'Internal server error'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
```

**Startup Sequence:**
1. Load environment variables from `.env`
2. Import dependencies
3. Create Express app
4. Connect to MongoDB
5. Seed leave types (if not exist)
6. Apply middleware (CORS, JSON parser, logger)
7. Register API routes
8. Add error handlers
9. Start listening on port 5000

### 5.5 Middleware Explained

**What is Middleware?**
- Functions that run before controllers
- Can modify request/response objects
- Can terminate request-response cycle
- Can call next middleware in stack

**Middleware Chain:**
```
Request
  │
  ▼
[CORS Middleware]  ← Allow cross-origin requests
  │
  ▼
[JSON Parser]      ← Parse request body
  │
  ▼
[Logger]           ← Log request details
  │
  ▼
[Auth Middleware]  ← Verify JWT token (if required)
  │
  ▼
[Controller]       ← Execute business logic
  │
  ▼
Response
```

**Example: Authentication Middleware**

**File:** `backend/src/middleware/auth.js`

```javascript
const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET || 'paradeops_secret_key_2024';

const authenticateToken = (req, res, next) => {
  // Extract token from Authorization header
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  // Verify token
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid or expired token' });
    }
    req.user = user;  // Attach user data to request object
    next();           // Continue to next middleware/controller
  });
};

module.exports = { authenticateToken, JWT_SECRET };
```

**Usage in Routes:**
```javascript
// Public route (no auth required)
router.post('/login', authController.login);

// Protected route (auth required)
router.get('/users', authenticateToken, userController.getAllUsers);
```

### 5.6 API Routes

**File:** `backend/src/routes/authRoutes.js`

```javascript
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { authenticateToken } = require('../middleware/auth');

// Public routes (no authentication required)
router.post('/login', authController.login);
router.post('/register', authController.register);

// Protected routes (authentication required)
router.post('/logout', authenticateToken, authController.logout);
router.post('/change-password', authenticateToken, authController.changePassword);
router.get('/verify', authenticateToken, authController.verifyToken);

module.exports = router;
```

**Route Definition Pattern:**
```javascript
router.METHOD(path, [middleware1, middleware2, ...], controller)
```

**Complete API Endpoints:**

| Method | Endpoint | Auth | Purpose |
|--------|----------|------|---------|
| **Authentication** |
| POST | /api/auth/login | ❌ | Login user |
| POST | /api/auth/register | ❌ | Create new user |
| POST | /api/auth/logout | ✅ | Logout user |
| POST | /api/auth/change-password | ✅ | Change password |
| GET | /api/auth/verify | ✅ | Verify token |
| **Users** |
| GET | /api/users | ✅ | Get all users |
| GET | /api/users/me | ✅ | Get current user |
| GET | /api/users/:id | ✅ | Get user by ID |
| PUT | /api/users/:id | ✅ | Update user |
| GET | /api/users/rank-summary | ❌ | Public stats |
| **Leaves** |
| GET | /api/leaves | ✅ | Get leaves (filtered by role) |
| GET | /api/leaves/types | ✅ | Get leave types |
| GET | /api/leaves/balance/:userId | ✅ | Get leave balance |
| GET | /api/leaves/:id | ✅ | Get specific leave |
| POST | /api/leaves | ✅ | Create leave application |
| PUT | /api/leaves/:id/approve | ✅ | Approve leave |
| PUT | /api/leaves/:id/reject | ✅ | Reject leave |
| DELETE | /api/leaves/:id | ✅ | Delete leave |
| **Attendance** |
| POST | /api/attendance/init-date | ✅ | Initialize attendance |
| POST | /api/attendance/mark | ✅ | Mark attendance |
| GET | /api/attendance | ✅ | Get attendance records |
| GET | /api/attendance/summary | ✅ | Get summary stats |

### 5.7 Controllers - Business Logic

**File:** `backend/src/controllers/authController.js`

**Login Function Explained Step-by-Step:**

```javascript
const login = async (req, res) => {
  try {
    // Step 1: Extract credentials from request body
    const { service_number, password } = req.body;

    // Step 2: Validate input
    if (!service_number || !password) {
      return res.status(400).json({ 
        error: 'Service number and password are required' 
      });
    }

    // Step 3: Find user in database
    const user = await User.findByServiceNumber(service_number);

    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Step 4: Verify password
    const isValidPassword = await User.validatePassword(
      password, 
      user.password_hash
    );

    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Step 5: Generate JWT token
    const token = jwt.sign(
      {
        user_id: user._id.toString(),
        service_number: user.service_number,
        name: user.name,
        rank: user.rank,
        role: user.role,
        company: user.company
      },
      JWT_SECRET,
      { expiresIn: '8h' }  // Token valid for 8 hours
    );

    // Step 6: Send response
    res.json({
      success: true,
      message: 'Login successful',
      token,
      user: {
        user_id: user.user_id,
        service_number: user.service_number,
        name: user.name,
        rank: user.rank,
        role: user.role,
        company: user.company
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Login failed' });
  }
};
```

**What Happens in Each Step:**

1. **Extract credentials:** Pull data from POST request body
2. **Validate input:** Check if required fields are present
3. **Find user:** Query database using Mongoose model
4. **Verify password:** Compare plain-text with bcrypt hash
5. **Generate token:** Create JWT with user data & expiration
6. **Send response:** Return token + user info to frontend

**Password Verification (Bcrypt):**

```javascript
// During registration:
const hashedPassword = await bcrypt.hash(plainPassword, 10);
// Result: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy

// During login:
const isMatch = await bcrypt.compare(plainPassword, hashedPassword);
// Returns: true or false
```

**How Bcrypt Works:**
1. Takes plain-text password
2. Generates random salt (10 rounds)
3. Hashes password + salt multiple times
4. Result is one-way encrypted (cannot be decrypted)
5. Each hash is unique even for same password

### 5.8 Models - Mongoose Schemas

**File:** `backend/src/models/User.js`

```javascript
const userSchema = new mongoose.Schema({
  service_number: {
    type: String,
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: true
  },
  rank: {
    type: String,
    required: true
  },
  company: {
    type: String,
    required: false
  },
  role: {
    type: String,
    required: true,
    enum: ['soldier', 'coy_comd', 'adjutant', 'bsm', 'commanding_officer']
  },
  email: {
    type: String
  },
  phone: {
    type: String
  },
  password_hash: {
    type: String,
    required: true
  }
}, {
  timestamps: true  // Auto-add createdAt & updatedAt
});

// Virtual field (computed, not stored in DB)
userSchema.virtual('user_id').get(function() {
  return this._id.toString();
});

// Hide password_hash in JSON responses
userSchema.methods.toJSON = function() {
  const obj = this.toObject();
  delete obj.password_hash;
  return obj;
};

// Static methods (callable on Model)
userSchema.statics.findByServiceNumber = function(service_number) {
  return this.findOne({ 
    service_number: new RegExp('^' + service_number + '$', 'i') 
  });
};

userSchema.statics.getAllUsers = function() {
  return this.find({})
    .select('service_number name rank role company email phone')
    .sort('name');
};

const User = mongoose.model('User', userSchema);
module.exports = User;
```

**Schema Features:**

1. **Type Validation**
   ```javascript
   service_number: { type: String, required: true }
   // MongoDB rejects if not string or missing
   ```

2. **Enums (Restricted Values)**
   ```javascript
   role: { enum: ['soldier', 'coy_comd', ...] }
   // Only these 5 values allowed
   ```

3. **Unique Constraint**
   ```javascript
   service_number: { unique: true }
   // MongoDB creates index, prevents duplicates
   ```

4. **Timestamps**
   ```javascript
   { timestamps: true }
   // Auto-adds: createdAt, updatedAt
   ```

5. **Virtual Fields**
   ```javascript
   userSchema.virtual('user_id').get(function() {
     return this._id.toString();
   });
   // Computed field, not in database
   ```

6. **Methods vs Statics**
   ```javascript
   // Instance method (called on document)
   userSchema.methods.fullName = function() {
     return this.rank + ' ' + this.name;
   };
   const user = await User.findOne({});
   user.fullName();  // "Lieutenant Refa Jahan"

   // Static method (called on Model)
   userSchema.statics.findByRank = function(rank) {
     return this.find({ rank });
   };
   User.findByRank('Captain');
   ```

### 5.9 Error Handling

**Global Error Handler:**
```javascript
// In server.js
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    error: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});
```

**Try-Catch in Controllers:**
```javascript
const getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Failed to fetch user' });
  }
};
```

**HTTP Status Codes Used:**
- **200 OK:** Successful request
- **201 Created:** Resource created
- **400 Bad Request:** Invalid input
- **401 Unauthorized:** No/invalid token
- **403 Forbidden:** Insufficient permissions
- **404 Not Found:** Resource doesn't exist
- **500 Internal Server Error:** Server-side error

---

## 6. Frontend Layer - HTML/JavaScript

### 6.1 Why Vanilla JavaScript?

**Advantages:**
- ✅ No build process (no webpack, babel, etc.)
- ✅ Fast page loads (no framework overhead)
- ✅ Easy deployment (just copy HTML files)
- ✅ Direct browser execution
- ✅ Simple debugging (no sourcemaps needed)

**Disadvantages:**
- ❌ No component reusability
- ❌ No virtual DOM optimization
- ❌ More boilerplate code
- ❌ Manual state management

### 6.2 Frontend Structure

```
frontend/
├── login.html                    # Entry point
├── user-registration.html        # New user signup
├── soldier/
│   ├── soldier_dashboard.html
│   └── sldr_lve_apply.html
├── coy_commander/
│   ├── coy_dashboard.html
│   ├── Leave_approval.html
│   ├── coy_lve_hist.html
│   ├── coy_report.html
│   └── readiness_check.html
├── adjutant/
│   ├── adjt_dashboard.html
│   ├── adjt_lve_hist.html
│   ├── adjt_report_gen.html
│   ├── daily_parade_state.html
│   └── weekly_summary.html
├── bsm/
│   ├── bsm-dashboard.html
│   ├── bsm_lve_approval.html
│   └── report.html
└── CO/
    ├── CO_dashboard.html
    ├── report_genarate.html
    └── battalion_strength_report.html
```

### 6.3 Login Page Breakdown

**File:** `frontend/login.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ParadeOps - Login</title>
  <style>
    /* CSS styling for login form */
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }
    .login-container {
      background: white;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.3);
      width: 100%;
      max-width: 400px;
    }
    /* ... more styles ... */
  </style>
</head>
<body>
  <div class="login-container">
    <h1>ParadeOps Login</h1>
    <form id="loginForm">
      <div class="form-group">
        <label>Service Number</label>
        <input type="text" id="service_number" required>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" id="password" required>
      </div>
      <button type="submit">Login</button>
    </form>
    <p class="register-link">
      New user? <a href="user-registration.html">Register here</a>
    </p>
  </div>

  <!-- JWT Decode Library -->
  <script src="https://cdn.jsdelivr.net/npm/jwt-decode@3.1.2/build/jwt-decode.min.js"></script>

  <script>
    const API_BASE = 'http://localhost:5000';

    document.getElementById('loginForm').addEventListener('submit', async (e) => {
      e.preventDefault();  // Prevent page reload

      // Get form values
      const service_number = document.getElementById('service_number').value;
      const password = document.getElementById('password').value;

      try {
        // Send login request to backend
        const response = await fetch(`${API_BASE}/api/auth/login`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ service_number, password })
        });

        const data = await response.json();

        if (data.success) {
          // Store token in localStorage
          localStorage.setItem('token', data.token);
          
          // Decode token to get user role
          const decoded = jwt_decode(data.token);
          
          // Redirect based on role
          switch(decoded.role) {
            case 'soldier':
              window.location.href = 'soldier/soldier_dashboard.html';
              break;
            case 'coy_comd':
              window.location.href = 'coy_commander/coy_dashboard.html';
              break;
            case 'adjutant':
              window.location.href = 'adjutant/adjt_dashboard.html';
              break;
            case 'bsm':
              window.location.href = 'bsm/bsm-dashboard.html';
              break;
            case 'commanding_officer':
              window.location.href = 'CO/CO_dashboard.html';
              break;
            default:
              alert('Unknown role');
          }
        } else {
          alert(data.error || 'Login failed');
        }
      } catch (error) {
        console.error('Login error:', error);
        alert('Connection error. Please check if backend is running.');
      }
    });
  </script>
</body>
</html>
```

**Login Flow Detailed:**

1. **User fills form**
   - Service Number: 1111002
   - Password: Test@123

2. **Form submission**
   - `e.preventDefault()` stops page reload
   - Extract values from input fields

3. **Fetch API call**
   ```javascript
   fetch(url, {
     method: 'POST',
     headers: { 'Content-Type': 'application/json' },
     body: JSON.stringify(credentials)
   })
   ```

4. **Response handling**
   - Parse JSON response
   - Check `data.success` flag

5. **Token storage**
   ```javascript
   localStorage.setItem('token', data.token);
   // Stored in browser, persists after page refresh
   ```

6. **Token decoding**
   ```javascript
   const decoded = jwt_decode(token);
   // Result: { user_id: "...", role: "coy_comd", ... }
   ```

7. **Role-based redirect**
   - Switch statement checks role
   - Redirects to appropriate dashboard

### 6.4 Dashboard Page Breakdown

**File:** `frontend/coy_commander/coy_dashboard.html`

**Key Features:**
1. Token verification
2. Data fetching (soldiers, leaves)
3. Status calculation
4. Dynamic table rendering
5. Real-time statistics

**JavaScript Code Flow:**

```javascript
// 1. Load on page ready
window.addEventListener('DOMContentLoaded', loadDashboard);

async function loadDashboard() {
  try {
    // 2. Get token from localStorage
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '../../login.html';
      return;
    }

    // 3. Decode token to get user info
    const decoded = jwt_decode(token);
    const currentCompany = decoded.company;

    // 4. Fetch soldiers from API
    const userResponse = await fetch(`${API_BASE}/api/users`, {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    const userData = await userResponse.json();
    
    // 5. Filter soldiers by company
    const companySoldiers = userData.users.filter(
      user => user.role === 'soldier' && user.company === currentCompany
    );

    // 6. Fetch leaves from API
    const leaveResponse = await fetch(`${API_BASE}/api/leaves`, {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    const leaveData = await leaveResponse.json();

    // 7. Process soldier statuses
    const processedSoldiers = companySoldiers.map(soldier => {
      const attendance = getAttendanceFromLocalStorage(soldier.service_number);
      const activeLeave = findActiveLeave(soldier, leaveData.leaves);
      
      return {
        ...soldier,
        status: calculateStatus(attendance, activeLeave),
        statusClass: getStatusClass(status)
      };
    });

    // 8. Calculate statistics
    const stats = {
      total: processedSoldiers.length,
      present: processedSoldiers.filter(s => s.status === 'On Parade').length,
      leave: processedSoldiers.filter(s => s.status === 'On Leave').length,
      awol: processedSoldiers.filter(s => s.status === 'AWOL').length
    };

    // 9. Update UI
    document.getElementById('totalStrength').textContent = stats.total;
    document.getElementById('onParade').textContent = stats.present;
    document.getElementById('offParade').textContent = stats.leave;
    document.getElementById('awol').textContent = stats.awol;

    // 10. Render table
    renderSoldierTable(processedSoldiers);

  } catch (error) {
    console.error('Error loading dashboard:', error);
    alert('Failed to load dashboard data');
  }
}

function renderSoldierTable(soldiers) {
  const tableBody = document.getElementById('soldierTableBody');
  tableBody.innerHTML = '';  // Clear existing rows

  soldiers.forEach(soldier => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${soldier.service_number}</td>
      <td>${soldier.rank}</td>
      <td>${soldier.name}</td>
      <td class="${soldier.statusClass}">${soldier.status}</td>
    `;
    tableBody.appendChild(row);
  });
}
```

**Data Flow Visualization:**

```
localStorage (token)
  │
  ▼
Decode JWT → Get user role & company
  │
  ▼
API Call: GET /api/users
  │
  ▼
Filter: role='soldier' & company='Radio'
  │
  ▼
API Call: GET /api/leaves
  │
  ▼
Match leaves with soldiers
  │
  ▼
Calculate status for each soldier
  │
  ▼
Update statistics (Total, Present, Leave, AWOL)
  │
  ▼
Render table with soldier data
```

### 6.5 Fetch API Explained

**Basic Fetch Syntax:**
```javascript
fetch(url, options)
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error(error));
```

**With Async/Await:**
```javascript
try {
  const response = await fetch(url, options);
  const data = await response.json();
  console.log(data);
} catch (error) {
  console.error(error);
}
```

**Common Patterns:**

1. **GET Request**
   ```javascript
   const response = await fetch(`${API_BASE}/api/users`, {
     headers: {
       'Authorization': `Bearer ${token}`
     }
   });
   ```

2. **POST Request**
   ```javascript
   const response = await fetch(`${API_BASE}/api/leaves`, {
     method: 'POST',
     headers: {
       'Authorization': `Bearer ${token}`,
       'Content-Type': 'application/json'
     },
     body: JSON.stringify({
       start_date: '2026-03-01',
       end_date: '2026-03-10',
       reason: 'Family vacation'
     })
   });
   ```

3. **PUT Request**
   ```javascript
   const response = await fetch(`${API_BASE}/api/leaves/${id}/approve`, {
     method: 'PUT',
     headers: {
       'Authorization': `Bearer ${token}`
     }
   });
   ```

4. **DELETE Request**
   ```javascript
   const response = await fetch(`${API_BASE}/api/leaves/${id}`, {
     method: 'DELETE',
     headers: {
       'Authorization': `Bearer ${token}`
     }
   });
   ```

**Response Handling:**
```javascript
const response = await fetch(url);

if (!response.ok) {
  if (response.status === 401) {
    // Unauthorized - redirect to login
    localStorage.clear();
    window.location.href = 'login.html';
  } else if (response.status === 403) {
    // Forbidden - insufficient permissions
    alert('Access denied');
  } else if (response.status === 404) {
    // Not found
    alert('Resource not found');
  } else {
    // Other errors
    alert('Request failed');
  }
  return;
}

const data = await response.json();
// Process data
```

### 6.6 LocalStorage Usage

**What is localStorage?**
- Browser API for storing key-value pairs
- Persists after browser close
- 5-10MB storage limit
- Same-origin policy (security)

**Common Operations:**
```javascript
// Store data
localStorage.setItem('token', 'eyJhbGci...');

// Retrieve data
const token = localStorage.getItem('token');

// Remove data
localStorage.removeItem('token');

// Clear all data
localStorage.clear();

// Store objects (must stringify)
const user = { name: 'Ahmed', role: 'soldier' };
localStorage.setItem('user', JSON.stringify(user));

// Retrieve objects (must parse)
const user = JSON.parse(localStorage.getItem('user'));
```

**ParadeOps localStorage Usage:**

1. **Authentication Token**
   ```javascript
   // After login
   localStorage.setItem('token', data.token);

   // In all API calls
   const token = localStorage.getItem('token');
   fetch(url, { headers: { 'Authorization': `Bearer ${token}` } });
   ```

2. **Attendance Cache**
   ```javascript
   // Store daily attendance (temporary cache)
   const key = `attendance_${service_number}_${date}`;
   localStorage.setItem(key, JSON.stringify({
     special_status: 'on_duty',
     timestamp: new Date().toISOString()
   }));
   ```

3. **Notices/Messages**
   ```javascript
   // Store notices for CO dashboard
   localStorage.setItem('CO_notices', JSON.stringify([
     { title: 'Urgent', message: 'Parade at 0800', timestamp: '...' }
   ]));
   ```

**Security Considerations:**
- ⚠️ localStorage is not encrypted
- ⚠️ Accessible via JavaScript (XSS risk)
- ✅ Use HttpOnly cookies for sensitive data (more secure)
- ✅ ParadeOps: Token expires after 8 hours (mitigates risk)

---

## 7. Authentication & Security

### 7.1 JWT (JSON Web Token)

**What is JWT?**
- Stateless authentication mechanism
- Self-contained (includes user data)
- Cryptographically signed (tamper-proof)

**JWT Structure:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTIzIiwicm9sZSI6InNvbGRpZXIifQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
│────────── Header ──────────────│  │─────────── Payload ───────────────────│  │────────── Signature ────────────────────│
```

**Decoded JWT:**
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "user_id": "507f1f77bcf86cd799439011",
    "service_number": "1111002",
    "name": "Refa Jahan",
    "rank": "Lieutenant",
    "role": "coy_comd",
    "company": "Radio",
    "iat": 1677606000,
    "exp": 1677634800
  },
  "signature": "..."
}
```

**How JWT Works:**

1. **User logs in**
   → Backend creates JWT
   → Signs with secret key
   → Sends to frontend

2. **Frontend stores token**
   → localStorage.setItem('token', jwt)

3. **Subsequent requests**
   → Frontend sends: `Authorization: Bearer <token>`
   → Backend verifies signature
   → Extracts user data from payload
   → Allows/denies access

**Why JWT?**
- ✅ Stateless (no session storage needed)
- ✅ Scalable (works with load balancers)
- ✅ Cross-domain (CORS-friendly)
- ✅ Mobile-friendly (no cookies needed)

**JWT vs Sessions:**

| Feature | JWT | Session |
|---------|-----|---------|
| Storage | Client-side | Server-side |
| Scalability | High (stateless) | Low (needs shared storage) |
| Security | Token can be stolen | Session ID can be stolen |
| Expiration | Built-in | Requires server logic |
| Revocation | Difficult (need blacklist) | Easy (delete session) |

### 7.2 Password Security

**Bcrypt Hashing:**

```javascript
// During registration
const plainPassword = 'Test@123';
const saltRounds = 10;
const hashedPassword = await bcrypt.hash(plainPassword, saltRounds);
// Result: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
```

**Bcrypt Format:**
```
$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
│ │ │  │──────────────────────────────────────────────────────────│
│ │ │  │                                                            │
│ │ │  └─ Hash (31 chars)                                          │
│ │ └── Salt (22 chars)                                            │
│ └──── Cost factor (10 = 2^10 = 1024 iterations)                 │
└────── Algorithm ($2a = bcrypt)                                   │
```

**Why Salt?**
```
Without salt:
password "Test@123" → hash "abc123" (always same)
password "Test@123" → hash "abc123" (always same)
↑ Rainbow table attack possible

With salt:
password "Test@123" + salt1 → hash "xyz789"
password "Test@123" + salt2 → hash "pqr456"
↑ Each hash is unique, rainbow tables useless
```

**Cost Factor (Rounds):**
- 10 rounds = 2^10 = 1024 iterations (~100ms)
- 12 rounds = 2^12 = 4096 iterations (~400ms)
- 14 rounds = 2^14 = 16384 iterations (~1.6s)

Higher rounds = more secure but slower

**Password Validation:**
```javascript
// During login
const isMatch = await bcrypt.compare('Test@123', hashedPassword);
// Returns: true or false

// Bcrypt internally:
// 1. Extracts salt from stored hash
// 2. Hashes input password with same salt
// 3. Compares hashes
```

**Password Requirements (Frontend):**
```javascript
// In user-registration.html
function validatePassword(password) {
  const requirements = {
    length: password.length >= 6,
    uppercase: /[A-Z]/.test(password),
    special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)
  };
  
  return requirements.length && requirements.uppercase && requirements.special;
}
```

### 7.3 CORS (Cross-Origin Resource Sharing)

**The Problem:**
```
Frontend: http://localhost:8000
Backend: http://localhost:5000
↑ Different ports = Different origins
```

Browser blocks requests by default (security policy)

**The Solution:**
```javascript
// In backend/src/server.js
app.use(cors({
  origin: '*',           // Allow all origins (for development)
  credentials: true     // Allow cookies/auth headers
}));
```

**Production CORS:**
```javascript
app.use(cors({
  origin: 'https://yourdomain.com',  // Restrict to your domain
  credentials: true
}));
```

**How CORS Works:**

1. **Browser sends preflight request**
   ```
   OPTIONS /api/users
   Origin: http://localhost:8000
   ```

2. **Server responds with CORS headers**
   ```
   Access-Control-Allow-Origin: *
   Access-Control-Allow-Methods: GET, POST, PUT, DELETE
   Access-Control-Allow-Headers: Authorization, Content-Type
   ```

3. **Browser allows actual request**
   ```
   GET /api/users
   Authorization: Bearer token123
   ```

### 7.4 Security Best Practices

**Implemented in ParadeOps:**

1. **Password Hashing**
   - ✅ Bcrypt with 10 salt rounds
   - ✅ Never store plain-text passwords
   - ✅ Remove password_hash from JSON responses

2. **JWT Expiration**
   - ✅ Tokens expire after 8 hours
   - ✅ Users must re-login after expiration

3. **Input Validation**
   - ✅ Backend validates all inputs
   - ✅ Mongoose schema validation
   - ✅ Frontend form validation

4. **HTTPS (Production)**
   - ⚠️ Currently HTTP (localhost)
   - ✅ Should use HTTPS in production

5. **Authorization Checks**
   - ✅ Role-based access control
   - ✅ Only commanders can approve leaves
   - ✅ Users can only see their own data

**Not Implemented (Future):**

- ❌ Rate limiting (prevent brute-force)
- ❌ IP whitelisting
- ❌ Two-factor authentication
- ❌ Password history (prevent reuse)
- ❌ Account lockout after failed attempts

---

## 8. API Communication

### 8.1 REST API Principles

**REST** = Representational State Transfer

**Characteristics:**
1. **Client-Server Architecture**
   - Separation of concerns
   - Frontend and backend independent

2. **Stateless**
   - Each request is independent
   - No session state on server
   - All context in request (JWT token)

3. **Resource-Based**
   - URLs represent resources
   - `/api/users` = users collection
   - `/api/leaves/123` = specific leave

4. **HTTP Methods**
   - GET = Read
   - POST = Create
   - PUT/PATCH = Update
   - DELETE = Delete

5. **JSON Format**
   - Request/response bodies in JSON
   - Universal, language-independent

**ParadeOps API Design:**

| Resource | GET | POST | PUT | DELETE |
|----------|-----|------|-----|--------|
| /api/users | List all | Create | Update | - |
| /api/users/:id | Get one | - | Update | - |
| /api/leaves | List all | Create | - | Delete |
| /api/leaves/:id | Get one | - | - | Delete |
| /api/leaves/:id/approve | - | - | Approve | - |

### 8.2 Request/Response Examples

**Example 1: Login**

**Request:**
```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "service_number": "1111002",
  "password": "Test@123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "user_id": "507f1f77bcf86cd799439011",
    "service_number": "1111002",
    "name": "Refa Jahan",
    "rank": "Lieutenant",
    "role": "coy_comd",
    "company": "Radio"
  }
}
```

**Example 2: Get Users**

**Request:**
```
GET http://localhost:5000/api/users
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "count": 120,
  "users": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "service_number": "1111003",
      "name": "Ahmed Hassan",
      "rank": "Sergeant",
      "role": "soldier",
      "company": "Radio",
      "email": "ahmed@army.mil",
      "phone": "01712345678"
    },
    {
      "_id": "507f1f77bcf86cd799439012",
      "service_number": "1111004",
      "name": "Karim Ali",
      "rank": "Corporal",
      "role": "soldier",
      "company": "Radio",
      "email": null,
      "phone": "01812345678"
    }
    // ... more users
  ]
}
```

**Example 3: Create Leave**

**Request:**
```
POST http://localhost:5000/api/leaves
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "leave_type_id": "507f1f77bcf86cd799439033",
  "start_date": "2026-03-01",
  "end_date": "2026-03-10",
  "total_days": 10,
  "reason": "Family emergency",
  "address_during_leave": "123 Main St, Dhaka",
  "contact_number": "01712345678"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Leave application submitted successfully",
  "leave": {
    "_id": "507f1f77bcf86cd799439055",
    "user_id": "507f1f77bcf86cd799439011",
    "leave_type_id": "507f1f77bcf86cd799439033",
    "start_date": "2026-03-01T00:00:00.000Z",
    "end_date": "2026-03-10T00:00:00.000Z",
    "total_days": 10,
    "reason": "Family emergency",
    "status": "pending",
    "createdAt": "2026-02-28T10:30:00.000Z",
    "updatedAt": "2026-02-28T10:30:00.000Z"
  }
}
```

**Example 4: Approve Leave**

**Request:**
```
PUT http://localhost:5000/api/leaves/507f1f77bcf86cd799439055/approve
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "success": true,
  "message": "Leave approved successfully",
  "leave": {
    "_id": "507f1f77bcf86cd799439055",
    "status": "approved",
    "approved_by": {
      "_id": "507f1f77bcf86cd799439002",
      "name": "Refa Jahan"
    },
    "updatedAt": "2026-02-28T11:00:00.000Z"
  }
}
```

### 8.3 Error Responses

**400 Bad Request:**
```json
{
  "error": "Service number and password are required"
}
```

**401 Unauthorized:**
```json
{
  "error": "Access token required"
}
```

**403 Forbidden:**
```json
{
  "error": "Insufficient permissions"
}
```

**404 Not Found:**
```json
{
  "error": "User not found"
}
```

**500 Internal Server Error:**
```json
{
  "error": "Failed to fetch users",
  "stack": "Error: Connection lost\n  at..."  // Only in development
}
```

---

## 9. Complete Data Flow Examples

### 9.1 Example: Soldier Applies for Leave

**Step-by-Step Flow:**

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Soldier Opens Leave Application Page               │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
Frontend: sldr_lve_apply.html
- Loads page
- Checks for token in localStorage
- Fetches leave types from API
- Populates dropdown

┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Fetch Leave Types                                  │
└─────────────────────────────────────────────────────────────┘
                          │
Frontend JavaScript:      ▼
  fetch('/api/leaves/types')
                          │
                          ▼
Backend: leaveRoutes.js
  router.get('/types', leaveController.getLeaveTypes)
                          │
                          ▼
Backend: leaveController.js
  async getLeaveTypes() {
    const types = await LeaveType.find();
    res.json(types);
  }
                          │
                          ▼
MongoDB:
  db.leavetypes.find({})
  Returns: [
    { _id: "...", type_name: "Annual", max_days: 60 },
    { _id: "...", type_name: "Casual", max_days: 10 },
    ...
  ]
                          │
                          ▼
Frontend: Receives response
  Populates <select> dropdown with options

┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Soldier Fills Form                                 │
└─────────────────────────────────────────────────────────────┘
- Leave Type: Annual
- Start Date: 2026-03-01
- End Date: 2026-03-10
- Reason: Family emergency
- Contact: 01712345678
- Address: 123 Main St, Dhaka

┌─────────────────────────────────────────────────────────────┐
│ STEP 4: Soldier Clicks "Submit"                            │
└─────────────────────────────────────────────────────────────┘
                          │
Frontend JavaScript:      ▼
  document.getElementById('leaveForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    // Validate form
    if (!validateForm()) return;
    
    // Prepare data
    const leaveData = {
      leave_type_id: document.getElementById('leaveType').value,
      start_date: document.getElementById('startDate').value,
      end_date: document.getElementById('endDate').value,
      total_days: calculateDays(start, end),
      reason: document.getElementById('reason').value,
      contact_number: document.getElementById('contact').value,
      address_during_leave: document.getElementById('address').value
    };
    
    // Send to backend
    const response = await fetch('/api/leaves', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(leaveData)
    });
  });

┌─────────────────────────────────────────────────────────────┐
│ STEP 5: Backend Receives Request                           │
└─────────────────────────────────────────────────────────────┘
                          │
Backend: Express Router   ▼
  POST /api/leaves
                          │
                          ▼
Middleware: authenticateToken
  - Extract token from header
  - Verify signature
  - Decode payload → req.user
                          │
                          ▼
Backend: leaveController.js
  async createLeave(req, res) {
    try {
      const user_id = req.user.user_id;
      const leaveData = {
        user_id,
        ...req.body,
        status: 'pending'
      };
      
      // Validate user exists
      const user = await User.findById(user_id);
      if (!user) return res.status(404).json({ error: 'User not found' });
      
      // Validate leave type exists
      const leaveType = await LeaveType.findById(leaveData.leave_type_id);
      if (!leaveType) return res.status(404).json({ error: 'Invalid leave type' });
      
      // Check if total_days exceeds max_days
      if (leaveData.total_days > leaveType.max_days) {
        return res.status(400).json({ 
          error: `Maximum ${leaveType.max_days} days allowed for ${leaveType.type_name}` 
        });
      }
      
      // Create leave record
      const leave = await Leave.create(leaveData);
      
      res.status(201).json({
        success: true,
        message: 'Leave application submitted',
        leave
      });
    } catch (error) {
      console.error('Create leave error:', error);
      res.status(500).json({ error: 'Failed to create leave' });
    }
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 6: MongoDB Stores Leave                               │
└─────────────────────────────────────────────────────────────┘
                          │
Mongoose:                 ▼
  const leave = new Leave(leaveData);
  await leave.save();
                          │
                          ▼
MongoDB:
  db.leaves.insertOne({
    _id: ObjectId("607f1f77bcf86cd799439055"),
    user_id: ObjectId("607f1f77bcf86cd799439011"),
    leave_type_id: ObjectId("607f1f77bcf86cd799439033"),
    start_date: ISODate("2026-03-01"),
    end_date: ISODate("2026-03-10"),
    total_days: 10,
    reason: "Family emergency",
    contact_number: "01712345678",
    address_during_leave: "123 Main St, Dhaka",
    status: "pending",
    createdAt: ISODate("2026-02-28T10:30:00Z"),
    updatedAt: ISODate("2026-02-28T10:30:00Z")
  })

┌─────────────────────────────────────────────────────────────┐
│ STEP 7: Response Back to Frontend                          │
└─────────────────────────────────────────────────────────────┘
                          │
Backend sends:            ▼
  Status: 201 Created
  Body: {
    success: true,
    message: "Leave application submitted",
    leave: { ... }
  }
                          │
                          ▼
Frontend JavaScript:
  const data = await response.json();
  
  if (data.success) {
    alert('Leave application submitted successfully!');
    window.location.href = 'soldier_dashboard.html';
  }

┌─────────────────────────────────────────────────────────────┐
│ STEP 8: Commander Sees Pending Leave                       │
└─────────────────────────────────────────────────────────────┘
                          │
Commander opens:          ▼
  Leave_approval.html
                          │
                          ▼
JavaScript fetches:
  GET /api/leaves?status=pending
                          │
                          ▼
Backend: Role-based filtering
  if (user.role === 'coy_comd') {
    filters.unit = user.company;  // Only Radio company
  }
                          │
                          ▼
MongoDB Query:
  1. Find users in Radio company
     db.users.find({ company: 'Radio' }, { _id: 1 })
     
  2. Find pending leaves for those users
     db.leaves.find({
       status: 'pending',
       user_id: { $in: [array of user IDs] }
     })
                          │
                          ▼
Mongoose Population:
  .populate('user_id', 'name service_number rank')
  .populate('leave_type_id', 'type_name')
                          │
                          ▼
Response to Commander:
  {
    count: 5,
    leaves: [
      {
        _id: "...",
        user_id: {
          name: "Ahmed Hassan",
          service_number: "1111003",
          rank: "Sergeant"
        },
        leave_type_id: {
          type_name: "Annual"
        },
        start_date: "2026-03-01",
        end_date: "2026-03-10",
        total_days: 10,
        reason: "Family emergency",
        status: "pending"
      },
      ...
    ]
  }
                          │
                          ▼
Frontend renders table:
  ┌────────┬──────────┬───────┬──────────┬────────┬────────┐
  │ Serial │ Rank     │ Name  │ Type     │ Days   │ Action │
  ├────────┼──────────┼───────┼──────────┼────────┼────────┤
  │ 1111003│ Sergeant │ Ahmed │ Annual   │ 10     │ [Approve]│
  │        │          │Hassan │          │        │ [Reject] │
  └────────┴──────────┴───────┴──────────┴────────┴────────┘

┌─────────────────────────────────────────────────────────────┐
│ STEP 9: Commander Approves Leave                           │
└─────────────────────────────────────────────────────────────┘
                          │
Commander clicks:         ▼
  "Approve" button
                          │
                          ▼
Frontend JavaScript:
  const response = await fetch('/api/leaves/${id}/approve', {
    method: 'PUT',
    headers: { 'Authorization': `Bearer ${token}` }
  });
                          │
                          ▼
Backend: leaveController.js
  async approveLeave(req, res) {
    const { id } = req.params;
    const approved_by = req.user.user_id;
    
    const leave = await Leave.approve(id, approved_by);
    
    res.json({
      success: true,
      message: 'Leave approved',
      leave
    });
  }
                          │
                          ▼
Mongoose:
  Leave.findByIdAndUpdate(
    id,
    {
      status: 'approved',
      approved_by: approved_by
    },
    { new: true }
  )
                          │
                          ▼
MongoDB:
  db.leaves.updateOne(
    { _id: ObjectId("...") },
    {
      $set: {
        status: "approved",
        approved_by: ObjectId("..."),
        updatedAt: ISODate("...")
      }
    }
  )
                          │
                          ▼
Frontend receives response:
  alert('Leave approved successfully!');
  // Refresh page to update list
  location.reload();

┌─────────────────────────────────────────────────────────────┐
│ STEP 10: Soldier Sees Approved Status                      │
└─────────────────────────────────────────────────────────────┘
                          │
Soldier dashboard:        ▼
  - Fetches GET /api/leaves
  - Filters by user_id (own leaves only)
  - Displays status: "Approved"
```

### 9.2 Example: BSM Marks Attendance

**Complete Flow:**

```
┌─────────────────────────────────────────────────────────────┐
│ BSM Opens Dashboard                                         │
└─────────────────────────────────────────────────────────────┘
URL: bsm-dashboard.html

JavaScript runs on page load:
  - Check authentication
  - Fetch all soldiers
  - Initialize attendance records for today
  - Display soldier list

┌─────────────────────────────────────────────────────────────┐
│ Initialize Today's Attendance                               │
└─────────────────────────────────────────────────────────────┘

Frontend calls:
  POST /api/attendance/init-date
  Body: { date: '2026-02-28' }

Backend: attendanceController.js
  async initDate(req, res) {
    const date = req.body.date || todayStr();
    
    // Get all soldiers
    const soldiers = await User.find({ role: 'soldier' })
      .select('service_number name rank company');
    
    // Create blank attendance records
    const ops = soldiers.map(s => ({
      updateOne: {
        filter: { service_number: s.service_number, date },
        update: {
          $setOnInsert: {
            service_number: s.service_number,
            date,
            name: s.name,
            rank: s.rank,
            company: s.company,
            morning_pt: '',
            office: '',
            games: '',
            roll_call: '',
            leave: '',
            awol: ''
          }
        },
        upsert: true
      }
    }));
    
    await Attendance.bulkWrite(ops);
  }

MongoDB:
  - Creates one document per soldier if doesn't exist
  - Skips if already exists (composite unique index)

┌─────────────────────────────────────────────────────────────┐
│ BSM Marks Soldier Present in Morning PT                    │
└─────────────────────────────────────────────────────────────┘

BSM clicks checkbox for "1111003 - Ahmed Hassan - Morning PT"

Frontend:
  const response = await fetch('/api/attendance/mark', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      service_number: '1111003',
      date: '2026-02-28',
      morning_pt: 'present'
    })
  });

Backend:
  async markAttendance(req, res) {
    const { service_number, date, morning_pt } = req.body;
    
    await Attendance.findOneAndUpdate(
      { service_number, date },
      { $set: { morning_pt, last_updated: new Date() } },
      { upsert: true }
    );
  }

MongoDB:
  db.soldier_attendance.updateOne(
    {
      service_number: "1111003",
      date: "2026-02-28"
    },
    {
      $set: {
        morning_pt: "present",
        last_updated: ISODate("2026-02-28T06:15:00Z")
      }
    }
  )

Frontend updates UI:
  - Checkbox checked
  - Visual feedback (green color)
  - Auto-save indicator shown
```

---

## 10. Role-Based Access Control

### 10.1 User Roles

| Role | Code | Count | Permissions |
|------|------|-------|-------------|
| Soldier | `soldier` | ~500 | View own data, apply leave |
| Company Commander | `coy_comd` | ~5 | Approve company leaves, view company stats |
| Adjutant | `adjutant` | 1 | View all except Radio, generate reports |
| BSM | `bsm` | 1 | Mark attendance, manage logistics |
| Commanding Officer | `commanding_officer` | 1 | Full access, battalion-wide view |

### 10.2 Access Matrix

| Feature | Soldier | Coy Comd | Adjutant | BSM | CO |
|---------|---------|----------|----------|-----|-----|
| Apply Leave | ✅ | ✅ | ✅ | ✅ | ✅ |
| Approve Own Company Leave | ❌ | ✅ | ❌ | ❌ | ✅ |
| Approve All Leaves | ❌ | ❌ | ✅ | ❌ | ✅ |
| Mark Attendance | ❌ | ❌ | ❌ | ✅ | ✅ |
| View Own Data | ✅ | ✅ | ✅ | ✅ | ✅ |
| View Company Data | ❌ | ✅ | ❌ | ❌ | ✅ |
| View All Data | ❌ | ❌ | ✅* | ❌ | ✅ |
| Generate Reports | ❌ | ✅ | ✅ | ✅ | ✅ |

*Except Radio company

### 10.3 Implementation

**Backend Authorization:**
```javascript
// In leaveController.js
const getAllLeaves = async (req, res) => {
  const user = req.user;
  let filters = {};

  if (user.role === 'soldier') {
    // Soldiers see only own leaves
    filters.user_id = user.user_id;
  } else if (user.role === 'coy_comd') {
    // Commanders see only their company
    filters.unit = user.company;
  } else if (user.role === 'adjutant') {
    // Adjutant sees all except Radio
    filters.exclude_unit = 'Radio';
  }
  // BSM and CO see everything

  const leaves = await Leave.findAll(filters);
  res.json({ leaves });
};
```

**Frontend Dashboard Selection:**
```javascript
// In login.html
const decoded = jwt_decode(token);

switch(decoded.role) {
  case 'soldier':
    window.location.href = 'soldier/soldier_dashboard.html';
    break;
  case 'coy_comd':
    window.location.href = 'coy_commander/coy_dashboard.html';
    break;
  case 'adjutant':
    window.location.href = 'adjutant/adjt_dashboard.html';
    break;
  case 'bsm':
    window.location.href = 'bsm/bsm-dashboard.html';
    break;
  case 'commanding_officer':
    window.location.href = 'CO/CO_dashboard.html';
    break;
}
```

---

## 11. Deployment & Running

### 11.1 System Requirements

**Hardware:**
- CPU: 2+ cores
- RAM: 4GB minimum (8GB recommended)
- Storage: 10GB free space

**Software:**
- Node.js v14+ (npm included)
- MongoDB 5.0+
- Python 3.x (for frontend server)
- Web Browser (Chrome, Firefox, Edge)

### 11.2 Installation Steps

**1. Install MongoDB:**
```powershell
# Download from: https://www.mongodb.com/try/download/community
# Run installer with default settings
# MongoDB runs as Windows service automatically
```

**2. Install Node.js:**
```powershell
# Download from: https://nodejs.org
# Run installer
# Verify installation:
node --version  # Should show v14+
npm --version   # Should show 6+
```

**3. Install Python (if not installed):**
```powershell
# Download from: https://www.python.org
# Run installer
# Check "Add Python to PATH"
```

**4. Clone/Download Project:**
```powershell
# Option 1: Git clone
git clone https://github.com/refa9568/SDP_Project.git
cd SDP_Project

# Option 2: Download ZIP and extract
```

**5. Install Backend Dependencies:**
```powershell
cd backend
npm install
```

### 11.3 Running the Application

**Start System (3 Terminals):**

**Terminal 1: MongoDB (if not auto-started)**
```powershell
# Check if running:
Get-Service MongoDB

# If not running:
net start MongoDB
```

**Terminal 2: Backend API**
```powershell
cd E:\SDP_Project\backend
npm start

# Output:
# ✓ MongoDB connected successfully
# Leave types seeded/updated successfully
# Server running on http://localhost:5000
```

**Terminal 3: Frontend Server**
```powershell
cd E:\SDP_Project
python -m http.server 8000

# Output:
# Serving HTTP on :: port 8000 (http://[::]:8000/) ...
```

**Access Application:**
- Open browser
- Navigate to: `http://localhost:8000`
- Login page appears

### 11.4 Default Test Accounts

| Role | Service Number | Password |
|------|----------------|----------|
| Soldier | 1111003 | Test@123 |
| Company Commander | 1111002 | Test@123 |
| BSM | BSM001 | Test@123 |
| Adjutant | ADJ001 | Test@123 |
| CO | CO001 | Test@123 |

### 11.5 Verification Checklist

**Health Check:**
```powershell
# Check backend health
Invoke-WebRequest http://localhost:5000/health

# Should return:
# {"status":"ok","timestamp":"2026-02-28T..."}
```

**Database Check:**
```powershell
cd backend
node -e "
const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/paradeops_db')
  .then(() => console.log('✓ Database connected'))
  .catch(err => console.error('✗ Database error:', err));
"
```

**Port Check:**
```powershell
# Check what's running on ports
netstat -ano | findstr ":5000"  # Backend
netstat -ano | findstr ":8000"  # Frontend
netstat -ano | findstr ":27017" # MongoDB
```

---

## 12. Testing Scenarios

### 12.1 Manual Testing Workflow

**Test 1: Login & Dashboard**
```
1. Open http://localhost:8000
2. Enter: Service Number = 1111002, Password = Test@123
3. Click Login
4. ✅ Should redirect to Company Commander Dashboard
5. ✅ Should display company name (Radio)
6. ✅ Should show soldier statistics
```

**Test 2: Leave Application**
```
1. Login as soldier (1111003)
2. Navigate to "Apply Leave"
3. Fill form:
   - Leave Type: Annual
   - Start Date: Tomorrow
   - End Date: 10 days later
   - Reason: Family emergency
4. Click Submit
5. ✅ Should show success message
6. ✅ Should appear in "My Leaves" as "Pending"
```

**Test 3: Leave Approval**
```
1. Login as Company Commander (1111002)
2. Navigate to "Leave Approval"
3. ✅ Should see soldier's leave in pending list
4. Click "Approve"
5. ✅ Leave status should change to "Approved"
6. Login as soldier again
7. ✅ Leave should show as "Approved"
```

**Test 4: Attendance Marking**
```
1. Login as BSM (BSM001)
2. Dashboard shows all soldiers
3. Click checkbox for "Morning PT - Present"
4. ✅ Should auto-save
5. Refresh page
6. ✅ Checkbox should remain checked
```

### 12.2 API Testing (Postman)

**Test Collection:**

```json
{
  "info": { "name": "ParadeOps API Tests" },
  "item": [
    {
      "name": "Login",
      "request": {
        "method": "POST",
        "url": "http://localhost:5000/api/auth/login",
        "body": {
          "mode": "raw",
          "raw": "{\"service_number\":\"1111002\",\"password\":\"Test@123\"}"
        }
      }
    },
    {
      "name": "Get Users",
      "request": {
        "method": "GET",
        "url": "http://localhost:5000/api/users",
        "header": [
          {"key": "Authorization", "value": "Bearer {{token}}"}
        ]
      }
    }
  ]
}
```

### 12.3 Database Verification

```javascript
// Check user count
const mongoose = require('mongoose');
const User = require('./src/models/User');

mongoose.connect('mongodb://localhost:27017/paradeops_db');

const counts = {
  soldiers: await User.countDocuments({ role: 'soldier' }),
  commanders: await User.countDocuments({ role: 'coy_comd' }),
  total: await User.countDocuments()
};

console.log(counts);
// Expected: { soldiers: ~500, commanders: ~5, total: 508 }
```

---

## 13. Common Issues & Solutions

### 13.1 Backend Won't Start

**Issue:** `Error: Cannot find module 'express'`

**Solution:**
```powershell
cd backend
npm install
```

---

**Issue:** `MongoDB connection failed`

**Solution:**
```powershell
# Check if MongoDB is running
Get-Service MongoDB

# Start MongoDB
net start MongoDB

# Verify connection
mongo --eval "db.version()"
```

### 13.2 Frontend Can't Connect to Backend

**Issue:** `Failed to fetch` / CORS error

**Solution:**
1. Check backend is running on port 5000
2. Verify CORS is enabled in server.js
3. Check browser console for specific error

```javascript
// In server.js, ensure:
app.use(cors({ origin: '*', credentials: true }));
```

### 13.3 Login Fails

**Issue:** `Invalid credentials` even with correct password

**Solution:**
```powershell
# Verify user exists
cd backend
node -e "
const User = require('./src/models/User');
const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/paradeops_db');
User.findByServiceNumber('1111002').then(u => console.log(u));
"
```

### 13.4 Token Expired

**Issue:** `Invalid or expired token`

**Solution:**
- Tokens expire after 8 hours
- User must log in again
- Clear localStorage and refresh page

```javascript
// In browser console:
localStorage.clear();
location.reload();
```

### 13.5 Port Already in Use

**Issue:** `EADDRINUSE: address already in use :::5000`

**Solution:**
```powershell
# Find process using port 5000
netstat -ano | findstr ":5000"

# Kill process (replace PID with actual number)
taskkill /PID <PID> /F
```

---

## 14. Project Summary

### 14.1 What We Built

**ParadeOps** is a complete military personnel management system with:

✅ **Authentication System**
- JWT-based token authentication
- Bcrypt password hashing
- Role-based access control

✅ **Leave Management**
- Application workflow
- Approval system
- Leave balance tracking

✅ **Attendance System**
- Daily parade state
- Multiple activity checkpoints
- AWOL tracking

✅ **Reporting**
- Company-wise reports
- Battalion strength reports
- Daily/weekly summaries

### 14.2 Technical Achievements

**Architecture:**
- Three-tier architecture (Client-Server-Database)
- RESTful API design
- Separation of concerns

**Security:**
- One-way password encryption
- Token expiration
- Input validation
- API authorization

**Database:**
- NoSQL schema design
- Indexing for performance
- Relationship management

**Frontend:**
- Responsive UI
- Dynamic data rendering
- Real-time updates

### 14.3 Key Metrics

| Metric | Value |
|--------|-------|
| Total Lines of Code | ~15,000+ |
| API Endpoints | 25+ |
| Database Collections | 4 |
| User Roles | 5 |
| HTML Pages | 20+ |
| Controllers | 4 |
| Models | 3 |
| Routes | 4 |
| Features | 10+ |

### 14.4 Technologies Mastered

**Backend:**
- ✅ Node.js & Express.js
- ✅ MongoDB & Mongoose
- ✅ JWT Authentication
- ✅ Bcrypt Encryption
- ✅ RESTful API Design

**Frontend:**
- ✅ HTML5 & CSS3
- ✅ Vanilla JavaScript
- ✅ Fetch API
- ✅ DOM Manipulation
- ✅ LocalStorage

**Architecture:**
- ✅ MVC Pattern
- ✅ Middleware Chain
- ✅ Error Handling
- ✅ CORS Configuration

---

## 15. Future Enhancements

### 15.1 Immediate Improvements

1. **Rate Limiting**
   ```javascript
   const rateLimit = require('express-rate-limit');
   const limiter = rateLimit({
     windowMs: 15 * 60 * 1000,  // 15 minutes
     max: 100  // Max 100 requests per window
   });
   app.use('/api/', limiter);
   ```

2. **Input Sanitization**
   ```javascript
   const mongoSanitize = require('express-mongo-sanitize');
   app.use(mongoSanitize());  // Prevent NoSQL injection
   ```

3. **Helmet (Security Headers)**
   ```javascript
   const helmet = require('helmet');
   app.use(helmet());  // Set security headers
   ```

### 15.2 Advanced Features

- 📱 Mobile app (React Native)
- 📊 Advanced analytics & charts
- 📧 Email notifications
- 📱 SMS integration
- 🔔 Push notifications
- 📄 PDF report generation
- 🌐 Multi-language support
- 🔍 Advanced search & filtering

### 15.3 Scalability

- ⚡ Redis caching
- 🔄 Load balancing
- 📦 Microservices architecture
- 🐳 Docker containerization
- ☁️ Cloud deployment (AWS/Azure)

---

## 16. Conclusion

This documentation covers the complete technical implementation of ParadeOps from database to frontend, explaining every layer in detail. It serves as a comprehensive guide for:

✅ **Developers** - Understanding code structure & flow  
✅ **Testers** - Testing scenarios & verification  
✅ **Project Managers** - Architecture & technology stack  
✅ **Viva Examiners** - Technical depth & implementation details  
✅ **Stakeholders** - System capabilities & features

The project demonstrates real-world application of modern web development technologies in a military context, solving genuine problems with scalable, secure solutions.

---

**END OF DOCUMENTATION**

For questions or clarifications, refer to specific sections or code files mentioned throughout this document.
