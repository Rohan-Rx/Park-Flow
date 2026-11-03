package in.parkflow.servlet;


import in.parkflow.model.ParkingSlot;
import in.parkflow.service.ParkingSlotService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.exception.ConstraintViolationException;
import java.lang.NumberFormatException;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/Admin/add-slot")
public class AddParkingSlotServlet extends HttpServlet {

    private final ParkingSlotService parkingSlotService =
            new ParkingSlotService();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String slotNumber = request.getParameter("slotNumber");
        String zoneName = request.getParameter("zoneName");
        String location = request.getParameter("location");
        String rateValue = request.getParameter("hourlyRate");

        if (slotNumber == null || slotNumber.trim().isEmpty()
                || zoneName == null || zoneName.trim().isEmpty()
                || location == null || location.trim().isEmpty()
                || rateValue == null || rateValue.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/Admin/slots?error=missing"
            );
            return;
        }


        try {
            BigDecimal hourlyRate = new BigDecimal(rateValue.trim());

            if (hourlyRate.compareTo(BigDecimal.ZERO) <= 0
                    || hourlyRate.scale() > 2) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/Admin/slots?error=rate"
                );
                return;
            }

            ParkingSlot slot = new ParkingSlot();
            slot.setSlotNumber(slotNumber.trim());
            slot.setZoneName(zoneName.trim());
            slot.setLocation(location.trim());
            slot.setHourlyRate(hourlyRate);
            slot.setStatus("AVAILABLE");

            parkingSlotService.addSlot(slot);

            response.sendRedirect(
                    request.getContextPath()
                            + "/Admin/slots?success=added"
            );


        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/Admin/slots?error=rate"
            );

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/Admin/slots?error=duplicate"
            );

        } catch (ConstraintViolationException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/Admin/slots?error=duplicate"
            );
        }


    }
}

