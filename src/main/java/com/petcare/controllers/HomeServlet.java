package com.petcare.controllers;

import com.petcare.model.ReviewItem;
import com.petcare.model.ServiceCard;
import com.petcare.models.Reviews;
import com.petcare.services.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/trang-chu", "/dat-lich"})
public class HomeServlet extends HttpServlet {

    public static List<ServiceCard> buildDefaultServices() {
        List<ServiceCard> list = new ArrayList<>();

        list.add(new ServiceCard(
                "tam-spa",
                "tam-spa",
                "Grooming & Tắm sấy", "badge-mint",
                "4.9 (840+)",
                "Grooming & Tắm Sấy Thảo Mộc Toàn Diện",
                "Làm sạch sâu với sữa tắm thảo mộc hữu cơ, ngâm bồn sục thư giãn, sấy phồng tơi mượt và xịt dưỡng tinh dầu thơm mát dài lâu.",
                Arrays.asList("Sữa tắm Organic", "Thời lượng: 45 phút", "Khử mùi & Dưỡng ẩm"),
                "Giá dịch vụ từ", "150.000 đ", "/lần"
        ));

        list.add(new ServiceCard(
                "grooming-cat-tia",
                "grooming",
                "Cắt tỉa tạo kiểu", "badge-sky",
                "5.0 (1.200+)",
                "Cắt Tỉa Tạo Kiểu Chuẩn Salon",
                "Tạo form dáng chuẩn quốc tế (Teddy Bear, Gấu tròn, Bichon, Sư tử...) bởi chuyên viên Master Groomer giàu kinh nghiệm.",
                Arrays.asList("Tạo kiểu theo yêu cầu", "Thời lượng: 90 phút", "Kéo cắt chuyên sâu"),
                "Giá dịch vụ từ", "280.000 đ", "/lần"
        ));

        list.add(new ServiceCard(
                "spa-cham-soc-da",
                "tam-spa",
                "Spa & Chăm sóc da", "badge-peach",
                "4.9 (650+)",
                "Spa Thảo Dược & Phục Hồi Da Lông",
                "Liệu trình ủ bùn khoáng và tinh chất Collagen giúp làm dịu làn da nhạy cảm, giảm rụng lông và phục hồi độ bóng mượt tự nhiên.",
                Arrays.asList("Ủ Collagen & Argan", "Thời lượng: 60 phút", "Da nhạy cảm"),
                "Giá dịch vụ từ", "350.000 đ", "/lần"
        ));

        list.add(new ServiceCard(
                "ve-sinh-tai-mong",
                "tam-spa",
                "Vệ sinh tai / móng", "badge-mint",
                "4.9 (520+)",
                "Vệ Sinh Tai, Móng & Tuyến Hôi Chuyên Sâu",
                "Nhổ lông tai êm ái, làm sạch ống tai bằng dung dịch thảo dược, cắt và mài nhẵn móng, cạo vệ sinh bàn chân và vắt tuyến hôi.",
                Arrays.asList("Dụng cụ tiệt trùng UV", "Thời lượng: 30 phút", "Êm ái không đau"),
                "Giá dịch vụ từ", "120.000 đ", "/lần"
        ));

        list.add(new ServiceCard(
                "cham-soc-suc-khoe",
                "grooming",
                "Chăm sóc sức khỏe cơ bản", "badge-sky",
                "4.8 (430+)",
                "Kiểm Tra Sức Khỏe Cơ Bản & Gỡ Rối Lông",
                "Tầm soát da lông, kiểm tra răng miệng, gỡ rối lông bết bằng xịt dưỡng Keratin và massage thư giãn giảm căng thẳng cho bé.",
                Arrays.asList("Tầm soát da & tai", "Gỡ rối không đau", "Massage tinh dầu"),
                "Giá dịch vụ từ", "180.000 đ", "/lần"
        ));

        list.add(new ServiceCard(
                "combo-cham-soc",
                "khach-san",
                "Combo tiết kiệm -20%", "badge-peach",
                "5.0 (910+)",
                "Combo Chăm Sóc Toàn Diện & Lưu Trú VIP",
                "Trọn gói Tắm sấy thảo mộc, Cắt tỉa tạo kiểu, Vệ sinh 7 bước kết hợp ủ dưỡng Collagen hoặc nghỉ dưỡng phòng VIP có camera 24/7.",
                Arrays.asList("Trọn gói 9 bước", "Ưu đãi thành viên", "Tặng phụ kiện xinh"),
                "Trọn gói ưu đãi", "390.000 đ", "/combo"
        ));

        return list;
    }

