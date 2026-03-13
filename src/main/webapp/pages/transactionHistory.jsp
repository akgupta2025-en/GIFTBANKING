<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.giftbank.model.User" %>
<%@ page import="com.giftbank.dao.AccountDAO" %>
<%@ page import="com.giftbank.dao.TransactionDAO" %>
<%@ page import="com.giftbank.model.Account" %>
<%@ page import="com.giftbank.model.Transaction" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    AccountDAO accountDAO = new AccountDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    List<Account> accounts = accountDAO.getAccountsByUserId(user.getId());
    
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int totalTransactions = (Integer) request.getAttribute("totalTransactions");
    String selectedAccount = (String) request.getAttribute("selectedAccount");
    
    String preselectedAccount = request.getParameter("account");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History - GIFT Bank</title>
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
                    <a href="dashboard.jsp">
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
                    <a href="transactionHistory.jsp" class="active">
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
                    <h4>Transaction History</h4>
                    <p class="text-muted mb-0">View your account transactions</p>
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

            <div class="content-card">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <form action="transactionHistory" method="get" class="d-flex">
                            <select class="form-select me-2" name="account">
                                <option value="">All Accounts</option>
                                <% for (Account account : accounts) { %>
                                    <option value="<%= account.getAccountNumber() %>" 
                                            <%= (preselectedAccount != null && preselectedAccount.equals(account.getAccountNumber())) ? "selected" : "" %>>
                                        <%= account.getAccountNumber() %> - <%= account.getHolderName() %>
                                    </option>
                                <% } %>
                            </select>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter me-1"></i>Filter
                            </button>
                        </form>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" id="searchInput" placeholder="Search transactions...">
                        </div>
                    </div>
                </div>

                <% if (transactions != null && !transactions.isEmpty()) { %>
                    <div class="mb-3">
                        <small class="text-muted">
                            Showing <%= transactions.size() %> of <%= totalTransactions %> transactions
                            <% if (selectedAccount != null) { %>
                                for account <%= selectedAccount %>
                            <% } %>
                        </small>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover" id="transactionTable">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Account Number</th>
                                    <th>Type</th>
                                    <th>Amount</th>
                                    <th>Balance After</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Transaction transaction : transactions) { %>
                                    <tr>
                                        <td>
                                            <%= transaction.getDate() != null ? 
                                               new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(transaction.getDate()) : "N/A" %>
                                        </td>
                                        <td><strong><%= transaction.getAccountNumber() %></strong></td>
                                        <td>
                                            <% if ("DEPOSIT".equals(transaction.getType())) { %>
                                                <span class="badge bg-success">
                                                    <i class="fas fa-plus-circle me-1"></i>Deposit
                                                </span>
                                            <% } else if ("WITHDRAWAL".equals(transaction.getType())) { %>
                                                <span class="badge bg-warning">
                                                    <i class="fas fa-minus-circle me-1"></i>Withdrawal
                                                </span>
                                            <% } else { %>
                                                <span class="badge bg-info">
                                                    <i class="fas fa-exchange-alt me-1"></i>Transfer
                                                </span>
                                            <% } %>
                                        </td>
                                        <td class="fw-bold">
                                            <% if ("DEPOSIT".equals(transaction.getType())) { %>
                                                <span class="text-success">+$<%= String.format("%.2f", transaction.getAmount()) %></span>
                                            <% } else { %>
                                                <span class="text-danger">-$<%= String.format("%.2f", transaction.getAmount()) %></span>
                                            <% } %>
                                        </td>
                                        <td>$<%= String.format("%.2f", transaction.getBalanceAfter()) %></td>
                                        <td>
                                            <%= transaction.getDescription() != null ? transaction.getDescription() : "-" %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <% if (totalPages > 1) { %>
                        <nav aria-label="Transaction pagination">
                            <ul class="pagination justify-content-center" id="pagination">
                                <% if (currentPage > 1) { %>
                                    <li class="page-item">
                                        <a class="page-link" href="?page=<%= currentPage - 1 %>&account=<%= selectedAccount != null ? selectedAccount : "" %>">
                                            Previous
                                        </a>
                                    </li>
                                <% } %>
                                
                                <% for (int i = 1; i <= totalPages; i++) { %>
                                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                        <a class="page-link" href="?page=<%= i %>&account=<%= selectedAccount != null ? selectedAccount : "" %>">
                                            <%= i %>
                                        </a>
                                    </li>
                                <% } %>
                                
                                <% if (currentPage < totalPages) { %>
                                    <li class="page-item">
                                        <a class="page-link" href="?page=<%= currentPage + 1 %>&account=<%= selectedAccount != null ? selectedAccount : "" %>">
                                            Next
                                        </a>
                                    </li>
                                <% } %>
                            </ul>
                        </nav>
                    <% } %>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No transactions found</h5>
                        <p class="text-muted">
                            <% if (selectedAccount != null) { %>
                                No transactions found for account <%= selectedAccount %>.
                            <% } else { %>
                                You don't have any transactions yet. Make a deposit or withdrawal to see your transaction history.
                            <% } %>
                        </p>
                        <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                            <a href="deposit.jsp" class="btn btn-success">
                                <i class="fas fa-plus-circle me-2"></i>Make a Deposit
                            </a>
                            <a href="withdraw.jsp" class="btn btn-warning">
                                <i class="fas fa-minus-circle me-2"></i>Make a Withdrawal
                            </a>
                        </div>
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
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            searchTransactions();
        });
        
        function searchTransactions() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('#transactionTable tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        }
        
        // Export functionality
        function exportTransactions() {
            const table = document.getElementById('transactionTable');
            let csv = [];
            
            // Get headers
            const headers = [];
            table.querySelectorAll('thead th').forEach(th => {
                headers.push(th.textContent.trim());
            });
            csv.push(headers.join(','));
            
            // Get rows
            table.querySelectorAll('tbody tr').forEach(tr => {
                const row = [];
                tr.querySelectorAll('td').forEach(td => {
                    row.push(td.textContent.trim());
                });
                csv.push(row.join(','));
            });
            
            // Create download link
            const csvContent = csv.join('\n');
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'transactions.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        }
    </script>
</body>
</html>
