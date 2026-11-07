package com.petcare.controller;

import com.petcare.model.BookingRequest;
import com.petcare.model.ReviewItem;
import com.petcare.model.ServiceCard;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
                "Tắm & Spa Vệ Sinh", "badge-mint",
                "4.9 (840+)",
                "Tắm Spa Thảo Mộc & Vệ Sinh Toàn Diện",
                "Vệ sinh tai, vắt tuyến hôi, bấm mài móng êm ái, ngâm bồn tắm thảo mộc dưỡng ẩm lông và sấy phồng thơm...",
                Arrays.asList("Sữa tắm hữu cơ Organic", "Thời lượng: 45 phút", "Vắt tuyến hôi sạch sẽ"),
                "Chi phí niêm yết", "150.000 đ", ""
        ));

        list.add(new ServiceCard(
                "grooming-cat-tia",
                "grooming",
                "Grooming & Cắt Tỉa", "badge-sky",
                "5.0 (1.200+)",
                "Grooming & Cắt Tỉa Lông Tạo Kiểu",
                "Cắt tỉa theo form dáng chuẩn (Teddy bear, sư tử, gấu tròn...), gỡ rối lông, tỉa gọn chân và mắt, tạo phồng...",
                Arrays.asList("Tạo kiểu theo yêu cầu", "Kéo cắt chuyên nghiệp"),
                "Chi phí niêm yết", "280.000 đ", ""
        ));

        list.add(new ServiceCard(
                "spa-nhuom-long",
                "grooming",
                "Spa & Thẩm Mỹ Cao Cấp", "badge-peach",
                "4.9 (650+)",
                "Spa Cắt Tỉa & Nhuộm Lông Thẩm Mỹ Cao Cấp",
                "Dưỡng lông tơ bóng mượt với collagen organic, tạo kiểu tai/đuôi thời thượng, xịt nước hoa cao cấp an toàn",
                Arrays.asList("Collagen dưỡng mượt lông", "Thuốc nhuộm thảo mộc tự nhiên"),
                "Chi phí từ", "350.000 đ", ""
        ));

        list.add(new ServiceCard(
                "cao-long-phuc-hoi",
                "tam-spa",
                "Phục Hồi & Vệ Sinh", "badge-mint",
                "4.8 (390+)",
                "Cạo Lông Mát Mẻ & Phục Hồi Lông Rối",
                "Cạo lông sạch sẽ thoáng mát mùa nóng, gỡ búi lông rối bết không đau rát, vệ sinh kẽ móng và massage nhẹ...",
                Arrays.asList("Tông-đơ êm không ồn", "Massage tinh dầu thư giãn"),
                "Chi phí niêm yết", "180.000 đ", ""
        ));

        list.add(new ServiceCard(
                "khach-san-vip",
                "khach-san",
                "Khách Sạn & Lưu Trú", "badge-peach",
                "5.0 (420+)",
                "Khách Sạn Thú Cưng Lưu Trú VIP",
                "Phòng riêng điều hòa 24/7, camera theo dõi trực tiếp cho chủ qua app, sân chơi vui nhộn 2 lần/ngày, khẩu...",
                Arrays.asList("Camera 24/7 trực tiếp", "Sân chơi tương tác riêng"),
                "Chi phí từ", "200.000 đ", "/ngày"
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

    private void loadHomePageData(HttpServletRequest req) {
        req.setAttribute("services", buildDefaultServices());
        req.setAttribute("reviews", buildDefaultReviews());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        loadHomePageData(req);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String ownerName = req.getParameter("ownerName");
        String phone = req.getParameter("phone");
        String petName = req.getParameter("petName");
        String petType = req.getParameter("petType");
        String weightRange = req.getParameter("weightRange");
        String serviceName = req.getParameter("serviceName");
        String branch = req.getParameter("branch");
        String bookingDate = req.getParameter("bookingDate");
        String timeSlot = req.getParameter("timeSlot");
        String notes = req.getParameter("notes");

        BookingRequest booking = new BookingRequest(
                ownerName, phone, petName, petType, weightRange,
                serviceName, branch, bookingDate, timeSlot, notes
        );

        req.setAttribute("bookingSuccess", true);
        req.setAttribute("bookingData", booking);
        loadHomePageData(req);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
