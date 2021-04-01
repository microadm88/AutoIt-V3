#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=drmobileico.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region
#EndRegion
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <String.au3>
#Include <WinAPI.au3>
#include <Misc.au3>
#include <UDFs\Capture.au3>
#include <UDFs\DroidInfoUDF.au3>
#include <UDFs\GUICtrlPicPNG.au3>
#include <UDFs\MouseControl.au3>

; Adding Files inside final EXE and Copy that files to Windows Temp Dir if Needed.
If Not FileExists(@TempDir & "\adb.exe") Then
	FileInstall("adb.exe", @TempDir & "\adb.exe", 1)
EndIf
If Not FileExists(@TempDir & "\AdbWinApi.dll") Then
	FileInstall("AdbWinApi.dll", @TempDir & "\AdbWinApi.dll", 1)
EndIf
If Not FileExists(@TempDir & "\AdbWinUsbApi.dll") Then
	FileInstall("AdbWinUsbApi.dll", @TempDir & "\AdbWinUsbApi.dll", 1)
EndIf

Global $localpath = @TempDir
Global $quot = Chr(13)
Global $myptx, $mypty, $mymaction, $mymouseData, $phoneptx, $phoneptx2, $phonepty, $phonepty2


Global $intsdcard = AndroInfo("sdcard")
	If StringInStr($intsdcard,"error") Then
		MsgBox("","","Opps!!! there is an error, check the info: "&@CRLF&$intsdcard)
		Exit
	EndIf

$dimen = Capture($intsdcard,$localpath,1)
If Not StringInStr($dimen,"error") Then
	$wDim = StringSplit($dimen,"|")
	$iW = $wDim[1]
	$iH = $wDim[2]
Else
	MsgBox("","","Opps!!! there is an error, check the info: "&@CRLF&$dimen)
EndIf
$scale = "1.5"
; Create GUI
Local $hMainGUI = GUICreate("DrMobile Android Control", ($iW/$scale)-1, ($iH/$scale)-1)
GUISetState(@SW_SHOW)

HotKeySet("{F5}","Refresh")
HotKeySet("{ESC}","Home")
HotKeySet("{Enter}","WakeUp")

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch

	Local $wPos = WinGetPos($hMainGUI)
	Local $xreach = $wPos[0] + ($iW/$scale)+1
	Local $yreach = $wPos[1]+22 + ($iH/$scale)+1


	If $myptx >= $wPos[0] And $myptx <= $xreach And $mypty >= ($wPos[1]+22) And $mypty <= $yreach Then
		$vDLL = DllOpen("user32.dll")
		$phoneptx = ((($iW/$scale)+1) - ($xreach - $myptx)) * $scale
		$phonepty = ((($iH/$scale)+1) - ($yreach - $mypty)) * $scale
		$press = "0"
		; This Perform Swipe on Screen or Tap on Screen, depend if you click and move or just Click.
		While _IsPressed("01", $vDLL)
			$phoneptx2 = ((($iW/$scale)+1) - ($xreach - $myptx)) * $scale
			$phonepty2 = ((($iH/$scale)+1) - ($yreach - $mypty)) * $scale
			$press = "1"
		WEnd
		If $press == "1" And $phoneptx <> $phoneptx2 Or $press == "1" And $phonepty <> $phonepty2 Then
				RunWait(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell input swipe "&$phoneptx&" "&$phonepty&" "&$phoneptx2&" "&$phonepty2, "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
				Sleep(400)
				Refresh()
			ElseIf $press == "1" And $phoneptx == $phoneptx2 Or $press == "1" And $phonepty == $phonepty2 Then
				RunWait(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell input tap "&$phoneptx&" "&$phonepty, "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
				Sleep(400)
				Refresh()
			EndIf

		; Move Forward on Settings or List Menu(DPAD UP)
		If $mymaction == "mWheel"  And $mymouseData = "mWheelF" Then
			RunWait(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell input keyevent 19", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
			Sleep(400)
			Refresh()
		EndIf
		; Move Backward on Settings or List Menu(DPAD DOWN)
		If $mymaction == "mWheel" And $mymouseData = "mWheelB" Then
			RunWait(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell input keyevent 20", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
			Sleep(400)
			Refresh()
		EndIf
		; Back Buttom Pressed
		If $mymaction == "rDown" Then
			RunWait(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell input keyevent 4", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
			Sleep(400)
			Refresh()
		EndIf
		; Wheel Down Perform Refresh screen operation also HotKey (F5)
		If $mymaction == "wDown" Then
			Refresh()
		EndIf
	DllClose($vDLL)
	EndIf

WEnd


; Refresh Screen
Func Refresh()
	Capture($intsdcard,$localpath)
	_GUICtrlPic_Create($localpath&"\cap.png", -1,-1,($iW/$scale)-1,($iH/$scale)-1)
EndFunc
; Home Buttom Pressed
Func Home()
	RunWait(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell input keyevent 3", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
	Capture($intsdcard,$localpath)
	_GUICtrlPic_Create($localpath&"\cap.png", -1,-1,($iW/$scale)-1,($iH/$scale)-1)
EndFunc
; WakeUp Event (Power Buttom)
Func WakeUp()
	RunWait(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell input keyevent 26", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
	Capture($intsdcard,$localpath)
	_GUICtrlPic_Create($localpath&"\cap.png", -1,-1,($iW/$scale)-1,($iH/$scale)-1)
EndFunc


