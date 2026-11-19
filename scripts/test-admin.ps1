param(
    [string]$BaseUrl = 'http://127.0.0.1:18089/petcare',
    [string]$AdminEmail = 'qa-admin@petcare.test',
    [string]$AdminPassword = 'Admin@123',
    [string]$CustomerEmail = 'qa-customer@petcare.test',
    [string]$StaffEmail = 'qa-staff@petcare.test'
)
# Run against a disposable QA database only. Creates QA records and deletes catalog fixtures.
$ErrorActionPreference = 'Stop'
Import-Module Microsoft.PowerShell.Utility
$null=Get-Command Invoke-WebRequest
$checks = [System.Collections.Generic.List[object]]::new()
$fixtures = [System.Collections.Generic.List[object]]::new()
$session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
$paths = @('tai-khoan','dich-vu','combo','phong','ca-lam-viec','thu-cung')
function Check($name, $ok) {
    $checks.Add([pscustomobject]@{Check=$name;Passed=[bool]$ok})
    if (!$ok) { throw "FAIL: $name" }
}
function GetPage($path, $webSession=$session) {
    Invoke-WebRequest "$BaseUrl$path" -WebSession $webSession -SkipHttpErrorCheck -TimeoutSec 30
}
function PostRaw($path,$body,$webSession=$session) {
    Invoke-WebRequest "$BaseUrl$path" -Method Post -Body $body -WebSession $webSession -SkipHttpErrorCheck -TimeoutSec 30
}
function PostAdmin($path,$body) {
    $page=GetPage "/admin/$path"
    $token=[regex]::Match($page.Content,'name="csrfToken" value="([^"]+)"').Groups[1].Value
    Check "CSRF token $path" (![string]::IsNullOrEmpty($token))
    $body['csrfToken']=$token
    PostRaw "/admin/$path" $body
}
function CreateRow($path,$body) {
    $body['action']='save'
    $page=PostAdmin $path $body
    if(!$page.Content.Contains('Đã lưu thay đổi.')) {
        $page.Content | Set-Content (Join-Path $PSScriptRoot '../target/admin-http-failure.html') -Encoding utf8
        Write-Output ([regex]::Match($page.Content,'(?s)role="alert">(.*?)</p>').Groups[1].Value)
    }
    Check "Create $path" ($page.StatusCode -eq 200 -and $page.Content.Contains('Đã lưu thay đổi.'))
    $id=[regex]::Match($page.Content,'\?id=(\d+)').Groups[1].Value
    Check "Created ID $path" (![string]::IsNullOrEmpty($id))
    $fixtures.Add(@{path=$path;id=$id})
    return $id
}
$tag='QA-HTTP-'+[guid]::NewGuid().ToString('N').Substring(0,6)
try {
    foreach($path in $paths) {
        $guest=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
        $page=GetPage "/admin/$path" $guest
        Check "Guest blocked $path" ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/login'))
    }
    foreach($email in @($CustomerEmail,$StaffEmail)) {
        $other=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
        $null=PostRaw '/login' @{identifier=$email;password=$AdminPassword} $other
        foreach($path in $paths) {
            $page=GetPage "/admin/$path" $other
            Check "$email blocked $path" ($page.StatusCode -eq 403)
        }
    }
    $page=PostRaw '/login' @{identifier=$AdminEmail;password=$AdminPassword}
    Check 'Admin login' ($page.Content.Contains('Quản lý tài khoản'))
    foreach($path in $paths) {
        $page=GetPage "/admin/$path"
        Check "Render $path" ($page.StatusCode -eq 200 -and $page.Content.Contains('csrfToken'))
        $blocked=PostRaw "/admin/$path" @{action='delete';id='1'}
        Check "Missing CSRF rejected $path" ($blocked.StatusCode -eq 403)
    }
    $service=@{name="$tag <script>alert(1)</script>";category='GROOMING';duration_minutes='30';price='125000';is_active='1'}
    $sid=CreateRow 'dich-vu' $service
    $page=GetPage '/admin/dich-vu'
    Check 'Stored HTML escaped' ($page.Content.Contains('&lt;script&gt;') -and !$page.Content.Contains('<script>alert(1)</script>'))
    $service['id']=$sid; $service['name']="$tag updated"
    $page=PostAdmin 'dich-vu' $service
    Check 'Update service' ($page.Content.Contains('Đã lưu thay đổi.') -and $page.Content.Contains("$tag updated"))
    $cid=CreateRow 'combo' @{name=$tag;price='100000';is_active='1';serviceIds=$sid}
    $page=GetPage "/admin/combo?id=$cid"
    Check 'Combo membership retained in edit' ($page.Content -match ('name="serviceIds" value="'+$sid+'" checked'))
    $page=PostAdmin 'dich-vu' @{action='delete';id=$sid}
    Check 'Referenced service cannot be deleted' ($page.Content.Contains('Dữ liệu đang được sử dụng'))
    $rid=CreateRow 'phong' @{room_code=$tag;room_type='Mèo';daily_rate='200000';status='AVAILABLE'}
    $page=PostAdmin 'phong' @{action='save';room_code=$tag;daily_rate='100';status='AVAILABLE'}
    Check 'Duplicate room rejected' ($page.Content.Contains('Dữ liệu bị trùng'))
    $page=GetPage '/admin/thu-cung'
    $owner=[regex]::Match($page.Content,'<option value="(\d+)"[^>]*>QA Customer').Groups[1].Value
    $null=CreateRow 'thu-cung' @{owner_id=$owner;name=$tag;species='Mèo';weight_kg='2.50';birth_date='2025-01-01'}
    $page=GetPage '/admin/ca-lam-viec'
    $staff=[regex]::Match($page.Content,'<option value="(\d+)"[^>]*>QA Staff').Groups[1].Value
    $shift=@{staff_id=$staff;work_date='2099-12-02';start_time='09:00';end_time='10:00'}
    $null=CreateRow 'ca-lam-viec' $shift
    $page=PostAdmin 'ca-lam-viec' $shift
    Check 'Overlapping shift rejected' ($page.Content.Contains('Ca làm việc trùng'))
    $page=PostAdmin 'ca-lam-viec' @{action='save';staff_id=$staff;work_date='2099-12-02';start_time='12:00';end_time='11:00'}
    Check 'Invalid time range rejected' ($page.Content.Contains('Giờ kết thúc phải sau'))
    $page=GetPage '/admin/quanLyPhong.jsp'
    Check 'Legacy page redirects to live module' ($page.BaseResponse.RequestMessage.RequestUri.AbsolutePath.EndsWith('/admin/phong'))
} finally {
    for($i=$fixtures.Count-1;$i -ge 0;$i--) {
        $fixture=$fixtures[$i]
        $page=PostAdmin $fixture.path @{action='delete';id=$fixture.id}
        Check "Cleanup $($fixture.path) #$($fixture.id)" ($page.Content.Contains('Đã lưu thay đổi.'))
    }
    $checks | ConvertTo-Json | Set-Content (Join-Path $PSScriptRoot '../target/admin-http-results.json') -Encoding utf8
}
Write-Output "PASS $($checks.Count)/$($checks.Count) admin HTTP checks"
