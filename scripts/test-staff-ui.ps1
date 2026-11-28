param([string]$BaseUrl='http://127.0.0.1:18091/petcare')
# Run only against the disposable staff-ui-fixture.sql database.
$ErrorActionPreference='Stop'
Import-Module Microsoft.PowerShell.Utility
$null=Get-Command Invoke-WebRequest
$checks=[System.Collections.Generic.List[object]]::new()
$staff=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
function Check($name,$ok) {
    $checks.Add([pscustomobject]@{Check=$name;Passed=[bool]$ok})
    if(!$ok) {throw "FAIL: $name"}
}
function GetPage($path,$session=$staff) {Invoke-WebRequest "$BaseUrl$path" -WebSession $session -SkipHttpErrorCheck}
function PostForm($path,$body,$session=$staff) {Invoke-WebRequest "$BaseUrl$path" -Method Post -Body $body -WebSession $session -SkipHttpErrorCheck}
$routes=@('/staff/lich-hen','/staff/lich-lam-viec','/staff/dat-lich-tai-quay')
try {
    $guest=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
    foreach($route in $routes) {Check "Guest blocked $route" ((GetPage $route $guest).BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/login'))}
    $customer=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $null=PostForm '/login' @{identifier='staff-qa-customer@petcare.test';password='Admin@123'} $customer
    foreach($route in $routes) {Check "Customer forbidden $route" ((GetPage $route $customer).StatusCode -eq 403)}
    $null=PostForm '/login' @{identifier='staff-qa@petcare.test';password='Admin@123'}
    foreach($route in $routes) {
        $page=GetPage $route
        if($page.StatusCode -ne 200) {$page.Content | Set-Content target/staff-http-failure.html}
        Check "Staff page renders $route" ($page.StatusCode -eq 200)
        foreach($nav in $routes) {Check "Navigation $route to $nav" ($page.Content.Contains($nav))}
    }
    foreach($legacy in @('quanLyLichHen.jsp','lichLamViec.jsp','datLichTaiQuay.jsp')) {
        Check "Legacy route redirects $legacy" (!(GetPage "/staff/$legacy").BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('.jsp'))
    }
    Check 'Protected view is inaccessible' ((GetPage '/WEB-INF/views/staff/lichLamViec.jsp').StatusCode -eq 404)
    $page=GetPage '/staff/lich-hen'
    $fixtureDate=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::UtcNow,'SE Asia Standard Time').AddDays(1).ToString('yyyy-MM-dd')
    $page=GetPage "/staff/lich-hen?date=$fixtureDate"
    Check 'Assigned service lines rendered for selected day' ($page.Content.Contains('QA Bông') -and $page.Content.Contains('QA Lucky'))
    foreach($route in @('/staff/lich-hen','/staff/dat-lich-tai-quay')) {
        Check "Missing CSRF rejected $route" ((PostForm $route @{action='timKhach'}).StatusCode -eq 403)
        Check "Wrong CSRF rejected $route" ((PostForm $route @{csrfToken='wrong';action='timKhach'}).StatusCode -eq 403)
    }
    $page=GetPage '/staff/dat-lich-tai-quay'
    $token=[regex]::Match($page.Content,'name="csrfToken" value="([^"]+)"').Groups[1].Value
    Check 'CSRF token issued' (![string]::IsNullOrEmpty($token))
    $page=PostForm '/staff/dat-lich-tai-quay' @{csrfToken=$token;action='timKhach';phone='0901770203';fullName=''}
    Check 'Existing customer lookup renders booking form' ($page.StatusCode -eq 200 -and $page.Content.Contains('counter-staffChoice'))
    Check 'Customer attributes escaped' ($page.Content.Contains('&lt;b&gt;Thử&lt;/b&gt;') -and !$page.Content.Contains('<b>Thử</b>'))
    Check 'All counter POST forms carry token' ([regex]::Matches($page.Content,'name="csrfToken"').Count -eq 3)
    $page=PostForm '/staff/dat-lich-tai-quay' @{csrfToken=$token;action='themThuCung';customerId='3';petName='QA';petSpecies=''}
    Check 'Invalid pet retains customer and booking context' ($page.StatusCode -eq 200 -and $page.Content.Contains('counter-staffChoice') -and $page.Content.Contains('QA Bông'))
    $empty=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $null=PostForm '/login' @{identifier='staff-empty@petcare.test';password='Admin@123'} $empty
    foreach($route in $routes) {Check "Empty staff renders $route" ((GetPage $route $empty).StatusCode -eq 200)}
} finally {
    $checks | ConvertTo-Json | Set-Content target/staff-ui-http-results.json
    $checks | Format-Table -AutoSize
}
