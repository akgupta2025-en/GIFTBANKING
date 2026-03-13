package com.giftbank.servlets;

import com.giftbank.database.DBConnection;
import com.giftbank.database.Transaction;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/transactionHistory")
public class TransactionHistoryServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }

        String accountNumber = request.getParameter("accountNumber");
        String page = request.getParameter("page");
        if (page == null || page.isEmpty()) {
            page = "1";
        }

        int pageNumber = Integer.parseInt(page);
        int pageSize = 10;
        int offset = (pageNumber - 1) * pageSize;

        try {
            Connection con = DBConnection.getConnection();

            // Get total count
            String countQuery = "SELECT COUNT(*) as total FROM transactions WHERE account_number = ?";
            PreparedStatement countPst = con.prepareStatement(countQuery);
            countPst.setString(1, accountNumber);
            ResultSet countRs = countPst.executeQuery();
            int totalRecords = 0;
            if (countRs.next()) {
                totalRecords = countRs.getInt("total");
            }

            // Get paginated transactions
            String query = "SELECT * FROM transactions WHERE account_number = ? ORDER BY transaction_date DESC LIMIT ? OFFSET ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, accountNumber);
            pst.setInt(2, pageSize);
            pst.setInt(3, offset);
            ResultSet rs = pst.executeQuery();

            List<Transaction> transactions = new ArrayList<>();
            while (rs.next()) {
                Transaction trans = new Transaction();
                trans.setTransactionId(rs.getInt("transaction_id"));
                trans.setAccountNumber(rs.getString("account_number"));
                trans.setTransactionType(rs.getString("transaction_type"));
                trans.setAmount(rs.getBigDecimal("amount"));
                trans.setBalanceAfter(rs.getBigDecimal("balance_after"));
                trans.setTransactionDate(rs.getTimestamp("transaction_date").toLocalDateTime());
                trans.setDescription(rs.getString("description"));
                transactions.add(trans);
            }

            request.setAttribute("transactions", transactions);
            request.setAttribute("accountNumber", accountNumber);
            request.setAttribute("currentPage", pageNumber);
            request.setAttribute("totalPages", (totalRecords + pageSize - 1) / pageSize);

            countRs.close();
            countPst.close();
            rs.close();
            pst.close();
            DBConnection.closeConnection(con);
            request.getRequestDispatcher("jsp/transactionHistory.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("jsp/transactionHistory.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
