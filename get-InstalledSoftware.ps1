##       Name: installedsoftware.ps1 
##    Written: Sandeep Parmar
##       Date: 01/15/2013
##    Purpose: To retrieve all of the installed software on a machine.
## Parameters: <empty> or <computer name>
##   <empty> Will produce a list of software installed on the local computer.
##   <computer name> Will produce a list of software of the remote computer and
##     output it to screen.

Param(
    ## Retrieves the inputted computer name otherwise sets the variable to null.
    [String]$Comp=$null
)

## Checks if a computer name is entered.
If($Comp -eq ""){

    ####################### Variables ##############################
    ## Gets the name of the local computer.
    $computername = gc env:computername
    ## Gets the current date and time formatted properly.
    $date = get-date -format "_MMddyyyy-HHmmss"
    ## Location of the where the files need to be stored. 
    $sourcelocation="\\idunn\installedsoftware"
    ## Location of where the old files need to be moved. 
    $targetlocation="\\idunn\installedsoftware\_old"
    ## This sets where the updated installed software file gets stored.
    $filename= $sourcelocation+ "\" + $computername + $date + ".txt"
    ## This finds any files with the same name in the source location.
    $filefound = Get-ChildItem -Path $sourcelocation $computername* | select -expand name

    ## Checks a file already exists. If it does then it is moved to the the target location. 
    if($filefound) {
         foreach($name in $filefound){
                    ## sets the file path of the source file.
                    $filepath=$sourcelocation + "\" + $filefound
                    Move-Item $filepath $targetlocation
         }
    }
    ## This retrieves the installed software list of the computer, then formats the output (installed date, version
    ## number, program name). It then sorts the list by name and then outputs it to the source location with the proper
    ## naming scheme.
    Get-WmiObject -Query "SELECT * FROM SMS_InstalledSoftware" -Namespace "root\cimv2\sms" | Select-Object InstallDate,ProductVersion,ProductName | Sort-Object ProductName | Format-Table -Property @{Label='InstallDate';Expression={$_.InstallDate.substring(0,8)};Width=12},@{Label='ProductVersion';Expression={$_.ProductVersion};Width=24},ProductName | Out-File -Encoding ASCII $filename
}else{

    ## This retrieves the installed software list of a remote computer, then formats the output (installed date,
    ## version number, program name). It then sorts the list by name and then outputs to the screen.  
    Get-WmiObject -ComputerName $Comp -Query "SELECT * FROM SMS_InstalledSoftware" -Namespace "root\cimv2\sms" | Select-Object InstallDate,ProductVersion,ProductName | Sort-Object ProductName | Format-Table -Property @{Label='InstallDate';Expression={$_.InstallDate.substring(0,8)};Width=12},@{Label='ProductVersion';Expression={$_.ProductVersion};Width=24},ProductName
}