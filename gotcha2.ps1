# Display a gotcha prompt
Add-Type -AssemblyName PresentationCore, PresentationFramework
[System.Windows.MessageBox]::Show("Gotcha2!", "Alert", 'OK', 'Information')
