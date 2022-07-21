<#
.SYNOPSIS
grep -Patterns -Files
OtherCommands | grep -Patterns

.DESCRIPTION
grep searches for -Patterns in each file in -Files.
grep prints each line that matches a pattern.
This is a basic imitation of unix and linux "grep" command.

.PARAMETER <Patterns>
This is a required parameter.
Typically -Patterns should be quoted when grep is used in a PowerShell command.

.PARAMETER <Files>
This is an optional parameter where you can specify one or more files (accept wildcards)
to search their contents.
This parameter cannot be used if the function is invoked with pipeline input.

.PARAMETER <Content>
This is an optional parameter where you can pass from a pipeline.
This parameter cannot be used if -Files are specified.

.EXAMPLE
grep "hello" 1.txt *.cpp

.EXAMPLE
cat Hello.java | grep "hello"

.EXAMPLE
ls | grep 1.txt

#>
function grep {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Patterns,
        
        [Parameter(Position = 1,
            ValueFromRemainingArguments)]
        [SupportsWildcards()]
        [string[]]
        $Files,

        [Parameter(
            ValueFromPipeline = $true)]
        $Content
    )
    
    begin {
        $output = [System.Collections.Generic.List[object]]::new()
    }

    process {
        $output.Add($Content)
    }

    end {
        $FilesProvided = $null -ne $Files
        $ContentProvided = $null -ne $Content

        # if both or none of $Files and $Content are provided, stop the function
        if ($FilesProvided -eq $ContentProvided) {
            Write-Error -Message "Syntax error." -ErrorAction Stop
        }

        # if there are files provided, search the content of all files
        if ($FilesProvided) {
            
            foreach ($item in Get-Item($Files)) {

                # if an item is a file, search its content
                if (Test-Path -Path $item -PathType Leaf) {
                    $match = Get-Content $item | Out-String -Stream | Select-String -Pattern $Patterns

                    foreach ($line in $match) {
                        Write-Host $item.Name -ForegroundColor DarkMagenta -NoNewline
                        Write-Host ':' -ForegroundColor DarkCyan -NoNewline
                        $line.ToEmphasizedString("")
                    }
                }

                # if an item is a directory or others, prompt and skip
                else {
                    Write-Host "grep: $($item.Name): Is a directory"
                }
            }
        }

        # if the function is invoked with pipeline input, search the resulting string
        if ($ContentProvided) {
            $output  | Out-String -Stream | Select-String -Pattern $Patterns
        }
    }
}
