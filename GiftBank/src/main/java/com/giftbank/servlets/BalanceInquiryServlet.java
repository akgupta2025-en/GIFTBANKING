package com.giftbank.servlets;

import com.giftbank.database.DBConnection;
import com.giftbank.utils.ValidationUtils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/balanceInquiry")
public class BalanceInquiryServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }
        response.sendRedirect("jsp/balanceInquiry.jsp");
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

        // Validation
        if (!ValidationUtils.isNotEmpty(accountNumber)) {
            request.setAttribute("error", "Account number is required");
            request.getRequestDispatcher("jsp/balanceInquiry.jsp").forward(request, response);
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT holder_name, balance, account_status FROM accounts WHERE account_number = ? LIMIT 1";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, accountNumber);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String holderName = rs.getString("holder_name");
                String balance = rs.getString("balance");
                String status = rs.getString("account_status");

                request.setAttribute("accountNumber", accountNumber);
                request.setAttribute("holderName", holderName);
                request.setAttribute("balance", balance);
                request.setAttribute("status", status);
                request.setAttribute("success", "Balance inquiry successful");
            } else {
                request.setAttribute("error", "Account not found");
            }
            
            rs.close();
            pst.close();
            DBConnection.closeConnection(con);
            request.getRequestDispatcher("jsp/balanceInquiry.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("jsp/balanceInquiry.jsp").forward(request, response);
        }
    }
}
