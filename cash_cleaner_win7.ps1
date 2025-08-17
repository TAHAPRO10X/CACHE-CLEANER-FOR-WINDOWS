Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "CASH CLEANER v1.1 - Windows 7"
$form.Size = New-Object System.Drawing.Size(650,450)
$form.StartPosition = "CenterScreen"

# Title Label
$title = New-Object System.Windows.Forms.Label
$title.Text = "CASH CLEANER v1.1"
$title.Font = New-Object System.Drawing.Font("Segoe UI",16,[System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::Black
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(200,20)
$form.Controls.Add($title)

# Log TextBox
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.Size = New-Object System.Drawing.Size(600,200)
$logBox.Location = New-Object System.Drawing.Point(20,80)
$logBox.ReadOnly = $true
$logBox.BackColor = [System.Drawing.Color]::White
$logBox.ForeColor = [System.Drawing.Color]::Black
$form.Controls.Add($logBox)

# ProgressBar
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(20,300)
$progress.Size = New-Object System.Drawing.Size(600,30)
$progress.Minimum = 0
$progress.Maximum = 100
$progress.Value = 0
$form.Controls.Add($progress)

# Buttons
$cleanBtn = New-Object System.Windows.Forms.Button
$cleanBtn.Text = "Run Cleaner"
$cleanBtn.Size = New-Object System.Drawing.Size(120,40)
$cleanBtn.Location = New-Object System.Drawing.Point(150,350)
$form.Controls.Add($cleanBtn)

$stopBtn = New-Object System.Windows.Forms.Button
$stopBtn.Text = "Stop"
$stopBtn.Size = New-Object System.Drawing.Size(120,40)
$stopBtn.Location = New-Object System.Drawing.Point(350,350)
$stopBtn.Enabled = $false
$form.Controls.Add($stopBtn)

# About Button
$aboutBtn = New-Object System.Windows.Forms.Button
$aboutBtn.Text = "About"
$aboutBtn.Size = New-Object System.Drawing.Size(80,30)
$aboutBtn.Location = New-Object System.Drawing.Point(540,20)
$form.Controls.Add($aboutBtn)

# Stop Flag
$stopCleaning = $false

# Function to append log
function Append-Log($message){
    $logBox.Invoke([action]{ 
        $logBox.AppendText((Get-Date -Format "HH:mm:ss") + " - $message`r`n")
        $logBox.SelectionStart = $logBox.Text.Length
        $logBox.ScrollToCaret()
    })
    Start-Sleep -Milliseconds 300
}

# Cleaner function
$cleanBtn.Add_Click({
    $cleanBtn.Enabled = $false
    $stopBtn.Enabled = $true
    $stopCleaning = $false
    $progress.Value = 0

    $steps = @(
        @{Text="[STEP 1] Cleaning C:\Windows\Temp..."; Action={if (Test-Path "C:\Windows\Temp") {try {Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue} catch {}}}},
        @{Text="[STEP 2] Cleaning Prefetch and user Temp..."; Action={
            $prefetchPath = "C:\Windows\Prefetch"
            if (Test-Path $prefetchPath) {try {Remove-Item "$prefetchPath\*" -Recurse -Force -ErrorAction SilentlyContinue} catch {}}
            $userTemp = $env:TEMP
            if ($userTemp -and (Test-Path $userTemp)) {try {Remove-Item "$userTemp\*" -Recurse -Force -ErrorAction SilentlyContinue} catch {}}
        }},
        @{Text="[STEP 3] Removing legacy temp directories..."; Action={
            $legacyPaths = @("C:\Windows\Tempor~1","C:\Windows\Tmp","C:\Windows\History","C:\Windows\Cookies","C:\Windows\Recent","C:\Windows\Spool\Printers")
            foreach ($path in $legacyPaths){if (Test-Path $path){try {Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue} catch {}}}
            $tmpFiles = Get-ChildItem "C:\Windows" -Filter "ff*.tmp" -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer }
            foreach ($file in $tmpFiles){if ($file -and $file.FullName){try {Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue} catch {}}}
        }}
    )

    Append-Log "[INFO] Cash Cleaner Started"

    $stepCount = $steps.Count
    $current = 0

    foreach ($step in $steps){
        if ($stopCleaning) {Append-Log "[INFO] Cleaning Stopped by User"; break}
        Append-Log $step.Text
        & $step.Action
        Append-Log "[OK] Completed."
        $current++
        $progress.Value = [int](($current/$stepCount)*100)
    }

    if (-not $stopCleaning) {Append-Log "[INFO] Cash Cleaner Completed Successfully!"}
    $cleanBtn.Enabled = $true
    $stopBtn.Enabled = $false
})

# Stop button action
$stopBtn.Add_Click({
    $stopCleaning = $true
})

# About Button action
$aboutBtn.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("CASH CLEANER v1.1`nDevelopers:`nahmed-hassan-coder-x`nTAHAPRO10X`nProject GitHub:`nhttps://github.com/TAHAPRO10X/CACHE-CLEANER-FOR-WINDOWS","About Cash Cleaner",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
})

# Show Form
[void]$form.ShowDialog()