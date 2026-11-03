<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 24-10-2026
  Time: 10:22 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="in.parkflow.model.Booking" %>

<%
    List<Booking> bookings =
            (List<Booking>) request.getAttribute("bookings");

    if (bookings == null) {
        bookings = new java.util.ArrayList<>();
    }

    int confirmedCount = 0;
    int pendingCount = 0;
    int cancelledCount = 0;
    int completedCount = 0;

    for (Booking booking : bookings) {
        String status = booking.getStatus() == null
                ? "UNKNOWN" : booking.getStatus().toUpperCase();

        if ("CONFIRMED".equals(status)) {
            confirmedCount++;
        } else if ("PENDING_PAYMENT".equals(status)) {
            pendingCount++;
        } else if ("CANCELLED".equals(status)) {
            cancelledCount++;
        } else if ("COMPLETED".equals(status)) {
            completedCount++;
        }
    }

    String selectedStatus = request.getParameter("status") == null
            || request.getParameter("status").trim().isEmpty()
            ? "ALL" : request.getParameter("status").toUpperCase();

    String selectedPayment = request.getParameter("payment") == null
            || request.getParameter("payment").trim().isEmpty()
            ? "ALL" : request.getParameter("payment").toUpperCase();

    String search = request.getParameter("q") == null
            ? "" : request.getParameter("q").trim();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkFlow | All Bookings</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">

    <style>

        .cancel-booking-btn {
            display: inline-block;
            padding: 8px 12px;
            border: 1px solid rgba(255, 80, 80, 0.45);
            border-radius: 8px;
            background: rgba(255, 80, 80, 0.08);
            color: #ff7777;
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
        }

        .cancel-booking-btn:hover {
            background: rgba(255, 80, 80, 0.18);
        }

        .booking-action-disabled {
            color: #999;
            font-size: 0.8rem;
            white-space: nowrap;
        }

        .view-booking-btn {
            display: inline-block;
            padding: 8px 12px;
            border: 1px solid rgba(163, 255, 18, 0.35);
            border-radius: 8px;
            color: #a3ff12;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 700;
            white-space: nowrap;
        }

        .view-booking-btn:hover {
            background: rgba(163, 255, 18, 0.10);
        }
        .bookings-content { display: flex; flex-direction: column; gap: 24px; }
        .booking-stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }
        .booking-stat, .booking-panel {
            background: var(--card, #111511);
            border: 1px solid var(--border, rgba(255,255,255,.10));
            border-radius: 16px;
            padding: 20px;
        }
        .booking-stat span { display:block; color: var(--muted, #9aa39a); font-size: .82rem; margin-bottom: 10px; }
        .booking-stat strong { font-size: 1.8rem; color: var(--text, #f3f6f1); }
        .booking-stat .stat-confirmed { color: #a3ff12; }
        .booking-stat .stat-pending { color: #f5c451; }
        .booking-stat .stat-cancelled { color: #ff7373; }
        .booking-toolbar {
            display: flex; flex-wrap: wrap; align-items: end;
            gap: 12px; margin-bottom: 18px;
        }
        .booking-toolbar .form-field { flex: 1 1 170px; min-width: 0; }
        .booking-toolbar label { display:block; margin-bottom:8px; font-size:.85rem; }
        .booking-toolbar input, .booking-toolbar select {
            width:100%; box-sizing:border-box; min-height:42px;
            padding:10px 12px; border-radius:9px;
            border:1px solid var(--border, #333);
            background:var(--input-bg, #101310);
            color:var(--text, #f3f6f1);
        }
        .booking-toolbar button, .clear-filter-btn {
            min-height:42px; padding:10px 16px; border-radius:9px;
            border:1px solid transparent; cursor:pointer; font-weight:700;
            text-decoration:none; display:inline-flex; align-items:center; justify-content:center;
        }
        .booking-toolbar button { background:#a3ff12; color:#101510; }
        .clear-filter-btn { border-color:var(--border, #333); color:var(--text, #f3f6f1); }
        .booking-table-wrap { width:100%; overflow-x:auto; }
        .booking-table { width:100%; border-collapse:collapse; min-width:1050px; }
        .booking-table th {
            text-align:left; padding:13px 12px; font-size:.76rem;
            text-transform:uppercase; letter-spacing:.06em;
            color:var(--muted, #9aa39a); border-bottom:1px solid var(--border, #333);
            white-space:nowrap;
        }
        .booking-table td {
            padding:15px 12px; border-bottom:1px solid var(--border, rgba(255,255,255,.08));
            font-size:.88rem; vertical-align:middle;
        }
        .booking-table tbody tr:hover { background:rgba(163,255,18,.035); }
        .booking-id { font-weight:800; color:#a3ff12; }
        .booking-slot { font-weight:700; }
        .booking-subtext { display:block; color:var(--muted, #9aa39a); font-size:.78rem; margin-top:4px; }
        .status-pill {
            display:inline-flex; align-items:center; padding:6px 9px;
            border-radius:999px; font-size:.72rem; font-weight:800;
            white-space:nowrap; border:1px solid transparent;
        }
        .status-confirmed, .payment-paid { color:#b7ff5a; background:rgba(163,255,18,.10); border-color:rgba(163,255,18,.25); }
        .status-pending_payment, .payment-pending { color:#f5c451; background:rgba(245,196,81,.10); border-color:rgba(245,196,81,.25); }
        .status-cancelled, .payment-failed { color:#ff8989; background:rgba(255,100,100,.10); border-color:rgba(255,100,100,.25); }
        .status-completed, .payment-refunded { color:#8fd8ff; background:rgba(90,190,255,.10); border-color:rgba(90,190,255,.25); }
        .status-unknown, .payment-unknown { color:#c5c9c5; background:rgba(180,180,180,.08); border-color:rgba(180,180,180,.2); }
        .empty-bookings { padding:42px 18px; text-align:center; color:var(--muted, #9aa39a); }
        .empty-bookings h3 { color:var(--text, #f3f6f1); margin-bottom:8px; }
        .booking-results { color:var(--muted, #9aa39a); font-size:.84rem; margin:0 0 12px; }
        @media (max-width: 900px) { .booking-stats { grid-template-columns:repeat(2,minmax(0,1fr)); } }
        @media (max-width: 520px) {
            .booking-stats { grid-template-columns:1fr 1fr; gap:9px; }
            .booking-stat { padding:14px; }
            .booking-stat strong { font-size:1.4rem; }
            .booking-panel { padding:14px; }
        }
    </style>
</head>
<body>
<div class="admin-layout">

    <aside class="sidebar">
        <a href="<%= request.getContextPath() %>/Admin/dashboard.jsp" class="brand">
            Park<span>Flow</span>
        </a>

        <p class="sidebar-label">ADMIN PANEL</p>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/dashboard.jsp">Dashboard</a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/slots">Manage Parking Slots</a>

        <a class="nav-item active"
           href="<%= request.getContextPath() %>/Admin/bookings">All Bookings</a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/dashboard.jsp">User Dashboard</a>

        <form action="<%= request.getContextPath() %>/LogoutServlet" method="post">
            <button class="logout-btn" type="submit">Logout</button>
        </form>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <p class="eyebrow">ADMIN PANEL</p>
                <h1>All Bookings</h1>
                <p class="page-description">Review reservations, parking slots, and payment statuses.</p>
            </div>
        </header>

        <div class="bookings-content">
            <section class="booking-stats" aria-label="Booking summary">
                <div class="booking-stat">
                    <span>Total Bookings</span>
                    <strong><%= bookings.size() %></strong>
                </div>
                <div class="booking-stat">
                    <span>Confirmed</span>
                    <strong class="stat-confirmed"><%= confirmedCount %></strong>
                </div>
                <div class="booking-stat">
                    <span>Pending Payment</span>
                    <strong class="stat-pending"><%= pendingCount %></strong>
                </div>
                <div class="booking-stat">
                    <span>Cancelled</span>
                    <strong class="stat-cancelled"><%= cancelledCount %></strong>
                </div>
            </section>

            <section class="booking-panel">
                <div class="section-heading">
                    <div>
                        <p class="eyebrow">RESERVATION RECORDS</p>
                        <h2>Booking Management</h2>
                    </div>
                </div>

                <form class="booking-toolbar" method="get"
                      action="<%= request.getContextPath() %>/Admin/bookings">
                    <div class="form-field">
                        <label for="q">Search</label>
                        <input id="q" name="q" type="search"
                               placeholder="Booking ID, user ID, or slot"
                               value="<%= escapeHtml(search) %>">
                    </div>

                    <div class="form-field">
                        <label for="status">Booking Status</label>
                        <select id="status" name="status">
                            <option value="ALL" <%= "ALL".equals(selectedStatus) ? "selected" : "" %>>All statuses</option>
                            <option value="PENDING_PAYMENT" <%= "PENDING_PAYMENT".equals(selectedStatus) ? "selected" : "" %>>Pending payment</option>
                            <option value="CONFIRMED" <%= "CONFIRMED".equals(selectedStatus) ? "selected" : "" %>>Confirmed</option>
                            <option value="CANCELLED" <%= "CANCELLED".equals(selectedStatus) ? "selected" : "" %>>Cancelled</option>
                            <option value="COMPLETED" <%= "COMPLETED".equals(selectedStatus) ? "selected" : "" %>>Completed</option>
                        </select>
                    </div>

                    <div class="form-field">
                        <label for="payment">Payment Status</label>
                        <select id="payment" name="payment">
                            <option value="ALL" <%= "ALL".equals(selectedPayment) ? "selected" : "" %>>All payments</option>
                            <option value="PENDING" <%= "PENDING".equals(selectedPayment) ? "selected" : "" %>>Pending</option>
                            <option value="PAID" <%= "PAID".equals(selectedPayment) ? "selected" : "" %>>Paid</option>
                            <option value="FAILED" <%= "FAILED".equals(selectedPayment) ? "selected" : "" %>>Failed</option>
                            <option value="REFUNDED" <%= "REFUNDED".equals(selectedPayment) ? "selected" : "" %>>Refunded</option>
                        </select>
                    </div>

                    <button type="submit">Apply Filters</button>
                    <a class="clear-filter-btn"
                       href="<%= request.getContextPath() %>/Admin/bookings">Reset</a>
                </form>

                <p class="booking-results" id="bookingResults">
                    Showing <span id="visibleCount"><%= bookings.size() %></span> booking(s)
                </p>

                <div class="booking-table-wrap">
                    <table class="booking-table">
                        <thead>
                        <tr>
                            <th>Booking</th>
                            <th>User ID</th>
                            <th>Parking Slot</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Amount</th>
                            <th>Booking Status</th>
                            <th>Payment</th>
                            <th>Action</th>

                        </tr>
                        </thead>
                        <tbody id="bookingTableBody">
                        <% if (bookings.isEmpty()) { %>
                        <tr>
                            <td colspan="8">
                                <div class="empty-bookings">
                                    <h3>No bookings found</h3>
                                    <p>Bookings will appear here when users make reservations.</p>
                                </div>
                            </td>
                        </tr>
                        <% } else {
                            for (Booking booking : bookings) {
                                String status = booking.getStatus() == null
                                        ? "UNKNOWN" : booking.getStatus().toUpperCase();
                                String paymentStatus = booking.getPaymentStatus() == null
                                        ? "UNKNOWN" : booking.getPaymentStatus().toUpperCase();

                                String slotNumber = booking.getParkingSlot() == null
                                        ? "N/A" : booking.getParkingSlot().getSlotNumber();
                                String zoneName = booking.getParkingSlot() == null
                                        ? "" : booking.getParkingSlot().getZoneName();

                                String bookingDate = booking.getBookingDate() == null
                                        ? "N/A" : booking.getBookingDate().toString();
                                String startTime = booking.getStartTime() == null
                                        ? "" : booking.getStartTime().toString();
                                String endTime = booking.getEndTime() == null
                                        ? "" : booking.getEndTime().toString();
                                String amount = booking.getTotalAmount() == null
                                        ? "0.00" : booking.getTotalAmount().toPlainString();

                                String searchable = (booking.getId() + " " +
                                        booking.getUserId() + " " + slotNumber + " " +
                                        zoneName + " " + status + " " + paymentStatus)
                                        .toLowerCase();
                        %>
                        <tr class="booking-row"
                            data-search="<%= escapeHtml(searchable) %>"
                            data-status="<%= escapeHtml(status) %>"
                            data-payment="<%= escapeHtml(paymentStatus) %>">
                            <td>
                                <span class="booking-id">#<%= booking.getId() %></span>
                                <span class="booking-subtext">Created:
                                        <%= booking.getCreatedAt() == null ? "N/A" : booking.getCreatedAt().toString().replace('T', ' ') %>
                                    </span>
                            </td>
                            <td><%= booking.getUserId() == null ? "N/A" : booking.getUserId() %></td>
                            <td>
                                <span class="booking-slot"><%= escapeHtml(slotNumber) %></span>
                                <span class="booking-subtext"><%= escapeHtml(zoneName) %></span>
                            </td>
                            <td><%= escapeHtml(bookingDate) %></td>
                            <td><%= escapeHtml(startTime) %> – <%= escapeHtml(endTime) %></td>
                            <td>₹<%= escapeHtml(amount) %></td>
                            <td>
                                    <span class="status-pill status-<%= status.toLowerCase() %>">
                                        <%= escapeHtml(status.replace('_', ' ')) %>
                                    </span>
                            </td>
                            <td>
                                    <span class="status-pill payment-<%= paymentStatus.toLowerCase() %>">
                                        <%= escapeHtml(paymentStatus) %>
                                    </span>
                            </td>
                            <td>
                                <a class="view-booking-btn"
                                   href="<%= request.getContextPath() %>/Admin/booking-details?id=<%= booking.getId() %>">
                                    View Details
                                </a>
                                <form action="<%= request.getContextPath() %>/Admin/cancel-booking"
                                      method="post"
                                      onsubmit="return confirm('Are you sure you want to cancel this booking?');"
                                      style="display:inline;">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= booking.getId() %>">

                                    <% if (!"CANCELLED".equalsIgnoreCase(booking.getStatus())
                                            && !"COMPLETED".equalsIgnoreCase(booking.getStatus())) { %>

                                    <button type="submit" class="cancel-booking-btn">
                                        Cancel Booking
                                    </button>

                                    <% } else { %>

                                    <span class="booking-action-disabled">
            Not Available
        </span>

                                    <% } %>

                                </form>
                            </td>



                        </tr>
                        <%  }
                        } %>
                        </tbody>
                    </table>
                </div>
                <div class="empty-bookings" id="noFilteredResults" hidden>
                    <h3>No matching bookings</h3>
                    <p>Try changing your search or filters.</p>
                </div>
            </section>
        </div>

        <footer class="footer">ParkFlow · Smart Parking Management System</footer>
    </main>
</div>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<script>
    // The server already supplies the full list. These filters narrow the
    // displayed rows without making additional requests.
    const searchInput = document.getElementById("q");
    const statusSelect = document.getElementById("status");
    const paymentSelect = document.getElementById("payment");
    const rows = Array.from(document.querySelectorAll(".booking-row"));
    const visibleCount = document.getElementById("visibleCount");
    const noFilteredResults = document.getElementById("noFilteredResults");

    function filterBookings() {
        const query = (searchInput.value || "").trim().toLowerCase();
        const status = (statusSelect.value || "ALL").toUpperCase();
        const payment = (paymentSelect.value || "ALL").toUpperCase();
        let count = 0;

        rows.forEach(function (row) {
            const matchesQuery = (row.dataset.search || "").includes(query);
            const matchesStatus = status === "ALL" || row.dataset.status === status;
            const matchesPayment = payment === "ALL" || row.dataset.payment === payment;
            const visible = matchesQuery && matchesStatus && matchesPayment;

            row.hidden = !visible;
            if (visible) count++;
        });

        visibleCount.textContent = count;
        noFilteredResults.hidden = count !== 0 || rows.length === 0;
    }

    searchInput.addEventListener("input", filterBookings);
    statusSelect.addEventListener("change", filterBookings);
    paymentSelect.addEventListener("change", filterBookings);
    filterBookings();
</script>
</body>
</html>

