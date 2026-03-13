# GIFT Banking System

A complete dynamic online banking system built with Java Servlets, JSP, and MySQL database.

## 🏦 Project Overview

GIFT Bank is a comprehensive web-based banking application that provides secure online banking services with modern UI/UX design. The system includes account management, transaction processing, and complete banking operations.

## 🛠️ Technology Stack

### Backend
- **Java 11** - Core programming language
- **Java Servlets** - Web framework for handling HTTP requests
- **JSP (JavaServer Pages)** - View layer for dynamic content
- **MySQL** - Database for data persistence
- **Maven** - Build and dependency management

### Frontend
- **HTML5** - Markup language
- **CSS3** - Styling with custom design
- **Bootstrap 5** - Responsive UI framework
- **JavaScript** - Client-side validation and interactions
- **Font Awesome** - Icon library

### Server
- **Apache Tomcat** - Web server for deployment

## 📁 Project Structure

```
gift-banking-system/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/giftbank/
│       │       ├── model/          # Data models (User, Account, Transaction)
│       │       ├── dao/            # Data Access Objects
│       │       ├── servlet/        # HTTP request handlers
│       │       └── util/           # Utility classes
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml        # Deployment descriptor
│           ├── css/
│           │   └── style.css      # Custom styling
│           ├── js/
│           │   └── validation.js   # Client-side validation
│           ├── pages/              # JSP pages
│           │   ├── dashboard.jsp
│           │   ├── createAccount.jsp
│           │   ├── deposit.jsp
│           │   ├── withdraw.jsp
│           │   ├── balanceInquiry.jsp
│           │   └── transactionHistory.jsp
│           └── index.jsp           # Login page
├── database_schema.sql             # MySQL database schema
├── pom.xml                         # Maven configuration
└── README.md                       # This file
```

## 🚀 Features

### 🔐 Authentication & Security
- User login with email and password
- OTP (One Time Password) verification
- Session-based authentication
- Password hashing with BCrypt
- Secure session handling

### 👤 Account Management
- Create new bank accounts
- Auto-generated account numbers
- Account holder information management
- Multiple accounts per user

### 💰 Transaction Operations
- **Deposit Money**: Add funds to accounts
- **Withdraw Money**: Remove funds with balance validation
- **Balance Inquiry**: Check account details and balance
- **Transaction History**: View all transactions with pagination

### 📊 Dashboard Features
- Account summary with total balance
- Quick action buttons
- Recent account overview
- Transaction statistics

### 🎨 UI/UX Design
- Professional banking interface
- Blue and white banking theme
- Responsive design for mobile devices
- Modern cards and tables
- Left sidebar navigation
- Clean and intuitive dashboard

## 📋 Database Schema

### Tables
1. **users** - User authentication and roles
2. **accounts** - Bank account information
3. **transactions** - Transaction records

### Sample Data
- Admin user: `admin@giftbank.com` / `admin123`
- Customer user: `customer@giftbank.com` / `customer123`
- Sample account: `1000000001` with $5,000 balance

## 🛠️ Setup Instructions

### Prerequisites
- Java 11 or higher
- Apache Tomcat 9.0 or higher
- MySQL 8.0 or higher
- Maven 3.6 or higher

### Database Setup
1. Install MySQL and create database:
   ```sql
   CREATE DATABASE gift_bank;
   ```

2. Import the database schema:
   ```bash
   mysql -u root -p gift_bank < database_schema.sql
   ```

### Application Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/akgupta2025-en/GIFTBANKING.git
   cd GIFTBANKING
   ```

2. Build the project:
   ```bash
   mvn clean install
   ```

3. Deploy to Tomcat:
   - Copy `target/gift-banking-system.war` to Tomcat's `webapps` directory
   - Or deploy using your IDE's Tomcat integration

4. Configure database connection:
   - Update `DatabaseUtil.java` with your MySQL credentials
   - Default: `localhost:3306/gift_bank` with `root` user and empty password

### Running the Application
1. Start Apache Tomcat server
2. Access the application at: `http://localhost:8080/gift-banking-system/`

## 📱 Usage Guide

### Login
1. Visit the application URL
2. Enter email and password
3. Generate and enter OTP (demo: click "Send OTP" button)
4. Click "Login to Account"

### Creating an Account
1. Navigate to "Create Account" from dashboard
2. Fill in account holder details
3. Enter initial deposit (minimum $100)
4. Submit to create account

### Making Transactions
1. **Deposit**: Select account, enter amount, confirm
2. **Withdraw**: Select account, enter amount (must have sufficient balance)
3. **Balance Check**: View account details and current balance

### Viewing History
1. Go to "Transaction History"
2. Filter by specific account or view all
3. Search transactions using the search box
4. Navigate through pages using pagination

## 🔧 Configuration

### Database Connection
Update `src/main/java/com/giftbank/util/DatabaseUtil.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/gift_bank";
private static final String USERNAME = "your_username";
private static final String PASSWORD = "your_password";
```

### Server Configuration
Update `pom.xml` for Tomcat plugin:
```xml
<configuration>
    <port>8080</port>
    <path>/gift-banking-system</path>
</configuration>
```

## 🎯 Team Information

**GIFT Bank System**

Under the Guidance of: **Rumana Hasinullah Shaikh**

- **CEO**: Adarsh Kumar Gupta
- **Accountant**: Rudra Narayan Behera
- **Cashier**: Birupakshya Sahu

## 📝 License

This project is for educational purposes. Please use responsibly and comply with banking regulations and security standards.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For any issues or questions, please create an issue in the GitHub repository.

---

**Note**: This is a demo application for educational purposes. Do not use with real financial data without proper security audits and compliance checks.
