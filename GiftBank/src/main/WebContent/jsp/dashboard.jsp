<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.giftbank.database.DBConnection" %>
<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIFT Bank - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3 class="brand-color"><i class="bi bi-bank"></i> GIFT Bank</h3>
            </div>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="createAccount.jsp"><i class="bi bi-plus-circle"></i> Create Account</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="deposit.jsp"><i class="bi bi-arrow-up-circle"></i> Deposit</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="withdraw.jsp"><i class="bi bi-arrow-down-circle"></i> Withdraw</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="balanceInquiry.jsp"><i class="bi bi-search"></i> Balance Inquiry</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="transactionHistory.jsp"><i class="bi bi-clock-history"></i> Transaction History</a>
                </li>
                <li class="nav-item border-top mt-3 pt-3">
                    <a class="nav-link text-danger" href="../logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Navigation -->
            <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
                <div class="container-fluid">
                    <span class="navbar-text">Welcome, <strong><%= email %></strong></span>
                    <% if ("admin".equals(role)) { %>
                    <span class="badge bg-danger ms-2">Admin</span>
                    <% } %>
                </div>
            </nav>

            <!-- Page Content -->
            <div class="container-fluid p-4">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h1 class="h3 mb-2"><i class="bi bi-speedometer2"></i> Dashboard</h1>
                        <p class="text-muted">Welcome to your banking dashboard</p>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card stats-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Accounts</p>
                                        <h3 class="brand-color">
                                            <%
                                                try {
                                                    Connection con = DBConnection.getConnection();
                                                    String query = "SELECT COUNT(*) as count FROM accounts WHERE user_id = ?";
                                                    PreparedStatement pst = con.prepareStatement(query);
                                                    pst.setInt(1, userId);
                                                    ResultSet rs = pst.executeQuery();
                                                    int count = 0;
                                                    if (rs.next()) {
                                                        count = rs.getInt("count");
                                                    }
                                            %>
                                            <%= count %>
                                            <%
                                                    rs.close();
                                                    pst.close();
                                                    DBConnection.closeConnection(con);
                                                } catch (Exception e) {
                                                    out.print("0");
                                                }
                                            %>
                                        </h3>
                                    </div>
                                    <div class="stat-icon">
                                        <i class="bi bi-wallet2"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card stats-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Total Balance</p>
                                        <h3 class="text-success">
                                            <%
                                                try {
                                                    Connection con = DBConnection.getConnection();
                                                    String query = "SELECT SUM(balance) as total FROM accounts WHERE user_id = ?";
                                                    PreparedStatement pst = con.prepareStatement(query);
                                                    pst.setInt(1, userId);
                                                    ResultSet rs = pst.executeQuery();
                                                    double total = 0;
                                                    if (rs.next()) {
                                                        total = rs.getDouble("total");
                                                    }
                                            %>
                                            ₹<%= String.format("%.2f", total) %>
                                            <%
                                                    rs.close();
                                                    pst.close();
                                                    DBConnection.closeConnection(con);
                                                } catch (Exception e) {
                                                    out.print("0.00");
                                                }
                                            %>
                                        </h3>
                                    </div>
                                    <div class="stat-icon">
                                        <i class="bi bi-cash-coin"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card stats-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <p class="text-muted mb-1">Recent Transactions</p>
                                        <h3 class="text-info">
                                            <%
                                                try {
                                                    Connection con = DBConnection.getConnection();
                                                    String query = "SELECT COUNT(*) as count FROM transactions WHERE account_number IN (SELECT account_number FROM accounts WHERE user_id = ?) AND transaction_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
                                                    PreparedStatement pst = con.prepareStatement(query);
                                                    pst.setInt(1, userId);
                                                    ResultSet rs = pst.executeQuery();
                                                    int count = 0;
                                                    if (rs.next()) {
                                                        count = rs.getInt("count");
                                                    }
                                            %>
                                            <%= count %>
                                            <%
                                                    rs.close();
                                                    pst.close();
                                                    DBConnection.closeConnection(con);
                                                } catch (Exception e) {
                                                    out.print("0");
                                                }
                                            %>
                                        </h3>
                                    </div>
                                    <div class="stat-icon">
                                        <i class="bi bi-graph-up"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h5 class="mb-3">Quick Actions</h5>
                        <div class="row g-3">
                            <div class="col-md-3">
                                <a href="createAccount.jsp" class="btn btn-primary btn-lg w-100">
                                    <i class="bi bi-plus-circle"></i> Create Account
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="deposit.jsp" class="btn btn-success btn-lg w-100">
                                    <i class="bi bi-arrow-up-circle"></i> Deposit
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="withdraw.jsp" class="btn btn-warning btn-lg w-100">
                                    <i class="bi bi-arrow-down-circle"></i> Withdraw
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="balanceInquiry.jsp" class="btn btn-info btn-lg w-100">
                                    <i class="bi bi-search"></i> Check Balance
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Accounts -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0"><i class="bi bi-list-check"></i> Your Accounts</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Account Number</th>
                                                <th>Account Holder</th>
                                                <th>Balance</th>
                                                <th>Status</th>
                                                <th>Created</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    Connection con = DBConnection.getConnection();
                                                    String query = "SELECT * FROM accounts WHERE user_id = ? ORDER BY created_at DESC";
                                                    PreparedStatement pst = con.prepareStatement(query);
                                                    pst.setInt(1, userId);
                                                    ResultSet rs = pst.executeQuery();
                                                    
                                                    while (rs.next()) {
                                            %>
                                            <tr>
                                                <td><code><%= rs.getString("account_number") %></code></td>
                                                <td><%= rs.getString("holder_name") %></td>
                                                <td class="text-success fw-bold">₹<%= String.format("%.2f", rs.getDouble("balance")) %></td>
                                                <td>
                                                    <% String status = rs.getString("account_status");
                                                       String badgeClass = "active".equals(status) ? "success" : "danger";
                                                    %>
                                                    <span class="badge bg-<%= badgeClass %>"><%= status.toUpperCase() %></span>
                                                </td>
                                                <td><%= rs.getTimestamp("created_at") %></td>
                                            </tr>
                                            <%
                                                    }
                                                    rs.close();
                                                    pst.close();
                                                    DBConnection.closeConnection(con);
                                                } catch (Exception e) {
                                                    out.print("<tr><td colspan='5' class='text-center text-danger'>Error loading accounts</td></tr>");
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer bg-dark text-white mt-5">
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-md-12 text-center">
                    <h5>GIFT Bank System</h5>
                    <p class="mb-2">Under the Guidance of: <strong>Rumana Hasinullah Shaikh</strong></p>
                    <p class="mb-2">CEO: <strong>Adarsh Kumar Gupta</strong> | Accountant: <strong>Rudra Narayan Behera</strong></p>
                    <p>Cashier: <strong>Birupakshya Sahu</strong></p>
                    <hr>
                    <p class="mb-0">&copy; 2026 GIFT Bank. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
