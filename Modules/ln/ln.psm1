function ln {
    param (
        [Parameter(Mandatory)]
        $Target,

        [Parameter(Mandatory)]
        [string]
        $LinkName,

        [Parameter()]
        [Alias("s")]
        [switch]
        $Symbolic
    )
    
    $LinkType = "HardLink"
    if ($Symbolic) {
        $LinkType = "SymbolicLink"
    }

    if (Test-Path -Path $Target) {
        New-Item -ItemType $LinkType -Path $LinkName -Value (Get-Item $Target)
    }
    else {
        Write-Error -Message "failed to access $Target`: No such file or directory"
    }
}
