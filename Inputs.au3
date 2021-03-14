#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $sConfigPath = @ScriptDir & "\MySettings.ini"

#Region ### START Koda GUI section ### Form=
Local $Form1 = GUICreate("Form1", 362, 34, 192, 124)
Local $Input1 = GUICtrlCreateInput("", 8, 8, 346, 20)
#EndRegion ### END Koda GUI section ###

; Here we can execute code before the window is shown

; Get the value of Input1 from the ini file.
GUICtrlSetData($Input1, IniRead($sConfigPath, "inputs", "Input1", ""))

; Show the window afterwards so it looks a bit tidier
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()

    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            ; Note: Exit needs to be changed to ExitLoop
            ; for any code after the loop to execute.
            ExitLoop
    EndSwitch
WEnd

; This code will be executed when the window is closed.

; Writes the value of the $Input1 control to the ini file
IniWrite($sConfigPath, "inputs", "Input1", GUICtrlRead($Input1))