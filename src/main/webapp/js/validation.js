// GIFT Bank JavaScript Validation

// Form Validation Functions
function validateLoginForm() {
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();
    const otp = document.getElementById('otp').value.trim();
    
    let isValid = true;
    
    // Email validation
    if (email === '') {
        showError('emailError', 'Email is required');
        isValid = false;
    } else if (!isValidEmail(email)) {
        showError('emailError', 'Please enter a valid email address');
        isValid = false;
    } else {
        hideError('emailError');
    }
    
    // Password validation
    if (password === '') {
        showError('passwordError', 'Password is required');
        isValid = false;
    } else if (password.length < 6) {
        showError('passwordError', 'Password must be at least 6 characters');
        isValid = false;
    } else {
        hideError('passwordError');
    }
    
    // OTP validation
    if (otp === '') {
        showError('otpError', 'OTP is required');
        isValid = false;
    } else if (otp.length !== 6) {
        showError('otpError', 'OTP must be 6 digits');
        isValid = false;
    } else {
        hideError('otpError');
    }
    
    return isValid;
}

function validateAccountForm() {
    const holderName = document.getElementById('holderName').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const address = document.getElementById('address').value.trim();
    const initialDeposit = document.getElementById('initialDeposit').value.trim();
    
    let isValid = true;
    
    // Name validation
    if (holderName === '') {
        showError('holderNameError', 'Account holder name is required');
        isValid = false;
    } else if (holderName.length < 3) {
        showError('holderNameError', 'Name must be at least 3 characters');
        isValid = false;
    } else {
        hideError('holderNameError');
    }
    
    // Phone validation
    if (phone === '') {
        showError('phoneError', 'Phone number is required');
        isValid = false;
    } else if (!isValidPhone(phone)) {
        showError('phoneError', 'Please enter a valid phone number');
        isValid = false;
    } else {
        hideError('phoneError');
    }
    
    // Address validation
    if (address === '') {
        showError('addressError', 'Address is required');
        isValid = false;
    } else if (address.length < 10) {
        showError('addressError', 'Please enter a complete address');
        isValid = false;
    } else {
        hideError('addressError');
    }
    
    // Initial deposit validation
    if (initialDeposit === '') {
        showError('initialDepositError', 'Initial deposit is required');
        isValid = false;
    } else if (parseFloat(initialDeposit) < 0) {
        showError('initialDepositError', 'Initial deposit cannot be negative');
        isValid = false;
    } else if (parseFloat(initialDeposit) < 100) {
        showError('initialDepositError', 'Minimum initial deposit is $100');
        isValid = false;
    } else {
        hideError('initialDepositError');
    }
    
    return isValid;
}

function validateTransactionForm() {
    const accountNumber = document.getElementById('accountNumber').value.trim();
    const amount = document.getElementById('amount').value.trim();
    
    let isValid = true;
    
    // Account number validation
    if (accountNumber === '') {
        showError('accountNumberError', 'Account number is required');
        isValid = false;
    } else if (!isValidAccountNumber(accountNumber)) {
        showError('accountNumberError', 'Please enter a valid 10-digit account number');
        isValid = false;
    } else {
        hideError('accountNumberError');
    }
    
    // Amount validation
    if (amount === '') {
        showError('amountError', 'Amount is required');
        isValid = false;
    } else if (parseFloat(amount) <= 0) {
        showError('amountError', 'Amount must be greater than 0');
        isValid = false;
    } else if (parseFloat(amount) > 100000) {
        showError('amountError', 'Maximum transaction amount is $100,000');
        isValid = false;
    } else {
        hideError('amountError');
    }
    
    return isValid;
}

function validateBalanceInquiryForm() {
    const accountNumber = document.getElementById('accountNumber').value.trim();
    
    if (accountNumber === '') {
        showError('accountNumberError', 'Account number is required');
        return false;
    } else if (!isValidAccountNumber(accountNumber)) {
        showError('accountNumberError', 'Please enter a valid 10-digit account number');
        return false;
    } else {
        hideError('accountNumberError');
        return true;
    }
}

