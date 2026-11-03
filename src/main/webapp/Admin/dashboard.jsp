<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 15-10-2026
  Time: 02:49 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="in.parkflow.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkFlow | Admin Dashboard</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>
<div class="admin-layout">

    <aside class="sidebar">
        <a href="<%= request.getContextPath() %>/Admin/dashboard.jsp"
           class="brand">Park<span>Flow</span></a>

        <p class="sidebar-label">ADMIN PANEL</p>

        <a class="nav-item active"
           href="<%= request.getContextPath() %>/Admin/dashboard.jsp">
            Dashboard
        </a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/slots">
            Manage Parking Slots
        </a>
        <a class="nav-item" href="<%= request.getContextPath() %>/Admin/create-admin">
            Admin Management
        </a>


        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/bookings">
            All Bookings
        </a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/dashboard.jsp">
            User Dashboard
        </a>

        <form action="<%= request.getContextPath() %>/logout"
              method="get">
            <button class="logout-btn" type="submit">Logout</button>
        </form>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <p class="eyebrow">SYSTEM CONTROL</p>
                <h1>Admin Dashboard</h1>
            </div>

            <div class="admin-profile">
                <span class="status-dot"></span>
                <div>
                    <strong><%= user.getName() %></strong>
                    <small>Administrator</small>
                </div>
            </div>
        </header>

        <section class="welcome-panel">
            <p class="eyebrow">PARKFLOW MANAGEMENT</p>
            <h2>Welcome back, <%= user.getName() %>.</h2>
            <p>
                Monitor parking operations and manage slots and bookings
                from one place.
            </p>
        </section>

        <section class="section-heading">
            <div>
                <p class="eyebrow">QUICK ACCESS</p>
                <h2>Management Console</h2>
            </div>
        </section>

        <section class="management-grid">
            <a class="management-card"
               href="<%= request.getContextPath() %>/Admin/slots">
                <span class="card-number">01 / OPERATIONS</span>
                <h3>Manage Parking Slots</h3>
                <p>View parking spaces and manage their availability.</p>
                <span class="card-action">Open slot management →</span>
            </a>

            <a class="management-card"
               href="<%= request.getContextPath() %>/Admin/bookings">
                <span class="card-number">02 / RESERVATIONS</span>
                <h3>All Bookings</h3>
                <p>Review customer reservations and booking statuses.</p>
                <span class="card-action">View bookings →</span>
            </a>
        </section>

        <footer class="footer">
            ParkFlow · Smart Parking Management System
        </footer>
    </main>
</div>
</body>
</html>
