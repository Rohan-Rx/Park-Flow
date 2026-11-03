
package in.parkflow.servlet;

import in.parkflow.model.ParkingSlot;
import in.parkflow.service.ParkingSlotService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/Admin/slots")
public class AdminSlotServlet extends HttpServlet {

    private final ParkingSlotService parkingSlotService =
            new ParkingSlotService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        List<ParkingSlot> slots =
                parkingSlotService.getAllSlots();

        request.setAttribute("slots", slots);

        request.getRequestDispatcher("/Admin/slots.jsp")
                .forward(request, response);
    }
}