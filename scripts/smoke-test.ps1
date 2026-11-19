param(
    [string]$BaseUrl = 'http://localhost:8080/asm-jav102',
    [string]$AdminEmail = $env:PETCARE_QA_ADMIN_EMAIL,
    [string]$AdminPassword = $env:PETCARE_QA_ADMIN_PASSWORD
)
$ErrorActionPreference = 'Stop'
Import-Module Microsoft.PowerShell.Utility
$null = Get-Command Invoke-WebRequest
New-Item -ItemType Directory -Force (Join-Path $PSScriptRoot '../target') | Out-Null
$results = [System.Collections.Generic.List[object]]::new()
function Check($name, [bool]$ok) {
    $results.Add([pscustomobject]@{ Check = $name; Passed = $ok })
    if (!$ok) { Write-Warning "FAIL: $name" }
}
function Get-Page($path, $session) {
    Invoke-WebRequest ($BaseUrl + $path) -WebSession $session -SkipHttpErrorCheck -TimeoutSec 45
}
function Post-Form($path, $body, $session) {
    Invoke-WebRequest ($BaseUrl + $path) -Method Post -Body $body -WebSession $session -SkipHttpErrorCheck -TimeoutSec 45
}
$guest = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
foreach ($path in @('/home','/services.jsp','/branches.jsp','/branch-q3.jsp','/branch-thaodien.jsp','/branch-dongda.jsp','/branch-caugiay.jsp','/login','/register')) {
    $page = Get-Page $path $guest
    Check "Public page $path" ($page.StatusCode -eq 200)
}
foreach ($path in @('/profile','/customer/dat-lich','/admin/tai-khoan','/staff/quanLyLichHen.jsp')) {
    $page = Get-Page $path $guest
    Check "Anonymous blocked $path" ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/login'))
}
$page = Post-Form '/dat-lich' @{petName='QA';ownerName='QA';phone='0901770017'} $guest
Check 'Legacy booking does not claim success' ($page.Content -notmatch 'Đã giữ chỗ 15 phút cho bé')

