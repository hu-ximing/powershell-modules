# https://stackoverflow.com/questions/9552367/get-the-detail-informations-from-a-png-file-in-powershell

function Get-Image($path) {
    Add-Type -AssemblyName System.Drawing
    $img = New-Object System.Drawing.Bitmap $path
    return $img
}