    public static List<ReviewItem> buildDefaultReviews() {
        List<ReviewItem> reviews = new ArrayList<>();

        reviews.add(new ReviewItem(
                "2 ngày trước",
                "\"Bé Miu nhà mình lông dày và hay rụng nhiều. Đưa đến Pet care làm gói tắm thảo mộc và chải lông tơ, về nhà lông mượt mà thơm nức mũi cả tuần. Các bạn chuyên viên cực kỳ cưng và nhẹ nhàng với mèo.\"",
                "assets/images/review-cat-miu.jpg",
                "Chị Thảo My & Bé Miu (Mèo Anh)",
                "Cơ sở Nguyễn Đình Chiểu, Q.3"
        ));

        reviews.add(new ReviewItem(
                "1 tuần trước",
                "\"Quy trình đặt lịch giữ chỗ 15 phút rất tiện. Đưa bé Bơ đến là được vào bồn tắm sấy ngay không cần chờ đợi. Kỹ thuật viên mài móng không làm bé giật mình, form mông trái tim cắt siêu đáng yêu!\"",
                "assets/images/review-dog-bo.jpg",
                "Anh Tuấn Khang & Bé Bơ (Corgi)",
                "Cơ sở Hoàng Cầu, Hà Nội"
        ));

        reviews.add(new ReviewItem(
                "3 tuần trước",
                "\"Gói Spa cắt tỉa ở đây là số 1! Các bạn kỹ thuật viên rất kiên nhẫn với các bé nhút nhát. Tắm xong thơm tho sạch sẽ và cắt tỉa form gấu bông siêu cưng. Lại còn được tặng 100 điểm tích lũy thành viên nữa.\"",
                "assets/images/review-dog-may.jpg",
                "Chị Lan Phương & Bé Mây (Poodle)",
                "Cơ sở Nguyễn Đình Chiểu, Q.3"
        ));

        return reviews;
    }

    private final ReviewService reviewService = new ReviewService();

    private void loadHomePageData(HttpServletRequest req) {
        req.setAttribute("services", buildDefaultServices());
        List<ReviewItem> reviews = new ArrayList<>();
        try {
            List<Reviews> dbReviews = reviewService.getRecentPublicReviews(3);
            for (Reviews r : dbReviews) {
                if (r.getComment() != null && !r.getComment().isBlank()) {
                    String stars = "★".repeat(Math.max(1, Math.min(5, r.getRating())));
                    reviews.add(new ReviewItem(
                            stars + " • " + r.getFormattedCreatedAt(),
                            "\"" + r.getComment() + "\"",
                            "assets/images/review-dog-may.jpg",
                            r.getCustomerName() + " & Bé " + r.getPetName() + " (" + r.getPetSpecies() + ")",
                            r.getSummaryLabel()
                    ));
                }
            }
        } catch (Exception ignored) {
            // Fall back to default marketing reviews if DB is unavailable.
        }
        if (reviews.isEmpty()) {
            reviews = buildDefaultReviews();
        }
        req.setAttribute("reviews", reviews);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if ("/dat-lich".equals(req.getServletPath())) {
            resp.sendRedirect(req.getContextPath() + "/customer/dat-lich");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session != null) {
            Object profileSuccess = session.getAttribute("profileSuccess");
            if (profileSuccess != null) {
                req.setAttribute("profileSuccess", profileSuccess);
                session.removeAttribute("profileSuccess");
            }
            Object profileError = session.getAttribute("profileError");
            if (profileError != null) {
                req.setAttribute("profileError", profileError);
                session.removeAttribute("profileError");
            }
        }

        loadHomePageData(req);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        resp.sendRedirect(req.getContextPath() + "/customer/dat-lich");
    }
}
