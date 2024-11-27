Function Add-PrefixDirs
{
    <#
    .SYNOPSIS
    Add a prefix with the format "[int]_" to all folders within the given path (root directory). Each level starts with i=1.
    .DESCRIPTION
    The function:
    (1) asks for a root directory (parent folder) to the user;
    (2) defines an interator ($i=1) for the root dir;
    (3) gets the parent folder's subfolders and call itself again for each of these, passing them as parent folders as well, setting an iterator $i=1 for them, and getting their respective subfolders;
    (4) renames all the defined parent folders' subfolders adding the prefix "[$i_]" to their names.
    .PARAMETER FOLDER
    The first and main root dir (parent folder), i.e., where you want to add a prefix to all subfolders recursively by level. It's your current location (working directory) by default.
    .EXAMPLE
    Add-PrefixDirs .\example\folder
    .EXAMPLE
    Add-PrefixDirs
    .EXAMPLE
    Add-PrefixDirs -Folder example\folder
    .INPUTS
    System.String
    .OUTPUTS
    System.Object
    .NOTES
    Helpful content on:
    https://stackoverflow.com/questions/78197645/how-can-i-reset-a-counter-within-each-subfolder-level-in-a-loop-that-access-recu
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/rename-item?view=powershell-7.4
    .LINK
    https://estudianteporahora.blog
    #>
    
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
