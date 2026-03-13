package com.giftbank.servlets;

import com.giftbank.database.DBConnection;
import com.giftbank.utils.ValidationUtils;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/withdraw")
public class WithdrawServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }
        response.sendRedirect("jsp/withdraw.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }

        String accountNumber = request.getParameter("accountNumber");
        String amount = request.getParameter("amount");

        // Validation
        if (!ValidationUtils.isNotEmpty(accountNumber)) {
            request.setAttribute("error", "Account number is required");
            request.getRequestDispatcher("jsp/withdraw.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtils.isValidAmount(amount)) {
            request.setAttribute("error", "Amount must be greater than 0");
            request.getRequestDispatcher("jsp/withdraw.jsp").forward(request, response);
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            // Check account exists and get current balance
            String selectQuery = "SELECT balance FROM accounts WHERE account_number = ? FOR UPDATE";
            PreparedStatement selectPst = con.prepareStatement(selectQuery);
            selectPst.setString(1, accountNumber);
            ResultSet rs = selectPst.executeQuery();

            if (!rs.next()) {
                con.rollback();
                request.setAttribute("error", "Account not found");
                request.getRequestDispatcher("jsp/withdraw.jsp").forward(request, response);
                return;
            }

            BigDecimal currentBalance = rs.getBigDecimal("balance");
            BigDecimal withdrawAmount = new BigDecimal(amount);

            // Check sufficient balance
            if (currentBalance.compareTo(withdrawAmount) < 0) {
                con.rollback();
                request.setAttribute("error", "Insufficient balance! Current balance: " + currentBalance);
                request.getRequestDispatcher("jsp/withdraw.jsp").forward(request, response);
                return;
            }

            BigDecimal newBalance = currentBalance.subtract(withdrawAmount);

            // Update balance
            String updateQuery = "UPDATE accounts SET balance = ? WHERE account_number = ?";
            PreparedStatement updatePst = con.prepareStatement(updateQuery);
            updatePst.setBigDecimal(1, newBalance);
            updatePst.setString(2, accountNumber);
            updatePst.executeUpdate();

            // Log transaction
            String transQuery = "INSERT INTO transactions (account_number, transaction_type, amount, balance_after, description) " +
                              "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement transPst = con.prepareStatement(transQuery);
            transPst.setString(1, accountNumber);
            transPst.setString(2, "WITHDRAWAL");
            transPst.setBigDecimal(3, withdrawAmount);
            transPst.setBigDecimal(4, newBalance);
            transPst.setString(5, "Cash withdrawal - Amount: " + amount);
            transPst.executeUpdate();

            con.commit();
            con.setAutoCommit(true);

            request.setAttribute("success", "Amount withdrawn successfully! New Balance: " + newBalance);
            request.setAttribute("withdrawAmount", amount);
            request.setAttribute("newBalance", newBalance);

            selectPst.close();
            updatePst.close();
            transPst.close();
            DBConnection.closeConnection(con);
            request.getRequestDispatcher("jsp/withdraw.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Withdrawal failed: " + e.getMessage());
            request.getRequestDispatcher("jsp/withdraw.jsp").forward(request, response);
        }
    }
}