# A dedicated QA account is reused. This script intentionally writes only test data.
$email = 'qa-smoke-20261117@petcare.test'
$password = 'QaSmoke@12345'
$phone = '0901770017'
$customer = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
$page = Post-Form '/register' @{fullName='QA Smoke Test';phone=$phone;email=$email;password=$password;confirmPassword=$password} $customer
Check 'Register or detect existing QA customer' ($page.StatusCode -eq 200 -and $page.Content -match 'thành công|đã được|đã đăng ký')
$page = Post-Form '/login' @{identifier=$email;password='WrongPassword'} $customer
Check 'Wrong password rejected' ($page.Content -match 'không chính xác')
$probe = '"><script>alert(1)</script>'
$page = Post-Form '/login' @{identifier=$probe;password='WrongPassword'} $customer
Check 'Login escapes reflected input' ($page.Content -notmatch '<script>alert\(1\)</script>')
$page = Post-Form '/register' @{fullName=$probe;phone='invalid';email='invalid';password='Password123';confirmPassword='Password123'} $customer
Check 'Register escapes reflected input' ($page.Content -notmatch '<script>alert\(1\)</script>')
$page = Post-Form '/register' @{fullName='QA';phone=$phone;email=$email;password='Password123';confirmPassword='Mismatch123'} $customer
Check 'Registration confirmation mismatch rejected' ($page.Content -match 'không khớp')
$page = Post-Form '/login' @{identifier=$email;password=$password} $customer
Check 'Customer login' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/home'))
$page = Get-Page '/profile' $customer
Check 'Profile loads without SQL mapping errors' ($page.StatusCode -eq 200 -and $page.Content -notmatch 'column name|Không thể tải thông tin')
$byPhone = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
$page = Post-Form '/login' @{identifier='+84 901 770 017';password=$password} $byPhone
Check 'Login normalizes phone' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/home'))
$page = Get-Page '/profile' $customer
$idMatch = [regex]::Match($page.Content, 'data-user-id="(\d+)"')
$customerId = $idMatch.Groups[1].Value
$page = Post-Form '/profile' @{action='updateProfile';fullName='QA <Smoke>';phone=$phone;email=$email} $customer
Check 'Profile save persists and escapes user input' ($page.Content -match 'Cập nhật hồ sơ người dùng thành công' -and $page.Content -notmatch 'value="QA <Smoke>"' -and $page.Content -match 'QA &lt;Smoke&gt;')
$page = Post-Form '/profile' @{action='updateProfile';fullName='QA Smoke Test';phone=$phone;email=$email} $customer
Check 'Restore QA profile' ($page.Content -match 'Cập nhật hồ sơ người dùng thành công')
$page = Post-Form '/profile' @{action='updateProfile';fullName='QA';phone='not-a-phone';email=$email} $customer
Check 'Invalid profile phone rejected' ($page.Content -match 'Số điện thoại không hợp lệ')
$page = Get-Page '/services.jsp' $customer
Check 'Service booking links use real booking route' ($page.Content -notmatch '/login" class="btn-svc-book"' -and $page.Content -match '/customer/dat-lich" class="btn-svc-book"')
$page = Get-Page '/admin/tai-khoan' $customer
Check 'Customer forbidden from admin' ($page.StatusCode -eq 403)
$page = Get-Page '/staff/quanLyLichHen.jsp' $customer
Check 'Customer forbidden from staff' ($page.StatusCode -eq 403)
$page = Get-Page '/customer/dat-lich' $customer
Check 'Booking form data loads' ($page.StatusCode -eq 200 -and $page.Content -notmatch 'Không tải được dữ liệu')
if ($page.Content -notmatch '>QA Pet Smoke \(') {
    $page = Post-Form '/customer/dat-lich' @{action='addPet';petName='QA Pet Smoke';petSpecies='Chó';petBreed='QA'} $customer
    Check 'Add QA pet' ($page.Content -match 'Đã thêm thú cưng')
}
$pet = [regex]::Match($page.Content, '<option value="(\d+)">QA Pet Smoke \(').Groups[1].Value
$staff = [regex]::Match($page.Content, '<option value="(\d+_\d+)">').Groups[1].Value
Check 'Bookable service and staff available' (![string]::IsNullOrEmpty($staff))
if ($pet -and $staff) {
    $invalid = Post-Form '/customer/dat-lich' @{action='book';petId=$pet;staffChoice=$staff;bookingDate='2020-01-01';bookingTime='10:00'} $customer
    Check 'Past booking rejected' ($invalid.Content -match 'phải ở trong tương lai')
    $tomorrow = (Get-Date).AddDays(1).ToString('yyyy-MM-dd')
    $invalid = Post-Form '/customer/dat-lich' @{action='book';petId='2147483647';staffChoice=$staff;bookingDate=$tomorrow;bookingTime='10:00'} $customer
    Check 'Unknown or foreign pet rejected' ($invalid.Content -match 'không thuộc tài khoản')
    $invalid = Post-Form '/customer/dat-lich' @{action='book';petId=$pet;staffChoice=$staff;bookingDate=$tomorrow;bookingTime='23:00'} $customer
    Check 'Outside shift rejected' ($invalid.Content -match 'ca làm việc|giờ mở cửa')
    # Store the successful booking slot so reruns do not create more appointments.
    $statePath = Join-Path $PSScriptRoot '../target/qa-booking-state.json'
    if (!(Test-Path $statePath)) {
        $booked = Post-Form '/customer/dat-lich' @{action='book';petId=$pet;staffChoice=$staff;bookingDate=$tomorrow;bookingTime='11:15'} $customer
        Check 'Real appointment created' ($booked.Content -match 'Mã lịch hẹn của bạn là #\d+')
        if ($booked.Content -match 'Mã lịch hẹn của bạn là #(\d+)') {
            @{date=$tomorrow;time='11:15';appointmentId=$Matches[1]} | ConvertTo-Json | Set-Content $statePath
        }
    }
    if (Test-Path $statePath) {
        $state = Get-Content $statePath -Raw | ConvertFrom-Json
        $overlap = Post-Form '/customer/dat-lich' @{action='book';petId=$pet;staffChoice=$staff;bookingDate=$state.date;bookingTime=$state.time} $customer
        Check 'Overlapping appointment rejected' ($overlap.Content -match 'trùng giờ')
    }
}
if ($AdminEmail -and $AdminPassword -and $customerId) {
    $admin = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $page = Post-Form '/login' @{identifier=$AdminEmail;password=$AdminPassword} $admin
    Check 'Admin list renders without 500' ($page.StatusCode -eq 200 -and $page.Content -match 'Quản lý tài khoản')
    $adminId = [regex]::Match($page.Content, 'data-user-id="(\d+)"').Groups[1].Value
    $page = Post-Form '/admin/tai-khoan' @{action='toggleActive';userId=$adminId;active='false'} $admin
    Check 'Admin cannot lock self' ($page.Content -match 'Không thể tự khóa')
    $page = Post-Form '/admin/tai-khoan' @{action='resetPassword';userId='2147483647';newPassword='InvalidTarget@123'} $admin
    Check 'Unknown password reset target rejected' ($page.Content -notmatch 'Đã đặt lại mật khẩu')
    # Role/lock tests need an account without pets or active bookings (DB invariant).
    $email = 'qa-admin-target-20261117@petcare.test'
    $phone = '0901770018'
    $page = Post-Form '/admin/tai-khoan' @{action='create';fullName='QA Admin Target';phone=$phone;email=$email;password=$password;role='CUSTOMER'} $admin
    Check 'Admin creates account or detects duplicate' ($page.StatusCode -eq 200 -and $page.Content -match 'Đã tạo tài khoản|đã được sử dụng|đã đăng ký')
    $customer = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $page = Post-Form '/login' @{identifier=$email;password=$password} $customer
    $page = Get-Page '/profile' $customer
    $customerId = [regex]::Match($page.Content, 'data-user-id="(\d+)"').Groups[1].Value
    $page = Post-Form '/admin/tai-khoan' @{action='update';userId=$customerId;fullName='QA Admin Target';phone=$phone;email=$email;role='STAFF'} $admin
    Check 'Admin updates QA role' ($page.StatusCode -eq 200 -and $page.Content -match 'Đã lưu thông tin')
    $page = Get-Page '/profile' $customer
    Check 'Role update persisted' ($page.Content -match 'STAFF')
    $page = Post-Form '/admin/tai-khoan' @{action='toggleActive';userId=$customerId;active='false'} $admin
    Check 'Admin locks QA account' ($page.StatusCode -eq 200 -and $page.Content -match 'Đã cập nhật trạng thái')
    $page = Get-Page '/customer/dat-lich' $customer
    Check 'Locked existing session rejected' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/login'))
    $locked = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $page = Post-Form '/login' @{identifier=$email;password=$password} $locked
    Check 'Locked account cannot login' ($page.Content -match 'bị khóa')
    $page = Post-Form '/admin/tai-khoan' @{action='toggleActive';userId=$customerId;active='true'} $admin
    Check 'Admin unlocks QA account' ($page.StatusCode -eq 200 -and $page.Content -match 'Đã cập nhật trạng thái')
    $page = Post-Form '/admin/tai-khoan' @{action='update';userId=$customerId;fullName='QA Smoke Test';phone=$phone;email=$email;role='CUSTOMER'} $admin
    Check 'Restore QA customer role' ($page.StatusCode -eq 200 -and $page.Content -match 'Đã lưu thông tin')
    # Only the disposable QA account's password is changed and restored.
    $page = Post-Form '/admin/tai-khoan' @{action='resetPassword';userId=$customerId;newPassword='QaReset@12345'} $admin
    Check 'Admin resets QA password' ($page.Content -match 'Đã đặt lại mật khẩu')
    $resetSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $page = Post-Form '/login' @{identifier=$email;password=$password} $resetSession
    Check 'Old QA password rejected after reset' ($page.Content -match 'không chính xác')
    $page = Post-Form '/login' @{identifier=$email;password='QaReset@12345'} $resetSession
    Check 'New QA password accepted' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/home'))
    $page = Post-Form '/profile' @{action='changePassword';currentPassword='WrongPassword';newPassword='QaChanged@12345';confirmPassword='QaChanged@12345'} $resetSession
    Check 'Password change requires current password' ($page.Content -match 'Mật khẩu hiện tại không chính xác')
    $page = Post-Form '/profile' @{action='changePassword';currentPassword='QaReset@12345';newPassword=$password;confirmPassword=$password} $resetSession
    Check 'Self-service password change succeeds' ($page.Content -match 'Đổi mật khẩu thành công')
    $page = Post-Form '/login' @{identifier=$email;password=$password} $resetSession
    Check 'Restored QA password accepted' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/home'))
}
$page = Get-Page '/logout' $customer
$page = Get-Page '/profile' $customer
Check 'Logout clears session' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/login'))
$results | Format-Table -AutoSize
$results | ConvertTo-Json | Set-Content (Join-Path $PSScriptRoot '../target/qa-smoke-results.json')
if ($results.Passed -contains $false) { exit 1 }
