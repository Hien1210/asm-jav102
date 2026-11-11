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
Login, authorization filters, CRUD, booking and payments
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

## SQL Server connection
DBUtil.getConnection() reads DB_HOST, DB_PORT, DB_NAME, DB_USER and DB_PASSWORD
from environment variables, overriding application.properties and the external file.
Alternatively set this IntelliJ Run Configuration VM option (also for Tomcat):

    -Dpetcare.config=F:/asm-jav102/application-local.properties

The external application-local.properties is ignored by Git and is outside
src/main/resources so it is not packaged into the WAR. Do not copy it there.
Run com.petcare.utils.DatabaseConnectionTest to check with SELECT 1.
Use try (Connection connection = DBUtil.getConnection()) in DAO methods.

The previous local development configuration enabled trustServerCertificate because the server's
certificate is not trusted by this Java installation. Traffic remains encrypted,
but server identity is not verified in this local configuration. The shared default
remains false; configure a trusted certificate for deployed environments.

Connection status: server reachable; SQL Server returned login failure 18456.
Verify credentials and that petcare_backend has access to the PetCare database.
## URL configuration update
External configuration supports db.url, db.username and db.password; DB_URL, DB_USER and DB_PASSWORD override those keys. An explicit db.url controls TLS options.
The current external file keeps trustServerCertificate=false. Java currently rejects the server certificate; configure a trusted certificate/truststore to use this setting.

## Current TLS configuration
The public certificate was copied from C:/PetCare-Certs/petcare-sqlserver.cer.
Its SHA-1 thumbprint matches the supplied reference:
657A12AE9D335F04FB9068B56770333232F8F7E0.
The certificate includes DNS hung211.tail1f20d2.ts.net.
A separate PKCS12 truststore is stored at certs/petcare-truststore.p12.
The external application-local.properties supplies db.trustStore and
 db.trustStorePassword; neither credentials nor truststore are packaged in WAR.
TLS verification succeeded with encrypt=true and trustServerCertificate=false.
The latest SELECT 1 test was blocked by SQL Server login error 18456.
The database administrator must inspect the server ERRORLOG state for this login.