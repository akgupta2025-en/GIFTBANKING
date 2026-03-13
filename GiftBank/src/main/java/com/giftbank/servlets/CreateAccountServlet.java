package com.giftbank.servlets;

import com.giftbank.database.DBConnection;
import com.giftbank.utils.ValidationUtils;
import com.giftbank.utils.CommonUtils;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/createAccount")
public class CreateAccountServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }
        response.sendRedirect("jsp/createAccount.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String holderName = request.getParameter("holderName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String initialDeposit = request.getParameter("initialDeposit");

        // Validation
        if (!ValidationUtils.isNotEmpty(holderName)) {
            request.setAttribute("error", "Account holder name is required");
            request.getRequestDispatcher("jsp/createAccount.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtils.isValidPhone(phone)) {
            request.setAttribute("error", "Phone number must be 10 digits");
            request.getRequestDispatcher("jsp/createAccount.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtils.isNotEmpty(address)) {
            request.setAttribute("error", "Address is required");
            request.getRequestDispatcher("jsp/createAccount.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtils.isValidAmount(initialDeposit)) {
            request.setAttribute("error", "Initial deposit must be greater than 0");
            request.getRequestDispatcher("jsp/createAccount.jsp").forward(request, response);
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            String accountNumber = CommonUtils.generateAccountNumber();
            BigDecimal balance = new BigDecimal(initialDeposit);

            String query = "INSERT INTO accounts (user_id, account_number, holder_name, phone, address, balance) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, userId);
            pst.setString(2, accountNumber);
            pst.setString(3, holderName);
            pst.setString(4, phone);
            pst.setString(5, address);
            pst.setBigDecimal(6, balance);

            int result = pst.executeUpdate();
            if (result > 0) {
                // Log transaction
                String transQuery = "INSERT INTO transactions (account_number, transaction_type, amount, balance_after, description) " +
                                  "VALUES (?, ?, ?, ?, ?)";
                PreparedStatement transPst = con.prepareStatement(transQuery);
                transPst.setString(1, accountNumber);
                transPst.setString(2, "INITIAL_DEPOSIT");
                transPst.setBigDecimal(3, balance);
                transPst.setBigDecimal(4, balance);
                transPst.setString(5, "Account opening deposit");
                transPst.executeUpdate();
                transPst.close();

                request.setAttribute("success", "Account created successfully! Account No: " + accountNumber);
                request.setAttribute("accountNumber", accountNumber);
            } else {
                request.setAttribute("error", "Failed to create account");
            }
            
            pst.close();
            DBConnection.closeConnection(con);
            request.getRequestDispatcher("jsp/createAccount.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("jsp/createAccount.jsp").forward(request, response);
        }
    }
}
