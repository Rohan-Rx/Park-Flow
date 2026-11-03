<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 28-10-2026
  Time: 10:52 pm
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object loggedInUser = session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkFlow | Smart Parking</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/welcome.css">
</head>
<body>

<header class="navbar">
    <a class="brand" href="<%= request.getContextPath() %>/index.jsp">
        <span class="brand-icon">P</span>
        <span>PARKFLOW<span class="brand-dot">.</span></span>
    </a>

    <nav>
        <a href="<%= request.getContextPath() %>/features.jsp"
           class="nav-cta">Features</a>

        <% if (loggedInUser != null) { %>
        <a href="<%= request.getContextPath() %>/dashboard.jsp"
           class="nav-cta">Dashboard</a>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/index.jsp"
           class="nav-cta">Login</a>
        <% } %>
    </nav>
</header>

<main>
    <section class="hero">
        <div class="hero-content">
            <p class="eyebrow">
                <span class="status-dot"></span>
                THE FUTURE OF PARKING
            </p>

            <h1>
                PARK SMART.<br>
                <span>MOVE FREELY.</span>
            </h1>

            <p class="hero-description">
                Find your space, book your spot, and make every journey
                smoother with intelligent parking management.
            </p>

            <div class="hero-actions">
                <% if (loggedInUser != null) { %>
                <a href="<%= request.getContextPath() %>/dashboard.jsp"
                   class="btn-primary">Go to Dashboard ↗</a>
                <% } else { %>
                <a href="<%= request.getContextPath() %>/index.jsp"
                   class="btn-primary">Get Started ↗</a>

                <a href="<%= request.getContextPath() %>/register.jsp"
                   class="btn-secondary">Create Account</a>
                <% } %>
            </div>

            <div class="hero-note">
                <span class="note-line"></span>
                YOUR SPACE. YOUR TIME. YOUR FLOW.
            </div>
        </div>

        <div class="hero-visual">
            <div class="visual-glow"></div>

            <div class="parking-card">
                <div class="card-top">
                    <span>LIVE PARKING SYSTEM</span>
                    <span class="live-indicator">● LIVE</span>
                </div>

                <div class="parking-symbol">P</div>

                <div class="card-bottom">
                    <div>
                        <span class="small-label">SMART MOBILITY</span>
                        <h2>Parking, reimagined.</h2>
                    </div>
                    <span class="arrow-symbol">↗</span>
                </div>
            </div>

            <div class="floating-tag tag-top">
                <span class="tag-dot"></span>
                SMART BOOKING
            </div>

            <div class="floating-tag tag-bottom">
                <span>01</span>
                FIND YOUR SPACE
            </div>
        </div>
    </section>

    <section class="features" id="features">
        <div class="section-heading">
            <p class="eyebrow">BUILT FOR BETTER JOURNEYS</p>
            <h2>Less searching. <span>More moving.</span></h2>
        </div>

        <div class="feature-grid">
            <article class="feature-card">
                <span class="feature-number">01 / DISCOVER</span>
                <div class="feature-icon">⌕</div>
                <h3>Find Your Space</h3>
                <p>Explore parking slots and check their availability.</p>
            </article>

            <article class="feature-card">
                <span class="feature-number">02 / RESERVE</span>
                <div class="feature-icon">↗</div>
                <h3>Easy Booking</h3>
                <p>Choose a slot and schedule your parking in advance.</p>
            </article>

            <article class="feature-card">
                <span class="feature-number">03 / MANAGE</span>
                <div class="feature-icon">◈</div>
                <h3>Stay in Control</h3>
                <p>Manage your bookings and track your parking details.</p>
            </article>
        </div>
    </section>
</main>

<footer>
    <a class="brand footer-brand" href="<%= request.getContextPath() %>/index.jsp">
        PARKFLOW<span class="brand-dot">.</span>
    </a>
    <span>SMART PARKING MANAGEMENT SYSTEM</span>
    <span>© 2026 PARKFLOW</span>
</footer>

</body>
</html>

