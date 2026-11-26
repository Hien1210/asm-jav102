package com.petcare.services;

import com.petcare.daos.ReviewDAO;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.sql.SQLException;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.*;

class ReviewServiceTest {

    @Test
    void rejectsOutOfRangeRatingAndOverlongComment() {
        ReviewService service = new ReviewService(null);
        assertThrows(IllegalArgumentException.class, () -> service.submitReview(1, 10, 0, "ok"));
        assertThrows(IllegalArgumentException.class, () -> service.submitReview(1, 10, 6, "ok"));
        assertThrows(IllegalArgumentException.class, () -> service.submitReview(1, 10, 5, "x".repeat(1001)));
    }

    @Test
    void translatesDuplicateAndIncompleteSqlErrors() {
        ReviewDAO dupDao = (ReviewDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{ReviewDAO.class},
                (p, m, a) -> { throw new SQLException("Duplicate", "23000", 2627); });
        SQLException dupEx = assertThrows(SQLException.class, () ->
                new ReviewService(dupDao).submitReview(1, 10, 5, "Tốt"));
        assertTrue(dupEx.getMessage().contains("đã được đánh giá"));

        ReviewDAO notDoneDao = (ReviewDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{ReviewDAO.class},
                (p, m, a) -> { throw new SQLException("Not completed", "S0000", 51044); });
        SQLException notDoneEx = assertThrows(SQLException.class, () ->
                new ReviewService(notDoneDao).submitReview(1, 10, 5, "Tốt"));
        assertTrue(notDoneEx.getMessage().contains("hoàn thành"));
    }

    @Test
    void submitsValidReview() throws Exception {
        AtomicInteger savedRating = new AtomicInteger();
        ReviewDAO okDao = (ReviewDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{ReviewDAO.class},
                (p, m, a) -> {
                    if ("submitReview".equals(m.getName())) {
                        savedRating.set((int) a[2]);
                    }
                    return null;
                });
        new ReviewService(okDao).submitReview(1, 10, 5, "Rất hài lòng!");
        assertEquals(5, savedRating.get());
    }
}
