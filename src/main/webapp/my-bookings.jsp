<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 13-10-2026
  Time: 11:50 pm
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="in.parkflow.model.User" %>
<%@ page import="in.parkflow.model.Booking" %>
<%@ page import="in.parkflow.service.BookingService" %>

<%
  User user = (User) session.getAttribute("user");

  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
  }

  BookingService bookingService = new BookingService();
  List<Booking> bookings = bookingService.getBookingHistory(user.getId());

  DateTimeFormatter dateFormat =
          DateTimeFormatter.ofPattern("dd MMM yyyy");
  DateTimeFormatter timeFormat =
          DateTimeFormatter.ofPattern("hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ParkFlow | My Bookings</title>

  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      padding: 35px 20px;
      background: #101310;
      color: #f2f5f0;
      font-family: Arial, sans-serif;
    }

    .container {
      max-width: 1100px;
      margin: auto;
    }

    .topbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 15px;
      margin-bottom: 28px;
    }

    h1 {
      margin-bottom: 8px;
    }

    .muted {
      color: #a4ada4;
    }

    a, .btn {
      display: inline-block;
      padding: 10px 15px;
      border-radius: 7px;
      text-decoration: none;
      font-weight: bold;
    }

    .back {
      color: #b7ff5a;
      border: 1px solid #b7ff5a;
    }

    .table-wrapper {
      overflow-x: auto;
      background: #191e19;
      border: 1px solid #303830;
      border-radius: 12px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      min-width: 750px;
    }

    th, td {
      padding: 16px;
      text-align: left;
      border-bottom: 1px solid #303830;
    }

    th {
      color: #b7ff5a;
      font-size: 13px;
      text-transform: uppercase;
    }

    .status {
      display: inline-block;
      padding: 6px 10px;
      border-radius: 20px;
      font-size: 12px;
      background: #263b25;
      color: #b7ff5a;
    }

    .cancelled {
      background: #482727;
      color: #ffaaaa;
    }

    .completed {
      background: #303530;
      color: #d0d6d0;
    }

    .cancel-btn {
      border: none;
      background: #ff6262;
      color: #171717;
      cursor: pointer;
    }

    .empty {
      padding: 35px;
      text-align: center;
      color: #a4ada4;
    }

    .message {
      padding: 13px;
      margin-bottom: 18px;
      border-radius: 7px;
      background: #263b25;
      color: #b7ff5a;
    }

    .error {
      background: #482727;
      color: #ffaaaa;
    }
  </style>
</head>

<body>
<div class="container">

  <div class="topbar">
    <div>
      <h1>My Bookings</h1>
      <p class="muted">View and manage your parking reservations.</p>
    </div>

    <a class="back"
       href="<%= request.getContextPath() %>/dashboard.jsp">
      ← Dashboard
    </a>
  </div>

  <% if ("1".equals(request.getParameter("cancelled"))) { %>
  <div class="message">Booking cancelled successfully.</div>
  <% } %>

  <% if (request.getParameter("error") != null) { %>
  <div class="message error">
    Unable to cancel the booking. It may not exist or may no longer be cancellable.
  </div>
  <% } %>

  <div class="table-wrapper">
    <table>
      <thead>
      <tr>
        <th>Booking ID</th>
        <th>Parking Slot</th>
        <th>Zone</th>
        <th>Date</th>
        <th>Start Time</th>
        <th>End Time</th>
        <th>Amount</th>
        <th>Status</th>
        <th>Action</th>
      </tr>
      </thead>

      <tbody>
      <% if (bookings.isEmpty()) { %>
      <tr>
        <td colspan="9" class="empty">
          You haven't made any bookings yet.
          <br><br>
          <a class="back"
             href="<%= request.getContextPath() %>/Bookings.jsp">
            Book a Parking Slot
          </a>
        </td>
      </tr>
      <% } else {
        for (Booking booking : bookings) {
          String status = booking.getStatus();
          String statusClass = "CONFIRMED".equalsIgnoreCase(status)
                  ? ""
                  : ("CANCELLED".equalsIgnoreCase(status)
                     ? "cancelled" : "completed");
      %>
      <tr>
        <td><%= booking.getId() %></td>
        <td><%= booking.getParkingSlot().getSlotNumber() %></td>
        <td>Zone <%= booking.getParkingSlot().getZoneName() %></td>
        <td><%= booking.getBookingDate().format(dateFormat) %></td>
        <td><%= booking.getStartTime().format(timeFormat) %></td>
        <td><%= booking.getEndTime().format(timeFormat) %></td>
        <td>₹<%= booking.getTotalAmount() %></td>
        <td>
                        <span class="status <%= statusClass %>">
                            <%= status %>
                        </span>
        </td>
        <td>
          <% if ("CONFIRMED".equalsIgnoreCase(status)) { %>
          <form action="<%= request.getContextPath() %>/cancel-booking"
                method="post"
                onsubmit="return confirm('Are you sure you want to cancel this booking?');">
            <input type="hidden"
                   name="bookingId"
                   value="<%= booking.getId() %>">
            <button class="btn cancel-btn" type="submit">
              Cancel
            </button>
          </form>
          <% } else { %>
          <span class="muted">—</span>
          <% } %>
        </td>
      </tr>
      <%  }
      } %>
      </tbody>
    </table>
  </div>

</div>
</body>
</html>
