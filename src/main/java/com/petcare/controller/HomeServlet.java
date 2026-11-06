package com.petcare.controller;

import com.petcare.model.BookingRequest;
import com.petcare.model.ServiceCard;
import com.petcare.model.ServiceComparison;
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
                "tam-cho-meo",
                "SPA VỆ SINH", "badge-green",
                "Từ 60.000đ", "price-orange",
                "Tắm chó mèo",
                "Làm sạch lông, khử mùi, sấy khô kỹ và kiểm tra da lông trong một lần chăm sóc nhẹ nhàng.",
                "assets/images/service-bath.jpg",
                Arrays.asList(
                        "Tắm bọt thảo dược, sấy khô chải tơ lông",
                        "Vệ sinh tai, bấm mài móng, cạo bàn",
                        "Vắt tuyến hôi và kiểm tra da lông cơ bản"
                ),
                "bullet-green",
                "Xem chi tiết & Đặt lịch", "#dat-lich-section", "link-green", false
        ));

        list.add(new ServiceCard(
                "grooming",
                "TẠO KIỂU CHO CHÓ", "badge-orange",
                "Từ 250.000đ", "price-orange",
                "Grooming / cắt tỉa lông chó",
                "Cắt tỉa gọn đẹp, xử lý lông rối và tư vấn kiểu lông phù hợp dáng chó, mùa nóng và thói quen chăm sóc.",
                "assets/images/service-grooming.jpg",
                Arrays.asList(
                        "Tư vấn dáng lông chuẩn breed trước khi làm",
                        "Bao gồm trọn gói dịch vụ tắm sấy spa",
                        "Có nhuộm lông theo yêu cầu an toàn"
                ),
                "bullet-orange",
                "Xem chi tiết & Đặt lịch", "#dat-lich-section", "link-orange", false
        ));

        list.add(new ServiceCard(
                "cao-long",
                "DỊCH VỤ THEO TÌNH TRẠNG", "badge-indigo",
                "Theo cân nặng", "price-dark",
                "Cạo lông chó mèo",
                "Cạo hoặc tỉa ngắn khi lông rối bết, khó vệ sinh hoặc có nhu cầu chăm sóc phù hợp; trao đổi tình trạng da lông trước khi làm.",
                "assets/images/service-shaving.jpg",
                Arrays.asList(
                        "Kiểm tra bề mặt da trước khi tiến hành",
                        "Độ dài lưỡi cạo an toàn, không phạm da",
                        "Cân nhắc kỹ với mèo hoặc pet khó hợp tác"
                ),
                "bullet-slate",
                "Xem chi tiết & Đặt lịch", "#dat-lich-section", "link-dark", false
        ));

        list.add(new ServiceCard(
                "ve-ran",
                "TƯ VẤN SẢN PHẨM", "badge-sky",
                "Theo sản phẩm", "price-sky",
                "Ve rận, bọ chét",
                "Tư vấn sản phẩm nhỏ gáy hoặc xịt phù hợp, hướng dẫn dùng đúng cách và nhắc vệ sinh môi trường sống để hạn chế tái xuất hiện.",
                "assets/images/service-flea.jpg",
                Arrays.asList(
                        "Kiểm tra phân tích da lông ban đầu",
                        "Hướng dẫn nhỏ gáy / xịt đúng cân nặng",
                        "Nhắc nhở vệ sinh ổ nằm và thảm lót"
                ),
                "bullet-sky",
                "Tư vấn dùng thuốc", "#dat-lich-section", "link-sky", false
        ));

        list.add(new ServiceCard(
                "noi-tru",
                "NỘI TRÚ", "badge-peach",
                "Từ 60.000đ/ngày", "price-orange",
                "Nội trú chó mèo",
                "Trông giữ ngắn ngày tại cơ sở, có chỗ nghỉ riêng, cho ăn theo lịch và ghi chú thói quen cần lưu ý.",
                "assets/images/service-boarding.jpg",
                Arrays.asList(
                        "Khẩu phần ăn 2 lần/ngày đúng giờ",
                        "Có thể gửi đồ ăn và đồ chơi riêng của pet",
                        "Cập nhật video sinh hoạt hằng ngày cho chủ"
                ),
                "bullet-orange",
                "Đặt phòng nội trú", "#dat-lich-section", "link-orange", false
        ));

        list.add(new ServiceCard(
                "pet-shop",
                "CỬA HÀNG", "badge-mint",
                "Mua online", "price-green",
                "Pet shop tại Vinh",
                "Gợi ý thức ăn, phụ kiện và sản phẩm chăm sóc hằng ngày; kênh mua online đặt tại petshopvinh.vn.",
                "assets/images/service-petshop.jpg",
                Arrays.asList(
                        "Thức ăn hạt, pate dinh dưỡng, phụ kiện",
                        "Sữa tắm, lược chải, cát vệ sinh chuyên dụng",
                        "Giao hàng nhanh nội thành TP. Vinh"
                ),
                "bullet-green",
                "Đến petshopvinh.vn", "https://petshopvinh.vn", "link-green", true
        ));

        return list;
    }

    public static List<ServiceComparison> buildDefaultComparisons() {
        List<ServiceComparison> list = new ArrayList<>();

        list.add(new ServiceComparison(
                "Tắm chó mèo",
                "Pet có mùi, lông bết, lâu chưa vệ sinh hoặc khó tự tắm tại nhà.",
                "Tắm, sấy khô, chải lông, vệ sinh tai, móng và kiểm tra da lông cơ bản.",
                "Pet đang mệt, ho, tiêu hóa bất thường, da đỏ hoặc từng rất sợ tắm/sấy.",
                "Đặt lịch", "btn-table-green", "Tắm chó mèo (Spa vệ sinh)"
        ));

        list.add(new ServiceComparison(
                "Grooming / cắt tỉa",
                "Chó lông rối, dày, nóng, mất form hoặc chủ nuôi muốn tạo kiểu rõ hơn.",
                "Tư vấn form, gỡ rối, tắm sấy, cắt tỉa, tạo kiểu hoặc nhuộm khi phù hợp.",
                "Lông rối sát da, cần giữ form đặc biệt, nhuộm màu hoặc khó hợp tác.",
                "Đặt lịch", "btn-table-orange", "Grooming / cắt tỉa lông chó"
        ));

        list.add(new ServiceComparison(
                "Cạo lông chó mèo",
                "Chó mèo rối bết nặng hoặc cần cạo gọn theo tình trạng da lông; cạo lông máu Poodle không bắt buộc.",
                "Kiểm tra lông da, cạo theo phạm vi thống nhất, có thể kết hợp tắm sấy theo combo.",
                "Mèo/chó khó tính, lông rối sát da, da đỏ kích ứng hoặc chủ chỉ muốn cạo vì sợ nóng.",
                "Đặt lịch", "btn-table-soft", "Cạo lông chó mèo"
        ));

        list.add(new ServiceComparison(
                "Ve rận, bọ chét",
                "Pet ngứa gãi, thấy ve/bọ chét hoặc cần chọn nhỏ gáy/xịt đúng cân nặng.",
                "Kiểm tra da lông, tư vấn sản phẩm phù hợp và nhắc vệ sinh ổ nằm, khăn, thảm.",
                "Pet còn nhỏ, già yếu, da trầy đỏ hoặc đã dùng sản phẩm ve rận gần đây.",
                "Tư vấn", "btn-table-sky", "Tư vấn sản phẩm ve rận, bọ chét"
        ));

        list.add(new ServiceComparison(
                "Nội trú chó mèo",
                "Chủ nuôi đi vắng, cần gửi pet theo ngày và muốn có nơi theo dõi ăn uống.",
                "Cho ăn, nước uống, ghi chú thói quen, đồ ăn riêng và liên hệ khi phát sinh.",
                "Pet đang bệnh, rất nhát, hung dữ, kén ăn hoặc cần dùng thuốc/sản phẩm riêng.",
                "Đặt chỗ", "btn-table-orange", "Nội trú chó mèo"
        ));

        list.add(new ServiceComparison(
                "Pet shop tại Vinh",
                "Cần mua thức ăn, vệ sinh, phụ kiện hoặc hỏi sản phẩm phù hợp theo từng pet.",
                "Gợi ý nhóm hàng và dẫn sang petshopvinh.vn để xem sản phẩm, giá, đặt hàng.",
                "Pet đang đổi thức ăn, da lông nhạy cảm hoặc cần chọn sản phẩm theo cân nặng.",
                "Xem shop", "btn-table-darkgreen", "Pet shop tại Vinh"
        ));

        return list;
    }

    private void loadHomePageData(HttpServletRequest req) {
        req.setAttribute("services", buildDefaultServices());
        req.setAttribute("comparisons", buildDefaultComparisons());
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

