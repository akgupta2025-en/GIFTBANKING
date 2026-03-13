package com.giftbank.utils;

import java.util.Random;

public class CommonUtils {
    
    /**
     * Generate unique account number (format: GIFT + 12 digits)
     */
    public static String generateAccountNumber() {
        Random random = new Random();
        long accountNum = 100000000000L + random.nextLong() % 900000000000L;
        return "GIFT" + accountNum;
    }

    /**
     * Generate OTP (6 digits)
     */
    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    /**
     * Generate transaction reference number
     */
    public static String generateTransactionRef() {
        Random random = new Random();
        long ref = 10000000 + random.nextLong() % 90000000;
        return "TXN" + ref;
    }

    /**
     * Format currency to 2 decimal places
     */
    public static String formatCurrency(double amount) {
        return String.format("%.2f", amount);
    }

    /**
     * Format phone number for display
     */
    public static String formatPhone(String phone) {
        if (phone != null && phone.length() == 10) {
            return phone.substring(0, 3) + "-" + phone.substring(3, 6) + "-" + phone.substring(6);
        }
        return phone;
    }
}
