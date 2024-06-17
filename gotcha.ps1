# Display a gotcha prompt
Add-Type -AssemblyName PresentationCore, PresentationFramework
[System.Windows.MessageBox]::Show("Gotcha!", "Alert", 'OK', 'Information')
