# GIFT Bank - Online Banking System

A complete dynamic online banking system built with Java (Servlet + JSP), MySQL, and Bootstrap 5. The application provides a professional banking interface with full transaction management capabilities.

## 🌟 Features

- **User Authentication**: Session-based login system with secure password hashing
- **Account Management**: Create and manage multiple bank accounts
- **Deposit Money**: Add funds to your account with instant processing
- **Withdraw Money**: Withdraw funds with balance verification
- **Balance Inquiry**: Check your current account balance
- **Transaction History**: View all transactions with pagination
- **Professional UI**: Blue and white banking theme with responsive design
- **Security**: Session-based authentication with timeout
- **Database**: Complete MySQL database with proper transactions
- **Error Handling**: Comprehensive error handling and validation

## 🛠️ Technology Stack

### Frontend
- HTML5
- CSS3
- JavaScript (Vanilla)
- Bootstrap 5
- Bootstrap Icons

### Backend
- Java Servlets
- JSP (JavaServer Pages)
- Java Database Connectivity (JDBC)

### Database
- MySQL 5.7 or higher

### Server
- Apache Tomcat 9.0 or higher

## 📋 Prerequisites

- Java Development Kit (JDK) 8 or higher
- Apache Tomcat 9.0+
- MySQL Server 5.7+
- MySQL JDBC Driver (mysql-connector-java-8.0.xx.jar)

## 🚀 Installation & Setup

### Step 1: Create Database

1. Open MySQL command line or MySQL Workbench
2. Execute the SQL script:
   ```sql
   SOURCE database_schema.sql;
   ```
   Or copy the entire content of `database_schema.sql` and run it in MySQL

### Step 2: Configure Database Connection

1. Edit `src/main/java/com/giftbank/database/DBConnection.java`
2. Update the following constants:
   ```java
   private static final String DB_URL = "jdbc:mysql://localhost:3306/gift_bank";
   private static final String DB_USER = "root";
   private static final String DB_PASSWORD = "your_password";
   ```

### Step 3: Add MySQL JDBC Driver

1. Download MySQL JDBC Driver: [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/)
2. Place the JAR file in: `WEB-INF/lib/`

### Step 4: Compile Java Classes

```bash
cd GiftBank
javac -d "src/main/WebContent/WEB-INF/classes" src/main/java/com/giftbank/**/*.java
```

Or use your IDE (Eclipse, IntelliJ) to build the project automatically.

### Step 5: Deploy to Tomcat

1. **Option A - Using IDE:**
   - Configure Tomcat server in your IDE
   - Deploy the GiftBank application

2. **Option B - Manual Deployment:**
   - Copy `GiftBank` folder to `TOMCAT_HOME/webapps/`
   - Restart Tomcat

### Step 6: Access the Application

- Open browser and go to: `http://localhost:8080/GiftBank/`
- Or directly to login: `http://localhost:8080/GiftBank/jsp/login.jsp`

## 👤 Default Login Credentials

```
Email: admin@giftbank.com
Password: admin123
```

## 📁 Project Structure

```
GiftBank/
├── src/main/
│   ├── java/com/giftbank/
│   │   ├── servlets/           # Servlet classes
│   │   ├── database/           # Database models and connection
│   │   └── utils/              # Utility classes
│   └── WebContent/
│       ├── jsp/                # JSP pages
│       ├── css/                # Stylesheets
│       ├── js/                 # JavaScript files
│       ├── WEB-INF/
│       │   └── web.xml         # Deployment descriptor
│       └── index.jsp           # Home page
├── database_schema.sql         # Database schema
└── README.md                   # This file
```

## 🗄️ Database Schema

### Users Table
- `id` - Primary key
- `email` - User email (unique)
- `password` - Hashed password
- `role` - User role (customer/admin)
- `created_at`, `updated_at` - Timestamps

### Accounts Table
- `account_id` - Primary key
- `user_id` - Foreign key to users
- `account_number` - Unique account number
- `holder_name` - Account holder name
- `phone` - Contact number
- `address` - Address
- `balance` - Current balance (DECIMAL)
- `account_status` - Account status (active/inactive)

### Transactions Table
- `transaction_id` - Primary key
- `account_number` - Account number
- `transaction_type` - Type (DEPOSIT/WITHDRAWAL/INITIAL_DEPOSIT)
- `amount` - Transaction amount
- `balance_after` - Balance after transaction
- `transaction_date` - Transaction timestamp
- `description` - Transaction description

### OTP Requests Table
- `otp_id` - Primary key
- `email` - User email
- `otp_code` - OTP code
- `created_at` - Creation timestamp
- `expires_at` - Expiration timestamp
- `is_verified` - Verification status

