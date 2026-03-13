<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.giftbank.model.User" %>
<%@ page import="com.giftbank.model.Account" %>
<%@ page import="com.giftbank.dao.AccountDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    AccountDAO accountDAO = new AccountDAO();
    List<Account> accounts = accountDAO.getAccountsByUserId(user.getId());
    double totalBalance = accounts.stream().mapToDouble(acc -> acc.getBalance().doubleValue()).sum();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - GIFT Bank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3><i class="fas fa-university me-2"></i>GIFT Bank</h3>
            </div>
            <ul class="sidebar-menu">
                <li>
                    <a href="dashboard.jsp" class="active">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="createAccount.jsp">
                        <i class="fas fa-user-plus"></i> Create Account
                    </a>
                </li>
                <li>
                    <a href="deposit.jsp">
                        <i class="fas fa-plus-circle"></i> Deposit Money
                    </a>
                </li>
                <li>
                    <a href="withdraw.jsp">
                        <i class="fas fa-minus-circle"></i> Withdraw Money
                    </a>
                </li>
                <li>
                    <a href="balanceInquiry.jsp">
                        <i class="fas fa-balance-scale"></i> Balance Inquiry
                    </a>
                </li>
                <li>
                    <a href="transactionHistory.jsp">
                        <i class="fas fa-history"></i> Transaction History
                    </a>
                </li>
                <li>
                    <a href="../logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="top-header">
                <div>
                    <h4>Welcome, <%= user.getEmail() %></h4>
                    <p class="text-muted mb-0">Manage your accounts and transactions</p>
                </div>
                <div>
                    <span class="badge bg-success">
                        <i class="fas fa-circle me-1"></i> Online
                    </span>
                </div>
            </div>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    <%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-3 mb-3">
                    <div class="stat-card success">
                        <div class="stat-icon text-success">
                            <i class="fas fa-wallet"></i>
                        </div>
                        <div class="stat-value">$<%= String.format("%.2f", totalBalance) %></div>
                        <div class="stat-label">Total Balance</div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card info">
                        <div class="stat-icon text-info">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <div class="stat-value"><%= accounts.size() %></div>
                        <div class="stat-label">Total Accounts</div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card warning">
                        <div class="stat-icon text-warning">
                            <i class="fas fa-exchange-alt"></i>
                        </div>
                        <div class="stat-value">0</div>
                        <div class="stat-label">Today's Transactions</div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card danger">
                        <div class="stat-icon text-danger">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="stat-value">+0%</div>
                        <div class="stat-label">Monthly Growth</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="content-card">
                <h5 class="mb-4">Quick Actions</h5>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <a href="createAccount.jsp" class="btn btn-outline-primary w-100 h-100 d-flex flex-column align-items-center justify-content-center" style="min-height: 120px;">
                            <i class="fas fa-user-plus fa-2x mb-2"></i>
                            Create Account
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="deposit.jsp" class="btn btn-outline-success w-100 h-100 d-flex flex-column align-items-center justify-content-center" style="min-height: 120px;">
                            <i class="fas fa-plus-circle fa-2x mb-2"></i>
                            Deposit Money
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="withdraw.jsp" class="btn btn-outline-warning w-100 h-100 d-flex flex-column align-items-center justify-content-center" style="min-height: 120px;">
                            <i class="fas fa-minus-circle fa-2x mb-2"></i>
                            Withdraw Money
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="transactionHistory.jsp" class="btn btn-outline-info w-100 h-100 d-flex flex-column align-items-center justify-content-center" style="min-height: 120px;">
                            <i class="fas fa-history fa-2x mb-2"></i>
                            View History
                        </a>
                    </div>
                </div>
            </div>

            <!-- Recent Accounts -->
            <div class="content-card">
                <h5 class="mb-4">Your Accounts</h5>
                <% if (accounts.isEmpty()) { %>
                    <div class="text-center py-4">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">No accounts found. Create your first account to get started!</p>
                        <a href="createAccount.jsp" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Create Account
                        </a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Account Number</th>
                                    <th>Holder Name</th>
                                    <th>Phone</th>
                                    <th>Balance</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Account account : accounts) { %>
                                    <tr>
                                        <td><strong><%= account.getAccountNumber() %></strong></td>
                                        <td><%= account.getHolderName() %></td>
                                        <td><%= account.getPhone() %></td>
                                        <td class="text-success fw-bold">$<%= String.format("%.2f", account.getBalance()) %></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-info" onclick="viewAccountDetails('<%= account.getAccountNumber() %>')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-primary" onclick="depositToAccount('<%= account.getAccountNumber() %>')">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning" onclick="withdrawFromAccount('<%= account.getAccountNumber() %>')">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <footer class="footer">
        <div class="container">
            <h5>GIFT Bank System</h5>
            <p class="mb-2">Under the Guidance of: <strong>Rumana Hasinullah Shaikh</strong></p>
            <p class="mb-1">CEO: <strong>Adarsh Kumar Gupta</strong></p>
            <p class="mb-1">Accountant: <strong>Rudra Narayan Behera</strong></p>
            <p class="mb-0">Cashier: <strong>Birupakshya Sahu</strong></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/validation.js"></script>
    <script>
        function viewAccountDetails(accountNumber) {
            window.location.href = 'balanceInquiry.jsp?account=' + accountNumber;
        }
        
        function depositToAccount(accountNumber) {
            window.location.href = 'deposit.jsp?account=' + accountNumber;
        }
        
        function withdrawFromAccount(accountNumber) {
            window.location.href = 'withdraw.jsp?account=' + accountNumber;
        }
    </script>
</body>
</html>
