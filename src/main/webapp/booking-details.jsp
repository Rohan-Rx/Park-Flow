<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 15-10-2026
  Time: 11:31 am
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="in.parkflow.model.User" %>
<%@ page import="in.parkflow.model.Booking" %>
<%@ page import="in.parkflow.service.BookingService" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Booking booking = null;
    String bookingIdParam = request.getParameter("id");

    if (bookingIdParam != null) {
        try {
            Long bookingId = Long.parseLong(bookingIdParam);
            booking = new BookingService()
                    .getBookingById(bookingId, user.getId());
        } catch (NumberFormatException e) {
            booking = null;
        }
    }

    if (booking == null) {
        response.sendError(
                jakarta.servlet.http.HttpServletResponse.SC_NOT_FOUND,
                "Booking not found."
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Details | ParkFlow</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/bookings.css">
</head>
<body>

<main class="booking-details-page">
    <section class="booking-summary">
        <h2>Booking Details</h2>

        <div class="summary-row">
            <span>Booking ID</span>
            <strong><%= booking.getId() %></strong>
        </div>

        <div class="summary-row">
            <span>Parking Slot</span>
            <strong><%= booking.getParkingSlot().getSlotNumber() %></strong>
        </div>

        <div class="summary-row">
            <span>Zone</span>
            <strong><%= booking.getParkingSlot().getZoneName() %></strong>
        </div>

        <div class="summary-row">
            <span>Date</span>
            <strong><%= booking.getBookingDate() %></strong>
        </div>

        <div class="summary-row">
            <span>Start Time</span>
            <strong><%= booking.getStartTime() %></strong>
        </div>

        <div class="summary-row">
            <span>End Time</span>
            <strong><%= booking.getEndTime() %></strong>
        </div>

        <div class="summary-row">
            <span>Status</span>
            <strong><%= booking.getStatus() %></strong>
        </div>

        <div class="summary-row summary-total">
            <span>Total Amount</span>
            <strong>Rs. <%= booking.getTotalAmount() %></strong>
        </div>
        <div class="payment-section">
            <button type="button" id="payNowBtn" class="pay-btn">
                Pay Now
            </button>

            <p id="paymentMessage" role="status"></p>
        </div>

        <p>
            <a href="<%= request.getContextPath() %>/my-bookings.jsp">
                Back to My Bookings
            </a>
        </p>
    </section>
</main>

</body>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<script>
    const contextPath = '<%= request.getContextPath() %>';
    const bookingId = new URLSearchParams(window.location.search)
        .get("id");

    const payButton = document.getElementById("payNowBtn");
    const paymentMessage = document.getElementById("paymentMessage");

    payButton.addEventListener("click", async function () {
        if (!bookingId || !/^\d+$/.test(bookingId)) {
            paymentMessage.textContent = "Invalid booking ID.";
            return;
        }

        payButton.disabled = true;
        paymentMessage.textContent = "Preparing secure checkout...";

        try {
            // Step 1: Ask the server to create or retrieve the Razorpay order.
            const orderResponse = await fetch(
                contextPath + "/create-payment-order?bookingId=" +
                encodeURIComponent(bookingId),
                {
                    method: "POST",
                    credentials: "same-origin"
                }
            );

            const orderData = await orderResponse.json();

            if (!orderResponse.ok) {
                throw new Error(orderData.error || "Could not start payment.");
            }

            // Step 2: Open Razorpay Checkout.
            const options = {
                key: orderData.keyId,
                amount: orderData.amount,
                currency: orderData.currency,
                name: "ParkFlow",
                description: "Parking booking #" + bookingId,
                order_id: orderData.orderId,

                handler: async function (paymentResponse) {
                    paymentMessage.textContent =
                        "Verifying payment with ParkFlow...";

                    try {
                        // Step 3: Verify the payment on the server.
                        const formData = new URLSearchParams({
                            bookingId: bookingId,
                            razorpay_order_id:
                            paymentResponse.razorpay_order_id,
                            razorpay_payment_id:
                            paymentResponse.razorpay_payment_id,
                            razorpay_signature:
                            paymentResponse.razorpay_signature
                        });

                        const verifyResponse = await fetch(
                            contextPath + "/verify-payment",
                            {
                                method: "POST",
                                credentials: "same-origin",
                                headers: {
                                    "Content-Type":
                                        "application/x-www-form-urlencoded;charset=UTF-8"
                                },
                                body: formData.toString()
                            }
                        );

                        const verifyData = await verifyResponse.json();

                        if (!verifyResponse.ok || !verifyData.success) {
                            throw new Error(
                                verifyData.error || "Payment verification failed."
                            );
                        }

                        window.location.href = verifyData.redirectUrl;

                    } catch (error) {
                        paymentMessage.textContent = error.message;
                        payButton.disabled = false;
                    }
                },

                modal: {
                    ondismiss: function () {
                        paymentMessage.textContent =
                            "Checkout closed. Your booking is still awaiting payment.";
                        payButton.disabled = false;
                    }
                },

                theme: {
                    color: "#3399cc"
                }
            };

            const checkout = new Razorpay(options);

            checkout.on("payment.failed", function (event) {
                paymentMessage.textContent =
                    event.error.description || "Payment failed. Please try again.";
                payButton.disabled = false;
            });

            checkout.open();

        } catch (error) {
            paymentMessage.textContent = error.message;
            payButton.disabled = false;
        }
    });
</script>
</html>
