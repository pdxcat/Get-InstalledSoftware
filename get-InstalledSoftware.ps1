##       Name: installedsoftware.ps1 
##    Written: Sandeep Parmar
##       Date: 01/15/2013
##    Purpose: To retrieve all of the installed software on a machine.
## Parameters: <empty> or <computer name>
##                     <empty> Will produce a list of software installed on the local computer. 
##             <computer name> Will produce a list of software of the remote computer and output it to the screen.
##    Edit By: Bartholomew Brandner on 2/23/2014 

Param(
    ## Retrieves the inputted computer name otherwise sets the variable to null.
    [String]$Comp=$null
)

## Checks that a computer name was entered. 
If($Comp -eq $null){

    ####################### Variables ##############################
    ## Gets the name of the local computer.
    $computername = gc env:computername
    ## Gets the current date and time formatted properly.
    $date = get-date -format "_MMddyyyy-hhmmss"
    ## Location where the files will be stored. 
    $sourcelocation="c:\temp"
    ## Location where the old files will be moved. 
    $targetlocation="c:\temp\_old"
    ## This sets where the updated list of installed software file gets stored.
    $filename= $sourcelocation+ "\" + $computername + $date + ".txt"
    ## This finds any files with the same name in the source locaiton.
    $filefound = Get-ChildItem -Path $sourcelocation $computername* | select -expand name

    ## Checks if a file already exists. If it does then it is moved to the target location (where old files go to DIE). 
    if($filefound) {
         foreach($name in $filefound){
                    ## sets the file path of the source file.
                    $filepath=$sourcelocation + "\" + $filefound
                    Move-Item $filepath $targetlocation
         }
    }
    ## This retrieves the list of installed software on the computer, then formats the output (installed date, version
    ## number, program name). It then sorts the list by name and outputs it to the source location with the proper
    ## naming scheme.
    Get-WmiObject -class win32_product | select name, version | sort name | format-table -autosize >> $filename
}else{

    ## This retrieves the installed software list of a remote computer, then formats the output (installed date,
    ## version number, program name). It then sorts the list by name and outputs it to the screen.  
    Get-WmiObject -ComputerName $Comp -class win32_product | select name, version | sort name | format-table -autosize
}
