get-InstalledSoftware.ps1

This script is used to retieve the software installed on a windows computer and store the list in a file. If there is a the file already exists it moves that list into storage and then place it in that location. It does this by using wmi query and uses the win32_product class. If a computername is not give then this uses the computer name of the computer the script is running on.  

Improvements: The ability to output the list to the host console instead of just a file. 