<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 25-10-2026
  Time: 03:41 pm
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="in.parkflow.model.Booking" %>

<%!
    private String safe(String value) {
        if (value == null) return "N/A";
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    Booking booking =
            (Booking) request.getAttribute("booking");

    if (booking == null) {
        response.sendError(404, "Booking not found.");
        return;
    }

    String status = booking.getStatus() == null
            ? "UNKNOWN" : booking.getStatus().toUpperCase();

    String payment = booking.getPaymentStatus() == null
            ? "UNKNOWN" : booking.getPaymentStatus().toUpperCase();

    String slotNumber = booking.getParkingSlot() == null
            ? "N/A" : booking.getParkingSlot().getSlotNumber();

    String zone = booking.getParkingSlot() == null
            ? "N/A" : booking.getParkingSlot().getZoneName();

    String location = booking.getParkingSlot() == null
            ? "N/A" : booking.getParkingSlot().getLocation();

    String rate = booking.getParkingSlot() == null
            || booking.getParkingSlot().getHourlyRate() == null
            ? "N/A"
            : booking.getParkingSlot().getHourlyRate().toPlainString();

    String amount = booking.getTotalAmount() == null
            ? "0.00" : booking.getTotalAmount().toPlainString();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkFlow | Booking Details</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">

    <style>
        .details-content {
            display: grid;
            gap: 22px;
        }

        .details-panel {
            background: var(--card, #111511);
            border: 1px solid var(--border, rgba(255,255,255,.1));
            border-radius: 16px;
            padding: 24px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .detail-item {
            padding: 15px;
            border: 1px solid var(--border, #333);
            border-radius: 10px;
            min-width: 0;
        }

        .detail-label {
            display: block;
            color: var(--muted, #9aa39a);
            font-size: .8rem;
            margin-bottom: 8px;
        }

        .detail-value {
            color: var(--text, #f3f6f1);
            font-weight: 700;
            overflow-wrap: anywhere;
        }

        .amount-value {
            color: #a3ff12;
            font-size: 1.5rem;
        }

        .detail-status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            background: rgba(163,255,18,.1);
            color: #b7ff5a;
            font-size: .8rem;
        }

        .back-btn {
            display: inline-block;
            padding: 11px 16px;
            border-radius: 9px;
            border: 1px solid var(--border, #333);
            color: var(--text, #f3f6f1);
            text-decoration: none;
            font-weight: 700;
        }

        @media (max-width: 600px) {
            .details-grid {
                grid-template-columns: 1fr;
            }

            .details-panel {
                padding: 16px;
            }
        }
    </style>
</head>

<body>
<div class="admin-layout">

    <aside class="sidebar">
        <a href="<%= request.getContextPath() %>/Admin/dashboard.jsp"
           class="brand">Park<span>Flow</span></a>

        <p class="sidebar-label">ADMIN PANEL</p>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/dashboard.jsp">
            Dashboard
        </a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/slots">
            Manage Parking Slots
        </a>

        <a class="nav-item active"
           href="<%= request.getContextPath() %>/Admin/bookings">
            All Bookings
        </a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/dashboard.jsp">
            User Dashboard
        </a>

        <form action="<%= request.getContextPath() %>/LogoutServlet"
              method="post">
            <button class="logout-btn" type="submit">Logout</button>
        </form>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="eyebrow">ADMIN PANEL</p>
                <h1>Booking #<%= booking.getId() %></h1>
                <p class="page-description">
                    Complete reservation and payment information.
                </p>
            </div>

            <a class="back-btn"
               href="<%= request.getContextPath() %>/Admin/bookings">
                Back to Bookings
            </a>
        </header>

        <div class="details-content">

            <section class="details-panel">
                <p class="eyebrow">BOOKING INFORMATION</p>
                <h2>Reservation Details</h2>

                <div class="details-grid">
                    <div class="detail-item">
                        <span class="detail-label">Booking ID</span>
                        <div class="detail-value">
                            #<%= booking.getId() %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">User ID</span>
                        <div class="detail-value">
                            <%= booking.getUserId() == null
                                    ? "N/A" : booking.getUserId() %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Booking Date</span>
                        <div class="detail-value">
                            <%= booking.getBookingDate() == null
                                    ? "N/A" : booking.getBookingDate() %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Time Slot</span>
                        <div class="detail-value">
                            <%= booking.getStartTime() == null
                                    ? "N/A" : booking.getStartTime() %>
                            –
                            <%= booking.getEndTime() == null
                                    ? "N/A" : booking.getEndTime() %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Booking Status</span>
                        <span class="detail-status">
                            <%= safe(status.replace('_', ' ')) %>
                        </span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Created At</span>
                        <div class="detail-value">
                            <%= booking.getCreatedAt() == null
                                    ? "N/A"
                                    : booking.getCreatedAt().toString().replace('T', ' ') %>
                        </div>
                    </div>
                </div>
            </section>

            <section class="details-panel">
                <p class="eyebrow">PARKING INFORMATION</p>
                <h2>Assigned Parking Slot</h2>

                <div class="details-grid">
                    <div class="detail-item">
                        <span class="detail-label">Slot Number</span>
                        <div class="detail-value">
                            <%= safe(slotNumber) %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Zone</span>
                        <div class="detail-value">
                            <%= safe(zone) %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Location</span>
                        <div class="detail-value">
                            <%= safe(location) %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Hourly Rate</span>
                        <div class="detail-value">
                            ₹<%= safe(rate) %>
                        </div>
                    </div>
                </div>
            </section>

            <section class="details-panel">
                <p class="eyebrow">PAYMENT INFORMATION</p>
                <h2>Payment Details</h2>

                <div class="details-grid">
                    <div class="detail-item">
                        <span class="detail-label">Total Amount</span>
                        <div class="detail-value amount-value">
                            ₹<%= safe(amount) %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Payment Status</span>
                        <span class="detail-status">
                            <%= safe(payment) %>
                        </span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Razorpay Order ID</span>
                        <div class="detail-value">
                            <%= safe(booking.getRazorpayOrderId()) %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Razorpay Payment ID</span>
                        <div class="detail-value">
                            <%= safe(booking.getRazorpayPaymentId()) %>
                        </div>
                    </div>
                </div>
            </section>

        </div>

        <footer class="footer">
            ParkFlow · Smart Parking Management System
        </footer>

    </main>
</div>
</body>
</html>
