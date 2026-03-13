package com.giftbank.dao;

import com.giftbank.model.Account;
import com.giftbank.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class AccountDAO {
    
    public String generateAccountNumber() {
        Random random = new Random();
        StringBuilder accountNumber = new StringBuilder("1000");
        for (int i = 0; i < 6; i++) {
            accountNumber.append(random.nextInt(10));
        }
        return accountNumber.toString();
    }
    
    public boolean createAccount(Account account) {
        String sql = "INSERT INTO accounts (account_number, holder_name, phone, address, balance, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, account.getAccountNumber());
            pstmt.setString(2, account.getHolderName());
            pstmt.setString(3, account.getPhone());
            pstmt.setString(4, account.getAddress());
            pstmt.setBigDecimal(5, account.getBalance());
            pstmt.setInt(6, account.getUserId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Account getAccountByNumber(String accountNumber) {
        String sql = "SELECT * FROM accounts WHERE account_number = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, accountNumber);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setAccountNumber(rs.getString("account_number"));
                account.setHolderName(rs.getString("holder_name"));
                account.setPhone(rs.getString("phone"));
                account.setAddress(rs.getString("address"));
                account.setBalance(rs.getBigDecimal("balance"));
                account.setUserId(rs.getInt("user_id"));
                return account;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public List<Account> getAccountsByUserId(int userId) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setAccountNumber(rs.getString("account_number"));
                account.setHolderName(rs.getString("holder_name"));
                account.setPhone(rs.getString("phone"));
                account.setAddress(rs.getString("address"));
                account.setBalance(rs.getBigDecimal("balance"));
                account.setUserId(rs.getInt("user_id"));
                accounts.add(account);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return accounts;
    }
    
    public boolean updateBalance(String accountNumber, BigDecimal newBalance) {
        String sql = "UPDATE accounts SET balance = ? WHERE account_number = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBigDecimal(1, newBalance);
            pstmt.setString(2, accountNumber);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Account> getAllAccounts() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM accounts ORDER BY account_id";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setAccountNumber(rs.getString("account_number"));
                account.setHolderName(rs.getString("holder_name"));
                account.setPhone(rs.getString("phone"));
                account.setAddress(rs.getString("address"));
                account.setBalance(rs.getBigDecimal("balance"));
                account.setUserId(rs.getInt("user_id"));
                accounts.add(account);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return accounts;
    }
}
