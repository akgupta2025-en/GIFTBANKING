# GIFT Bank - Quick Start Guide

## ⚡ 5-Minute Quick Start

### 1. Database Setup (2 minutes)

```bash
# Open MySQL Command Line
mysql -u root -p

# Run the schema script
SOURCE C:\path\to\GiftBank\database_schema.sql;

# Or copy-paste the entire SQL file content and execute
```

### 2. Configure Database Connection (1 minute)

Edit this file:
```
src/main/java/com/giftbank/database/DBConnection.java
```

Update these 3 lines:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/gift_bank";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "your_password";
```

### 3. Add MySQL Driver (1 minute)

1. Download: [MySQL Connector/J 8.0](https://dev.mysql.com/downloads/connector/j/)
2. Extract and copy: `mysql-connector-java-8.0.xx.jar`
3. Paste to: `src/main/WebContent/WEB-INF/lib/`

### 4. Deploy to Tomcat (1 minute)

**Using IDE (Eclipse/IntelliJ):**
- Configure Tomcat server
- Right-click project → Run on Server

**Manual:**
- Copy GiftBank folder → `TOMCAT_HOME/webapps/`
- Restart Tomcat

## 🎯 Access Application

```
URL: http://localhost:8080/GiftBank/
```

## 👤 Demo Login

```
Email: admin@giftbank.com
Password: admin123
```

## 🎬 Try These Features

### 1. Create an Account
- Go to Dashboard → Create Account
- Fill form: Name, Phone, Address, Initial Deposit (e.g., 1000)
- Note the generated Account Number

### 2. Deposit Money
- Go to Deposit
- Enter account number and amount (e.g., 500)
- Check balance increased

### 3. Withdraw Money
- Go to Withdraw
- Enter account number and amount (e.g., 200)
- Verify balance decreased

### 4. View Transactions
- Go to Transaction History
- Enter account number
- See all deposits and withdrawals

## 📁 Important Files

| File | Purpose |
|------|---------|
| `database_schema.sql` | Create all database tables |
| `DBConnection.java` | Configure database |
| `web.xml` | Tomcat configuration |
| `style.css` | All styling |
| `validation.js` | Form validation |

## ✅ Checklist Before Going Live

- [ ] Database created and running
- [ ] Database credentials configured
- [ ] MySQL JDBC driver added to WEB-INF/lib/
- [ ] Tomcat server running
- [ ] Can login with admin credentials
- [ ] Can create account
- [ ] Can deposit money
- [ ] Can withdraw money
- [ ] Can see transaction history
- [ ] Responsive design works on mobile

## 🔧 Troubleshooting

**Problem: Cannot connect to database**
```
Solution: Check MySQL is running and credentials are correct in DBConnection.java
```

**Problem: 404 error when accessing**
```
Solution: Check Tomcat is running and app is in webapps folder
```

**Problem: MySQL driver not found**
```
Solution: Add mysql-connector-java-8.0.x.jar to WEB-INF/lib/
```

**Problem: Servlet not found**
```
Solution: Rebuild project and restart Tomcat
```

## 📊 Project Contains

- **12** Java classes (Servlets + Models)
- **11** JSP pages
- **1** Complete CSS file (500+ lines)
- **1** JavaScript validation file
- **1** SQL database schema
- **1** Tomcat configuration file

## 🚀 Advanced Features

Once basic setup is working, try:

1. **Register new user**: Go to Register page
2. **Multiple accounts**: Create several accounts per user
3. **Large transactions**: Test with varied amounts
4. **Transaction history**: View with pagination
5. **Logout**: Test session management

## 📖 Documentation

- **README.md** - Detailed setup and features
- **PROJECT_SUMMARY.md** - Complete project overview
- **database_schema.sql** - Database structure
- **Inline code comments** - Throughout Java classes

## 🎓 Learning Points

This application teaches:
- Java Servlet development
- JSP programming
- MySQL database design
- JDBC operations
- HTML/CSS/JavaScript
- Session management
- Form validation
- Error handling
- MVC pattern

## 💾 Backup Important Files

Before making changes, backup:
- `database_schema.sql`
- `DBConnection.java`
- All configuration files

## 📝 Notes

- Session timeout: 30 minutes
- Account numbers auto-generated (GIFT + 12 digits)
- Passwords hashed with SHA-256
- All transactions logged automatically
- Responsive design works on all devices

## ❓ Getting Help

If stuck, check:
1. Is MySQL running? (`mysql --version`)
2. Is Tomcat running? (Visit localhost:8080)
3. Are credentials correct in DBConnection.java?
4. Is mysql-connector-java JAR in WEB-INF/lib/?
5. Check Tomcat logs for detailed errors

## 🎉 You're Ready!

Your complete online banking system is ready. Enjoy!

---

**Questions? Refer to README.md for detailed documentation**

*GIFT Bank - Created with ❤️*
