Function Pop-Web {
<#
    .SYNOPSIS
    Browse the web from the shell.
    .DESCRIPTION
    The function uses user inputs to launch a specific browser (duck, google or bing) with a given query. You can later create an alias in your PS profile for this function, like "web".
    .PARAMETER B
    The browser. If you omit this parameter it will use duck by default.
    .EXAMPLE
    pop-web -b google
    .EXAMPLE
    pop-web g
    .INPUTS
    System.String
    .OUTPUTS
    html
    .NOTES
    Helpful content on:
    https://adamtheautomator.com/powershell-modules/#Installing_Modules
    https://mikefrobbins.com/2013/07/04/how-to-create-powershell-script-modules-and-module-manifests/
    .LINK
    https://estudianteporahora.blog
#>
    [CmdletBinding (
        SupportsShouldProcess = $True
    )]
    Param (
        [Parameter (
        Mandatory = $False,
        ValueFromPipeline =$True,
        ValueFromPipelineByPropertyName = $True,
        HelpMessage = "Please choose a browser between duck (duckduckgo), google, and bing. This parameter is not mandatory, the default value is duck."
        )]
        [String]$B = "duck"
    )
    $Query = Read-Host ("Write your query")
    If ($PSCmdlet.ShouldProcess($B)) {
        Switch ($B) {
        {$_ -eq "google" -or $_ -eq "g"} {Start-Process ("https://google.com/search?q=" + $Query -Replace ("-","+"))}
        {$_ -eq "bing" -or $_ -eq "b"} {Start-Process ("https://bing.com/search?q=" + $Query -Replace ("-", "+"))}
        {$_ -eq "duck" -or $_ -eq "d"} {Start-Process ("https://duckduckgo.com/?q=" + $Query -Replace ("-", "+"))}
        }
    }
}
