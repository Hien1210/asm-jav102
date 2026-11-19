param([string]$BaseUrl='http://127.0.0.1:18090/petcare')
# Requires the disposable admin-operations-fixture.sql database; does not use real customer data.
$ErrorActionPreference='Stop'
Import-Module Microsoft.PowerShell.Utility
$null=Get-Command Invoke-WebRequest
$checks=[System.Collections.Generic.List[object]]::new()
$admin=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
function Check($name,$ok) {
    $checks.Add([pscustomobject]@{Check=$name;Passed=[bool]$ok})
    if(!$ok) {throw "FAIL: $name"}
}
function GetPage($path,$session=$admin) {Invoke-WebRequest "$BaseUrl$path" -WebSession $session -SkipHttpErrorCheck -TimeoutSec 30}
function PostForm($path,$body,$session=$admin) {Invoke-WebRequest "$BaseUrl$path" -Method Post -Body $body -WebSession $session -SkipHttpErrorCheck -TimeoutSec 30}
$calendar='/admin/lich-hen?from=2099-06-01&to=2099-06-04'
try {
    $guest=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
    foreach($path in @('/admin/lich-hen','/admin/bao-cao')) {
        $page=GetPage $path $guest
        Check "Guest blocked $path" ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/login'))
    }
    foreach($email in @('ops-staff@petcare.test','ops-customer@petcare.test')) {
        $session=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
        $null=PostForm '/login' @{identifier=$email;password='Admin@123'} $session
        foreach($path in @('/admin/lich-hen','/admin/bao-cao?format=csv')) {
            $page=GetPage $path $session
            Check "$email forbidden $path" ($page.StatusCode -eq 403)
        }
    }
    $page=PostForm '/login' @{identifier='ops-admin@petcare.test';password='Admin@123'}
    Check 'Admin login' ($page.StatusCode -eq 200 -and $page.Content.Contains('Được bảo vệ'))
    $page=GetPage $calendar
    if($page.StatusCode -ne 200) {$page.Content|Set-Content 'target/operations-http-failure.html'}
    Check 'Calendar renders three appointments' ($page.StatusCode -eq 200 -and [regex]::Matches($page.Content,'data-appointment-id=').Count -eq 3)
    Check 'Sidebar includes both modules' ($page.Content.Contains('Báo cáo hệ thống') -and $page.Content.Contains('/admin/lich-hen'))
    $page=GetPage "$calendar&type=BOARDING"
    Check 'Type filter' ([regex]::Matches($page.Content,'data-appointment-id=').Count -eq 1)
    $page=GetPage "$calendar&q=Ops%20Miu"
    Check 'Pet search' ([regex]::Matches($page.Content,'data-appointment-id=').Count -eq 1)
    $page=GetPage "$calendar&q=%25"
    Check 'Literal wildcard search' ([regex]::Matches($page.Content,'data-appointment-id=').Count -eq 0)
    $injection=[Uri]::EscapeDataString("' OR 1=1--")
    $page=GetPage "$calendar&q=$injection"
    Check 'Search remains parameterized' ($page.StatusCode -eq 200 -and [regex]::Matches($page.Content,'data-appointment-id=').Count -eq 0)
    foreach($invalid in @('/admin/lich-hen?from=invalid',"$calendar&status=HACK","$calendar&type=HACK","$calendar&page=-1",'/admin/bao-cao?from=2020-01-01&to=2026-11-19')) {
        $page=GetPage $invalid
        Check "Invalid filter rejected $invalid" ($page.StatusCode -eq 400)
    }
    $page=GetPage "$calendar&id=1"
    Check 'Full service detail' ($page.StatusCode -eq 200 -and $page.Content.Contains('Ops Bath') -and $page.Content.Contains('Ops Trim') -and $page.Content.Contains('Ops Staff'))
    $page=GetPage "$calendar&id=3"
    Check 'Boarding room detail' ($page.StatusCode -eq 200 -and $page.Content.Contains('OPS-01'))
    $token=[regex]::Match($page.Content,'name="csrfToken" value="([^"]+)"').Groups[1].Value
    Check 'Status form has CSRF' (![string]::IsNullOrEmpty($token))
    $page=PostForm '/admin/lich-hen' @{action='status';appointmentId='3';expectedStatus='PENDING';status='CONFIRMED'}
    Check 'Missing CSRF rejected' ($page.StatusCode -eq 403)
    $page=PostForm '/admin/bao-cao' @{csrfToken=$token}
    Check 'Report cannot mutate data' ($page.StatusCode -eq 405)
    $page=GetPage '/admin/bao-cao'
    if($page.StatusCode -ne 200) {$page.Content|Set-Content 'target/operations-report-failure.html'}
    Check 'Report renders real QA receipts' ($page.StatusCode -eq 200 -and $page.Content.Contains('350.000') -and $page.Content.Contains('50.000') -and $page.Content.Contains('300.000'))
    $page=GetPage '/admin/bao-cao?format=csv'
    Check 'CSV download content type' ($page.Headers.'Content-Type' -match 'text/csv')
    Check 'CSV money matches report' ($page.Content.Contains('350000.00,50000.00,300000.00'))
    $page=PostForm '/admin/lich-hen' @{csrfToken=$token;action='status';appointmentId='3';expectedStatus='PENDING';status='CANCELLED';cancelReason=''}
    Check 'Cancellation requires reason' ($page.Content.Contains('Vui lòng nhập lý do hủy'))
    $page=PostForm '/admin/lich-hen' @{csrfToken=$token;action='status';appointmentId='3';expectedStatus='PENDING';status='CONFIRMED'}
    Check 'Valid status update' ($page.Content.Contains('Đã cập nhật lịch hẹn #3') -and $page.Content.Contains('name="expectedStatus" value="CONFIRMED"'))
    $page=PostForm '/admin/lich-hen' @{csrfToken=$token;action='status';appointmentId='3';expectedStatus='PENDING';status='CONFIRMED'}
    Check 'Stale status request rejected' ($page.Content.Contains('Trạng thái lịch đã thay đổi'))
} finally {
    $checks|ConvertTo-Json|Set-Content (Join-Path $PSScriptRoot '../target/admin-operations-http-results.json') -Encoding utf8
}
Write-Output "PASS $($checks.Count)/$($checks.Count) operations HTTP checks"
