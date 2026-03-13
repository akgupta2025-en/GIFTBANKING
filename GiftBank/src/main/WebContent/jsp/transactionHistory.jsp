<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.giftbank.database.Transaction" %>
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
    <title>GIFT Bank - Transaction History</title>
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
                    <a class="nav-link" href="balanceInquiry.jsp"><i class="bi bi-search"></i> Balance Inquiry</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="transactionHistory.jsp"><i class="bi bi-clock-history"></i> Transaction History</a>
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
                        <h1 class="h3 mb-2"><i class="bi bi-clock-history"></i> Transaction History</h1>
                        <p class="text-muted">View all your transactions</p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Search Transactions</h5>
                            </div>
                            <div class="card-body">
                                <% String error = (String) request.getAttribute("error");
                                   if (error != null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <%= error %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                                <form action="../transactionHistory" method="post">
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-9">
                                            <label for="accountNumber" class="form-label">Account Number</label>
                                            <input type="text" class="form-control" id="accountNumber" name="accountNumber" placeholder="GIFT1234567890" required>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="bi bi-search"></i> Search
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <% List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
                   if (transactions != null && !transactions.isEmpty()) { %>
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-dark text-white">
                                <h5 class="mb-0">Transaction Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Date & Time</th>
                                                <th>Transaction Type</th>
                                                <th>Amount</th>
                                                <th>Balance After</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Transaction trans : transactions) { 
                                                String typeClass = "DEPOSIT".equals(trans.getTransactionType()) || "INITIAL_DEPOSIT".equals(trans.getTransactionType()) ? "text-success" : "text-danger";
                                                String typeIcon = "DEPOSIT".equals(trans.getTransactionType()) || "INITIAL_DEPOSIT".equals(trans.getTransactionType()) ? "arrow-up" : "arrow-down";
                                            %>
                                            <tr>
                                                <td><%= trans.getTransactionDate() %></td>
                                                <td>
                                                    <i class="bi bi-<%= typeIcon %>-circle <%= typeClass %>"></i>
                                                    <span class="<%= typeClass %>"><strong><%= trans.getTransactionType() %></strong></span>
                                                </td>
                                                <td class="<%= typeClass %>"><strong>₹<%= String.format("%.2f", trans.getAmount()) %></strong></td>
                                                <td class="text-primary"><strong>₹<%= String.format("%.2f", trans.getBalanceAfter()) %></strong></td>
                                                <td><%= trans.getDescription() != null ? trans.getDescription() : "N/A" %></td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <% Integer currentPage = (Integer) request.getAttribute("currentPage");
                                   Integer totalPages = (Integer) request.getAttribute("totalPages");
                                   String accountNum = (String) request.getAttribute("accountNumber");
                                   if (totalPages != null && totalPages > 1) { %>
                                <nav aria-label="Page navigation" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <% if (currentPage > 1) { %>
                                        <li class="page-item">
                                            <a class="page-link" href="transactionHistory.jsp?accountNumber=<%= accountNum %>&page=<%= currentPage - 1 %>">Previous</a>
                                        </li>
                                        <% } %>

                                        <% for (int p = 1; p <= totalPages; p++) { 
                                            String activeClass = p == currentPage ? "active" : "";
                                        %>
                                        <li class="page-item <%= activeClass %>">
                                            <a class="page-link" href="transactionHistory.jsp?accountNumber=<%= accountNum %>&page=<%= p %>"><%= p %></a>
                                        </li>
                                        <% } %>

                                        <% if (currentPage < totalPages) { %>
                                        <li class="page-item">
                                            <a class="page-link" href="transactionHistory.jsp?accountNumber=<%= accountNum %>&page=<%= currentPage + 1 %>">Next</a>
                                        </li>
                                        <% } %>
                                    </ul>
                                </nav>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else if (request.getAttribute("accountNumber") != null) { %>
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No transactions found for this account.
                        </div>
                    </div>
                </div>
                <% } %>
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
