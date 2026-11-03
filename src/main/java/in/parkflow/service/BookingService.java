
    package in.parkflow.service;

    import in.parkflow.model.Booking;
    import in.parkflow.model.ParkingSlot;
    import in.parkflow.util.HibernateUtil;
    import jakarta.persistence.LockModeType;
    import org.hibernate.Session;
    import org.hibernate.Transaction;
    import org.hibernate.LockMode;
    import org.hibernate.query.Query;

    import java.math.BigDecimal;
    import java.math.RoundingMode;
    import java.time.Duration;
    import java.time.LocalDate;
    import java.time.LocalTime;
    import java.util.List;

    public class BookingService {

        public Booking createBooking(
                Long userId,
                Long slotId,
                LocalDate bookingDate,
                LocalTime startTime,
                LocalTime endTime) {

            if (userId == null || slotId == null ||
                    bookingDate == null || startTime == null ||
                    endTime == null) {
                throw new IllegalArgumentException(
                        "All booking details are required.");
            }

            if (!endTime.isAfter(startTime)) {
                throw new IllegalArgumentException(
                        "End time must be after start time.");
            }

            if (bookingDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException(
                        "Booking date cannot be in the past.");
            }

            if (bookingDate.equals(LocalDate.now()) &&
                    !startTime.isAfter(LocalTime.now())) {
                throw new IllegalArgumentException(
                        "Start time must be in the future.");
            }

            long durationMinutes =
                    Duration.between(startTime, endTime).toMinutes();

            if (durationMinutes <= 0) {
                throw new IllegalArgumentException(
                        "Booking duration must be at least one minute.");
            }

            Transaction transaction = null;

            try (Session session =
                         HibernateUtil.getSessionFactory().openSession()) {

                transaction = session.beginTransaction();

                ParkingSlot slot = session.find(
                        ParkingSlot.class,
                        slotId,
                        LockMode.PESSIMISTIC_WRITE.toJpaLockMode());

                if (slot == null) {
                    throw new IllegalArgumentException(
                            "Parking slot not found.");
                }

                if (!"AVAILABLE".equalsIgnoreCase(slot.getStatus())) {
                    throw new IllegalArgumentException(
                            "This parking slot is not available.");
                }

                String hql =
                        "SELECT COUNT(b) FROM Booking b " +
                                "WHERE b.parkingSlot.id = :slotId " +
                                "AND b.bookingDate = :bookingDate " +
                                "AND (b.status = 'CONFIRMED' " +
                                "OR b.status = 'PENDING_PAYMENT') " +
                                "AND b.startTime < :endTime " +
                                "AND b.endTime > :startTime";

                Long overlapping = session.createQuery(
                                hql, Long.class)
                        .setParameter("slotId", slotId)
                        .setParameter("bookingDate", bookingDate)
                        .setParameter("startTime", startTime)
                        .setParameter("endTime", endTime)
                        .getSingleResult();

                if (overlapping > 0) {
                    throw new IllegalArgumentException(
                            "This slot is already booked for that time.");
                }

                BigDecimal hours = BigDecimal.valueOf(durationMinutes)
                        .divide(BigDecimal.valueOf(60), 4,
                                RoundingMode.HALF_UP);

                BigDecimal totalAmount = slot.getHourlyRate()
                        .multiply(hours)
                        .setScale(2, RoundingMode.HALF_UP);

                Booking booking = new Booking();
                booking.setUserId(userId);
                booking.setParkingSlot(slot);
                booking.setBookingDate(bookingDate);
                booking.setStartTime(startTime);
                booking.setEndTime(endTime);
                booking.setTotalAmount(totalAmount);
                booking.setStatus("PENDING_PAYMENT");
                booking.setPaymentStatus("PENDING");
                session.persist(booking);
                transaction.commit();

                return booking;

            } catch (RuntimeException ex) {
                if (transaction != null && transaction.isActive()) {
                    transaction.rollback();
                }
                throw ex;
            }
        }

        public List<Booking> getBookingHistory(Long userId) {
            if (userId == null) {
                throw new IllegalArgumentException(
                        "User ID is required.");
            }

            try (Session session =
                         HibernateUtil.getSessionFactory().openSession()) {

                Query<Booking> query = session.createQuery(
                        "FROM Booking b " +
                                "JOIN FETCH b.parkingSlot " +
                                "WHERE b.userId = :userId " +
                                "ORDER BY b.bookingDate DESC, b.startTime DESC",
                        Booking.class);

                query.setParameter("userId", userId);

                return query.getResultList();
            }
        }

        public boolean cancelBooking(Long bookingId, Long userId) {
            try (Session session = HibernateUtil.getSessionFactory().openSession()) {
                Transaction transaction = session.beginTransaction();

                try {
                    Booking booking = session.createQuery(
                                    "FROM Booking b " +
                                            "WHERE b.id = :bookingId " +
                                            "AND b.userId = :userId",
                                    Booking.class
                            )
                            .setParameter("bookingId", bookingId)
                            .setParameter("userId", userId)
                            .uniqueResult();

                    if (booking == null) {
                        transaction.rollback();
                        return false;
                    }

                    if (!"CONFIRMED".equalsIgnoreCase(booking.getStatus())) {
                        transaction.rollback();
                        return false;
                    }

                    booking.setStatus("CANCELLED");

                    transaction.commit();
                    return true;

                } catch (Exception e) {
                    if (transaction.isActive()) {
                        transaction.rollback();
                    }
                    throw e;
                }
            }
        }


        public boolean checkAvailability(
                Long slotId,
                LocalDate bookingDate,
                LocalTime startTime,
                LocalTime endTime) {

            if (slotId == null || bookingDate == null ||
                    startTime == null || endTime == null) {
                throw new IllegalArgumentException(
                        "All availability details are required.");
            }

            if (!endTime.isAfter(startTime)) {
                throw new IllegalArgumentException(
                        "End time must be after start time.");
            }

            try (Session session =
                         HibernateUtil.getSessionFactory().openSession()) {

                ParkingSlot slot = session.get(ParkingSlot.class, slotId);

                if (slot == null ||
                        !"AVAILABLE".equalsIgnoreCase(slot.getStatus())) {
                    return false;
                }

                Long overlapping = session.createQuery(
                                "SELECT COUNT(b) FROM Booking b " +
                                        "WHERE b.parkingSlot.id = :slotId " +
                                        "AND b.bookingDate = :bookingDate " +
                                        "AND (b.status = 'CONFIRMED' " +
                                        "OR b.status = 'PENDING_PAYMENT') " +
                                        "AND b.startTime < :endTime " +
                                        "AND b.endTime > :startTime",
                                Long.class)
                        .setParameter("slotId", slotId)
                        .setParameter("bookingDate", bookingDate)
                        .setParameter("startTime", startTime)
                        .setParameter("endTime", endTime)
                        .getSingleResult();

                return overlapping == 0;
            }
        }

        public Booking getBookingById(Long bookingId, Long userId) {
            try (Session session = HibernateUtil.getSessionFactory().openSession()) {
                return session.createQuery(
                                "FROM Booking b JOIN FETCH b.parkingSlot " +
                                        "WHERE b.id = :bookingId AND b.userId = :userId",
                                Booking.class
                        )
                        .setParameter("bookingId", bookingId)
                        .setParameter("userId", userId)
                        .uniqueResult();
            }
        }
        public boolean saveRazorpayOrder(
                Long bookingId,
                Long userId,
                String orderId) {

            try (Session session =
                         HibernateUtil.getSessionFactory().openSession()) {

                Transaction tx = session.beginTransaction();

                try {
                    Booking booking = session.createQuery(
                                    "FROM Booking b WHERE b.id = :bookingId " +
                                            "AND b.userId = :userId",
                                    Booking.class)
                            .setParameter("bookingId", bookingId)
                            .setParameter("userId", userId)
                            .setLockMode(
                                    LockModeType.PESSIMISTIC_WRITE)
                            .uniqueResult();

                    if (booking == null ||
                            !"PENDING_PAYMENT".equals(booking.getStatus())) {
                        tx.rollback();
                        return false;
                    }

                    // Never replace an existing order with a different order.
                    if (booking.getRazorpayOrderId() != null &&
                            !booking.getRazorpayOrderId().equals(orderId)) {
                        tx.rollback();
                        return false;
                    }

                    booking.setRazorpayOrderId(orderId);
                    tx.commit();
                    return true;

                } catch (RuntimeException ex) {
                    if (tx.isActive()) {
                        tx.rollback();
                    }
                    throw ex;
                }
            }
        }
        public boolean markBookingPaid(
                Long bookingId,
                Long userId,
                String orderId,
                String paymentId) {

            try (Session session =
                         HibernateUtil.getSessionFactory().openSession()) {

                Transaction tx = session.beginTransaction();

                try {
                    Booking booking = session.createQuery(
                                    "FROM Booking b WHERE b.id = :bookingId " +
                                            "AND b.userId = :userId",
                                    Booking.class)
                            .setParameter("bookingId", bookingId)
                            .setParameter("userId", userId)
                            .setLockMode(
                                    LockModeType.PESSIMISTIC_WRITE)
                            .uniqueResult();

                    if (booking == null) {
                        tx.rollback();
                        return false;
                    }

                    // Idempotent handling if the same payment is verified again.
                    if ("PAID".equals(booking.getPaymentStatus())) {
                        boolean samePayment =
                                paymentId.equals(booking.getRazorpayPaymentId())
                                        && orderId.equals(booking.getRazorpayOrderId());

                        tx.commit();
                        return samePayment;
                    }

                    if (!"PENDING_PAYMENT".equals(booking.getStatus())
                            || !"PENDING".equals(booking.getPaymentStatus())
                            || !orderId.equals(booking.getRazorpayOrderId())) {
                        tx.rollback();
                        return false;
                    }

                    booking.setRazorpayPaymentId(paymentId);
                    booking.setPaymentStatus("PAID");
                    booking.setStatus("CONFIRMED");

                    tx.commit();
                    return true;

                } catch (RuntimeException ex) {
                    if (tx.isActive()) {
                        tx.rollback();
                    }
                    throw ex;
                }
            }
        }

        public List<Booking> getAllBookings() {
            try (Session session =
                         HibernateUtil.getSessionFactory().openSession()) {

                return session.createQuery(
                        "FROM Booking b " +
                                "JOIN FETCH b.parkingSlot " +
                                "ORDER BY b.createdAt DESC, b.id DESC",
                        Booking.class
                ).getResultList();
            }
        }
        public Booking getBookingByIdForAdmin(Long bookingId) {
            if (bookingId == null) {
                return null;
            }

            try (Session session =
                         HibernateUtil.getSessionFactory().openSession()) {

                return session.createQuery(
                                "FROM Booking b " +
                                        "JOIN FETCH b.parkingSlot " +
                                        "WHERE b.id = :bookingId",
                                Booking.class
                        )
                        .setParameter("bookingId", bookingId)
                        .uniqueResult();
            }
        }

        public boolean cancelBookingByAdmin(Long bookingId) {
            if (bookingId == null || bookingId <= 0) {
                return false;
            }

            Transaction transaction = null;

            try (Session session = HibernateUtil.getSessionFactory().openSession()) {
                transaction = session.beginTransaction();

                Booking booking = session.createQuery(
                                "FROM Booking b WHERE b.id = :bookingId",
                                Booking.class
                        )
                        .setParameter("bookingId", bookingId)
                        .uniqueResult();

                if (booking == null) {
                    transaction.rollback();
                    return false;
                }

                String status = booking.getStatus();

                if (status == null ||
                        status.equalsIgnoreCase("CANCELLED") ||
                        status.equalsIgnoreCase("COMPLETED")) {
                    transaction.rollback();
                    return false;
                }

                booking.setStatus("CANCELLED");

                transaction.commit();
                return true;

            } catch (Exception e) {
                if (transaction != null && transaction.isActive()) {
                    transaction.rollback();
                }
                e.printStackTrace();
                return false;
            }
        }



    }
