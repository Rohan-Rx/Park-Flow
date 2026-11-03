
package in.parkflow.service;

import in.parkflow.model.ParkingSlot;
import in.parkflow.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import in.parkflow.model.Booking;

import java.util.List;

public class ParkingSlotService {

    public List<ParkingSlot> getAllSlots() {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "FROM ParkingSlot ORDER BY zoneName, slotNumber",
                    ParkingSlot.class
            ).getResultList();
        }
    }
    public void addSlot(ParkingSlot slot) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Transaction transaction =
                    session.beginTransaction();

            try {
                session.persist(slot);
                transaction.commit();
            } catch (Exception e) {
                if (transaction.isActive()) {
                    transaction.rollback();
                }
                throw e;
            }
        }
    }

    public ParkingSlot getSlotById(Long id) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.get(ParkingSlot.class, id);
        }
    }


    public void updateSlot(ParkingSlot updatedSlot) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                ParkingSlot existing = session.get(
                        ParkingSlot.class,
                        updatedSlot.getId()
                );

                if (existing == null) {
                    throw new IllegalArgumentException("Parking slot not found.");
                }

                existing.setSlotNumber(updatedSlot.getSlotNumber());
                existing.setZoneName(updatedSlot.getZoneName());
                existing.setLocation(updatedSlot.getLocation());
                existing.setHourlyRate(updatedSlot.getHourlyRate());
                existing.setStatus(updatedSlot.getStatus());

                transaction.commit();
            } catch (Exception e) {
                if (transaction.isActive()) {
                    transaction.rollback();
                }
                throw e;
            }
        }
    }

    public boolean hasBookings(Long slotId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery(
                            "SELECT COUNT(b.id) FROM Booking b " +
                                    "WHERE b.parkingSlot.id = :slotId",
                            Long.class
                    )
                    .setParameter("slotId", slotId)
                    .getSingleResult();

            return count > 0;
        }
    }

    public void deleteSlot(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                ParkingSlot existing = session.get(ParkingSlot.class, id);

                if (existing == null) {
                    throw new IllegalArgumentException("Parking slot not found.");
                }

                Long bookingCount = session.createQuery(
                                "SELECT COUNT(b.id) FROM Booking b " +
                                        "WHERE b.parkingSlot.id = :slotId",
                                Long.class
                        )
                        .setParameter("slotId", id)
                        .getSingleResult();

                if (bookingCount > 0) {
                    throw new IllegalStateException(
                            "Cannot delete this slot because booking records exist."
                    );
                }

                session.remove(existing);
                transaction.commit();
            } catch (Exception e) {
                if (transaction.isActive()) {
                    transaction.rollback();
                }
                throw e;
            }
        }
    }


}
