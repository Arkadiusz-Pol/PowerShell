# 1. Get Laptop Model Name
$laptopModel = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Model
Write-Host "Laptop Model: $laptopModel"

# Get Monitor Model Name
$monitorModel = Get-WmiObject -Namespace root\wmi -Class WmiMonitorID | ForEach-Object {
    $MonitorName = ($_.UserFriendlyName | Where-Object {$_ -ne 0} | ForEach-Object {[char]$_}) -join ""
    $MonitorName
}
Write-Host "Monitor Model: $monitorModel"

# 3. Get Windows Product Key
function Get-WindowsKey {
    $path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $DigitalProductID = (Get-ItemProperty -Path $path).DigitalProductId
    $key = ""
    $map = "BCDFGHJKMPQRTVWXY2346789"
    $i = 24
    while ($i -ge 0) {
        $cur = 0
        $j = 14
        while ($j -ge 0) {
            $cur = $cur * 256 -bxor $DigitalProductID[$j + 52]
            $DigitalProductID[$j + 52] = [math]::Floor([double]($cur / 24))
            $cur = $cur % 24
            $j--
        }
        $key = $map[$cur] + $key
        if (($i % 5 -eq 0) -and ($i -ne 0)) {
            $key = "-" + $key
        }
        $i--
    }
    return $key
}

$windowsKey = Get-WindowsKey
Write-Host "Windows Product Key: $windowsKey"

# 4. Get Office Version
$officeVersionKey = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
if (Test-Path $officeVersionKey) {
    $officeVersion = (Get-ItemProperty -Path $officeVersionKey).ProductReleaseIds
    Write-Host "Office Version: $officeVersion"
} else {
    Write-Host "Office is not installed or version information is unavailable."
}

# 5. Get Office Product Key
function Get-OfficeProductKey {
    $paths = @(
        "HKLM:\SOFTWARE\Microsoft\Office\16.0\Registration",
        "HKLM:\SOFTWARE\Microsoft\Office\15.0\Registration",
        "HKLM:\SOFTWARE\Microsoft\Office\14.0\Registration"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            $productID = (Get-ItemProperty -Path $path).ProductID
            $digitalProductID = (Get-ItemProperty -Path $path).DigitalProductID
            if ($productID -and $digitalProductID) {
                $officeKey = Get-WindowsKeyFromDigitalID $digitalProductID
                return $officeKey
            }
        }
    }
    return "Office Product Key not found."
}

function Get-WindowsKeyFromDigitalID($DigitalProductID) {
    $map = "BCDFGHJKMPQRTVWXY2346789"
    $key = ""
    $i = 24
    while ($i -ge 0) {
        $cur = 0
        $j = 14
        while ($j -ge 0) {
            $cur = $cur * 256 -bxor $DigitalProductID[$j + 52]
            $DigitalProductID[$j + 52] = [math]::Floor([double]($cur / 24))
            $cur = $cur % 24
            $j--
        }
        $key = $map[$cur] + $key
        if (($i % 5 -eq 0) -and ($i -ne 0)) {
            $key = "-" + $key
        }
        $i--
    }
    return $key
}

$officeKey = Get-OfficeProductKey
Write-Host "Office Product Key: $officeKey"