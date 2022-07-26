# https://www.techtutsonline.com/powershell-alternative-telnet-command/
# Marvelous-Telnet
<#
.Synopsis
Tests the connectivity between two computers on a TCP Port

.Description
The Telnet command tests the connectivity between two computers on a TCP Port. By running this command, you can determine if specific service is running on Server.

.Parameter <ComputerName>
This is a required parameter where you need to specify a computer name which can be localhost or a remote computer

.Parameter <Port>
This is a required parameter where you need to specify a TCP port you want to test connection on.

.Parameter <Timeout>
This is an optional parameter where you can specify the timeout in milli-seconds. Default timeout is 10000ms (10 seconds)

.Example
Telnet -ComputerName DC1 -Port 3389
This command reports if DC1 can be connected on port 3389 which is default port for Remote Desktop Protocol (RDP). By simply running this command, you can check if Remote Desktop is enabled on computer DC1.

.Example
Telnet WebServer 80
This command tells you if WebServer is reachable on Port 80 which is default port for HTTP.

.Example
Get-Content C:\Computers.txt | Telnet -Port 80
This command will take all the computernames from a text file and pipe each computername to Telnet Cmdlet to report if all the computers are accessible on Port 80.
#>
function Telnet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias ('HostName', 'cn', 'Host', 'Computer')]
        [String]$ComputerName,
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int32]$Port,
        [int32] $Timeout = 2000
    )
    
    begin {
        
    }
    
    process {
        foreach ($Computer in $ComputerName) {
            Try {
                $tcp = New-Object System.Net.Sockets.TcpClient
                $connection = $tcp.BeginConnect($Computer, $Port, $null, $null)
                $connection.AsyncWaitHandle.WaitOne($timeout, $false)  | Out-Null 
                if ($tcp.Connected -eq $true) {
                    Write-Host  "Successfully connected to Host: `"$Computer`" on Port: `"$Port`"" -ForegroundColor Green
                }
                else {
                    Write-Host "Could not connect to Host: `"$Computer `" on Port: `"$Port`"" -ForegroundColor Red
                }
            }
        
            Catch {
                Write-Host "Unknown Error" -ForegroundColor Red
            }

        }

    }
    
    end {
        
    }
}