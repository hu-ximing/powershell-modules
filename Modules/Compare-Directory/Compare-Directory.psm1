function Compare-Directory {
    param (
        $Folder1,
        $Folder2
    )
    $Folder1 = Get-ChildItem -Recurse $Folder1
    $Folder2 = Get-ChildItem -Recurse $Folder2
    Compare-Object $Folder1 $Folder2 -Property Name, Length
}