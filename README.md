# PS Stuff
My own code snippets for daily repetitive tasks, written in **PowerShell**.

Inside the folder 'snippets' you'll find functions save as PowerShell scripts (.ps1), but I strongly recommend following the Microsoft guidelines on this matter:
1. Create a module container (directory) in the available spaces suggested by Powershell—you can see these running `$env:PSModulePath -Split ";"`. Here you must select the module path that best suits your needs, each one has a different scope/range of action, such as system wide or current user—[read the doc](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath?view=powershell-7.4).
If you don't know if those directories are already created, then you can try something like (route for current user scope):
```powershell
If (Test-Path C:\Users\uruserhere\Documents\PowerShell\Modules) {Write-Host "all good"}
Else {New-Item -Path C:\Users\uruserhere\Documents\PowerShell\Modules -ItemType Directory}
```
Then proceed to create the module container inside.
  
2. Create a module file (.psm1) in the container and with the same name, this allows PowerShell to automatically recognize the module and import it (along with functions inside) in each session. No need for `Get-Module`, `Import-Module` or dot sourcing (`. .\function-name.ps1`).
3. Aggregate functions or any command combination to your module in your preferred editor (PowerShell ISE, Visual Studio or VSCode).
4. Create a module manifest (.psd1) to add helpful content about the module (author, company, description, version, etc.) and select specific functions that you want PowerShell to import. Do it with the same name as the module container and module file.
5. Create a module repository to upload/publish module files and make them accessible for everyone who want to use them (by installing them)—you can host your own repo locally or choose a web server such as [Powershell Gallery](https://www.powershellgallery.com/).

Personally, I stopped on step 4 because I don't intend to publish any module on any server, but I might someday to use it on another machine, or to install code from a third that may be useful.

### Helpful resources:
- https://adamtheautomator.com/powershell-modules/#Installing_Modules
- https://mikefrobbins.com/2013/07/04/how-to-create-powershell-script-modules-and-module-manifests/
- https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.4
- https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-5.1
- https://learn.microsoft.com/en-us/powershell/
