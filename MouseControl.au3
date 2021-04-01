Global Const $WM_MOUSEMOVE = 0x0200 ;mouse move
Global Const $WM_MOUSEWHEEL = 0x020A ;wheel up/down
Global Const $WM_LBUTTONDBLCLK = 0x0203 ;left button
Global Const $WM_LBUTTONDOWN = 0x0201
Global Const $WM_LBUTTONUP = 0x0202
Global Const $WM_RBUTTONDBLCLK = 0x0206 ;right button
Global Const $WM_RBUTTONDOWN = 0x0204
Global Const $WM_RBUTTONUP = 0x0205
Global Const $WM_MBUTTONDBLCLK = 0x0209 ;wheel clicks
Global Const $WM_MBUTTONDOWN = 0x0207
Global Const $WM_MBUTTONUP = 0x0208
;Consts/structs from msdn
Global Const $MSLLHOOKSTRUCT = $tagPOINT & ";dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo"
;Register callback
$hKey_Proc = DllCallbackRegister("_Mouse_Proc", "int", "int;ptr;ptr")
$hM_Module = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
$hM_Hook = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_MOUSE_LL, "ptr", DllCallbackGetPtr($hKey_Proc), "hwnd", $hM_Module[0], "dword", 0)

Func _Mouse_Proc($nCode, $wParam, $lParam) ;function called for mouse events..
    ;define local vars
    Local $info, $ptx, $pty, $mouseData, $flags, $time, $dwExtraInfo
    Local $xevent = "Unknown", $xmouseData = ""

    If $nCode < 0 Then ;recommended, see http://msdn.microsoft.com/en-us/library/ms644986(VS.85).aspx
        $ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], _
                "int", $nCode, "ptr", $wParam, "ptr", $lParam) ;recommended
        Return $ret[0]
    EndIf

    $info = DllStructCreate($MSLLHOOKSTRUCT, $lParam) ;used to get all data in the struct ($lParam is the ptr)
    $ptx = DllStructGetData($info, 1) ;see notes below..
    $pty = DllStructGetData($info, 2)
    $mouseData = DllStructGetData($info, 3)
    $flags = DllStructGetData($info, 4)
    $time = DllStructGetData($info, 5)
    $dwExtraInfo = DllStructGetData($info, 6)
    ; $ptx = Mouse x position
    ; $pty = Mouse y position
    ; $mouseData = can specify click states, and wheel directions
    ; $flags = Specifies the event-injected flag
    ; $time = Specifies the time stamp for this message
    ; $dwExtraInfo = Specifies extra information associated with the message.

    ;Find which event happened
	Select
        Case $wParam = $WM_MOUSEMOVE
            $xevent = "mMove" ; Se mueve el mouse
        Case $wParam = $WM_MOUSEWHEEL
            $xevent = "mWheel"
            If _WinAPI_HiWord($mouseData) > 0 Then
                $xmouseData = "mWheelF"
            Else
                $xmouseData = "mWheelB"
            EndIf
        Case $wParam = $WM_LBUTTONDBLCLK
            $xevent = "dLeft"
        Case $wParam = $WM_LBUTTONDOWN
            $xevent = "lDown"
        Case $wParam = $WM_LBUTTONUP
            $xevent = "lUp"
        Case $wParam = $WM_RBUTTONDBLCLK
            $xevent = "dRight"
        Case $wParam = $WM_RBUTTONDOWN
            $xevent = "rDown"
        Case $wParam = $WM_RBUTTONUP
            $xevent = "rUp"
        Case $wParam = $WM_MBUTTONDBLCLK
            $xevent = "dWheel"
        Case $wParam = $WM_MBUTTONDOWN
            $xevent = "wDown"
        Case $wParam = $WM_MBUTTONUP
            $xevent = "wUp"
    EndSelect

	$myptx = $ptx
	$mypty = $pty
	$mymaction = $xevent
	$mymouseData = $xmouseData
    ;This is recommended instead of Return 0
    $ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], _
            "int", $nCode, "ptr", $wParam, "ptr", $lParam)
	Return $ret[0]

EndFunc   ;==>_Mouse_Proc

Func OnAutoItExit()
    DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hM_Hook[0])
    $hM_Hook[0] = 0
    DllCallbackFree($hKey_Proc)
    $hKey_Proc = 0
EndFunc   ;==>OnAutoItExit