## 🔐 Security Features

- **Password Hashing**: SHA-256 hashing for password storage
- **Session Management**: 30-minute session timeout
- **HTTPS Ready**: Support for SSL/TLS configuration
- **CSRF Protection**: Session-based tokens
- **Input Validation**: Client-side and server-side validation
- **SQL Injection Prevention**: Using PreparedStatements
- **XSS Prevention**: Output encoding

## 📄 API Endpoints / Servlets

| Servlet | URL | Method | Purpose |
|---------|-----|---------|---------|
| LoginServlet | `/login` | POST | User login |
| RegisterServlet | `/register` | POST | User registration |
| CreateAccountServlet | `/createAccount` | POST | Create new account |
| DepositServlet | `/deposit` | POST | Deposit money |
| WithdrawServlet | `/withdraw` | POST | Withdraw money |
| BalanceInquiryServlet | `/balanceInquiry` | POST | Check balance |
| TransactionHistoryServlet | `/transactionHistory` | GET/POST | View transactions |
| LogoutServlet | `/logout` | GET | Logout user |

## 🖼️ Pages

- **Login Page** - User authentication
- **Register Page** - New user registration
- **Dashboard** - Main dashboard with account overview
- **Create Account** - New account creation form
- **Deposit** - Deposit money to account
- **Withdraw** - Withdraw money from account
- **Balance Inquiry** - Check account balance
- **Transaction History** - View all transactions with pagination
- **Error Pages** - 404 and 500 error pages

## ⚙️ Configuration

### Database Connection
Edit `DBConnection.java`:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/gift_bank";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "";
```

### Session Timeout
Edit `web.xml`:
```xml
<timeout-in-minutes>30</timeout-in-minutes>
```

## 🐛 Troubleshooting

### Issue: "Cannot connect to database"
- Check MySQL is running
- Verify database credentials in DBConnection.java
- Ensure MySQL JDBC driver is in WEB-INF/lib/

### Issue: "404 Not Found"
- Check Tomcat is running
- Verify application is deployed in webapps
- Check application context path

### Issue: "Class not found: com.mysql.jdbc.Driver"
- Add MySQL JDBC driver to WEB-INF/lib/
- Rebuild project

### Issue: "Session not working"
- Clear browser cookies
- Check Tomcat session settings in web.xml
- Verify session is enabled in browser

## 📊 Testing the Application

### Test Transactions
1. Login with demo credentials
2. Create a new account with initial deposit (e.g., ₹1000)
3. Check balance inquiry
4. Deposit additional amount (e.g., ₹500)
5. Withdraw money (e.g., ₹200)
6. View transaction history
7. Verify balance is correct

### Test Validations
- Try invalid email format
- Try short password (< 6 characters)
- Try invalid phone number (not 10 digits)
- Try withdraw more than balance
- Try empty form submission

## 📚 Documentation

All source code includes detailed comments explaining functionality.

### Key Classes

**DBConnection.java** - Database connectivity utility
**User.java, Account.java, Transaction.java** - Model classes
**ValidationUtils.java** - Input validation utilities
**CommonUtils.java** - Utility functions for account numbers, OTP, etc.

## 🎨 UI/UX Features

- Responsive design (mobile, tablet, desktop)
- Blue and white banking theme
- Bootstrap 5 components
- Bootstrap Icons
- Card-based layouts
- Sidebar navigation
- Real-time form validation
- Success/Error alerts
- Transaction type icons
- Pagination support

## 📝 Footer Information

All pages display:
- **Bank Name**: GIFT Bank System
- **Guidance**: Rumana Hasinullah Shaikh
- **CEO**: Adarsh Kumar Gupta
- **Accountant**: Rudra Narayan Behera
- **Cashier**: Birupakshya Sahu

## 🔄 Future Enhancements

- Firebase Authentication integration
- Email OTP verification
- Money Transfer between accounts
- Bill Payment
- Statement Download (PDF)
- Mobile App
- Advanced Analytics
- Admin Dashboard
- Two-factor Authentication
- Biometric Login

## 📞 Support

For issues or questions, please refer to the database schema and source code comments.

## 📄 License

This project is created for educational purposes.

---

## 🏦 Bank Details (Demo)

**GIFT Bank System**
- A complete online banking platform
- Secure and easy-to-use interface
- Professional banking experience

**Professional Team:**
- Under the Guidance of: **Rumana Hasinullah Shaikh**
- CEO: **Adarsh Kumar Gupta**
- Accountant: **Rudra Narayan Behera**
- Cashier: **Birupakshya Sahu**

© 2026 GIFT Bank. All rights reserved.

---

**Happy Banking! 🏦**
