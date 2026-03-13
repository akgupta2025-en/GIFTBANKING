-- Create GIFT Bank Database
CREATE DATABASE IF NOT EXISTS gift_bank;
USE gift_bank;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Accounts Table
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    holder_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL,
    balance DECIMAL(12, 2) DEFAULT 0.00,
    account_status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(20) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    balance_after DECIMAL(12, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    trans_status VARCHAR(50) DEFAULT 'completed',
    FOREIGN KEY (account_number) REFERENCES accounts(account_number)
);

-- OTP Table (for OTP verification)
CREATE TABLE IF NOT EXISTS otp_requests (
    otp_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    is_verified BOOLEAN DEFAULT FALSE
);

-- Create Index for faster queries
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_account_number ON accounts(account_number);
CREATE INDEX idx_account_user ON accounts(user_id);
CREATE INDEX idx_transaction_account ON transactions(account_number);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);

-- Sample admin user (password: admin123 - hashed value)
INSERT INTO users (email, password, role) VALUES 
('admin@giftbank.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36gZvWFm', 'admin');

-- Display confirmation
SHOW TABLES;
SHOW DATABASES;
