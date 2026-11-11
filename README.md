# PetCare - ASM JAV102

Web scaffold: Java 17, Jakarta Servlet 6.0, JSP 3.1, JSTL 3 and SQL Server.
Runtime target: Apache Tomcat 10.1. Use jakarta.servlet imports, not javax.servlet.

## Structure
- src/main/java/com/petcare/controllers: HTTP servlets
- models: data models; daos: SQL access; services: business logic
- utils: DBUtil, configuration, session, validation and date utilities
- filter, listener, websocket: reserved packages, no implementation yet
- src/main/resources: server-side configuration
- src/main/web: JSP views by customer, staff and admin roles
- src/main/web/assets: public CSS, JavaScript and images
- src/main/web/WEB-INF: web.xml and shared JSP includes
- database/petcare.sql: SQL schema; original PetCare.md is preserved
- docs/legacy-swing: archived desktop scaffold, excluded from compilation

## Build and run
1. Open pom.xml in IntelliJ and reload Maven. Select JDK 17+.
2. Run `mvn clean package` (or the Maven package lifecycle in IntelliJ).
3. Deploy target/petcare.war to Apache Tomcat 10.1.
4. Visit http://localhost:8080/petcare/ or /petcare/home.

This is a structure scaffold. JSP pages contain placeholders only.
Login, authorization filters, CRUD, booking, payments and database connection
are not implemented. Role folders are not access controls; do not place real
user data in these pages until authentication and authorization are implemented.
No database script was executed. The application no longer uses Main.java.
## JSP naming (following the sample project)
- TrangChu.jsp
- DangNhap.jsp
- register.jsp
- customer/quanLyThuCung.jsp
- customer/datLich.jsp
- customer/lichHenDanhSach.jsp
- staff/quanLyLichHen.jsp
- staff/lichLamViec.jsp
- admin/quanLiTaiKhoan.jsp
- admin/quanLyDichVu.jsp
- admin/quanLyCombo.jsp
- admin/quanLyPhong.jsp
- admin/quanLyCaLamViec.jsp

## Java naming
Model class and file names match database table names exactly: Users.java, Pets.java, Appointments.java. Every table has a model scaffold.
DAOs use paired XxxDAO interfaces and XxxDAOImpl classes, matching the reference.
Controllers use XxxServlet names; only TrangChuServlet currently has a URL mapping.
Other controllers and DAO implementations are empty scaffolds, with no business logic.
DatabaseConnection was renamed to utils/DBUtil; Session to SessionUtil; Validator to ValidationUtil.

Controllers now use Vietnamese names without accents, e.g. QuanLyTaiKhoanServlet and DatLichServlet.
