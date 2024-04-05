Function Add-PrefixDirs
{
    [CmdletBinding( 
        SupportsShouldProcess = $True,
        PositionalBinding = $True,
        ConfirmImpact = "Medium"
    )]

    Param(
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Type the path to the parent folder where you want to applicate the function"
        )]
        [String]$Folder = ".\"
    )

    If ($PSCmdlet.ShouldProcess($Folder)) {
        $i = 1
        Get-ChildItem $Folder | Where-Object {$_.PSIsContainer -eq $True} | ForEach-Object {
            Add-PrefixDirs $_.FullName
            Rename-Item -Path $_.FullName -NewName ".\$($i)_$($_.Name)"
            $i++
        }
    }
}
