package com.giftbank.servlets;

import com.giftbank.database.DBConnection;
import com.giftbank.utils.ValidationUtils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("jsp/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (!ValidationUtils.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format");
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtils.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 6 characters");
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            String query = "INSERT INTO users (email, password, role) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, ValidationUtils.hashPassword(password));
            pst.setString(3, "customer");
            
            int result = pst.executeUpdate();
            if (result > 0) {
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed");
                request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            }
            
            pst.close();
            DBConnection.closeConnection(con);
        } catch (Exception e) {
            e.printStackTrace();
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Email already registered");
            } else {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
        }
    }
}
