package com.petcare.daos;

import com.petcare.models.Appointments;
import com.petcare.models.Reviews;

import java.sql.SQLException;
import java.util.List;

public interface ReviewDAO {

    /** Submits a review for a COMPLETED appointment via dbo.SubmitReview. */
    void submitReview(int appointmentId, int customerId, int rating, String comment) throws SQLException;

    /** Reviews already submitted by the given customer. */
    List<Reviews> findByCustomer(int customerId) throws SQLException;

    /** Customer's COMPLETED appointments that have not yet been reviewed. */
    List<Appointments> findReviewableAppointments(int customerId) throws SQLException;

    /** Latest public customer reviews (for homepage display). */
    List<Reviews> findRecentPublicReviews(int limit) throws SQLException;
}
