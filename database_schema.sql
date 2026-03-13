-- GIFT Bank Database Schema
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS gift_bank;
USE gift_bank;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('CUSTOMER', 'ADMIN') DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Accounts table
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    holder_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL,
    type ENUM('DEPOSIT', 'WITHDRAWAL', 'TRANSFER') NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    balance_after DECIMAL(15,2) NOT NULL,
    description TEXT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_number) REFERENCES accounts(account_number) ON DELETE CASCADE
);

-- Insert sample admin user (password: admin123)
INSERT INTO users (email, password, role) VALUES 
('admin@giftbank.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN')
ON DUPLICATE KEY UPDATE email = email;

-- Insert sample customer user (password: customer123)
INSERT INTO users (email, password, role) VALUES 
('customer@giftbank.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'CUSTOMER')
ON DUPLICATE KEY UPDATE email = email;

-- Insert sample account
INSERT INTO accounts (account_number, holder_name, phone, address, balance, user_id) VALUES 
('1000000001', 'John Doe', '+1234567890', '123 Main St, City, State', 5000.00, 2)
ON DUPLICATE KEY UPDATE account_number = account_number;

-- Insert sample transactions
INSERT INTO transactions (account_number, type, amount, balance_after, description) VALUES 
('1000000001', 'DEPOSIT', 5000.00, 5000.00, 'Initial deposit')
ON DUPLICATE KEY UPDATE transaction_id = transaction_id;
