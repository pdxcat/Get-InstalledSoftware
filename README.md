get-InstalledSoftware.ps1
=========================

This script retrieves a list (stored as a .txt file) of installed software on a Windows computer. If the file already exists, it moves the existing file into storage and replaces it with the new file. If a computer name is not given, then it will use the name of the computer the script is being run on. It does all this by utilizing WMI query and the Win32_Product class.

Improvements: The ability to output the list to the host console instead of just a file. 