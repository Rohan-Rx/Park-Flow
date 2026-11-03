package in.parkflow.servlet;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import in.parkflow.model.Booking;
import in.parkflow.model.User;
import in.parkflow.service.BookingService;
import in.parkflow.util.RazorpayConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import org.json.JSONObject;

import java.io.IOException;

@WebServlet("/create-payment-order")
public class CreatePaymentOrderServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user;

        session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(
                    new JSONObject()
                            .put("error", "Please log in again.")
                            .toString()
            );
            return;
        }

        user = (User) session.getAttribute("user");

        if (user.getId() == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(
                    new JSONObject()
                            .put("error", "Please log in again.")
                            .toString()
            );
            return;
        }

        try {
            Long bookingId = Long.valueOf(req.getParameter("bookingId"));
            Booking booking = bookingService.getBookingById(
                    bookingId, user.getId());

            if (booking == null
                    || !"PENDING_PAYMENT".equals(booking.getStatus())
                    || !"PENDING".equals(booking.getPaymentStatus())) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        new JSONObject().put("error",
                                "This booking is not awaiting payment.").toString());
                return;
            }

            String orderId = booking.getRazorpayOrderId();

            // Reuse the same order if the user retries Checkout.
            if (orderId == null || orderId.trim().isEmpty()) {
                RazorpayClient client = new RazorpayClient(
                        RazorpayConfig.getKeyId(),
                        RazorpayConfig.getKeySecret());

                long amountPaise = booking.getTotalAmount()
                        .movePointRight(2)
                        .longValueExact();

                JSONObject orderRequest = new JSONObject();
                orderRequest.put("amount", amountPaise);
                orderRequest.put("currency", "INR");
                orderRequest.put("receipt", "parkflow_" + booking.getId());

                JSONObject notes = new JSONObject();
                notes.put("booking_id", booking.getId().toString());
                orderRequest.put("notes", notes);

                Order order = client.orders.create(orderRequest);
                orderId = order.get("id");

                boolean saved = bookingService.saveRazorpayOrder(
                        booking.getId(), user.getId(), orderId);

                if (!saved) {
                    throw new IllegalStateException(
                            "Could not associate the payment order with this booking.");
                }
            }

            JSONObject result = new JSONObject();
            result.put("keyId", RazorpayConfig.getKeyId());
            result.put("orderId", orderId);
            result.put("amount", booking.getTotalAmount()
                    .movePointRight(2).longValueExact());
            result.put("currency", "INR");
            result.put("bookingId", booking.getId());

            resp.getWriter().write(result.toString());

        } catch (NumberFormatException ex) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(
                    new JSONObject().put("error", "Invalid booking ID.").toString());

        } catch (Exception ex) {
            getServletContext().log("Could not create Razorpay order", ex);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(
                    new JSONObject().put("error",
                            "Unable to start payment. Please try again.").toString());
        }
    }
}