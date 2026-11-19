param([string]$BaseUrl='http://127.0.0.1:18089/petcare')
# Disposable QA environment seeded by the admin test setup, never production accounts.
$ErrorActionPreference='Stop'
Import-Module Microsoft.PowerShell.Utility
$null=Get-Command Invoke-WebRequest
$admin=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
$checks=[System.Collections.Generic.List[object]]::new()
function Check($name,$ok) {
    $checks.Add([pscustomobject]@{Check=$name;Passed=[bool]$ok})
    if(!$ok) { throw "FAIL: $name" }
}
function Request($path,$body,$session=$admin) {
    Invoke-WebRequest "$BaseUrl$path" -Method Post -Body $body -WebSession $session -SkipHttpErrorCheck -TimeoutSec 30
}
function AdminPost($body) {
    $page=Invoke-WebRequest "$BaseUrl/admin/tai-khoan" -WebSession $admin -TimeoutSec 30
    $body['csrfToken']=[regex]::Match($page.Content,'name="csrfToken" value="([^"]+)"').Groups[1].Value
    Request '/admin/tai-khoan' $body
}
try {
    $page=Request '/login' @{identifier='qa-admin@petcare.test';password='Admin@123'}
    Check 'Admin authenticated' ($page.Content.Contains('Quản lý tài khoản'))
    $email='qa-http-account-'+[guid]::NewGuid().ToString('N').Substring(0,6)+'@petcare.test'
    $page=AdminPost @{action='create';fullName='QA HTTP Account';email=$email;phone='';role='CUSTOMER';password='QaInitial@123'}
    Check 'Create account' ($page.Content.Contains('Đã tạo tài khoản mới.'))
    $row=@([regex]::Matches($page.Content,'(?s)<tr(?:\s[^>]*)?>.*?</tr>') | Where-Object {$_.Value.Contains($email)})[0].Value
    $id=[regex]::Match($row,'name="userId" value="(\d+)"').Groups[1].Value
    Check 'Created account ID' (![string]::IsNullOrEmpty($id))
    $page=AdminPost @{action='update';userId=$id;fullName='QA HTTP Updated';email=$email;phone='';role='STAFF'}
    Check 'Update account role' ($page.Content.Contains('Đã lưu thông tin tài khoản.'))
    $userSession=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $page=Request '/login' @{identifier=$email;password='QaInitial@123'} $userSession
    Check 'New account can log in' (!$page.Content.Contains('không chính xác'))
    $page=AdminPost @{action='toggleActive';userId=$id;active='false'}
    Check 'Lock account' ($page.Content.Contains('Đã cập nhật trạng thái tài khoản.'))
    $page=Invoke-WebRequest "$BaseUrl/staff/quanLyLichHen.jsp" -WebSession $userSession -SkipHttpErrorCheck -TimeoutSec 30
    Check 'Existing session revoked on lock' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/login'))
    $page=AdminPost @{action='toggleActive';userId=$id;active='true'}
    Check 'Unlock account' ($page.Content.Contains('Đã cập nhật trạng thái tài khoản.'))
    $page=AdminPost @{action='resetPassword';userId=$id;newPassword='QaReset@12345'}
    Check 'Reset password' ($page.Content.Contains('Đã đặt lại mật khẩu.'))
    $fresh=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $page=Request '/login' @{identifier=$email;password='QaInitial@123'} $fresh
    Check 'Old password rejected' ($page.Content.Contains('không chính xác'))
    $page=Request '/login' @{identifier=$email;password='QaReset@12345'} $fresh
    Check 'New password accepted' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/home'))
    $page=AdminPost @{action='toggleActive';userId='1';active='false'}
    Check 'Self lock rejected' ($page.Content.Contains('Không thể tự khóa'))
    $page=AdminPost @{action='resetPassword';userId='2147483647';newPassword='QaReset@12345'}
    Check 'Unknown reset target rejected' ($page.Content.Contains('Tài khoản không tồn tại.'))
} finally {
    $checks | ConvertTo-Json | Set-Content (Join-Path $PSScriptRoot '../target/admin-account-http-results.json') -Encoding utf8
}
Write-Output "PASS $($checks.Count)/$($checks.Count) account HTTP checks"
