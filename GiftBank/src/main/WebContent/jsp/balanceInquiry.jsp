<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIFT Bank - Balance Inquiry</title>
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
                    <a class="nav-link" href="dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
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
                    <a class="nav-link active" href="balanceInquiry.jsp"><i class="bi bi-search"></i> Balance Inquiry</a>
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
                </div>
            </nav>

            <!-- Page Content -->
            <div class="container-fluid p-4">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h1 class="h3 mb-2"><i class="bi bi-search"></i> Balance Inquiry</h1>
                        <p class="text-muted">Check your account balance</p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0">Account Search</h5>
                            </div>
                            <div class="card-body">
                                <% String error = (String) request.getAttribute("error");
                                   if (error != null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <%= error %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                                <% String success = (String) request.getAttribute("success");
                                   if (success != null) { %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <%= success %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                                <form action="../balanceInquiry" method="post">
                                    <div class="mb-3">
                                        <label for="accountNumber" class="form-label">Account Number</label>
                                        <input type="text" class="form-control" id="accountNumber" name="accountNumber" placeholder="GIFT1234567890" required>
                                        <small class="text-muted">Enter your account number</small>
                                    </div>

                                    <button type="submit" class="btn btn-info btn-lg w-100">
                                        <i class="bi bi-search"></i> Search Account
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <% String accountNumber = (String) request.getAttribute("accountNumber");
                           if (accountNumber != null) { %>
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0"><i class="bi bi-check-circle"></i> Account Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-sm-4">
                                        <strong>Account Number:</strong>
                                    </div>
                                    <div class="col-sm-8">
                                        <code><%= accountNumber %></code>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-sm-4">
                                        <strong>Account Holder:</strong>
                                    </div>
                                    <div class="col-sm-8">
                                        <%= request.getAttribute("holderName") %>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-sm-4">
                                        <strong>Current Balance:</strong>
                                    </div>
                                    <div class="col-sm-8">
                                        <h4 class="text-success">₹<%= request.getAttribute("balance") %></h4>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-sm-4">
                                        <strong>Status:</strong>
                                    </div>
                                    <div class="col-sm-8">
                                        <% String status = (String) request.getAttribute("status");
                                           String badgeClass = "active".equals(status) ? "success" : "danger";
                                        %>
                                        <span class="badge bg-<%= badgeClass %>"><%= status.toUpperCase() %></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="card bg-light">
                            <div class="card-body text-center">
                                <i class="bi bi-info-circle text-muted" style="font-size: 2rem;"></i>
                                <p class="text-muted mt-3">Enter an account number to view balance details</p>
                            </div>
                        </div>
                        <% } %>
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
