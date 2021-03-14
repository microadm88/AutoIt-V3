#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.12.0
 Author:         Jesux Herrera

 Script Function:
	https://autoithacks.wordpress.com/
#ce ----------------------------------------------------------------------------
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
$Form1 = GUICreate("Explorador Subcarpetas - AutoitHacks", 380, 388, -1, -1)
$Input1 = GUICtrlCreateInput("", 24, 24, 281, 21)
$Button1 = GUICtrlCreateButton(".....", 304, 22, 51, 25)
$Button2 = GUICtrlCreateButton("Escanear Carpeta", 24, 56, 331, 25)
$Edit1 = GUICtrlCreateEdit("", 24, 96, 329, 249)
$Label1 = GUICtrlCreateLabel("http://autoithacks.wordpress.com/", 88, 360, 202, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Verdana")
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			Case $Button1
			$mensaje = "Seleccione una Carpeta"
			$folder = FileSelectFolder($mensaje, "")
			GUICtrlSetData($Input1, $folder)
		Case $Button2
			Local $SourceFolder
			$source = GUICtrlRead($Input1)
			Dim $FolderName = $source
			Dim $FileCount = 0
			ScanFolder($FolderName)
	EndSwitch
WEnd
Func ScanFolder($SourceFolder)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath

	$Search = FileFindFirstFile($SourceFolder & "\*.*")

	While 2
		If $Search = -1 Then
			ExitLoop
		EndIf

		$File = FileFindNextFile($Search)
		If @error Then ExitLoop

		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)

		If StringInStr($FileAttributes,"D") Then
			ScanFolder($FullFilePath)
		Else
			LogFile($FullFilePath)
		EndIf

	WEnd

	FileClose($Search)
EndFunc
Func LogFile($FileName)
	FileWriteLine(@ScriptDir & "\Archivos-AutoitHacks.txt",$FileName)
	$FileCount += 1
	_GUICtrlEdit_AppendText($Edit1, $FileName & "" & @CRLF)
	Sleep(50)
	FileWriteLine(@ScriptDir & "\Archivos-AutoitHacks.txt","---------------------------------------------------------------------------------")
EndFunc