package com.petcare.services;

import com.petcare.daos.ReviewDAO;
import com.petcare.daos.ReviewDAOImpl;
import com.petcare.models.Appointments;
import com.petcare.models.Reviews;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewService {

    private static final Map<Integer, String> FRIENDLY_ERRORS = new HashMap<>();
    static {
        FRIENDLY_ERRORS.put(51001, "Hệ thống đang bận, vui lòng thử lại sau.");
        FRIENDLY_ERRORS.put(51015, "Chỉ có thể đánh giá các lịch hẹn đã hoàn thành.");
        FRIENDLY_ERRORS.put(51044, "Chỉ chủ sở hữu lịch hẹn đã hoàn thành mới được gửi đánh giá.");
        FRIENDLY_ERRORS.put(2627, "Lịch hẹn này đã được đánh giá rồi.");
        FRIENDLY_ERRORS.put(2601, "Lịch hẹn này đã được đánh giá rồi.");
    }

    private final ReviewDAO reviewDAO;

    public ReviewService() {
        this(new ReviewDAOImpl());
    }

    public ReviewService(ReviewDAO reviewDAO) {
        this.reviewDAO = reviewDAO;
    }

    public List<Appointments> getReviewableAppointments(int customerId) throws SQLException {
        return reviewDAO.findReviewableAppointments(customerId);
    }

    public List<Reviews> getCustomerReviews(int customerId) throws SQLException {
        return reviewDAO.findByCustomer(customerId);
    }

    public List<Reviews> getRecentPublicReviews(int limit) throws SQLException {
        return reviewDAO.findRecentPublicReviews(limit);
    }

    public void submitReview(int customerId, int appointmentId, int rating, String comment) throws SQLException {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Điểm đánh giá phải từ 1 đến 5 sao.");
        }
        String cleanComment = comment == null ? "" : comment.trim();
        if (cleanComment.length() > 1000) {
            throw new IllegalArgumentException("Nội dung nhận xét tối đa 1000 ký tự.");
        }
        try {
            reviewDAO.submitReview(appointmentId, customerId, rating, cleanComment);
        } catch (SQLException e) {
            throw new SQLException(
                    FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(), "Không thể gửi đánh giá. Vui lòng thử lại."),
                    e.getSQLState(), e.getErrorCode(), e);
        }
    }
}
