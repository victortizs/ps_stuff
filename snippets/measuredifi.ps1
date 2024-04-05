Function Measure-DiFi
{
    [CmdletBinding(
        SupportsShouldProcess = $True
    )]

    Param(
        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Path to the folder/drive that you want to explore recursively."
        )]
        [String]$Folder = ".\",
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Type 'dirs' to look only for dirs, 'files' to look only for files, or 'both' to look for both of them."
        )]
        [String]$Search = "Both",
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Type 'structure' to choose a structured output or 'names' to choose a list-formatted output."
        )]
        [String]$Display = "Names"
    )

    If ($PSCmdlet.ShouldProcess($Folder)) {
        Switch ($Search) {
            # Search just for directories/folders
            {$_ -eq "Dirs"} {
                If ((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count -eq 0) {
                    Write-Host "`nThe current item on this path '$(Get-Item $Folder)' has no subfolders within.`n"
                }
                Else {
                    Write-Host "`nThe parent folder '$(Get-item $Folder)' has a total of $((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count) subfolder(s) within:`n"
                    Switch ($Display) {
                        {$_ -eq "Names"} {
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object -Begin {$i = 1} -Process {Write-Host ("{0}. {1}" -f $i, $_.FullName); $i++} -End {Write-Host ""}
                        }
                        {$_ -eq "Structure"} {
                            Write-Host "The folder $(Get-Item $Folder) has $((Get-ChildItem $Folder -Directory | Measure-Object).Count) subfolder(s)."
                            # Descend structure
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object {
                                If ((Get-ChildItem $_.FullName -Directory | Measure-Object).Count -gt 0) {
                                    Write-Host "The folder $($_.FullName) has $((Get-ChildItem $_.FullName -Directory | Measure-Object).Count) subfolder(s)."
                                }
                            }
                            Write-Host ""
                        }
                    }
                }
            }
            # Search just for files
            {$_ -eq "Files"} {
                If ((Get-ChildItem $Folder -File -Recurse | Measure-Object).Count -eq 0) {
                    Write-Host "`nThe current item on this path '$(Get-Item $Folder)' has no files within.`n"
                }
                Else {
                    Write-Host "`nThe parent folder '$(Get-Item $Folder)' has a total of $((Get-ChildItem $Folder -File -Recurse | Measure-Object).Count) file(s) within:`n"
                    Switch ($Display) {
                        {$_ -eq "Names"} {
                            Get-ChildItem $Folder -File -Recurse | ForEach-Object -Begin {$i = 1} -Process {Write-Host ("{0}. {1}" -f $i, $_.FullName); $i++} -End {Write-Host ""}
                        }
                        {$_ -eq "Structure"} {
                            If ((Get-ChildItem $Folder -File | Measure-Object).Count -gt 0) {
                                Write-Host "The folder $(Get-Item $Folder) has $((Get-ChildItem $Folder -File | Measure-Object).Count) file(s)."
                            }
                            # Descend structure
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object {
                                If ((Get-ChildItem $_.FullName -File | Measure-Object).Count -gt 0) {
                                    Write-Host "The folder $($_.FullName) has $((Get-ChildItem $_.FullName -File | Measure-Object).Count) file(s)."
                                }  
                            }
                            Write-Host ""
                        }
                    }
                }
            }   
            # Search for both directories and files
            {$_ -eq "Both"} {
                # First case: parent folder contains both dirs and files
                If ((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count -gt 0 -and (Get-ChildItem $Folder -File -Recurse | Measure-Object).Count -gt 0) {
                    # Show dir results for parent folder
                    Write-Host "`nThe parent folder '$(Get-Item $Folder)' has a total of $((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count) subfolder(s) within:`n"
                    Switch ($Display) {
                        {$_ -eq "Names"} {
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object -Begin {$i = 1} -Process {Write-Host ("{0}. {1}" -f $i, $_.FullName); $i++} -End {Write-Host ""}
                        }
                        {$_ -eq "Structure"} {
                            Write-Host "The folder $(Get-Item $Folder) has $((Get-ChildItem $Folder -Directory | Measure-Object).Count) subfolder(s)."
                            # Descend structure and show results
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object {
                                If ((Get-ChildItem $_.FullName -Directory | Measure-Object).Count -gt 0) {
                                    Write-Host "The folder $($_.FullName) has $((Get-ChildItem $_.FullName -Directory | Measure-Object).Count) subfolder(s)."
                                }
                            }
                            Write-Host ""
                        }
                    }
                    # Show file results for parent folder
                    Write-Host "The parent folder '$(Get-Item $Folder)' has a total of $((Get-ChildItem $Folder -File -Recurse | Measure-Object).Count) file(s) within:`n"
                    Switch ($Display) {
                        {$_ -eq "Names"} {
                            Get-ChildItem $Folder -File -Recurse | ForEach-Object -Begin {$i = 1} -Process {Write-Host ("{0}. {1}" -f $i, $_.FullName); $i++} -End {Write-Host ""}
                        }
                        {$_ -eq "Structure"} {
                            If ((Get-ChildItem $Folder -File | Measure-Object).Count -gt 0) {
                                Write-Host "The folder $(Get-Item $Folder) has $((Get-ChildItem $Folder -File | Measure-Object).Count) file(s)."
                            }
                            # Descend structure and show results
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object {
                                If ((Get-ChildItem $_.FullName -File | Measure-Object).Count -gt 0) {
                                    Write-Host "The folder $($_.FullName) has $((Get-ChildItem $_.FullName -File | Measure-Object).Count) file(s)."
                                }
                            }
                            Write-Host ""                          
                        }
                    }
                }
                # Second case: parent folder only has files
                If ((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count -eq 0 -and (Get-ChildItem $Folder -File -Recurse | Measure-Object).Count -gt 0) {
                    Write-Host "`nThe current item on this path '$(Get-Item $Folder)' has no subfolders within.`n"
                    Write-Host "The parent folder '$(Get-Item $Folder)' has a total of $((Get-ChildItem $Folder -File -Recurse | Measure-Object).Count) file(s) within:`n"
                    Switch ($Display) {
                        {$_ -eq "Names"} {
                            Get-ChildItem $Folder -File -Recurse | ForEach-Object -Begin {$i = 1} -Process {Write-Host ("{0}. {1}" -f $i, $_.FullName); $i++} -End {Write-Host ""}
                        }
                        {$_ -eq "Structure"} {
                            Write-Host "The folder $(Get-Item $Folder) has $((Get-ChildItem $Folder -File | Measure-Object).Count) file(s).`n"
                        }
                    }
                }
                # Third case: parent folder only has dirs
                If ((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count -gt 0 -and (Get-ChildItem $Folder -File -Recurse | Measure-Object).Count -eq 0) {
                    Write-Host "`nThe current item on this path '$(Get-Item $Folder)' has no files within.`n"
                    Write-Host "The parent folder '$(Get-Item $Folder)' has a total of $((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count) subfolder(s) within:`n"
                    Switch ($Display) {
                        {$_ -eq "Names"} {
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object -Begin {$i = 1} -Process {Write-Host ("{0}. {1}" -f $i, $_.FullName); $i++} -End {Write-Host ""}
                        }
                        {$_ -eq "Structure"} {
                            Write-Host "The folder $(Get-Item $Folder) has $((Get-ChildItem $Folder -Directory | Measure-Object).Count) subfolder(s)."
                            # Descend structure
                            Get-ChildItem $Folder -Directory -Recurse | ForEach-Object {
                                If ((Get-ChildItem $_.FullName -Directory | Measure-Object).Count -gt 0) {
                                    Write-Host "The folder $($_.FullName) has $((Get-ChildItem $_.FullName -Directory | Measure-Object).Count) subfolder(s)."
                                }             
                            }
                            Write-Host ""
                        }
                    }
                }
                # Fourth and last case: parent folder doesn't have any items within
                If ((Get-ChildItem $Folder -Directory -Recurse | Measure-Object).Count -eq 0 -and (Get-ChildItem $Folder -File -Recurse | Measure-Object).Count -eq 0) {
                    Write-Host "`nThe current item on this path '$(Get-Item $Folder)' has no content.`n"
                }
            }
        }
    }
}
