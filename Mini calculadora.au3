#NoTrayIcon
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("MustDeclareVars", 1)

Global $Input, $Btn1, $Btn2, $Btn3, $Btn4, $Btn5, $Btn6, $Btn7
Global $Btn8, $Btn9, $Btn0, $Btn_add, $Btn_sub, $Btn_mul
Global $Btn_div, $Btn_clear, $Btn_dot, $Btn_ans_com, $Btn_ans_add
Global $Btn_ans_sub, $Btn_ans_mul, $Btn_ans_div, $nMsg, $read

main()
Func main()
GUICreate("Mini Calculator", 305, 103, -1, -1, -1, _
BitOR($WS_EX_OVERLAPPEDWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$Input = GUICtrlCreateInput("", 8, 8, 290, 21, _
BitOR($ES_RIGHT,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN), _
BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Btn1 = GUICtrlCreateButton("1", 8, 40, 27, 25, $WS_GROUP)
$Btn2 = GUICtrlCreateButton("2", 40, 40, 27, 25, $WS_GROUP)
$Btn3 = GUICtrlCreateButton("3", 72, 40, 27, 25, $WS_GROUP)
$Btn4 = GUICtrlCreateButton("4", 104, 40, 27, 25, $WS_GROUP)
$Btn5 = GUICtrlCreateButton("5", 136, 40, 27, 25, $WS_GROUP)
$Btn6 = GUICtrlCreateButton("6", 8, 72, 27, 25, $WS_GROUP)
$Btn7 = GUICtrlCreateButton("7", 40, 72, 27, 25, $WS_GROUP)
$Btn8 = GUICtrlCreateButton("8", 72, 72, 27, 25, $WS_GROUP)
$Btn9 = GUICtrlCreateButton("9", 104, 72, 27, 25, $WS_GROUP)
$Btn0 = GUICtrlCreateButton("0", 136, 72, 27, 25, $WS_GROUP)
$Btn_add = GUICtrlCreateButton("+", 176, 40, 27, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Btn_sub = GUICtrlCreateButton("-", 208, 40, 27, 25, $BS_BOTTOM)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$Btn_mul = GUICtrlCreateButton("*", 176, 72, 27, 25, BitOR($BS_TOP,$WS_GROUP))
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
$Btn_div = GUICtrlCreateButton("/", 208, 72, 27, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Btn_clear = GUICtrlCreateButton("c", 240, 40, 58, 25)
GUICtrlSetFont(-1, 11, 400, 0, "MS Sans Serif")
$Btn_dot = GUICtrlCreateButton(".", 240, 72, 27, 25, $BS_BOTTOM )
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
$Btn_ans_com = GUICtrlCreateButton("=", 272, 72, 27, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Btn_ans_add = GUICtrlCreateButton("=", 272, 72, 27, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$Btn_ans_sub = GUICtrlCreateButton("=", 272, 72, 27, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$Btn_ans_mul = GUICtrlCreateButton("=", 272, 72, 27, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$Btn_ans_div = GUICtrlCreateButton("=", 272, 72, 27, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
GUISetState(@SW_SHOW)

While 1
        $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Btn1
            GUICtrlSetData($Input, GUICtrlRead($Input)&1)
        Case $Btn2
            GUICtrlSetData($Input, GUICtrlRead($Input)&2)
        Case $Btn3
            GUICtrlSetData($Input, GUICtrlRead($Input)&3)
        Case $Btn4
            GUICtrlSetData($Input, GUICtrlRead($Input)&4)
        Case $Btn5
            GUICtrlSetData($Input, GUICtrlRead($Input)&5)
        Case $Btn6
            GUICtrlSetData($Input, GUICtrlRead($Input)&6)
        Case $Btn7
            GUICtrlSetData($Input, GUICtrlRead($Input)&7)
        Case $Btn8
            GUICtrlSetData($Input, GUICtrlRead($Input)&8)
        Case $Btn9
            GUICtrlSetData($Input, GUICtrlRead($Input)&9)
        Case $Btn0
            GUICtrlSetData($Input, GUICtrlRead($Input)&0)
        Case $Btn_dot
            GUICtrlSetData($Input, GUICtrlRead($Input)&'.')
        Case $Btn_add
            If GUICtrlRead($Input) <> '' Then
            GUICtrlSetState($Btn_ans_com, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_sub, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_mul, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_div, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_add, $GUI_SHOW)
            $read = GUICtrlRead($Input)
            GUICtrlSetData($Input, '')
            EndIf
        Case $Btn_sub
            If GUICtrlRead($Input) <> '' Then
            GUICtrlSetState($Btn_ans_com, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_add, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_mul, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_div, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_sub, $GUI_SHOW)
            $read = GUICtrlRead($Input)
            GUICtrlSetData($Input, '')
            EndIf
        Case $Btn_mul
            If GUICtrlRead($Input) <> '' Then
            GUICtrlSetState($Btn_ans_com, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_add, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_sub, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_div, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_mul, $GUI_SHOW)
            $read = GUICtrlRead($Input)
            GUICtrlSetData($Input, '')
            EndIf
        Case $Btn_div
            If GUICtrlRead($Input) <> '' Then
            GUICtrlSetState($Btn_ans_com, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_add, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_sub, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_mul, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_div, $GUI_SHOW)
            $read = GUICtrlRead($Input)
            GUICtrlSetData($Input, '')
            EndIf
        Case $Btn_ans_add
            GUICtrlSetData($Input, $read+GUICtrlRead($Input))
        Case $Btn_ans_sub
            GUICtrlSetData($Input, $read-GUICtrlRead($Input))
        Case $Btn_ans_mul
            GUICtrlSetData($Input, $read*GUICtrlRead($Input))
        Case $Btn_ans_div
            GUICtrlSetData($Input, $read/GUICtrlRead($Input))
        Case $Btn_clear
            GUICtrlSetState($Btn_ans_com, $GUI_SHOW)
            GUICtrlSetState($Btn_ans_add, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_sub, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_mul, $GUI_HIDE)
            GUICtrlSetState($Btn_ans_div, $GUI_HIDE)
            GUICtrlSetData($Input, '')
            ContinueLoop
    EndSwitch
WEnd
EndFunc