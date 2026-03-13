package com.giftbank.utils;

import java.security.MessageDigest;
import java.util.regex.Pattern;

public class ValidationUtils {
    
    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return Pattern.matches(emailRegex, email);
    }

    /**
     * Validate password strength (minimum 6 characters)
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    /**
     * Validate phone number (10 digits)
     */
    public static boolean isValidPhone(String phone) {
        String phoneRegex = "^[0-9]{10}$";
        return phone != null && Pattern.matches(phoneRegex, phone);
    }

    /**
     * Validate amount (positive number)
     */
    public static boolean isValidAmount(String amount) {
        try {
            double value = Double.parseDouble(amount);
            return value > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Check if string is not empty
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    /**
     * Hash password using SHA-256
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
