function touch {
    if ($args.Count -eq 0) {
        throw "missing file operand"
    }
    foreach ($item in $args) {
        New-Item $item
    }
}

function basename {
    param (
        $file,
        [switch] $NoExtention
    )
    $file = Get-Item($file)
    if ($NoExtention) {
        return $file.BaseName
    }
    return $file.Name
}

function head($file, $n = 10) {
    Get-Content $file -TotalCount $n
}

function tail($file, $n = 10) {
    Get-Content $file -Tail $n
}

function chext {
    if ($args.Count -lt 2) {
        Write-Error "Not enough arguments." -ErrorAction Stop
    }

    $Files = $args[0..($args.Count - 2)]
    $Extention = $args[-1]

    foreach ($item in Get-Item($Files)) {
        if (Test-Path -Path $item -PathType Leaf) {
            Rename-Item $item "$($item.Basename)`.$Extention"
        }
    }
}
