$scriptFiles = Get-ChildItem "$PSScriptRoot\..\Config\*.ps1" -Recurse

foreach ($script in $scriptFiles) {
    try {       
        . $script.FullName 
    }
    catch [System.Exception] {
        throw
    }
}