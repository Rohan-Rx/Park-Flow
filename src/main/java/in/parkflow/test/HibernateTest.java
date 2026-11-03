
package in.parkflow.test;

import in.parkflow.model.ParkingSlot;
import in.parkflow.service.ParkingSlotService;

import java.util.List;

public class HibernateTest {

    public static void main(String[] args) {
        ParkingSlotService service = new ParkingSlotService();

        List<ParkingSlot> slots = service.getAllSlots();

        System.out.println("Total parking slots: " + slots.size());

        for (ParkingSlot slot : slots) {
            System.out.println(
                    slot.getSlotNumber()
                            + " | Zone: " + slot.getZoneName()
                            + " | Location: " + slot.getLocation()
                            + " | Rate: ₹" + slot.getHourlyRate()
                            + " | Status: " + slot.getStatus()
            );
        }
    }
}
