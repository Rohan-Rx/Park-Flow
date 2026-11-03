package in.parkflow.servlet;

import in.parkflow.model.User;
import in.parkflow.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
@WebServlet("/cancel-booking")
public class CancelBookingServlet extends HttpServlet {
    private final BookingService bookingService=new BookingService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session==null)?null: (User)session.getAttribute("user");
        if(user == null){
            resp.sendRedirect(req.getContextPath()+"/index.jsp");
            return;
        }
        try {
            Long bookingId = Long.parseLong(req.getParameter("bookingId"));
            boolean cancelled = bookingService.cancelBooking(bookingId,user.getId());
            if(cancelled){
                resp.sendRedirect(req.getContextPath()+"/my-bookings.jsp?cancelled=1");
            }
            else{
                resp.sendRedirect(req.getContextPath()+"/my-bookings.jsp?error=not-canceled");
            }
        }
        catch (NumberFormatException e){
            resp.sendRedirect(req.getContextPath()+"/my-bookings.jsp?error=invalid-id");
        }catch (Exception e){
            throw new ServletException("Unable to cancel Booking",e);
        }
    }
}
