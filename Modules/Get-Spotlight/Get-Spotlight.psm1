function Get-Spotlight {
    $Source = "$env:LOCALAPPDATA\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
    $Destination = "$env:USERPROFILE\Desktop\spotlight-$(Get-Date -Format "MM-dd")"
    $WideImageDst = "$Destination\wide"
    $PhoneImageDst = "$Destination\phone"

    if (!(Test-Path -Path $Source)) {
        Write-Error "The source directory is inaccessible." -ErrorAction Stop
    }
    if (Test-Path -Path $Destination) {
        Write-Error "A directory exists with the same name as the destination directory." -ErrorAction Stop
    }
    mkdir $Destination
    mkdir $WideImageDst
    mkdir $PhoneImageDst

    $WideImageCollection = @()
    $PhoneImageCollection = @()

    foreach ($img in Get-ChildItem $Source) {
        $ImgData = New-Object System.Drawing.Bitmap $img.FullName
        if ($ImgData.Width -ge 1920 -and
            $ImgData.Height -ge 1080) {
            $WideImageCollection += $img
        }
        elseif ($ImgData.Width -ge 1080 -and
            $ImgData.Height -ge 1920) {
            $PhoneImageCollection += $img
        }
    }
    Copy-Item $WideImageCollection $WideImageDst
    Copy-Item $PhoneImageCollection $PhoneImageDst
    foreach ($item in (Get-ChildItem -Recurse $Destination)) {
        if (Test-Path -Path $item.FullName -PathType Leaf) {
            Rename-Item $item "$($item.Basename)`.jpg"
        }
    }
}