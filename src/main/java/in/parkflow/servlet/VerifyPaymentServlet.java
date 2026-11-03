package in.parkflow.servlet;

import in.parkflow.model.Booking;
import in.parkflow.model.User;
import in.parkflow.service.BookingService;
import in.parkflow.util.RazorpayConfig;
import in.parkflow.util.RazorpaySignature;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.json.JSONObject;

import java.io.IOException;

@WebServlet("/verify-payment")
public class VerifyPaymentServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

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

        User user = (User) session.getAttribute("user");

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
            String orderId = req.getParameter("razorpay_order_id");
            String paymentId = req.getParameter("razorpay_payment_id");
            String signature = req.getParameter("razorpay_signature");

            if (orderId == null || paymentId == null || signature == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        new JSONObject().put("error",
                                "Missing payment verification details.").toString());
                return;
            }

            Booking booking = bookingService.getBookingById(
                    bookingId, user.getId());

            if (booking == null ||
                    !orderId.equals(booking.getRazorpayOrderId())) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        new JSONObject().put("error",
                                "Payment order does not match this booking.").toString());
                return;
            }

            boolean validSignature = RazorpaySignature.verify(
                    orderId,
                    paymentId,
                    signature,
                    RazorpayConfig.getKeySecret());

            if (!validSignature) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        new JSONObject().put("error",
                                "Payment signature verification failed.").toString());
                return;
            }

            boolean updated = bookingService.markBookingPaid(
                    bookingId, user.getId(), orderId, paymentId);

            if (!updated) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write(
                        new JSONObject().put("error",
                                        "Booking could not be confirmed. Check its current status.")
                                .toString());
                return;
            }

            JSONObject result = new JSONObject();
            result.put("success", true);
            result.put("redirectUrl",
                    req.getContextPath() + "/booking-details.jsp?id=" + bookingId);

            resp.getWriter().write(result.toString());

        } catch (NumberFormatException ex) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(
                    new JSONObject().put("error", "Invalid booking ID.").toString());

        } catch (Exception ex) {
            getServletContext().log("Payment verification failed", ex);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(
                    new JSONObject().put("error",
                                    "Could not verify payment. Please contact support if charged.")
                            .toString());
        }
    }
}