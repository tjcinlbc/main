#SingleInstance, force


;To Dos
;Remove hypens and replace with -
;Do the file name clean up from the source IE: remove \\ and replace \ with _

; Set initial line number to 1
lineNumber := 1

EnvGet,UserProfile,UserProfile

Src_Folder=%UserProfile%\Downloads
Dest_Folder=%UserProfile%\OneDrive - Trusted Tech Team, Irvine\Documents\Clients\McElroy\Logs

;Hotkey is CTRL + F2
^F2::
    filePath := A_ScriptDir . "\Paste_Line_of_File.txt"
    
    FileRead, fileContent, % filePath
    
    lines := StrSplit(fileContent, "`n")
    
    if (lineNumber <= lines.MaxIndex()) {
        lineToPaste := RegExReplace(lines[lineNumber], "^\s+|\s+$", "")
        
        if (lineToPaste != "")
            {
            SrcFile=%Src_Folder%\ScanLog.csv
            DestFile=%Dest_Folder%\%lineToPaste%.csv
            FileMove,%SrcFile%,%DestFile%
            }
        lineNumber++
    } else {
        MsgBox Last line has been pasted.
        lineNumber := 1
    }
return

