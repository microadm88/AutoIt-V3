;Required Includes.
#include <GUIConstantsEx.au3> ;Constants for GUI Events
#include <EditConstants.au3> ;Edit constants. Required for the styles we used.
;Declare any variables.
;Create the GUI
$hGUI = GUICreate ("Learning to script with AutoIt V3- Example GUI", 400, 300)
;Create a lable
;Below you can see & _. It allows us to split up lines, making it easier to read.
$hLabel = GUICtrlCreateLabel ("This is a label control. Type text into the Input control" & _
"and press the button to set the text of the edit control. " & _
"Type /SPECIAL in the edit for a special message!",10, 10, 380, 40)
;Create an input control

$hInput = GUICtrlCreateInput ("This is an Input Control. Type stuff here!", 10, 50, 380, 20)
;Create an edit control
$hEdit = GUICtrlCreateEdit ("This is the edit control. We used a style to make it multiline and read-only!!", 10, 80, 380, 170, BitOR ($ES_MULTILINE, $ES_READONLY))
;Create the button
$hButton = GUICtrlCreateButton ("Press me!", 320, 260, 70, 25)
;Show the GUI. We need this line, or our GUI will NOT be displayed!
GUISetState (@SW_SHOW)

;Endless While loop
While 1
$nMsg = GUIGetMsg ()
Switch $nMsg
Case $GUI_EVENT_CLOSE; The red X is pressed
Exit ;Exit the script
Case $hLabel ;The label
MsgBox (0, "Hello!", "We have clicked on the label!"); Say Hello
Case $hButton ;The Button
$read = GUICtrlRead ($hInput)
;Check to see if we have /SPECIAL using StringInStr.
If StringInStr ($read, "/SPECIAL") Then
;We have it, display the message.
MsgBox (0, "WOW!", "This is a special message!")
Else
;Get Existing Data of edit
$read2 = GUICtrlRead ($hEdit)
$text = $read2 & @CRLF & $read ; Join the existing and the new text seperated by a line.
GUICtrlSetData ($hEdit, $text) ; Set the edit control to have our new data!
GUICtrlSetData ($hInput, "");Reset the data of the input.
EndIf
EndSwitch
Wend