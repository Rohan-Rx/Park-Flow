
package in.parkflow.servlet;

import in.parkflow.model.Booking;
import in.parkflow.service.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/Admin/bookings")
public class AdminBookingsServlet extends HttpServlet {

    private final BookingService bookingService =
            new BookingService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        List<Booking> bookings =
                bookingService.getAllBookings();

        System.out.println("ADMIN BOOKINGS COUNT: " + bookings.size());

        request.setAttribute("bookings", bookings);


        request.getRequestDispatcher("/Admin/bookings.jsp")
                .forward(request, response);
    }
}