// Utility Functions
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function isValidPhone(phone) {
    const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
    return phoneRegex.test(phone);
}

function isValidAccountNumber(accountNumber) {
    const accountRegex = /^\d{10}$/;
    return accountRegex.test(accountNumber);
}

function showError(elementId, message) {
    const errorElement = document.getElementById(elementId);
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }
}

function hideError(elementId) {
    const errorElement = document.getElementById(elementId);
    if (errorElement) {
        errorElement.style.display = 'none';
    }
}

function showSuccess(message) {
    showNotification(message, 'success');
}

function showError(message) {
    showNotification(message, 'danger');
}

function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show`;
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const container = document.querySelector('.content-card') || document.body;
    container.insertBefore(notification, container.firstChild);
    
    // Auto dismiss after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 5000);
}

// OTP Generation and Validation
function generateOTP() {
    return Math.floor(100000 + Math.random() * 900000).toString();
}

function sendOTP(phoneNumber) {
    const otp = generateOTP();
    // In a real application, this would send OTP via SMS service
    console.log(`OTP sent to ${phoneNumber}: ${otp}`);
    
    // Store OTP in session for validation
    sessionStorage.setItem('generatedOTP', otp);
    sessionStorage.setItem('otpGeneratedTime', new Date().getTime());
    
    return otp;
}

function validateOTP(enteredOTP) {
    const generatedOTP = sessionStorage.getItem('generatedOTP');
    const generatedTime = parseInt(sessionStorage.getItem('otpGeneratedTime'));
    const currentTime = new Date().getTime();
    
    // OTP expires after 5 minutes
    if (currentTime - generatedTime > 5 * 60 * 1000) {
        return false;
    }
    
    return enteredOTP === generatedOTP;
}

// Format Currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}

// Format Date
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// Loading Spinner
function showLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = '<div class="spinner"></div>';
        element.disabled = true;
    }
}

function hideLoading(elementId, originalText) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = originalText;
        element.disabled = false;
    }
}

// Search and Filter Functions
function searchTransactions() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('#transactionTable tbody tr');
    
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(searchTerm) ? '' : 'none';
    });
}

// Pagination
function setupPagination(totalItems, itemsPerPage, currentPage) {
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    const pagination = document.getElementById('pagination');
    
    if (!pagination) return;
    
    let paginationHTML = '';
    
    // Previous button
    if (currentPage > 1) {
        paginationHTML += `<li class="page-item">
            <a class="page-link" href="#" onclick="loadPage(${currentPage - 1})">Previous</a>
        </li>`;
    }
    
    // Page numbers
    for (let i = 1; i <= totalPages; i++) {
        const activeClass = i === currentPage ? 'active' : '';
        paginationHTML += `<li class="page-item ${activeClass}">
            <a class="page-link" href="#" onclick="loadPage(${i})">${i}</a>
        </li>`;
    }
    
    // Next button
    if (currentPage < totalPages) {
        paginationHTML += `<li class="page-item">
            <a class="page-link" href="#" onclick="loadPage(${currentPage + 1})">Next</a>
        </li>`;
    }
    
    pagination.innerHTML = paginationHTML;
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    // Add event listeners for real-time validation
    const emailInput = document.getElementById('email');
    if (emailInput) {
        emailInput.addEventListener('blur', function() {
            if (this.value.trim() !== '' && !isValidEmail(this.value.trim())) {
                showError('emailError', 'Please enter a valid email address');
            } else {
                hideError('emailError');
            }
        });
    }
    
    const amountInput = document.getElementById('amount');
    if (amountInput) {
        amountInput.addEventListener('input', function() {
            const value = parseFloat(this.value);
            if (value <= 0) {
                showError('amountError', 'Amount must be greater than 0');
            } else {
                hideError('amountError');
            }
        });
    }
});
