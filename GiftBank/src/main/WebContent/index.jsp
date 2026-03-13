<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // If user is logged in, redirect to dashboard
    if (session.getAttribute("userId") != null) {
        response.sendRedirect("jsp/dashboard.jsp");
        return;
    }
    // Otherwise, redirect to login
    response.sendRedirect("jsp/login.jsp");
%>
