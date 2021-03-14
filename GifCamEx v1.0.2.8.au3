#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
;~ #AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=c:\ProgramData\GifCam1.ico
#AutoIt3Wrapper_Outfile=GifCamEx.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#pragma compile(x64, false)
#AutoIt3Wrapper_Res_Description=GifCamEx
#AutoIt3Wrapper_Res_Field=Made By|wakillon
#AutoIt3Wrapper_Res_Fileversion=1.0.2.8
#AutoIt3Wrapper_Res_LegalCopyright=wakillon 2015
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Run_Au3Stripper=y
#au3stripper_Parameters=/so /mo
#AutoIt3Wrapper_Run_After=del "%scriptfile%_stripped.au3"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiListView.au3>
#Include <GuiMenu.au3>
#Include <GDIPlus.au3>
#Include <Timers.au3>
#EndRegion ;************ Includes ************

Opt ( 'GUIOnEventMode', 1 )
Opt ( 'MustDeclareVars', 1 )
Opt ( 'GUICloseOnESC', 0 )
AutoItWinSetTitle ( 'G1fCam3x' )
If _ScriptIsAlreadyRunning() Then Exit MsgBox ( 262144+16, 'Exiting', 'GifCamEx is Already Running !', 4 )

#Region ------ Global Variables ------------------------------
; Button Constants

Global Const $BS_SPLITBUTTON = 0x0000000C
Global Const $BS_DEFPUSHBUTTON = 0x0001
Global Const $BCN_FIRST = -1250
Global Const $BCN_DROPDOWN = ($BCN_FIRST + 0x0002)
; Windows Constants
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_CLIPSIBLINGS = 0x04000000
Global Const $WS_EX_LAYERED = 0x00080000
Global Const $WS_EX_TOPMOST = 0x00000008
Global Const $WS_POPUPWINDOW = 0x80880000
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_GETMINMAXINFO = 0x0024
Global Const $WM_WINDOWPOSCHANGING = 0x0046
Global Const $WM_LBUTTONDOWN = 0x0201
Global Const $WS_EX_APPWINDOW = 0x00040000
Global Const $WS_EX_MDICHILD = 0x00000040
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WM_MOVE = 0x0003
Global Const $WM_SIZE = 0x0005
Global Const $WM_TIMER = 0x0113
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_EX_WINDOWEDGE = 0x00000100
Global Const $WS_BORDER = 0x00800000
Global Const $WS_VSCROLL = 0x00200000
Global Const $SM_CXVSCROLL = 2
Global Const $WS_HSCROLL = 0x00100000
Global Const $SM_CYHSCROLL = 3
Global Const $WM_SYSCOMMAND = 0x0112
Global Const $SM_CXFRAME = 32
Global Const $SM_CYFRAME = 33
Global Const $SM_CYCAPTION = 4
; Avi Constants
Global $hAvifil32Dll
Global Const $OF_CREATE = 0x00001000
Global Const $AVIIF_KEYFRAME = 0x00000010
Global Const $AVIERR_OK = 0
Global Const $ICINFO = "DWORD dwSize;DWORD fccType;DWORD fccHandler;DWORD dwFlags;DWORD dwVersion;DWORD dwVersionICM;WCHAR szName[16];WCHAR szDescription[128];WCHAR szDriver[128];"
Global Const $BITMAPINFOHEADER = "dword biSize;long biWidth;long biHeight;short biPlanes;short biBitCount;dword biCompression;" & _
	"dword biSizeImage;long biXPelsPerMeter;long biYPelsPerMeter;dword biClrUsed;dword biClrImportant;"
Global Const $AVISTREAMINFO = "dword fccType;dword fccHandler;dword dwFlags;dword dwCaps;short wPriority;short wLanguage;dword dwScale;" & _
	"dword dwRate;dword dwStart;dword dwLength;dword dwInitialFrames;dword dwSuggestedBufferSize;dword dwQuality;dword dwSampleSize;int rleft;int rtop;int rright;int rbottom;dword dwEditCount;dword dwFormatChangeCount;wchar[64];"
Global Const $AVICOMPRESSOPTIONS = "DWORD fccType;DWORD fccHandler;DWORD dwKeyFrameEvery;DWORD dwQuality;DWORD dwBytesPerSecond;" & _
	"DWORD dwFlags;PTR lpFormat;DWORD cbFormat;PTR lpParms;DWORD cbParms;DWORD dwInterleaveEvery;"
; Notify Constants
Global Const $NM_FIRST = 0
Global Const $NM_CLICK = $NM_FIRST - 2
Global Const $NM_DBLCLK = $NM_FIRST - 3
Global Const $NM_RCLICK = $NM_FIRST - 5
;
Global Const $SC_DRAGMOVE = 0xF012
;
Global $hGui, $idButtonRec, $idButtonFrame, $idButtonEdit, $idButtonSave, $idLabelGrey, $idLabelLeft, $idLabelRight, $idLabelTop, $idLabelBottom, $idLabelBkGround
Global $hGuiAbout, $idLabelLink, $hGuiPreview, $hGuiProgress, $idProgressbar, $hGuiEdit
Global $iPopup, $iMsg, $iLabelWidth, $iGuiWidth, $iGuiHeight, $iRecord, $iSave, $iEdit, $iFrame, $iAbout, $iPreview, $iExportToAvi, $hTimerInitRecord, $iFPSRecord, $aLabelPos, $iStart, $iFrameCountTotal, $iFrameCount, $aMaxDim, $aGuiClientPos
Global $ahImage[1], $aFrameDelay[1], $aPos, $aPosEdit
Global $sFileName, $sFileName2, $iCursor, $aBkPos, $sAviFilePath, $sAviFilePath2, $aAviStream, $iReduction, $sFileOpen, $iOpen, $iLockSize
Global $idTimer1, $idTimer2 ; Timer1 = Display Frames Dimension in gui title, Timer2 = Capture frames
Global $hDesktop, $tRect, $ltpoint, $hDDC, $hCDC, $hBMP, $hImageList, $hDC
Global $hBitmapBuff, $hGraphicBuffer, $hGraphicGui, $iWidth, $iHeight, $hImageTmp, $iEffect
Global $sRegTitleKey = 'GifCamEx', $sRegKeySettings = 'HKCU' & StringReplace ( StringReplace ( @OSArch, 'x64', '64' ), 'x86', '' ) & '\Software\' & $sRegTitleKey & '\Settings'
Global $sVersion = _ScriptGetVersion()
Global $ghGDIPDll, $gbGDIP_V1_0
Global $sGDIPVersion = _GdipGetVersionByOS()
If $sGDIPVersion < 1.1 Then Exit MsgBox ( 262144+16, 'Exiting', 'Your version of GDIPlus is not compatible with this script !', 4 )
#EndRegion --- Global Variables ------------------------------

Global $tCurrentFrame, $hGIFControl, $hGIFThread, $ahIcons[1]
Global $idListView, $hListView, $Msg, $iCount, $iDim1 = 200, $iDim2 = 200
Global $iIndex, $iLeftClick = 0, $iRightClick = 0

#Region ------ Init ------------------------------
OnAutoItExitRegister ( '_OnAutoItExit' )
_FileInstall()
_Gui()
_GuiAbout()
_GuiPreview()
_GuiEdit()
_GuiProgress()
_GDIPlus_Startup()
$ghGDIPDll = $__g_hGDIPDll
$gbGDIP_V1_0 = $__g_bGDIP_V1_0
$idTimer1 = _Timer_SetTimer ( $hGui, 250, '_GuiDisplayFramesDimension' )
#EndRegion --- Init ------------------------------

#Region ------ Main Loop ------------------------------
While 1
	Select
		Case $iPopup <> 0
			;;;;;;;;;;;;;;;;;;;; Popup Menu
			Switch $iPopup
				Case GUICtrlGetHandle ( $idButtonRec )
					_GuiCtrlMenu_ShowPopup1 ( $idButtonRec )
				Case GUICtrlGetHandle ( $idButtonSave )
					_GuiCtrlMenu_ShowPopup2 ( $idButtonSave )
			EndSwitch
			$iPopup = 0
		Case $iRecord = True And $iStart = 0
			;;;;;;;;;;;;;;;;;;;; Record
			If _WindowIsVisible ( $hGuiPreview ) Then _GuiPreviewHide()
			If _WindowIsVisible ( $hGuiEdit ) Then _GuiEditHide()
			$iLockSize = RegRead ( $sRegKeySettings, 'LockSize' )
			If @error Then $iLockSize = 0
			$aPos = WinGetPos ( $hGui ) ; for lock gui size with _WM_GETMINMAXINFO.
			$iFPSRecord = RegRead ( $sRegKeySettings, 'FPS' )
			If @error Then $iFPSRecord = 10
			$iCursor = RegRead ( $sRegKeySettings, 'Cursor' )
			If @error Then $iCursor = 1
			$hDesktop = _WinAPI_GetDesktopWindow() ; GUICtrlGetHandle ( $idLabelBkGround )
			If Not $hDDC Then $hDDC = _WinAPI_GetDC ( $hDesktop )
			If Not $hCDC Then $hCDC = _WinAPI_CreateCompatibleDC ( $hDDC )
			$aLabelPos = ControlGetPos ( $hGui, '', $idLabelBkGround )
			$hBMP = _WinAPI_CreateCompatibleBitmap ( $hDDC, $aLabelPos[2], $aLabelPos[3] )
			_WinAPI_SelectObject ( $hCDC, $hBMP )
			$hTimerInitRecord = TimerInit()
			$idTimer2 = _Timer_SetTimer ( $hGui, 1000 / $iFPSRecord, '_Record' )
			$iStart = 1
		Case $iSave = 1
			;;;;;;;;;;;;;;;;;;;; Save
			If UBound ( $ahImage ) > 1 Then ; if there is capture done.
				$aMaxDim = _AnimatedGifGetMaxDimension()
				If Not @error Then
					$sFileName2 = @TempDir & '\' & @YEAR & @MON & @MDAY & ' - ' & @HOUR & @MIN & @SEC & ' - ' & @MSEC & '.gif'
					$sFileName = @DesktopDir & '\' & @YEAR & @MON & @MDAY & ' - ' & @HOUR & @MIN & @SEC & ' - ' & @MSEC +1 & '.gif'
					$sFileName = FileSaveDialog ( 'GifCamEx', @DesktopDir, '(*.gif)', 2+16, $sFileName, $hGui )
					If Not @error Then
						If StringRight ( $sFileName, 4 ) <> '.gif' Then $sFileName = $sFileName & '.gif'
						GUISetState ( @SW_SHOW, $hGuiProgress )
						_Save ( $sFileName2 )
						If @error Then
							MsgBox ( 262144+16, 'Error', 'Gif can not be Saved !', 5 )
						Else
							$iReduction = _GifSicleOptimize ( $sFileName2, $sFileName )
							If @error Then
								MsgBox ( 262144+16, 'Error', 'Gif can not be Optimized !', 5 )
								FileMove ( $sFileName2, $sFileName, 1+8 )
							Else
;~                              ConsoleWrite ( '+ Reduction : ' & $iReduction & '%' & @Crlf )
							EndIf
							DllCall ( 'psapi.dll', 'int', 'EmptyWorkingSet', 'long', -1 )
						EndIf
						_GuiProgressHide()
						GUICtrlSetData ( $idProgressbar, 0 )
					Else
						MsgBox ( 262144+16, 'Error', 'Save Operation Aborted !', 5 )
					EndIf
				Else
					MsgBox ( 262144+16, 'Error', 'Save Operation Aborted !', 5 )
				EndIf
			Else
				MsgBox ( 262144+16, 'Error', 'There is no image to Save !', 5 )
			EndIf
			$iSave = 0

			#Region ------ Edit ------------------------------
		Case $iEdit = 1
			;;;;;;;;;;;;;;;;;;;; Edit
			If UBound ( $ahImage ) > 1 Then ; if there is at least 1 frame.
				$aMaxDim = _AnimatedGifGetMaxDimension()
				If Not @error Then
					$iDim2 = _Min ( $aMaxDim[1], @DesktopHeight - 200 )
					$iDim1 = $iDim2*( $aMaxDim[0]/$aMaxDim[1] )
					_WinSetClientPos ( $hGuiEdit, $iDim1, $iDim2+80 )
					$aPosEdit = WinGetPos ( $hGuiEdit ) ; used for lock $hGuiEdit height.
					WinSetTitle ( $hGuiEdit, '', 'Edit : ' & UBound ( $ahImage ) -1 & ' Frames, ' &  $aMaxDim[0] & 'x' & $aMaxDim[1] )
					$iCount = UBound ( $ahImage ) -1
					GUISetState ( @SW_MINIMIZE, $hGuiEdit ) ; $hGuiEdit must be "visible" for avoid to loose the listview scrollbar.
					; create listview for frames.
					$idListView = GUICtrlCreateListView ( '',  0, 30, $iDim1, $iDim2+50, BitOR ( $LVS_AUTOARRANGE, $LVS_SINGLESEL ) )
					$hListView = GUICtrlGetHandle ( $idListView )
					_GUICtrlListView_SetExtendedListViewStyle ( $hListView, BitOR ( $LVS_EX_FLATSB, $LVS_EX_FULLROWSELECT, $LVS_EX_DOUBLEBUFFER ) )
					_GUICtrlListView_SetView ( $hListView, 0 )
					_GUICtrlListView_SetIconSpacing ( $hListView, $iDim1 +2, 0 ) ; Margin of 2 pixels between frames.
					_GUICtrlListView_SetWorkAreas ( $hListView, 0, 0, ( $iDim1 +2 ) * $iCount +30, $iDim2 +50 )
					$hImageList = _GUiImageList_Create ( $iDim1, $iDim2, 5, 3 )
					_GUICtrlListView_SetImageList ( $hListView, $hImageList, 0 )
					GUISetState ( @SW_SHOW, $hGuiProgress )
					$hGraphicGui = _GDIPlus_GraphicsCreateFromHWND ( $hGuiEdit )
					$hBitmapBuff = _GDIPlus_BitmapCreateFromGraphics ( $iDim1, $iDim2, $hGraphicGui ) ; buffer.
					$hGraphicBuffer = _GDIPlus_ImageGetGraphicsContext ( $hBitmapBuff ) ; access to the buffer.
					$iEffect = RegRead ( $sRegKeySettings, 'Effect' )
					If @error Then $iEffect = 0
					; Load images
					For $i = 1 To $iCount
						GUICtrlSetData ( $idProgressbar, ( $i/$iCount )*100 )
						$iWidth = _GDIPlus_ImageGetWidth ( $ahImage[$i] )
						$iHeight = _GDIPlus_ImageGetHeight ( $ahImage[$i] )
						; apply effect to next temp frames.
						$hImageTmp = _GifFrameApplyEffect ( $ahImage[$i], $iWidth, $iHeight, $iEffect )
						_GDIPlus_GraphicsClear ( $hGraphicBuffer, 0xFFFFFFFF ) ; set bkg to white.
						_GDIPlus_GraphicsDrawImageRectRect ( $hGraphicBuffer, $hImageTmp, 0, 0, $iWidth, $iHeight, ( $iDim1-$iWidth )/2, ( $iDim2-$iHeight )/2, $iWidth, $iHeight )
						$hBmp = _ImageCreateHBitmap ( $hBitmapBuff, $iDim1, $iDim2 )
						_GUiImageList_Add ( $hImageList, $hBmp )
						_GUICtrlListView_AddItem ( $hListView, 'Frame ' & $i & ' delay : ' & $aFrameDelay[$i]/100 & ' sec', $i -1 )
						_GUICtrlListView_SetItemImage ( $hListView, $i -1, $i -1 )
						_WinAPI_DeleteObject ( $hBmp )
						_GDIPlus_ImageDispose ( $hImageTmp )
					Next
					_GDIPlus_GraphicsDispose ( $hGraphicBuffer )
					_GDIPlus_GraphicsDispose ( $hGraphicGui )
					_GDIPlus_BitmapDispose ( $hBitmapBuff )
					_GuiProgressHide()
					GUISetState ( @SW_SHOWNORMAL, $hGuiEdit )
				EndIf
			Else
				MsgBox ( 262144+16, 'Error', 'There is no frame to Edit !', 5 )
			EndIf
			$iEdit = 0
			#EndRegion --- Edit ------------------------------

		Case $iFrame = 1
			;;;;;;;;;;;;;;;;;;;; Add one Frame.
			If $idTimer2 = 0 Then
				If _WindowIsVisible ( $hGuiPreview ) Then _GuiPreviewHide()
				If _WindowIsVisible ( $hGuiEdit ) Then _GuiEditHide()
				$iLockSize = RegRead ( $sRegKeySettings, 'LockSize' )
				If @error Then $iLockSize = 0
				$aPos = WinGetPos ( $hGui ) ; for lock gui size with _WM_GETMINMAXINFO.
				$iCursor = RegRead ( $sRegKeySettings, 'Cursor' )
				If @error Then $iCursor = 1
				$hDesktop = _WinAPI_GetDesktopWindow()
				If Not $hDDC Then $hDDC = _WinAPI_GetDC ( $hDesktop )
				If Not $hCDC Then $hCDC = _WinAPI_CreateCompatibleDC ( $hDDC )
				$aLabelPos = ControlGetPos ( $hGui, '', $idLabelBkGround )
				$hBMP = _WinAPI_CreateCompatibleBitmap ( $hDDC, $aLabelPos[2], $aLabelPos[3] )
				_WinAPI_SelectObject ( $hCDC, $hBMP )
				$iFPSRecord = RegRead ( $sRegKeySettings, 'FPS' )
				If @error Then $iFPSRecord = 10
				_Record ( Default, Default, Default, Default )
				_ImageGroupIdenticalFrames()
			Else
				MsgBox ( 262144+16, 'Error', 'Stop Record if you want Capture unique Frame !', 5 )
			EndIf
			$iFrame = 0
		Case $iAbout = 1
			;;;;;;;;;;;;;;;;;;;; About
			GUISetState ( @SW_SHOWNORMAL, $hGuiAbout )
			$iAbout = 0

			#Region ------ Preview ------------------------------
		Case $iPreview = 1
			;;;;;;;;;;;;;;;;;;;; Preview
			If UBound ( $ahImage ) > 1 Then
				$aMaxDim = _AnimatedGifGetMaxDimension()
				If Not @error Then
					GUISetState ( @SW_HIDE, $hGuiPreview )
					_WinSetClientPos ( $hGuiPreview, $aMaxDim[0], $aMaxDim[1] )
					ControlMove ( $hGuiPreview, '', $hGIFControl, 0, 0, $aMaxDim[0], $aMaxDim[1] )
					$hGIFThread = _AnimateGifInAnotherThread ( $hGIFControl, $tCurrentFrame )
					WinSetTitle ( $hGuiPreview, '', 'Preview : ' & UBound ( $ahImage ) -1 & ' Frames, ' & $aMaxDim[0] & 'x' & $aMaxDim[1] )
					GUISetState ( @SW_SHOWNORMAL, $hGuiPreview )
				Else
					MsgBox ( 262144+16, 'Error 1', 'Preview can not be created !', 5 )
				EndIf
			Else
				MsgBox ( 262144+16, 'Error 2', 'Preview can not be created !', 5 )
			EndIf
			$iPreview = 0
			#EndRegion --- Preview ------------------------------

		Case $iExportToAvi = 1
			;;;;;;;;;;;;;;;;;;;; ExportToAvi
			If UBound ( $ahImage ) > 1 Then ;  if there is at least 1 second of capture done.
				$aMaxDim = _AnimatedGifGetMaxDimension()
				If Not @error Then
					_WinSetClientPos ( $hGuiPreview, $aMaxDim[0], $aMaxDim[1] )
					$sFileName = FileSaveDialog ( 'GifCamEx', @DesktopDir, '(*.avi)', 2+16, @DesktopDir & '\' & @YEAR & @MON & @MDAY & ' - ' & @HOUR & @MIN & @SEC & ' - ' & @MSEC & '.avi', $hGui )
					If Not @error Then
						If StringRight ( $sFileName, 4 ) <> '.avi' Then $sFileName = $sFileName & '.avi'
						$sAviFilePath2 = _AVIFileBuild ( $sFileName, 'CVID' ) ; CVID = compressed using Cinepak (Radius)
						If @error or FileGetSize ( $sAviFilePath2 ) = 0 Then
							MsgBox ( 262144+16, 'Error 1', 'Export To Avi Operation Failed !', 5 )
							FileDelete ( $sAviFilePath2 )
						EndIf
					Else
						MsgBox ( 262144+16, 'Error 2', 'Export To Avi Operation Aborted !', 5 )
					EndIf
				Else
					MsgBox ( 262144+16, 'Error 3', 'Export To Avi Operation Failed !', 5 )
				EndIf
				DllCall ( 'psapi.dll', 'int', 'EmptyWorkingSet', 'long', -1 )
			Else
				MsgBox ( 262144+16, 'Error 4', 'Export To Avi Operation Failed !', 5 )
			EndIf
			$iExportToAvi = 0

			#Region ------ Open ------------------------------
		Case $iOpen = 1
			;;;;;;;;;;;;;;;;;;;; Open
			If _WindowIsVisible ( $hGuiPreview ) Then _GuiPreviewHide()
			$sFileOpen = FileOpenDialog ( 'Select a Gif', @DesktopDir & '\', 'Images (*.gif)', 1 + 2, '', $hGui )
			If @error Then
				MsgBox ( 262144+16, 'Aborted', 'No File Was Selected.' )
			Else
				_AnimatedGifExtractFrames ( $sFileOpen )
			EndIf
			$iOpen = 0
			#EndRegion --- Open ------------------------------

		Case $iRightClick = 1
			_GuiCtrlMenu_ShowPopup3 ( $hListView )
			$iLeftClick = 0
			$iRightClick = 0
		Case Else
			Sleep ( 240 )
	EndSelect
	Sleep ( 10 )
WEnd
#EndRegion --- Main Loop ------------------------------

Func _AnimatedGifExtractFrames ( $sGifPath )
	Local $sTmp = @TempDir & '\' & @HOUR & @MIN & @SEC & @MSEC & '.gif'
	Local $iDeComp = _GifSicleUnOptimize ( $sGifPath, $sTmp )
	ConsoleWrite ( '!->-- [' & StringFormat ( '%03i', @ScriptLineNumber ) & '] UnOptimization : ' & $iDeComp &  '%' & @Crlf )
	Local $hImage = _GDIPlus_ImageLoadFromFile ( $sTmp )
	Local $iWidth = _GDIPlus_ImageGetWidth ( $hImage )
	Local $iHeight = _GDIPlus_ImageGetHeight ( $hImage )
	$iFPSRecord = RegRead ( $sRegKeySettings, 'FPS' )
	If @error Then $iFPSRecord = 10
	Local $tGUID = DllStructCreate ( $tagGUID )
	Local $pGUID = DllStructGetPtr ( $tGUID )
	Local $GFDC = DllCall ( $ghGDIPDll, 'int', 'GdipImageGetFrameDimensionsCount', 'ptr', $hImage, 'int*', 0 )
	DllCall ( $ghGDIPDll, 'int', 'GdipImageGetFrameDimensionsList', 'ptr', $hImage, 'ptr', $pGUID, 'int', $GFDC[2] )
	Local $hBmp, $hBitmap, $iFrameCount = _AnimatedGifGetFrameCount ( $sTmp )
	GUISetState ( @SW_SHOW, $hGuiProgress )
	Local $aDelays = _AnimatedGifGetFramesDelays ( $sGifPath )
	For $i = 0 To $iFrameCount -1
		GUICtrlSetData ( $idProgressbar, ( ( $i+1 )/$iFrameCount )*100 )
		DllCall ( $ghGDIPDll, 'uint', 'GdipImageSelectActiveFrame', 'handle', $hImage, 'ptr', $pGUID, 'uint', $i )
		$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap ( $hImage, 0xFFFFFFFF ) ; set bk transparency to white instead of black.
		$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP ( $hBMP )
		_ArrayAdd ( $ahImage, $hBitmap )
		_ArrayAdd ( $aFrameDelay, $aDelays[$i+1] ) ; 100/$iFPSRecord ) ; gif frame delay is in hundredth of second.
		_WinAPI_DeleteObject ( $hBmp )
		Sleep ( 10 )
	Next
	_GDIPlus_ImageDispose ( $hImage )
	Sleep ( 250 )
	_GuiProgressHide()
	GUICtrlSetData ( $idProgressbar, 0 )
	$aGuiClientPos = _WinGetClientPos ( $hGui )
	_WinSetClientPos ( $hGui, $iWidth + $iLabelWidth, $iHeight, $aGuiClientPos[0], $aGuiClientPos[1] )
	FileDelete ( $sTmp )
EndFunc ;==> _AnimatedGifExtractFrames()

Func _AnimatedGifGetFrameCount ( $sGifPath )
	Local $hImage = _GDIPlus_ImageLoadFromFile ( $sGifPath )
	Local $tGUID = DllStructCreate ( $tagGUID )
	Local $pGUID = DllStructGetPtr ( $tGUID )
	Local $aGFDC = DllCall ( $ghGDIPDll, 'int', 'GdipImageGetFrameDimensionsCount', 'ptr', $hImage, 'int*', 0 )
	DllCall ( $ghGDIPDll, 'int', 'GdipImageGetFrameDimensionsList', 'ptr', $hImage, 'ptr', $pGUID, 'int', $aGFDC[2] )
	Local $aGFC = DllCall ( $ghGDIPDll, 'int', 'GdipImageGetFrameCount', 'int', $hImage, 'ptr', $pGUID, 'int*', 0 )
	$tGUID = 0
	_GDIPlus_ImageDispose ( $hImage )
	Return $aGFC[3]
EndFunc ;==> _AnimatedGifGetFrameCount()

Func _AnimatedGifGetFramesDelays ( $sGifPath )
	Local Const $GDIP_PROPERTYTAGFRAMEDELAY = 0x5100
	Local $hImage = _GDIPlus_ImageLoadFromFile ( $sGifPath )
	Local $aCall = DllCall ( $ghGDIPDll, 'dword', 'GdipGetPropertyItemSize', 'ptr', $hImage, 'ptr', $GDIP_PROPERTYTAGFRAMEDELAY, 'dword*', 0 )
	Local $tRawPropItem = DllStructCreate ( 'byte[' & $aCall[3] & ']' )
	DllCall ( $ghGDIPDll, 'dword', 'GdipGetPropertyItem', 'ptr', $hImage, 'dword', $GDIP_PROPERTYTAGFRAMEDELAY, 'dword', $aCall[3], 'ptr', DllStructGetPtr ( $tRawPropItem ) )
	Local $tPropItem = DllStructCreate ( 'int Id;dword Length;word Type;ptr Value', DllStructGetPtr ( $tRawPropItem ) )
	Local $tPropertyData = DllStructCreate ( 'dword[' & DllStructGetData ( $tPropItem, 'Length' )/4 & ']', DllStructGetData ( $tPropItem, 'Value' ) )
	Local $aDelay[_AnimatedGifGetFrameCount ( $sGifPath )+1]
	For $i = 1 To UBound ( $aDelay ) -1
		$aDelay[$i] = DllStructGetData ( $tPropertyData, 1, $i ) ; delay in ms.
	Next
	$aDelay[0] = UBound ( $aDelay ) -1
	_GDIPlus_ImageDispose ( $hImage )
	Return $aDelay
EndFunc ;==> _AnimatedGifGetFramesDelays()

Func _AnimatedGifGetMaxDimension()
	If UBound ( $ahImage ) < 2 Then Return SetError ( 1, 0, 0 )
	Local $iWidth, $iHeight, $iWidthMax, $iHeightMax, $aRet[2]
	For $i = 1 To UBound ( $ahImage ) -1
		$iWidth = _GDIPlus_ImageGetWidth ( $ahImage[$i] )
		If $iWidth > $iWidthMax Then $iWidthMax = $iWidth
		$iHeight = _GDIPlus_ImageGetHeight ( $ahImage[$i] )
		If $iHeight > $iHeightMax Then $iHeightMax = $iHeight
	Next
	$aRet[0] = $iWidthMax
	$aRet[1] = $iHeightMax
	Return $aRet
EndFunc ;==> _AnimatedGifGetMaxDimension()

Func _AnimateGifInAnotherThread ( $hGIFControl, ByRef $tCurrentFrame ) ; by trancexx, adapted to my needs.
	Local $aCall = DllCall ( 'kernel32.dll', 'ptr', 'GetModuleHandleW', 'wstr', 'kernel32.dll' )
	If @error Or Not $aCall[0] Then Return SetError ( 1, 0, '' )
	Local $hHandle = $aCall[0]
	Local $aSleep = DllCall ( 'kernel32.dll', 'ptr', 'GetProcAddress', 'ptr', $hHandle, 'str', 'Sleep' )
	If @error Or Not $aSleep[0] Then Return SetError ( 2, 0, '' )
	Local $pSleep = $aSleep[0]
	Local $iUbound = UBound ( $ahImage ) -1
	$tCurrentFrame = DllStructCreate ( 'dword' )
	Local $pCurrentFrame = DllStructGetPtr ( $tCurrentFrame )
	Local $tagCodeBuffer
	Local $tCodeBuffer
	Local $pRemoteCode
	$aCall = DllCall ( 'kernel32.dll', 'ptr', 'GetModuleHandleW', 'wstr', 'user32.dll' )
	If @error Or Not $aCall[0] Then Return SetError ( 3, 0, '' )
	$hHandle = $aCall[0]
	Local $aDrawIconEx = DllCall ( 'kernel32.dll', 'ptr', 'GetProcAddress', 'ptr', $hHandle, 'str', 'DrawIconEx' )
	If @error Or Not $aDrawIconEx[0] Then Return SetError ( 5, 0, '' )
	Local $pDrawIconEx = $aDrawIconEx[0]
	For $i = 1 To $iUbound
		$tagCodeBuffer &= 'byte[74];'
	Next
	$tagCodeBuffer &= 'byte[6]'
	$tCodeBuffer = DllStructCreate ( $tagCodeBuffer )
	$pRemoteCode = DllCall ( 'kernel32.dll', 'ptr', 'VirtualAlloc', 'ptr', 0, 'dword', DllStructGetSize ( $tCodeBuffer ), 'dword', 4096, 'dword', 64 ) ; MEM_COMMIT, PAGE_EXECUTE_READWRITE
	$pRemoteCode = $pRemoteCode[0]
	$aCall = DllCall ( 'user32.dll', 'hwnd', 'GetDC', 'hwnd', GUICtrlGetHandle ( $hGIFControl ) )
	If @error Or Not $aCall[0] Then Return SetError ( 6, 0, '' )
	Local $hDC = $aCall[0], $hIcon
	Local $iEffect = RegRead ( $sRegKeySettings, 'Effect' )
	If @error Then $iEffect = 0
	GUISetState ( @SW_SHOW, $hGuiProgress )
	Local $hImageTmp, $iWidth, $iHeight, $hBitmapBuff, $hGraphicBuffer, $hGraphicGui = _GDIPlus_GraphicsCreateFromHDC ( $hDC )
	$hBitmapBuff = _GDIPlus_BitmapCreateFromGraphics ( $aMaxDim[0], $aMaxDim[1], $hGraphicGui ) ; buffer.
	$hGraphicBuffer = _GDIPlus_ImageGetGraphicsContext ( $hBitmapBuff ) ; access to the buffer.
	For $i = 1 To $iUbound
		GUICtrlSetData ( $idProgressbar, 100*$i/$iUbound )
		$iWidth = _GDIPlus_ImageGetWidth ( $ahImage[$i] )
		$iHeight = _GDIPlus_ImageGetHeight ( $ahImage[$i] )
		_GDIPlus_GraphicsClear ( $hGraphicBuffer, 0xFFFFFFFF ) ; set bkgd to white.
		_GDIPlus_GraphicsDrawImageRectRect ( $hGraphicBuffer, $ahImage[$i], 0, 0, $iWidth, $iHeight, ( $aMaxDim[0] -$iWidth )/2, ( $aMaxDim[1] -$iHeight )/2, $iWidth, $iHeight )
		$hImageTmp = _GifFrameApplyEffect ( $hBitmapBuff, $aMaxDim[0], $aMaxDim[1], $iEffect )
		$hIcon = _GDIPlus_HICONCreateFromBitmap ( $hImageTmp )
		_ArrayAdd ( $ahIcons, $hIcon )
		DllStructSetData ( $tCodeBuffer, $i, _
			'0x' & _
			'68' & _SwapEndian ( 3 ) & _                                   ; push Flags DI_NORMAL
			'68' & _SwapEndian ( 0 ) & _                                   ; push FlickerFreeDraw
			'68' & _SwapEndian ( 0 ) & _                                   ; push IfAniCur
			'68' & _SwapEndian ( 0 ) & _                                   ; push Height
			'68' & _SwapEndian ( 0 ) & _                                   ; push Width
			'68' & _SwapEndian ( $hIcon ) & _                              ; push handle to the icon
			'68' & _SwapEndian ( 0 ) & _                                   ; push Top
			'68' & _SwapEndian ( 0 ) & _                                   ; push Left
			'68' & _SwapEndian ( $hDC ) & _                                ; push DC
			'B8' & _SwapEndian ( $pDrawIconEx ) & _                        ; mov eax, DrawIconEx
			'FFD0' & _                                                     ; call eax
			'B8' & _SwapEndian ( $i -1 ) & _                               ; mov eax, $i-1
			'A3' & _SwapEndian ( $pCurrentFrame ) & _                      ; mov $pCurrentFrame, eax
			'68' & _SwapEndian ( Int ( $aFrameDelay[$i]*10 ) ) & _         ; push Milliseconds
			'B8' & _SwapEndian ( $pSleep ) & _                             ; mov eax, Sleep
			'FFD0' )                                                       ; call eax
		_GDIPlus_ImageDispose ( $hImageTmp )
		$hImageTmp = 0
	Next
	Sleep ( 500 )
	_GuiProgressHide()
	GUICtrlSetData ( $idProgressbar, 0 )
	_GDIPlus_GraphicsDispose ( $hGraphicBuffer )
	_GDIPlus_GraphicsDispose ( $hGraphicGui )
	_GDIPlus_BitmapDispose ( $hBitmapBuff )
	DllStructSetData ( $tCodeBuffer, $iUbound + 1, '0xE9' & _SwapEndian ( - ( $iUbound * 74 + 5 ) ) & 'C3' )
	DllCall ( 'kernel32.dll', 'none', 'RtlMoveMemory', 'ptr', $pRemoteCode, 'ptr', DllStructGetPtr ( $tCodeBuffer ), 'dword', DllStructGetSize ( $tCodeBuffer ) )
	$aCall = DllCall ( 'kernel32.dll', 'ptr', 'CreateThread', 'ptr', 0, 'dword', 0, 'ptr', $pRemoteCode, 'ptr', 0, 'dword', 0, 'dword*', 0 )
	If @error Or Not $aCall[0] Then Return SetError ( 7, 0, '' )
	Local $hGIFThread = $aCall[0]
	Return SetError ( 0, 0, $hGIFThread ) ; this is success
EndFunc ;==> _AnimateGifInAnotherThread()

Func _AviCreate_mmioFOURCC ( $FOURCC ) ; coded by UEZ - http://www.fourcc.org/codecs.php
	If StringLen ( $FOURCC ) <> 4 Then Return SetError ( 1, 0, 0 )
	Local $aFOURCC = StringSplit ( $FOURCC, '', 2 )
	Return BitOR ( Asc ( $aFOURCC[0] ), BitShift ( Asc ( $aFOURCC[1] ), -8 ), BitShift ( Asc ( $aFOURCC[2] ), -16 ), BitShift ( Asc ( $aFOURCC[3] ), -24 ) )
EndFunc ;==> _AviCreate_mmioFOURCC()

Func _AVIFileBuild ( $sAviFilePath, $sAviCodec='CVID' )
	_AVIFileInit()
	If @error Then Return SetError ( 1, 0, 0 )
	Local $iDuration = _FramesGetTotalTimeDelay()
	; get frame rate from capture.
	Local $iFPSRecord = 100/( $iDuration/$iFrameCountTotal )
	$aAviStream = _AVIFileCreateStream ( $sAviFilePath, $iFPSRecord, $aMaxDim[0], $aMaxDim[1], 24, $sAviCodec ) ; DIB = uncompressed, msvc = compressed using Microsoft Video 1, CVID = compressed using Cinepak (Radius)  http://www.jmcgowan.com/avicodecs.html
	If @error Then
		_AVIFileRelease ( $aAviStream )
		_AVIFileExit()
		Return SetError ( 2, 0, 0 )
	EndIf
	; create avi
	GUISetState ( @SW_SHOW, $hGuiProgress )
	Local $iEffect = RegRead ( $sRegKeySettings, 'Effect' )
	If @error Then $iEffect = 0
	Local $hImageTmp, $hBMP, $iWidth, $iHeight, $hBitmapBuff, $hGraphicBuffer, $hGraphicGui = _GDIPlus_GraphicsCreateFromHWND ( $hGuiPreview )
	$hBitmapBuff = _GDIPlus_BitmapCreateFromGraphics ( $aMaxDim[0], $aMaxDim[1], $hGraphicGui ) ; buffer.
	$hGraphicBuffer = _GDIPlus_ImageGetGraphicsContext ( $hBitmapBuff ) ; access to the buffer.
	For $i = 1 To UBound ( $ahImage ) -1
		GUICtrlSetData ( $idProgressbar, ( $i/( UBound ( $ahImage ) -1 ) )*100 )
		$iWidth = _GDIPlus_ImageGetWidth ( $ahImage[$i] )
		$iHeight = _GDIPlus_ImageGetHeight ( $ahImage[$i] )
		_GDIPlus_GraphicsClear ( $hGraphicBuffer, 0xFFFFFFFF ) ; set bk transparency to white instead of black.
		_GDIPlus_GraphicsDrawImageRectRect ( $hGraphicBuffer, $ahImage[$i], 0, 0, $iWidth, $iHeight, ($aMaxDim[0]-$iWidth)/2, ($aMaxDim[1]-$iHeight)/2, $iWidth, $iHeight )
		$hImageTmp = _GifFrameApplyEffect ( $hBitmapBuff, $aMaxDim[0], $aMaxDim[1], $iEffect )
		$hBMP = _GDIPlus_BitmapCreateHBITMAPFromBitmap ( $hImageTmp, 0xFFFFFFFF ) ; set bk transparency to white instead of black.
;~      $iFPSRecord = avi frames count per second.
;~      $aFrameDelay = gif frames delay (in hundredth of second).
;~      100/$iFPSRecord = avi frames delay (in hundredth of second).
		For $j = 100/$iFPSRecord To $aFrameDelay[$i] Step 100/$iFPSRecord ; adapt gif frame delays to video frame rate.
			_AVIStreamWrite ( $aAviStream, $hBMP )
			If @error Then
				_AVIFileRelease ( $aAviStream )
				_AVIFileExit()
				_GuiProgressHide()
				Return SetError ( 3, 0, 0 )
			EndIf
			Sleep ( 10 )
		Next
		_WinAPI_DeleteObject ( $hBMP )
		_GDIPlus_ImageDispose ( $hImageTmp )
		$hBMP = 0
		$hImageTmp = 0
	Next
	_GDIPlus_BitmapDispose ( $hBitmapBuff )
	_GDIPlus_GraphicsDispose ( $hGraphicGui )
	_AVIFileRelease ( $aAviStream )
	_AVIFileExit()
	_GuiProgressHide()
	GUICtrlSetData ( $idProgressbar, 0 )
	Return $sAviFilePath
EndFunc ;==> _AVIFileBuild()

Func _AVIFileCreateStream ( $sFilename, $FrameRate, $Width, $Height, $BitCount=24, $mmioFOURCC='MSVC' ) ; by monoceres, Prog@ndy, UEZ
	Local $RetArr[6] ; avi file handle, compressed stream handle, bitmap count, BitmapInfoheader, Stride, stream handle
	Local $aRet, $pFile, $tASI, $tACO, $pStream, $psCompressed
	Local $stride = BitAND ( ( $Width * ( $BitCount/8 ) + 3 ), BitNOT ( 3 ) )
	Local $tBI = DllStructCreate ( $BITMAPINFOHEADER )
	DllStructSetData ( $tBI, 'biSize', DllStructGetSize ( $tBI ) )
	DllStructSetData ( $tBI, 'biWidth', $Width )
	DllStructSetData ( $tBI, 'biHeight', $Height )
	DllStructSetData ( $tBI, 'biPlanes', 1 )
	DllStructSetData ( $tBI, 'biBitCount', $BitCount )
	DllStructSetData ( $tBI, 'biSizeImage', $stride * $Height )
	$tASI = DllStructCreate ( $AVISTREAMINFO )
	DllStructSetData ( $tASI, 'fccType', _AviCreate_mmioFOURCC ( 'vids' ) )
	DllStructSetData ( $tASI, 'fccHandler', _AviCreate_mmioFOURCC ( $mmioFOURCC ) )
	DllStructSetData ( $tASI, 'dwScale', 1 )
	DllStructSetData ( $tASI, 'dwRate', $FrameRate )
	DllStructSetData ( $tASI, 'dwQuality', -1 )
	DllStructSetData ( $tASI, 'dwSuggestedBufferSize', $stride * $Height )
	DllStructSetData ( $tASI, 'rright', $Width )
	DllStructSetData ( $tASI, 'rbottom', $Height )
	Local $tParms = DllStructCreate ( $ICINFO )
	DllCall ( 'Msvfw32.dll', 'BOOL', 'ICInfo', 'DWORD', _AviCreate_mmioFOURCC ( 'vidc' ), 'DWORD', _AviCreate_mmioFOURCC ( $mmioFOURCC ), 'ptr', DllStructGetPtr ( $tParms ) )
	$tACO = DllStructCreate ( $AVICOMPRESSOPTIONS )
	DllStructSetData ( $tACO, 'fccType', _AviCreate_mmioFOURCC ( 'vids' ) )
	DllStructSetData ( $tACO, 'fccHandler', _AviCreate_mmioFOURCC ( $mmioFOURCC ) )
	DllStructSetData ( $tACO, 'dwKeyFrameEvery', 10 )
	DllStructSetData ( $tACO, 'dwQuality', 10000 )
	DllStructSetData ( $tACO, 'dwBytesPerSecond', 0 )
	DllStructSetData ( $tACO, 'dwFlags', 8 )
	DllStructSetData ( $tACO, 'lpFormat', 0 )
	DllStructSetData ( $tACO, 'cbFormat', 0 )
	DllStructSetData ( $tACO, 'lpParms', DllStructGetPtr ( $tParms ) )
	DllStructSetData ( $tACO, 'cbParms', DllStructGetSize ( $tParms ) )
	DllStructSetData ( $tACO, 'dwInterleaveEvery', 0 )
	$aRet = DllCall ( $hAvifil32Dll, 'int', 'AVIFileOpenW', 'ptr*', 0, 'wstr', $sFilename, 'uint', $OF_CREATE, 'ptr', 0 )
	$pFile = $aRet[1]
	$aRet = DllCall ( $hAvifil32Dll, 'int', 'AVIFileCreateStream', 'ptr', $pFile, 'ptr*', 0, 'ptr', DllStructGetPtr ( $tASI ) )
	$pStream = $aRet[2]
	$aRet = DllCall ( $hAvifil32Dll, 'int', 'AVIMakeCompressedStream', 'ptr*', 0, 'ptr', $pStream, 'ptr', DllStructGetPtr ( $tACO ), 'ptr', 0 )
	If $aRet[0] <> $AVIERR_OK Then
		$RetArr[0] = $pFile
		$RetArr[1] = $pStream
		$RetArr[2] = 0
		$RetArr[3] = $tBI
		$RetArr[4] = $stride
		$RetArr[5] = $pStream
		Return SetError ( 2, 0, $RetArr )
	EndIf
	$psCompressed = $aRet[1]
	$aRet = DllCall ( $hAvifil32Dll, 'int', 'AVIStreamSetFormat', 'ptr', $psCompressed, 'long', 0, 'ptr', DllStructGetPtr ( $tBI ), 'long', DllStructGetSize ( $tBI ) )
	$RetArr[0] = $pFile
	$RetArr[1] = $psCompressed
	$RetArr[2] = 0
	$RetArr[3] = $tBI
	$RetArr[4] = $stride
	$RetArr[5] = $pStream
	Return $RetArr
EndFunc ;==> _AVIFileCreateStream()

Func _AVIFileExit() ; Release the library, by monoceres, Prog@ndy, UEZ
	DllCall ( $hAvifil32Dll, 'none', 'AVIFileExit' )
	DllClose ( $hAvifil32Dll )
EndFunc ;==> _AVIFileExit()

Func _AVIFileInit() ; Init the avi library, by monoceres, Prog@ndy, UEZ
	$hAvifil32Dll = DllOpen ( 'Avifil32.dll' )
	DllCall ( $hAvifil32Dll, 'none', 'AVIFileInit' )
EndFunc ;==> _AVIFileInit()

Func _AVIFileRelease ( $Avi_Handle )
	DllCall ( $hAvifil32Dll, 'int', 'AVIStreamRelease', 'ptr', $Avi_Handle[1] ) ; by monoceres, Prog@ndy, UEZ
	DllCall ( $hAvifil32Dll, 'int', 'AVIStreamRelease', 'ptr', $Avi_Handle[5] )
	DllCall ( $hAvifil32Dll, 'int', 'AVIFileRelease', 'ptr', $Avi_Handle[0] )
EndFunc ;==> _AVIFileRelease()

Func _AVIStreamWrite ( ByRef $Avi_Handle, $hBitmap ) ; Adds a bitmap file to an already opened avi file. by monoceres, Prog@ndy
	Local $DC = _WinAPI_GetDC ( 0 )
	Local $hDC = _WinAPI_CreateCompatibleDC ( $DC )
	_WinAPI_ReleaseDC ( 0, $DC )
	Local $OldBMP = _WinAPI_SelectObject ( $hDC, $hBitmap )
	Local $bits = DllStructCreate ( 'byte[' & DllStructGetData ( $Avi_Handle[3], 'biSizeImage' ) & ']' )
	_WinAPI_GetDIBits ( $hDC, $hBitmap, 0, Abs ( DllStructGetData ( $Avi_Handle[3], 'biHeight' ) ), DllStructGetPtr ( $bits ), DllStructGetPtr ( $Avi_Handle[3] ), 0 )
	_WinAPI_SelectObject ( $hDC, $OldBMP )
	_WinAPI_DeleteDC ( $hDC )
	DllCall ( $hAvifil32Dll, 'int', 'AVIStreamWrite', 'ptr', $Avi_Handle[1], 'long', $Avi_Handle[2], 'long', 1, 'ptr', DllStructGetPtr ( $bits ), 'long', DllStructGetSize ( $bits ), 'long', $AVIIF_KEYFRAME, 'ptr*', 0, 'ptr*', 0 )
	$Avi_Handle[2] += 1
EndFunc ;==> _AVIStreamWrite()

Func _Base64Decode ( $input_string ) ; by trancexx
	Local $struct = DllStructCreate ( 'int' )
	Local $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', 0, 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $a = DllStructCreate ( 'byte[' & DllStructGetData ( $struct, 1 ) & ']' )
	$a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', DllStructGetPtr ( $a ), 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 2, 0, '' )
	Return DllStructGetData ( $a, 1 )
EndFunc ;==> _Base64Decode()

Func _Exit()
	If $iRecord Then Return
	_Timer_KillTimer ( $hGui, $idTimer1 )
	If $idTimer2 <> 0 Then _Timer_KillTimer ( $hGui, $idTimer2 )
	_GuiAboutHide()
	_GuiEditHide()
	_GuiPreviewHide()
	_GuiProgressHide()
	GUISetState ( @SW_HIDE, $hGui )
	; Clean up resources.
	For $i = 1 To UBound ( $ahImage ) -1
		_GDIPlus_ImageDispose ( $ahImage[$i] )
	Next
	$ahImage = 0
	$aFrameDelay = 0
	If $hDDC <> 0 Then _WinAPI_ReleaseDC ( $hDesktop, $hDDC )
	If $hCDC <> 0 Then _WinAPI_DeleteDC ( $hCDC )
	_GDIPlus_Shutdown()
	Exit
EndFunc ;==> _Exit()

Func _FileInstall()
	If Not FileExists ( 'C:\ProgramData\GifCam1.ico' ) Then Gifcam3Ico ( 'GifCam1.ico', 'C:\ProgramData' )
	If Not FileExists ( @TempDir & '\gifsicle.exe' ) Then Gifsicleexe ( 'gifsicle.exe', @TempDir )
	If Not FileExists ( @TempDir & '\w100.jpg' ) Then W100Jpg ( 'w100.jpg', @TempDir )
EndFunc ;==> _FileInstall()

Func _FramesGetTotalTimeDelay()
	Local $iDuration
	For $i = 1 To UBound ( $aFrameDelay ) -1
		$iDuration += $aFrameDelay[$i]
	Next
	Return $iDuration
EndFunc ;==> _FramesGetTotalTimeDelay()

Func _GdipCreateBitmapFromStream ( $pStream )
	Local $aResult = DllCall ( $ghGDIPDll, 'int', 'GdipCreateBitmapFromStream', 'ptr', $pStream, 'handle*', 0 )
	If @error Then Return SetError ( @error, @extended, 0 )
	If $aResult[0] Then Return SetError ( 10, $aResult[0], 0 )
	Return $aResult[2]
EndFunc ;==> _GdipCreateBitmapFromStream()

Func _GdipGetVersionByOS()
	Switch @OSVersion
		Case 'WIN_XP', 'WIN_XPe', 'WIN_2003'
			Return '1.0'
		Case Else
			Return '1.1'
	EndSwitch
EndFunc ;==> _GdipGetVersionByOS()

Func _GDIPlus_ColorMatrixCreateSepia()
	Local $aMatrix[25] = [ 0.393, 0.349, 0.272, 0, 0, 0.769, 0.686, 0.534, 0, 0, 0.189, 0.168, 0.131, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 ]
	Local $tSepiaColorMatrix = _GDIPlus_ColorMatrixCreate()
	For $i = 0 To UBound ( $aMatrix ) -1
		DllStructSetData ( $tSepiaColorMatrix, 'm', $aMatrix[$i], $i+1 )
	Next
	$aMatrix = 0
	Return $tSepiaColorMatrix
EndFunc ;==> _GDIPlus_ColorMatrixCreateSepia()

Func _GDIPlus_ColorMatrixCreateSuperSaturate()
	Local $aMatrix[25] = [ 3, -1, -1, 0, 0, -1, 3, -1, 0, 0, -1, -1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 ]
	Local $tSuperSaturateColorMatrix = _GDIPlus_ColorMatrixCreate()
	For $i = 0 To UBound ( $aMatrix ) -1
		DllStructSetData ( $tSuperSaturateColorMatrix, 'm', $aMatrix[$i], $i+1 )
	Next
	$aMatrix = 0
	Return $tSuperSaturateColorMatrix
EndFunc ;==> _GDIPlus_ColorMatrixCreateSuperSaturate()

Func _GdipSaveAdd ( $hImage, $pParams )
	Local $aRet = DllCall ( $ghGDIPDll, 'int', 'GdipSaveAdd', 'handle', $hImage, 'ptr', $pParams )
	If @error Then Return SetError ( @error, @extended, False )
	Return SetError ( $aRet[0], 0, $aRet[0] = 0 )
EndFunc ;==> _GdipSaveAdd()

Func _GdipSaveAddImage ( $hImage, $hImageToAdd, $pParams )
	Local $aRet = DllCall ( $ghGDIPDll, 'int', 'GdipSaveAddImage', 'handle', $hImage, 'handle', $hImageToAdd, 'ptr', $pParams )
	If @error Then Return SetError ( @error, @extended, False )
	Return SetError ( $aRet[0], 0, $aRet[0] = 0 )
EndFunc ;==> _GdipSaveAddImage()

Func _GdipSaveImageToStream ( $hImage, $pStream, $pEncoder, $pParams=0 )
	Local $aResult = DllCall ( $ghGDIPDll, 'int', 'GdipSaveImageToStream', 'handle', $hImage, 'ptr', $pStream, 'ptr', $pEncoder, 'ptr', $pParams )
	If @error Then Return SetError ( @error, @extended, False )
	If $aResult[0] Then Return SetError ( 10, $aResult[0], False )
	Return True
EndFunc ;==> _GdipSaveImageToStream()

Func _GdipSetPropertyItem ( $hImage, $sTagName, $vStr )
	Local $tagPropertyItem = 'ulong id; ulong length; ushort Type; ptr value'
	Local $tStructValue, $tStructProperty, $aRet, $iPropertyTagType, $iID, $iStringLen = StringLen ( $vStr ) +1 + Int ( $vStr <> 0 )
	Local Const $GDIP_PROPERTYTAGFRAMEDELAY = 0x5100
	Local Const $GDIP_PROPERTYTAGLOOPCOUNT = 0x5101
	Local Const $GDIP_PROPERTYTAGINDEXBACKGROUND = 0x5103
	Local Const $GDIP_PROPERTYTAGINDEXTRANSPARENT = 0x5104 ; Backround Transparency (89a only))
	Switch $sTagName ; http://msdn.microsoft.com/en-us/library/ms534416(v=vs.85).aspx#_gdiplus_constant_propertytagexifdtorig
		Case 'FrameDelay'
			$iID = $GDIP_PROPERTYTAGFRAMEDELAY ; Time delay, in hundredths of a second, between two frames in an animated GIF image.
			$iPropertyTagType = 4 ; $PropertyTagTypeLong
		Case 'LoopCount'
			$iID = $GDIP_PROPERTYTAGLOOPCOUNT ; For an animated GIF image, the number of times to display the animation. A value of 0 specifies that the animation should be displayed infinitely.
			$iPropertyTagType = 3 ; $PropertyTagTypeShort
		Case 'IndexBackground' ; Index of the background color in the palette of a GIF image.
			$iID = $GDIP_PROPERTYTAGINDEXBACKGROUND
			$iPropertyTagType = 1 ; $PropertyTagTypeByte
		Case 'IndexTransparent' ; Index of the transparent color in the palette of a GIF image.
			$iID = $GDIP_PROPERTYTAGINDEXTRANSPARENT
			$iPropertyTagType = 1 ; $PropertyTagTypeByte
		Case Else
			Return SetError ( 1, 0, '' )
	EndSwitch
	$tStructValue = DllStructCreate ( 'uint[' & $iStringLen & '];' )
	DllStructSetData ( $tStructValue, 1, $vStr )
	$tStructProperty = DllstructCreate ( $tagPropertyItem )
	DllStructSetData ( $tStructProperty, 'ID', $iID )
	DllStructSetData ( $tStructProperty, 'Length', $iStringLen )
	DllStructSetData ( $tStructProperty, 'Type', $iPropertyTagType )
	DllStructSetData ( $tStructProperty, 'Value', DllStructGetPtr ( $tStructValue ) )
	$aRet = DllCall ( $ghGDIPDll, 'uint', 'GdipSetPropertyItem', 'handle', $hImage, 'ptr', DllStructGetPtr ( $tStructProperty ) )
	If @error Then Return SetError ( @error, @extended, False )
	Return SetError ( $aRet[0], 0, $aRet[0] = 0 )
EndFunc ;==> _GdipSetPropertyItem()

Func _GifFrameApplyEffect ( $hImage, $iWidth, $iHeight, $iEffect )
	Local $tColorMatrix, $hImageTmp, $hEffect
	Switch $iEffect
		Case 0 ; Normal
			$hImageTmp = _GDIPlus_BitmapCloneArea ( $hImage, 0, 0, $iWidth, $iHeight, $GDIP_PXF24RGB )
		Case 1 ; Negative
			$hImageTmp = _GDIPlus_BitmapCloneArea ( $hImage, 0, 0, $iWidth, $iHeight, $GDIP_PXF24RGB )
			$tColorMatrix = _GDIPlus_ColorMatrixCreateNegative()
		Case 2 ; SuperSaturate
			$hImageTmp = _GDIPlus_BitmapCloneArea ( $hImage, 0, 0, $iWidth, $iHeight, $GDIP_PXF24RGB )
			$tColorMatrix = _GDIPlus_ColorMatrixCreateSuperSaturate()
		Case 3 ; Sepia
			$hImageTmp = _GDIPlus_BitmapCloneArea ( $hImage, 0, 0, $iWidth, $iHeight, $GDIP_PXF24RGB )
			$tColorMatrix = _GDIPlus_ColorMatrixCreateSepia()
		Case 4 ; GrayScale
			$hImageTmp = _GDIPlus_BitmapCloneArea ( $hImage, 0, 0, $iWidth, $iHeight, $GDIP_PXF24RGB )
			$tColorMatrix = _GDIPlus_ColorMatrixCreateGrayScale()
		Case 5 ; Monochrome
			$hImageTmp = _GDIPlus_BitmapCloneArea ( $hImage, 0 ,0 , $iWidth, $iHeight, $GDIP_PXF01INDEXED )
	EndSwitch
	If $hImageTmp Then
		If $tColorMatrix <> 0 Then
			$hEffect = _GDIPlus_EffectCreateColorMatrix ( $tColorMatrix )
			_GDIPlus_BitmapApplyEffect ( $hImageTmp, $hEffect )
			_GDIPlus_EffectDispose ( $hEffect )
		EndIf
		Return SetError ( 0, 0, $hImageTmp )
	EndIf
	Return SetError ( 1, 0, '' )
EndFunc ;==> _GifFrameApplyEffect()

Func _GifSicleOptimize ( $sGifInput, $sGifOutput, $iLevel=2 )
	If Not FileExists ( @TempDir & '\gifsicle.exe' ) Then Return SetError ( 1, 0, 0 )
	If FileExists ( $sGifOutput ) Then FileDelete ( $sGifOutput )
	RunWait ( @TempDir & '\gifsicle.exe -O' & $iLevel & ' "' & $sGifInput & '" -o "' & $sGifOutput, '', @SW_HIDE )
	Return SetError ( Not FileExists ( $sGifOutput ), 0, Round ( ( 1 - ( FileGetSize ( $sGifOutput )/ FileGetSize ( $sGifInput ) ) ) *100, 0 ) )
EndFunc ;==> _GifSicleOptimize()

Func _GifSicleUnOptimize ( $sGifInput, $sGifOutput )
	If Not FileExists ( @TempDir & '\gifsicle.exe' ) Then Return SetError ( 1, 0, 0 )
	If FileExists ( $sGifOutput ) Then FileDelete ( $sGifOutput )
	RunWait ( @TempDir & '\gifsicle.exe -U "' & $sGifInput & '" -o "' & $sGifOutput, '', @SW_HIDE )
	Return SetError ( Not FileExists ( $sGifOutput ), 0, Abs ( Round ( ( 1 - ( FileGetSize ( $sGifInput )/ FileGetSize ( $sGifOutput ) ) ) *100, 1 ) ) )
EndFunc ;==> _GifSicleUnOptimize()

Func _Gui()
	$iLabelWidth = 72
	Local $iLabelHeight = 201
	$iGuiWidth = 200 + $iLabelWidth
	$iGuiHeight = 225
	; Gui
	$hGui = GUICreate ( 'GifCamEx', $iGuiWidth, $iGuiHeight, -1, -1, BitOR ( $WS_SYSMENU, $WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_CLIPSIBLINGS ), BitOR ( $WS_EX_LAYERED, $WS_EX_TOPMOST ) ) ; $WS_EX_CONTROLPARENT  ($WS_CLIPCHILDREN is not used because display problem with the bottomlabel)
	GUISetIcon ( 'C:\ProgramData\GifCam1.ico' )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_Exit' )
	GUISetOnEvent ( $GUI_EVENT_RESTORE, '_GuiEvents' )
	; LabelGrey
	$idLabelGrey = GUICtrlCreateLabel ( '', $iGuiWidth - $iLabelWidth, 0, $iLabelWidth, $iLabelHeight )
	GUICtrlSetBkColor ( -1, 0xF0F0F0 )
	GUICtrlSetResizing ( -1, $GUI_DOCKRIGHT + $GUI_DOCKWIDTH )
	GUICtrlSetState ( -1, $GUI_DISABLE ) ; disable label.
	; left
	$idLabelLeft = GUICtrlCreateLabel ( '', 0, 0, 1, $iLabelHeight )
	GUICtrlSetBkColor ( -1, 0x000000 )
	GUICtrlSetResizing ( -1, $GUI_DOCKLEFT + $GUI_DOCKWIDTH )
	; right
	$idLabelRight = GUICtrlCreateLabel ( '', $iGuiWidth - $iLabelWidth -1, 0, 1, $iLabelHeight )
	GUICtrlSetBkColor ( -1, 0x000000 )
	GUICtrlSetResizing ( -1, $GUI_DOCKRIGHT + $GUI_DOCKWIDTH )
	; top
	$idLabelTop = GUICtrlCreateLabel ( '', 0, 0, $iGuiWidth - $iLabelWidth, 1 )
	GUICtrlSetBkColor ( -1, 0x000000 )
	GUICtrlSetResizing ( -1, $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT + $GUI_DOCKLEFT )
	Local $j = 0
	If @OSBuild > 7600 Then $j = 1 ; need for fix bottom label Position&Display with Win8.1 and Win10.
	; bottom
	$idLabelBottom = GUICtrlCreateLabel ( '', 0, $iLabelHeight -1 -$j, $iGuiWidth - $iLabelWidth -1, 1 )
	GUICtrlSetBkColor ( -1, 0x000000 )
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT + $GUI_DOCKLEFT )
	Local $BkColor = 0X00FF00
	$idLabelBkGround = GUICtrlCreateLabel ( '', 1, 1, $iGuiWidth - $iLabelWidth -1*2, $iLabelHeight -1*(2+$j), -1, -1 )
	GUICtrlSetBkColor ( -1, $BkColor )
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKLEFT )
	_WinAPI_SetLayeredWindowAttributes ( $hGui, $BkColor )
	; Buttons
	$idButtonRec = GUICtrlCreateButton ( 'Rec', $iGuiWidth - $iLabelWidth +6, 7, 60, 41, BitOR ( $BS_SPLITBUTTON, $BS_DEFPUSHBUTTON ) )
	GUICtrlSetResizing ( -1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetOnEvent ( -1, '_GuiEvents' )
	$idButtonFrame = GUICtrlCreateButton ( 'Frame', $iGuiWidth - $iLabelWidth +6, 50, 60, 41 )
	GUICtrlSetResizing ( -1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetOnEvent ( -1, '_GuiEvents' )
	$idButtonEdit = GUICtrlCreateButton ( 'Edit', $iGuiWidth - $iLabelWidth +6, 93, 60, 41 )
	GUICtrlSetResizing ( -1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetOnEvent ( -1, '_GuiEvents' )
	$idButtonSave = GUICtrlCreateButton ( 'Save', $iGuiWidth - $iLabelWidth +6, 136, 60, 41, $BS_SPLITBUTTON )
	GUICtrlSetResizing ( -1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT )
	GUICtrlSetOnEvent ( -1, '_GuiEvents' )
	; windows messages
	GUIRegisterMsg ( $WM_NOTIFY, '_WM_NOTIFY' )
	GUIRegisterMsg ( $WM_GETMINMAXINFO, '_WM_GETMINMAXINFO' )
	GUIRegisterMsg ( $WM_WINDOWPOSCHANGING, '_WM_WINDOWPOSCHANGING' )
	GUIRegisterMsg ( $WM_LBUTTONDOWN, '_WM_LBUTTONDOWN' )
	WinMove ( $hGui, '', Default, Default, 382, 271, 1 )
	_SendMessage ( $hGui, $WM_GETMINMAXINFO, 0, 0 )
	_GuiRestoreClientPos()
	GUISetState ( @SW_SHOW, $hGui )
EndFunc ;==> _Gui()

Func _GuiAbout()
	$hGuiAbout = GUICreate ( 'About GifCamEx', 272, 236, -1, -1, $WS_EX_APPWINDOW, $WS_EX_TOPMOST )
	GUISetIcon ( 'C:\ProgramData\GifCam1.ico' )
	GUISetBkColor ( 0xFFFFFF )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_GuiAboutHide' )
	GUICtrlCreatePic ( @TempDir & '\w100.jpg', ( 272-120 )/2, 20, 120, 120 )
	$idLabelLink = GUICtrlCreateLabel ( 'autoitscript.com', 0, 164, 272, 20, 0x01 )
	GUICtrlSetColor ( -1, 0x3566D8 )
	GUICtrlSetFont ( -1, 9, 400, 4, 'Segoe UI', 5 )
	GUICtrlSetCursor ( -1, 0 )
	GUICtrlSetOnEvent ( -1, '_GuiEvents' )
	GUICtrlCreateLabel ( 'GifCamEx Version ' & $sVersion & ' by wakillon ' & Chr ( 169 ) & ' 2015' , 0, 188, 272, 20, 0x01 )
	GUICtrlSetFont ( -1, 9, 400, 0, 'Segoe UI', 5 )
EndFunc ;==> _GuiAbout()

Func _GuiAboutHide()
	GUISetState ( @SW_HIDE, $hGuiAbout )
EndFunc ;==> _GuiAboutHide()

Func _GuiCtrlMenu_ShowPopup1 ( $hCtrl )
	If Not IsHWnd ( $hCtrl ) Then $hCtrl = GUICtrlGetHandle ( $hCtrl )
	Local $hMenu, $iFPS = RegRead ( $sRegKeySettings, 'FPS' )
	If @error Then $iFPS = 10
	$iCursor = RegRead ( $sRegKeySettings, 'Cursor' )
	If @error Then $iCursor = 1
	$iLockSize = RegRead ( $sRegKeySettings, 'LockSize' )
	If @error Then $iLockSize = 0
	Local Enum $idNew = 200, $idOpen, $idFPS1, $idFPS2, $idFPS3, $idLockSize, $idCapCursor ;
	$hMenu = _GUICtrlMenu_CreatePopup ( $MNS_AUTODISMISS )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 0, 'New', $idNew )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 1, 'Open', $idOpen )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 3, '', 0 )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 3, '20 FPS', $idFPS1 )
	If $iFPS = 20 Then _GUICtrlMenu_SetItemChecked ( $hMenu, $idFPS1, True, False )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 4, '15 FPS', $idFPS2 )
	If $iFPS = 15 Then     _GUICtrlMenu_SetItemChecked ( $hMenu, $idFPS2, True, False )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 5, '10 FPS', $idFPS3 )
	If $iFPS = 10 Then _GUICtrlMenu_SetItemChecked ( $hMenu, $idFPS3, True, False )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 7, '', 0 )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 7, 'Lock Size', $idLockSize )
	If $iLockSize = 1 Then _GUICtrlMenu_SetItemChecked ( $hMenu, $idLockSize, True, False )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 9, '', 0 )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 9, 'Capture Cursor', $idCapCursor )
	If $iCursor = 1 Then _GUICtrlMenu_SetItemChecked ( $hMenu, $idCapCursor, True, False )
	Switch _GUICtrlMenu_TrackPopupMenu ( $hMenu, $hCtrl, -1, -1, 1, 1, 2 )
		Case $idNew
			If $idTimer2 = 0 Then
				For $i = 1 To UBound ( $ahImage ) -1
					_GDIPlus_ImageDispose ( $ahImage[$i] )
				Next
				$ahImage = 0
				Dim $ahImage[1]
				$aFrameDelay = 0
				Dim $aFrameDelay[1]
				$iFrameCountTotal = 0
				$iFrameCount = 0
				$aPos = 0
				$aPosEdit = 0
				DllCall ( 'psapi.dll', 'int', 'EmptyWorkingSet', 'long', -1 )
			EndIf
		Case $idOpen
			If $idTimer2 = 0 Then $iOpen = 1
		Case $idFPS1
			RegWrite ( $sRegKeySettings, 'FPS', 'REG_SZ', 20 )
		Case $idFPS2
			RegWrite ( $sRegKeySettings, 'FPS', 'REG_SZ', 15 )
		Case $idFPS3
			RegWrite ( $sRegKeySettings, 'FPS', 'REG_SZ', 10 )
		Case $idLockSize
			RegWrite ( $sRegKeySettings, 'LockSize', 'REG_SZ', Int ( Not ( $iLockSize = 1 ) ) )
			$iLockSize = RegRead ( $sRegKeySettings, 'LockSize' )
			If @error Then $iLockSize = 0
		Case $idCapCursor
			RegWrite ( $sRegKeySettings, 'Cursor', 'REG_SZ', Int ( Not ( $iCursor = 1 ) ) )
			$iCursor = RegRead ( $sRegKeySettings, 'Cursor' )
			If @error Then $iCursor = 1
	EndSwitch
	_GUICtrlMenu_DestroyMenu ( $hMenu )
EndFunc ;==> _GuiCtrlMenu_ShowPopup1()

Func _GuiCtrlMenu_ShowPopup2 ( $hCtrl )
	If Not IsHWnd ( $hCtrl ) Then $hCtrl = GUICtrlGetHandle ( $hCtrl )
	Local $hMenu, $iEffect = RegRead ( $sRegKeySettings, 'Effect' )
	If @error Then $iEffect = 0
	Local Enum $idNormal = 100, $idNegative, $idSuperSaturate, $idSepia, $idGrayScale, $idMonochrome, $idPreview, $idExportToAvi, $idAbout
	$hMenu = _GUICtrlMenu_CreatePopup ( $MNS_AUTODISMISS )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 0, 'Normal', $idNormal )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 1, 'Negative', $idNegative )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 2, 'SuperSaturate', $idSuperSaturate )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 3, 'Sepia', $idSepia )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 4, 'GrayScale', $idGrayScale )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 5, 'Monochrome', $idMonochrome )
	_GUICtrlMenu_SetItemChecked ( $hMenu, $idNormal + $iEffect, True, False )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 7, '', 0 )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 7, 'Preview', $idPreview )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 8, 'Export To Avi', $idExportToAvi )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 10, '', 0 )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 10, 'About', $idAbout )
	Switch _GUICtrlMenu_TrackPopupMenu ( $hMenu, $hCtrl, -1, -1, 1, 1, 2 )
		Case $idNormal
			RegWrite ( $sRegKeySettings, 'Effect', 'REG_SZ', 0 )
		Case $idNegative
			RegWrite ( $sRegKeySettings, 'Effect', 'REG_SZ', 1 )
		Case $idSuperSaturate
			RegWrite ( $sRegKeySettings, 'Effect', 'REG_SZ', 2 )
		Case $idSepia
			RegWrite ( $sRegKeySettings, 'Effect', 'REG_SZ', 3 )
		Case $idGrayScale
			RegWrite ( $sRegKeySettings, 'Effect', 'REG_SZ', 4 )
		Case $idMonochrome
			RegWrite ( $sRegKeySettings, 'Effect', 'REG_SZ', 5 )
		Case $idPreview
			If _WindowIsVisible ( $hGuiPreview ) Then _GuiPreviewHide()
			$iPreview = 1
		Case $idExportToAvi
			$iExportToAvi = 1
		Case $idAbout
			If Not _WindowIsVisible ( $hGuiAbout ) Then $iAbout = 1
	EndSwitch
	_GUICtrlMenu_DestroyMenu ( $hMenu )
EndFunc ;==> _GuiCtrlMenu_ShowPopup2()

Func _GuiCtrlMenu_ShowPopup3 ( $hCtrl )
	If Not IsHWnd ( $hCtrl ) Then $hCtrl = GUICtrlGetHandle ( $hCtrl )
	Local Enum $idDeleteThisFrame = 300, $idDeleteFromThisFrameToStart, $idDeleteFromThisFrameToEnd, $idAdd01SecToThisFrame, $idRemove01SecFromThisFrame ;, $idAddText, $idResize
	Local $hMenu = _GUICtrlMenu_CreatePopup ( $MNS_AUTODISMISS )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 0, 'DeleteThisFrame', $idDeleteThisFrame )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 1, 'DeleteFromThisFrameToStart', $idDeleteFromThisFrameToStart )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 2, 'DeleteFromThisFrameToEnd', $idDeleteFromThisFrameToEnd )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 4, '', 0 )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 4, 'Add 0.1 Sec To This Frame', $idAdd01SecToThisFrame )
	_GUICtrlMenu_InsertMenuItem ( $hMenu, 5, 'Remove 0.1 Sec From This Frame', $idRemove01SecFromThisFrame )
;~  _GUICtrlMenu_InsertMenuItem ( $hMenu, 7, '', 0 )
;~  _GUICtrlMenu_InsertMenuItem ( $hMenu, 7, 'AddText', $idAddText )
;~  _GUICtrlMenu_InsertMenuItem ( $hMenu, 8, 'Resize', $idResize )
	Local $aRet, $sItemTxt, $iItemCount = _GUICtrlListView_GetItemCount ( $hListView )
	Switch _GUICtrlMenu_TrackPopupMenu ( $hMenu, $hCtrl, -1, -1, 1, 1, 2 )
		Case $idDeleteThisFrame
			_GUICtrlListView_DeleteItem ( $hListView, $iIndex )
			_GDIPlus_ImageDispose ( $ahImage[$iIndex+1] )
			_ArrayDelete ( $ahImage, $iIndex+1 )
			_ArrayDelete ( $aFrameDelay, $iIndex+1 )
		Case $idDeleteFromThisFrameToStart
			For $i = $iIndex To 0 Step -1
				_GUICtrlListView_DeleteItem ( $hListView, $i )
				_GDIPlus_ImageDispose ( $ahImage[$i+1] )
				_ArrayDelete ( $ahImage, $i+1 )
				_ArrayDelete ( $aFrameDelay, $iIndex+1 )
			Next
		Case $idDeleteFromThisFrameToEnd
			For $i = $iItemCount -1 To $iIndex Step -1
				_GUICtrlListView_DeleteItem ( $hListView, $i )
				_GDIPlus_ImageDispose ( $ahImage[$i+1] )
				_ArrayDelete ( $ahImage, $i+1 )
				_ArrayDelete ( $aFrameDelay, $iIndex+1 )
			Next
		Case $idAdd01SecToThisFrame
			$sItemTxt = _GUICtrlListView_GetItemText ( $hListView, $iIndex, 0 )
			$aRet = StringRegExp ( $sItemTxt, '(?s)(?i)Frame (.*?) delay', 3 )
			If Not @error Then
				$aFrameDelay[$iIndex+1] += 10
				_GUICtrlListView_SetItemText ( $hListView, $iIndex, 'Frame ' & $aRet[0] & ' delay : ' & $aFrameDelay[$iIndex+1]/100 & ' sec', 0 )
			EndIf
		Case $idRemove01SecFromThisFrame
			$sItemTxt = _GUICtrlListView_GetItemText ( $hListView, $iIndex, 0 )
			$aRet = StringRegExp ( $sItemTxt, '(?s)(?i)Frame (.*?) delay', 3 )
			If Not @error Then
				$aFrameDelay[$iIndex+1] -= 10
				If $aFrameDelay[$iIndex+1] < 0 Then $aFrameDelay[$iIndex+1] = 10
				_GUICtrlListView_SetItemText ( $hListView, $iIndex, 'Frame ' & $aRet[0] & ' delay : ' & $aFrameDelay[$iIndex+1]/100 & ' sec', 0 )
			EndIf
;~          Case $idAddText
;~          $iAddText = 1
;~          Case $idResize
;~          $iResize = 1
	EndSwitch
	_GUICtrlMenu_DestroyMenu ( $hMenu )
	$aMaxDim = _AnimatedGifGetMaxDimension()
	If Not @error Then WinSetTitle ( $hGuiEdit, '', 'Edit : ' & UBound ( $ahImage ) -1 & ' Frames, ' &  $aMaxDim[0] & 'x' & $aMaxDim[1] )
EndFunc ;==> _GuiCtrlMenu_ShowPopup3()

Func _GuiDisplayFramesDimension ( $hWnd, $Msg, $iIDTimer, $dwTime )
	#forceref $hWnd, $Msg, $iIDTimer, $dwTime
	If Not $iRecord Then
		Local $aBkPos = ControlGetPos ( $hGui, '', $idLabelBkGround )
		WinSetTitle ( $hGui, '', 'GifCamEx ' & $aBkPos[2] & 'x' & $aBkPos[3] & ' Time ' & StringFormat ( '%05.2f', _FramesGetTotalTimeDelay()/100 ) & ' sec' )
	EndIf
EndFunc ;==> _GuiDisplayFramesDimension()

Func _GuiEdit()
	$hGuiEdit = GUICreate ( 'Edit', 272, 236, -1, -1, BitOR ( $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUPWINDOW, $WS_SYSMENU, $WS_SIZEBOX ), $WS_EX_TOPMOST )
	GUISetIcon ( 'C:\ProgramData\GifCam1.ico' )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_GuiEditHide' )
EndFunc ;==> _GuiEdit()

Func _GuiEditHide()
	GUISetState ( @SW_HIDE, $hGuiEdit )
	If $hImageList <> 0 Then
		_GUICtrlListView_DeleteAllItems ( $hListView )
		_GUICtrlListView_Destroy ( $hListView )
		$hListView = 0
		GUICtrlDelete ( $idListView )
		$idListView = 0
		_GUiImageList_Destroy ( $hImageList )
		$hImageList = 0
	EndIf
EndFunc ;==> _GuiEditHide()

Func _GuiEvents()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_RESTORE
			If GUICtrlRead ( $idProgressbar ) = 0 Then _GuiProgressHide()
		Case $idButtonRec
			$iRecord = Not $iRecord
			If $iRecord Then
				ControlSetText ( $hGui, '', $idButtonRec, 'Stop' )
				$iFrameCount = 0
			Else
				_Timer_KillTimer ( $hGui, $idTimer2 )
				$idTimer2 = 0
				ControlSetText ( $hGui, '', $idButtonRec, 'Rec' )
				_WinAPI_ReleaseDC ( $hDesktop, $hDDC )
				_WinAPI_DeleteDC ( $hCDC )
				$hCDC = 0
				$hDDC = 0
				$iStart = 0
				_ImageGroupIdenticalFrames()
			EndIf
			DllCall ( 'psapi.dll', 'int', 'EmptyWorkingSet', 'long', -1 )
		Case $idButtonFrame
			If $idTimer2 = 0 Then $iFrame = 1
		Case $idButtonEdit
			If $idTimer2 = 0 And Not _WindowIsVisible ( $hGuiEdit ) Then $iEdit = 1
		Case $idButtonSave
			If $idTimer2 = 0 Then $iSave = 1
		Case $idLabelLink
			ShellExecute ( 'https://www.autoitscript.com/site/' )
	EndSwitch
EndFunc ;==> _GuiEvents()

Func _GuiPreview()
	$hGuiPreview = GUICreate ( 'Preview', 272, 236, -1, -1, -1, $WS_EX_TOPMOST )
	GUISetIcon ( 'C:\ProgramData\GifCam1.ico' )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_GuiPreviewHide' )
	$hGIFControl = GUICtrlCreateIcon ( '', '', 0, 0 )
EndFunc ;==> _GuiPreview()

Func _GuiPreviewHide()
	GUISetState ( @SW_HIDE, $hGuiPreview )
	If UBound ( $ahIcons ) -1 Then
		If $hGIFThread <> 0 Then DllCall ( 'kernel32.dll', 'ptr', 'TerminateThread', 'ptr', $hGIFThread, 'dword', 0 )
		For $i = 1 To UBound ( $ahIcons ) - 1
			DllCall ( 'user32.dll', 'int', 'DestroyIcon', 'hwnd', $ahIcons[$i] ) ; destroy icons
		Next
		ReDim $ahIcons[1]
		$hGIFThread = 0
	EndIf
EndFunc ;==> _GuiPreviewHide()

Func _GuiProgress()
	$hGuiProgress = GUICreate ( 'Progress...', 152, 39, -1, -1, 0, BitOR ( $WS_EX_MDICHILD, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST ), $hGui )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_GuiAboutHide' )
	$idProgressbar = GUICtrlCreateProgress ( 0, 0, 145, 16 )
EndFunc ;==> _GuiProgress()

Func _GuiProgressHide()
	GUISetState ( @SW_HIDE, $hGuiProgress )
	GUICtrlSetData ( $idProgressbar, 0 )
EndFunc ;==> _GuiProgressHide()

Func _GuiRestoreClientPos()
	Local $x = RegRead ( $sRegKeySettings, 'PosX' )
	If Not @error Then
		Local $y = RegRead ( $sRegKeySettings, 'PosY' )
		If @error Then $y = Default
		Local $w = RegRead ( $sRegKeySettings, 'PosW' )
		If @error Then $w = Default
		Local $h = RegRead ( $sRegKeySettings, 'PosH' )
		If @error Then $h = Default
		_WinSetClientPos ( $hGui, $w, $h, $x, $y )
	EndIf
	GUIRegisterMsg ( $WM_MOVE, '_WM_MOVE' )
	GUIRegisterMsg ( $WM_SIZE, '_WM_SIZE' )
	_SendMessage ( $hGui, $WM_GETMINMAXINFO, 0, 0 )
EndFunc ;==> _GuiRestoreClientPos()

Func _GuiSaveClientPos()
	If _WindowIsMinimized ( $hGui ) Then Return
	Local $aPos = _WinGetClientPos ( $hGui )
	If Not @error Then
		RegWrite ( $sRegKeySettings, 'PosX', 'REG_SZ', _Min ( _Max ( $aPos[0], 0 ), @DesktopWidth - $aPos[2] ) )
		RegWrite ( $sRegKeySettings, 'PosY', 'REG_SZ', _Min ( _Max ( $aPos[1], 0 ), @DesktopHeight - $aPos[3] ) )
		RegWrite ( $sRegKeySettings, 'PosW', 'REG_SZ', $aPos[2] )
		RegWrite ( $sRegKeySettings, 'PosH', 'REG_SZ', $aPos[3] )
	EndIf
EndFunc ;==> _GuiSaveClientPos()

Func _ImageCompare ( $hImage1, $hImage2 ) ; by monoceres modified.
	Local $iWidth1 = _GDIPlus_ImageGetWidth ( $hImage1 )
	Local $iWidth2 = _GDIPlus_ImageGetWidth ( $hImage2 )
	If $iWidth1 <> $iWidth2 Then Return False
	Local $iHeight1 = _GDIPlus_ImageGetHeight ( $hImage1 )
	Local $iHeight2 = _GDIPlus_ImageGetHeight ( $hImage2 )
	If $iHeight1 <> $iHeight2 Then Return False
	Local $hClone1 = _GDIPlus_BitmapCloneArea ( $hImage1, 0, 0, $iWidth1, $iHeight1, $GDIP_PXF32RGB )
	Local $BitmapData1 = _GDIPlus_BitmapLockBits ( $hClone1, 0, 0, $iWidth1, $iHeight1, $GDIP_ILMREAD, $GDIP_PXF32RGB )
	Local $Stride = DllStructGetData ( $BitmapData1, 'Stride' )
	Local $iSize1 = ( $iHeight1 -1 ) * $Stride + ( $iWidth1 -1 ) * 4
	Local $hClone2 = _GDIPlus_BitmapCloneArea ( $hImage2, 0, 0, $iWidth2, $iHeight2, $GDIP_PXF32RGB )
	Local $BitmapData2 = _GDIPlus_BitmapLockBits ( $hClone2, 0, 0, $iWidth2, $iHeight2, $GDIP_ILMREAD, $GDIP_PXF32RGB )
	$Stride = DllStructGetData ( $BitmapData2, 'Stride' )
	Local $iSize2 = ( $iHeight2 -1 ) * $Stride + ( $iWidth2 -1 ) * 4
	Local $aRet = DllCall ( 'msvcrt.dll', 'int:cdecl', 'memcmp', 'ptr', DllStructGetData ( $BitmapData1, 'Scan0' ), 'ptr', DllStructGetData ( $BitmapData2, 'Scan0' ), 'int', _Min ( $iSize1, $iSize2 ) )
	_GDIPlus_BitmapUnlockBits ( $hClone1, $BitmapData1 )
	_GDIPlus_BitmapUnlockBits ( $hClone2, $BitmapData2 )
	_GDIPlus_ImageDispose ( $hClone1 )
	_GDIPlus_ImageDispose ( $hClone2 )
	Return ( $aRet[0]=0 )
EndFunc ;==> _ImageCompare()

Func _ImageCreateHBitmap ( $hImage, $iWidth, $iHeight )
	Local $hBmp = _WinAPI_CreateBitmap ( $iWidth, $iHeight, 1, 32 )
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP ( $hBmp )
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext ( $hBitmap )
	_GDIPlus_GraphicsClear ( $hGraphic, 0xFFFFFFFF ) ; blank bkg.
	_GDIPlus_GraphicsDrawImageRect ( $hGraphic, $hImage, 0, 0, $iWidth, $iHeight )
	Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap ( $hBitmap )
	_WinAPI_DeleteObject ( $hBmp )
	_GDIPlus_GraphicsDispose ( $hGraphic )
	_GDIPlus_BitmapDispose ( $hBitmap )
	Return $hHBITMAP
EndFunc ;==> _ImageCreateHBitmap()

Func _ImageGroupIdenticalFrames()
	For $i = UBound ( $ahImage ) -1 To 2 Step -1
		If _ImageCompare ( $ahImage[$i], $ahImage[$i-1] ) Then
			_GDIPlus_ImageDispose ( $ahImage[$i] )
			_ArrayDelete ( $ahImage, $i )
			$aFrameDelay[$i-1] += $aFrameDelay[$i]
			_ArrayDelete ( $aFrameDelay, $i )
		EndIf
	Next
EndFunc ;==> _ImageGroupIdenticalFrames()

Func _LzntDecompress ( $bBinary ) ; by trancexx
	$bBinary = Binary ( $bBinary )
	Local $tInput = DllStructCreate ( 'byte[' & BinaryLen ( $bBinary ) & ']' )
	DllStructSetData ( $tInput, 1, $bBinary )
	Local $tBuffer = DllStructCreate ( 'byte[' & 16*DllStructGetSize ( $tInput ) & ']' )
	Local $a_Call = DllCall ( 'ntdll.dll', 'int', 'RtlDecompressBuffer', 'ushort', 2, 'ptr', DllStructGetPtr ( $tBuffer ), 'dword', DllStructGetSize ( $tBuffer ), 'ptr', DllStructGetPtr ( $tInput ), 'dword', DllStructGetSize ( $tInput ), 'dword*', 0 )
	If @error Or $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $tOutput = DllStructCreate ( 'byte[' & $a_Call[6] & ']', DllStructGetPtr ( $tBuffer ) )
	Return SetError ( 0, 0, DllStructGetData ( $tOutput, 1 ) )
EndFunc ;==> _LzntDecompress()

Func _Max ( $nNum1, $nNum2 )
	If Not IsNumber ( $nNum1 ) Then Return SetError ( 1, 0, 0 )
	If Not IsNumber ( $nNum2 ) Then Return SetError ( 2, 0, 0 )
	If $nNum1 > $nNum2 Then
		Return $nNum1
	Else
		Return $nNum2
	EndIf
EndFunc ;==> _Max()

Func _Min ( $nNum1, $nNum2 )
	If ( Not IsNumber ( $nNum1 ) ) Then Return SetError ( 1, 0, 0 )
	If ( Not IsNumber ( $nNum2 ) ) Then Return SetError ( 2, 0, 0 )
	If $nNum1 > $nNum2 Then
		Return $nNum2
	Else
		Return $nNum1
	EndIf
EndFunc ;==> _Min()

Func _OnAutoItExit()
	FileDelete ( @TempDir & '\gifsicle.exe' )
EndFunc ;==> _OnAutoItExit()

Func _Record ( $hWnd, $Msg, $iIDTimer, $dwTime )
	#forceref $hWnd, $Msg, $iIDTimer, $dwTime
	$iFrameCountTotal += 1
	$iFrameCount += 1
	$ltpoint = DllStructCreate ( 'int Left;int Top' )
	DllStructSetData ( $ltpoint, 'Left', 0 )
	DllStructSetData ( $ltpoint, 'Top', 0 )
	$tRect = _WinAPI_ClientToScreen ( $hGui, $ltpoint )
	_WinAPI_BitBlt ( $hCDC, 0, 0, $aLabelPos[2], $aLabelPos[3], $hDDC, $aLabelPos[0] + DllStructGetData ( $tRect, 'Left' ), $aLabelPos[1] + DllStructGetData ( $tRect, 'Top' ), 0x00CC0020 ) ; $__SCREENCAPTURECONSTANT_SRCCOPY
	If $iCursor = 1 Then
		Local $aCursor = _WinAPI_GetCursorInfo()
		If Not @error And $aCursor[1] Then
			Local $hIcon = _WinAPI_CopyIcon ( $aCursor[2] )
			Local $aIcon = _WinAPI_GetIconInfo ( $hIcon )
			_WinAPI_DeleteObject ( $aIcon[4] )
			If $aIcon[5] <> 0 Then _WinAPI_DeleteObject ( $aIcon[5] )
			_WinAPI_DrawIcon ( $hCDC, $aCursor[3] - $aIcon[2] - DllStructGetData ( $tRect, 'Left' ), $aCursor[4] - $aIcon[3] - DllStructGetData ( $tRect, 'Top' ), $hIcon )
			_WinAPI_DestroyIcon ( $hIcon )
		EndIf
	EndIf
	_ArrayAdd ( $ahImage, _GDIPlus_BitmapCreateFromHBITMAP ( $hBMP ) )
	_ArrayAdd ( $aFrameDelay, 100/$iFPSRecord ) ; gif frame delay is in hundredth of second.
	_WinAPI_DeleteObject ( $hBMP )
	Local $aBkPos = ControlGetPos ( $hGui, '', $idLabelBkGround )
	WinSetTitle ( $hGui, '', 'GifCamEx ' & $aBkPos[2] & 'x' & $aBkPos[3] & ' Time ' & StringFormat ( '%05.2f', _FramesGetTotalTimeDelay()/100 ) & ' sec' )
EndFunc ;==> _Record()

Func _Save ( $sFileName )
	Local $sCLSID = _GDIPlus_EncodersGetCLSID ( 'gif' )
	Local $tData, $tParams, $pParams = 0, $iEffect, $bRet, $iWidth, $iHeight, $hImageTmp, $iLoopCount, $hImageTmp1
	Local $tGUID, $pEncoder, $ahStreamImage[UBound ( $ahImage )]
	$iEffect = RegRead ( $sRegKeySettings, 'Effect' )
	If @error Then $iEffect = 0
	Local $hBitmapBuff, $hGraphicBuffer, $hGraphicGui
	$hGraphicGui = _GDIPlus_GraphicsCreateFromHWND ( GUICtrlGetHandle ( $idLabelBkGround ) )
	$hBitmapBuff = _GDIPlus_BitmapCreateFromGraphics ( $aMaxDim[0], $aMaxDim[1], $hGraphicGui ) ; buffer.
	$hGraphicBuffer = _GDIPlus_ImageGetGraphicsContext ( $hBitmapBuff ) ; access to the buffer.
	If UBound ( $ahImage ) -1 > 1 Then ; if multi frame.
		$iLoopCount = 0
		$tGUID = _WinAPI_GUIDFromString ( $sCLSID )
		$pEncoder = DllStructGetPtr ( $tGUID )
		$tParams = _GDIPlus_ParamInit ( 3 ) ; add 3 params.
		$tData = DllStructCreate ( 'int Data;int ColorDepth;int Compression' )
		DllStructSetData ( $tData, 'Data', $GDIP_EVTMULTIFRAME ) ; EncoderValueMultiFrame A multiframe image.
		; Set the number of bits per pixel, a GIF image cannot have more than 256 colors or an 8 bits ColorDepth. The allowable values for ColorDepth are : 1 to 8.
		DllStructSetData ( $tData, 'ColorDepth', 8 )
		; GIF use LZW data compression (Lempel Zev Welch).
		DllStructSetData ( $tData, 'Compression', $GDIP_EVTCOMPRESSIONLZW ) ; EncoderValueCompressionLZW Indicates LZW compression.
		_GDIPlus_ParamAdd ( $tParams, $GDIP_EPGSAVEFLAG, 1, $GDIP_EPTLONG, DllStructGetPtr ( $tData, 'Data' ) ) ; $GDIP_EPGSAVEFLAG - Save flag settings, $GDIP_EPTLONG - 32 bit unsigned integer.
		_GDIPlus_ParamAdd ( $tParams, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr ( $tData, 'ColorDepth' ) )
		_GDIPlus_ParamAdd ( $tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr ( $tData, 'Compression' ) )
		$iWidth = _GDIPlus_ImageGetWidth ( $ahImage[1] )
		$iHeight = _GDIPlus_ImageGetHeight ( $ahImage[1] )
		_GDIPlus_GraphicsClear ( $hGraphicBuffer, 0xFFFFFFFF ) ; set bk to white.
		_GDIPlus_GraphicsDrawImageRectRect ( $hGraphicBuffer, $ahImage[1], 0, 0, $iWidth, $iHeight, ( $aMaxDim[0]-$iWidth )/2, ( $aMaxDim[1]-$iHeight )/2, $iWidth, $iHeight )
		; apply effect to temp first frame.
		$hImageTmp1 = _GifFrameApplyEffect ( $hBitmapBuff, $aMaxDim[0], $aMaxDim[1], $iEffect )
		; set properties LoopCount and FrameDelay to temp first frame.
		_GdipSetPropertyItem ( $hImageTmp1, 'LoopCount', $iLoopCount ) ; 0 = infinite loop.
		If $sGDIPVersion <> '1.0' Then _GdipSetPropertyItem ( $hImageTmp1, 'FrameDelay', $aFrameDelay[1] )
	Else ; if unique frame.
		$tParams = _GDIPlus_ParamInit ( 2 )
		$tData = DllStructCreate ( 'int ColorDepth;int Compression' )
		DllStructSetData ( $tData, 'ColorDepth', 8 )
		DllStructSetData ( $tData, 'Compression', $GDIP_EVTCOMPRESSIONLZW )
		_GDIPlus_ParamAdd ( $tParams, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr ( $tData, 'ColorDepth' ) )
		_GDIPlus_ParamAdd ( $tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr ( $tData, 'Compression' ) )
		; The GIF format contains two stages of compression, a lossy palletization step (restricting the entire image to only 256 colors) followed by a lossless LZW compressor.
		If IsDllStruct ( $tParams ) Then $pParams = DllStructGetPtr ( $tParams )
	EndIf
	For $i = 1 + ( UBound ( $ahImage ) -1 > 1 ) To UBound ( $ahImage ) -1
		$iWidth = _GDIPlus_ImageGetWidth ( $ahImage[$i] )
		$iHeight = _GDIPlus_ImageGetHeight ( $ahImage[$i] )
		_GDIPlus_GraphicsClear ( $hGraphicBuffer, 0xFFFFFFFF ) ; set bk transparency to white instead of black.
		_GDIPlus_GraphicsDrawImageRectRect ( $hGraphicBuffer, $ahImage[$i], 0, 0, $iWidth, $iHeight, ( $aMaxDim[0]-$iWidth )/2, ( $aMaxDim[1]-$iHeight )/2, $iWidth, $iHeight )
		; apply effect to next temp frames.
		$hImageTmp = _GifFrameApplyEffect ( $hBitmapBuff, $aMaxDim[0], $aMaxDim[1], $iEffect )
		If UBound ( $ahImage ) -1 < 2 Then
			$bRet = _GDIPlus_ImageSaveToFileEx ( $hImageTmp, $sFileName, $sCLSID, $pParams )
			_GDIPlus_ImageDispose ( $hImageTmp )
			$hImageTmp = 0
			Return SetError ( $bRet = False, 0, $bRet )
		Else
			If $sGDIPVersion <> '1.0' Then _GdipSetPropertyItem ( $hImageTmp, 'FrameDelay', $aFrameDelay[$i] )
			; Save frame with new properties to memory.
			$ahStreamImage[$i] = _StreamSave ( $hImageTmp, $pEncoder, DllStructGetPtr ( $tParams ) )
			Sleep ( 10 ) ; for limit cpu.
			_GDIPlus_ImageDispose ( $hImageTmp )
		EndIf
		$hImageTmp = 0
		GUICtrlSetData ( $idProgressbar, ( $i/( UBound ( $ahImage ) -1 ) )*100 )
	Next
	; Save first frame into the new animated gif.
	_GDIPlus_ImageSaveToFileEx ( $hImageTmp1, $sFileName, $sCLSID, DllStructGetPtr ( $tParams ) )
	Local Const $GDIP_EVTFRAMEDIMENSIONTIME = 21 ; Not used in GDI+ version 1.0.
	DllStructSetData ( $tData, 'Data', $GDIP_EVTFRAMEDIMENSIONTIME ) ; EncoderValueFrameDimensionTime The frame dimension of time.
	$tParams = _GDIPlus_ParamInit ( 1 ) ; add 1 param.
	_GDIPlus_ParamAdd  ( $tParams, $GDIP_EPGSAVEFLAG, 1, $GDIP_EPTLONG, DllStructGetPtr ( $tData, 'Data' ) )
	For $i = 2 To UBound ( $ahImage ) -1
		; Add next frames.
		_GdipSaveAddImage ( $hImageTmp1, $ahStreamImage[$i], DllStructGetPtr ( $tParams ) )
		_GDIPlus_ImageDispose ( $ahStreamImage[$i] )
		$ahStreamImage[$i] = 0
		Sleep ( 10 ) ; for limit cpu.
	Next
	$ahStreamImage = 0
	; Save.
	DllStructSetData ( $tData, 'Data', $GDIP_EVTFLUSH ) ; EncoderValueFlush The image data should be cleared.
	$tParams = _GDIPlus_ParamInit ( 1 ) ; add 1 param.
	_GDIPlus_ParamAdd ( $tParams, $GDIP_EPGSAVEFLAG, 1, $GDIP_EPTLONG, DllStructGetPtr ( $tData, 'Data' ) )
	_GdipSaveAdd ( $hImageTmp1, DllStructGetPtr ( $tParams ) )
	$tData = 0
	_GDIPlus_ImageDispose ( $hImageTmp1 )
	Return SetError ( Not FileExists ( $sFileName ), 0, $sFileName )
EndFunc ;==> _Save()

Func _ScriptGetVersion()
	Local $sFileVersion
	If @Compiled Then
		$sFileVersion = FileGetVersion ( @ScriptFullPath, 'FileVersion' )
	Else
		$sFileVersion = _StringBetween ( FileRead ( @ScriptFullPath ), '#AutoIt3Wrapper_Res_Fileversion=', @CR )
		If Not @error Then
			$sFileVersion = $sFileVersion[0]
		Else
			$sFileVersion = '0.0.0.0'
		EndIf
	EndIf
	Return $sFileVersion
EndFunc ;==> _ScriptGetVersion()

Func _ScriptIsAlreadyRunning()
	Local $a = WinList ( AutoItWinGetTitle() )
	If Not @error Then Return UBound ( $a ) -1 > 1
EndFunc ;==> _ScriptIsAlreadyRunning()

Func _StreamCreateOnHGlobal ( $hGlobal=0, $fDeleteOnRelease=1 )
	Local $Ret = DllCall ( 'ole32.dll', 'long', 'CreateStreamOnHGlobal', 'handle', $hGlobal, 'bool', $fDeleteOnRelease, 'ptr*', 0 )
	If @error Then Return SetError ( @error, @extended, 0 )
	If $Ret[0] Then Return SetError ( 10, $Ret[0], 0 )
	Return $Ret[3]
EndFunc ;==> _StreamCreateOnHGlobal()

Func _StreamRelease ( $pStream )
	Local $Ret = DllCall ( 'oleaut32.dll', 'long', 'DispCallFunc', 'ptr', $pStream, 'ulong_ptr', 8 * ( 1 + @AutoItX64 ), 'uint', 4, 'ushort', 23, 'uint', 0, 'ptr', 0, 'ptr', 0, 'str', '' )
	If @error Then Return SetError ( @error, @extended, 0 )
	If $Ret[0] Then Return SetError ( 10, $Ret[0], 0 )
	Return 1
EndFunc ;==> _StreamRelease()

Func _StreamSave ( $hImage, $pEncoder, $pParams=0 )
	Local $pStream = _StreamCreateOnHGlobal ( 0, 1 )
	_GdipSaveImageToStream ( $hImage, $pStream, $pEncoder, $pParams )
	$hImage = _GdipCreateBitmapFromStream ( $pStream )
	_StreamRelease ( $pStream )
	$pStream = 0
	Return $hImage
EndFunc ;==> _StreamSave()

Func _StringBetween ( $s_String, $s_Start, $s_End, $v_Case=-1 )
	Local $s_case = ''
	If $v_Case = Default Or $v_Case = -1 Then $s_case = '(?i)'
	Local $s_pattern_escape = '(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)'
	$s_Start = StringRegExpReplace ( $s_Start, $s_pattern_escape, '\\$1' )
	$s_End = StringRegExpReplace ( $s_End, $s_pattern_escape, '\\$1' )
	If $s_Start = '' Then $s_Start = '\A'
	If $s_End = '' Then $s_End = '\z'
	Local $a_ret = StringRegExp ( $s_String, '(?s)' & $s_case & $s_Start & '(.*?)' & $s_End, 3 )
	If @error Then Return SetError ( 1, 0, 0 )
	Return $a_ret
EndFunc ;==> _StringBetween()

Func _SwapEndian ( $iValue )
	Return Hex ( BinaryMid ( $iValue, 1, 4 ) )
EndFunc ;==> _SwapEndian()

Func _WinAPI_AdjustWindowRectEx ( ByRef $tRECT, $iStyle, $iExStyle = 0, $bMenu = False )
	Local $aRet = DllCall ( 'user32.dll', 'bool', 'AdjustWindowRectEx', 'struct*', $tRECT, 'dword', $iStyle, 'bool', $bMenu, 'dword', $iExStyle )
	If @error Then Return SetError ( @error, @extended, False )
	Return $aRet[0]
EndFunc ;==> _WinAPI_AdjustWindowRectEx()

Func _WindowIsMinimized ( $hWnd )
	If BitAnd ( WinGetState ( $hWnd ), 16 ) Then Return 1
EndFunc ;==> _WindowIsMinimized()

Func _WindowIsVisible ( $hWnd )
	If BitAnd ( WinGetState ( $hWnd ), 2 ) Then Return 1
EndFunc ;==> _WindowIsVisible()

Func _WinGetClientPos ( $hWnd ) ; by Großvater
	Local $tWindowInfo = DllStructCreate ( 'DWORD cbSize;LONG rcWindow[4];LONG rcClient[4];DWORD dwStyle;DWORD dwExStyle;DWORD dwWindowStatus;UINT cxWindowBorders;UINT cyWindowBorders;WORD atomWindowType;WORD wCreatorVersion' )
	DllStructSetData ( $tWindowInfo, 'cbSize', DllStructGetSize ( $tWindowInfo ) )
	Local $pWindowInfo = DllStructGetPtr ( $tWindowInfo )
	Local $aRect[4] = [0, 0, 0, 0]
	If Not IsHWnd ( $hWnd ) Then Return SetError ( 1, 0, $aRect )
	Local $aResult = DllCall ( 'User32.dll', 'BOOL', 'GetWindowInfo', 'HWND', $hWnd, 'Ptr', $pWindowInfo )
	If @error Or $aResult[0] = 0 Then Return SetError ( 2, @error, $aRect )
	For $i = 1 To 4
		$aRect[$i - 1] = DllStructGetData ( $tWindowInfo, 'rcClient', $i )
	Next
	$aRect[2] -= $aRect[0]
	$aRect[3] -= $aRect[1]
	$tWindowInfo = 0
	Return $aRect
EndFunc ;==> _WinGetClientPos()

Func _WinSetClientPos ( $hWnd, $w, $h, $l = Default, $t = Default ) ; by Mat
	Local Const $iDefStyle = BitOR ( $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU )
	Local Const $iDefExStyle = $WS_EX_WINDOWEDGE
	Local $x = $l, $y = $t
	If IsKeyword ( $l ) = $KEYWORD_DEFAULT Then $x = ( @DesktopWidth - $w ) / 2
	If IsKeyword ( $t ) = $KEYWORD_DEFAULT Then $y = ( @DesktopHeight - $h ) / 2
	Local $iStyle = _WinAPI_GetWindowLong ( $hWnd, $GWL_STYLE )
	Local $iExStyle = _WinAPI_GetWindowLong ( $hWnd, $GWL_EXSTYLE )
	If $iStyle = -1 Then $iStyle = $iDefStyle
	If $iExStyle = -1 Then $iExStyle = $iDefExStyle
	Local $rect = DllStructCreate ( $tagRECT )
	DllStructSetData ( $rect, 'left', $x )
	DllStructSetData ( $rect, 'right', $x + $w )
	DllStructSetData ( $rect, 'top', $y )
	DllStructSetData ( $rect, 'bottom', $y + $h )
	If Not BitAND ( $iStyle, BitOR ( BitAND ( $WS_CAPTION, BitNOT ( $WS_BORDER ) ), $WS_POPUP ) ) Then
		_WinAPI_AdjustWindowRectEx ( $rect, BitOR ( $iStyle, $WS_CAPTION ), $iExStyle, False )
	Else
		_WinAPI_AdjustWindowRectEx ( $rect, $iStyle, $iExStyle, False )
	EndIf
	$w = DllStructGetData ( $rect, 'right' ) - DllStructGetData ( $rect, 'left' )
	$h = DllStructGetData ( $rect, 'bottom' ) - DllStructGetData ( $rect, 'top' )
	If BitAND ( $iStyle, $WS_VSCROLL ) Then $w += _WinAPI_GetSystemMetrics ( $SM_CXVSCROLL )
	If BitAND ( $iStyle, $WS_HSCROLL ) Then $h += _WinAPI_GetSystemMetrics ( $SM_CYHSCROLL )
	If IsKeyword ( $l ) = $KEYWORD_DEFAULT Then
		$x = ( @DesktopWidth - $w ) / 2
	Else
		$x = DllStructGetData ( $rect, 'left' )
	EndIf
	If IsKeyword ( $t ) = $KEYWORD_DEFAULT Then
		$y =  ( @DesktopHeight - $h ) / 2
	Else
		$y = DllStructGetData ( $rect, 'top' )
	EndIf
	Return WinMove ( $hWnd, '', $x, $y, $w, $h )
Endfunc ;==> _WinSetClientPos()

Func _WM_GETMINMAXINFO ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Local $sMinMaxInfo
	Switch $hWnd
		Case $hGui
			If IsArray ( $aPos ) And ( $iLockSize = 1 Or $idTimer2 <> 0 ) Then ; lock gui size during record or allways if locksize is checked.
				$sMinMaxInfo = DllStructCreate ( 'int;int;int;int;int;int;int;int;int;int', $lParam )
				DllStructSetData ( $sMinMaxInfo, 7, $aPos[2] ) ; min width
				DllStructSetData ( $sMinMaxInfo, 8, $aPos[3] ) ; min height
				DllStructSetData ( $sMinMaxInfo, 9, $aPos[2] ) ; max width
				DllStructSetData ( $sMinMaxInfo, 10, $aPos[3] ) ; max height
			Else
				$sMinMaxInfo = DllStructCreate ( 'int;int;int;int;int;int;int;int;int;int', $lParam )
				DllStructSetData ( $sMinMaxInfo, 7, 180 + 2* _WinAPI_GetSystemMetrics ( $SM_CXFRAME ) + $iLabelWidth ) ; min width
				DllStructSetData ( $sMinMaxInfo, 8, 180 + 2* _WinAPI_GetSystemMetrics ( $SM_CYFRAME ) + _WinAPI_GetSystemMetrics ( $SM_CYCAPTION ) +2 ) ; min height  (+_WinAPI_GetSystemMetrics ( $SM_CYMENU ))
				DllStructSetData ( $sMinMaxInfo, 9, @DesktopWidth )      ; max width
				DllStructSetData ( $sMinMaxInfo, 10, @DesktopHeight )    ; max height
			EndIf
			If Not $iRecord Then
				Local $aBkPos = ControlGetPos ( $hGui, '', $idLabelBkGround )
				WinSetTitle ( $hGui, '', 'GifCamEx ' & $aBkPos[2] & 'x' & $aBkPos[3] & ' Time ' & StringFormat ( '%05.2f', _FramesGetTotalTimeDelay()/100 ) & ' sec' )
			EndIf
		Case $hGuiEdit
			Local $iMaxHeight, $iMinHeight, $iMinWidth
			If UBound ( $aPosEdit ) = 4 Then
				$iMinWidth = $aPosEdit[2]
				$iMaxHeight = $aPosEdit[3]
				$iMinHeight = $aPosEdit[3]
				$sMinMaxInfo = DllStructCreate ( 'int;int;int;int;int;int;int;int;int;int', $lParam )
				DllStructSetData ( $sMinMaxInfo, 7, $iMinWidth ) ; min width
				DllStructSetData ( $sMinMaxInfo, 8, $iMinHeight ) ; min height
				DllStructSetData ( $sMinMaxInfo, 9, @DesktopWidth ) ; max width
				DllStructSetData ( $sMinMaxInfo, 10, $iMaxHeight ) ; max height
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_GETMINMAXINFO()

Func _WM_LBUTTONDOWN ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Switch $hWnd
		Case $hGui
			_SendMessage ( $hWnd, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0 )
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_LBUTTONDOWN()

Func _WM_MOVE ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Switch $hWnd
		Case $hGui
			_GuiSaveClientPos()
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_MOVE()

Func _WM_NOTIFY ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Local $hWndFrom, $iCode, $tNMHDR, $tInfo, $tNMBHOTITEM
	Switch $hWnd
		Case $hGui
			$tNMBHOTITEM = DllStructCreate ( 'hwnd hWndFrom;int IDFrom;int Code;dword dwFlags', $lParam )
			$iCode = DllStructGetData ( $tNMBHOTITEM, 'Code' )
			Switch $iCode
				Case $BCN_DROPDOWN
					$iPopup = DllStructGetData ( $tNMBHOTITEM, 'hWndFrom' )
			EndSwitch
		Case $hGuiEdit
			$tNMHDR = DllStructCreate ( 'hwnd hWndFrom;int_ptr IDFrom;int Code', $lParam )
			$hWndFrom = HWnd ( DllStructGetData ( $tNMHDR, 'hWndFrom' ) )
			Switch $hWndFrom
				Case $hListView
					$iCode = DllStructGetData ( $tNMHDR, 'Code' )
					Switch $iCode
						Case $NM_CLICK
							$tInfo = DllStructCreate ( $tagNMITEMACTIVATE, $lParam )
							$iIndex = DllStructGetData ( $tInfo, 'Index' )
							$iLeftClick = 1
						Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
							$tInfo = DllStructCreate ( $tagNMITEMACTIVATE, $lParam )
							$iIndex = DllStructGetData ( $tInfo, 'Index' )
							$iRightClick = 1
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_NOTIFY()

Func _WM_SIZE ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Switch $hWnd
		Case $hGui
			_GuiSaveClientPos()
		Case $hGuiEdit
			If Not _WindowIsVisible ( $hGuiEdit ) Then Return 0
			Local $iWidth = BitAND ( $lParam, 0xFFFF )
			Local $iHeight = BitShift ( $lParam, 16 )
			_WinAPI_MoveWindow ( $hListView, 0, 30, $iWidth, $iHeight -50, True )
		Case Else
			Return 0
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_SIZE()

Func _WM_WINDOWPOSCHANGING ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Switch $hWnd
		Case $hGui
			Local $aGuiPos = WinGetPos ( $hGui )
			If Not @error Then
				Local $aGuiClientPos = _WinGetClientPos ( $hGui )
				If Not @error Then
					Local $stWinPos = DllStructCreate ( 'uint;uint;int;int;int;int;uint', $lParam )
					Local $iLeft = DllStructGetData ( $stWinPos, 3 )
					Local $iTop = DllStructGetData ( $stWinPos, 4 )
					Local $iWidth = DllStructGetData ( $stWinPos, 5 )
					Local $iHeight = DllStructGetData ( $stWinPos, 6 )
					Local $iXMax = @DesktopWidth - $iWidth + $iLabelWidth + $aGuiPos[0] + $aGuiPos[2] - $aGuiClientPos[0] - $aGuiClientPos[2]
					Local $iYMax = @DesktopHeight - $iHeight + $aGuiPos[1] + $aGuiPos[3] - $aGuiClientPos[1] - $aGuiClientPos[3]
					If $iLeft < $aGuiPos[0] - $aGuiClientPos[0] Then DllStructSetData ( $stWinPos, 3, $aGuiPos[0] - $aGuiClientPos[0] )
					If $iLeft > $iXMax Then DllStructSetData ( $stWinPos, 3, $iXMax )
					If $iTop < $aGuiPos[1] - $aGuiClientPos[1] Then DllStructSetData ( $stWinPos, 4, $aGuiPos[1] - $aGuiClientPos[1] )
					If $iTop > $iYMax Then DllStructSetData ( $stWinPos, 4, $iYMax )
				EndIf
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_WINDOWPOSCHANGING()

Func Gifcam3Ico ( $sFileName, $sOutputDirPath, $iOverWrite=0 ) ; Code Generated by BinaryToAu3Kompressor.
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LzntDecompress ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Gifcam3Ico()

Func Gifsicleexe ( $sFileName, $sOutputDirPath, $iOverWrite=0 ) ; Code Generated by BinaryToAu3Kompressor.
	Local $sFileBin = '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '7IUD5gb64Aov1S5Nw1TMPKky6ULFI3DFq39RkWEUb1kFOJ/MHEBNZiUo6tRCBCRjPv4MgSWwqzvulFrf7NIcHK2YrImFxo556avEOa06JLYpCw7HBMWkpmvc880EJTxIg/YN6ifpFKOvFzpRugafwmy9jRFVti47UEyDdH1c3GBWM1dh0D6TU2JpB05gmyhCUBqw9TKecS9PMpywUd6cMmjDSMwB2WaP0s9FtN7NcrvyqrQxosXlEZoTZQF3yMXNeyLmuK3vnzE7VCCpbUDfaKawZJyPlHG1zUa6DqEQXSrn+EcTI8SW9xL/ZDqzjYE3R1tTwJ64K62Bgyh8Q7WlQ3Su3Ret5abrFGOdoBOa2WIZ8xZD8YjwWz/pNDX2THLoekxhg5Vok/lJK3qaNn0JyvqlRe1Gcd1zd3iPcHu2dzfM8q8owy4TUJBrVhabU508p/UJfDSwIDvYygM+V8Ea4vPvUPRSgCLaVMWVd3Mrtvjyd//cYSSnCerxzFFDbZzDgLMo/HLzXOGAMmoEDNm6pQQ4moznN+afnhveVjrL4lzhEnx6XIcpQ4lYjHluwaCVK5vaLDPP0sg2GywuvJfEunOdEwPbW6imeecYZHkGsYJjwScU+T6/ecNBA3mK4NtWjtMuewM7Nd7HOnCVk88fLJ84JgDvNvqoNIjTHxS+YvbLlWOEc9Z+X46f5avRQB3IZVpi7L3JC9mgGGN026C2/vqcJcVsIU8ZDzVZ9Q3byO5bvkTk8yW3JbBYIzwtdBlG+adF2+NXaTVSof7KSlQA7HQrkVa/he5nMaO1BbKIpXyLrJvgU2YUOxw39BxUcEvf6ABvkKvyZkfAfBjTcAq00jWvKBJecrSJ9PiBHa2LQdt1et9W1zH6PJ1XOOJsdVWwmH+/8JpywTysqEzQLaGWn8HbbancfnBbuLHgSqdnGDdMQv2+Jg3IEL8ECDsSku/lQukOZ1Xxl5nt8KsTzANEWo3QtdlzJKjZthmeqoUjrhlhQbl9Y5U07jARHOwlAgvIxYY/dyBvXaDp55e24o0QLhcnQ6aqO5CWOlSbe2SNWphYT41nyK9rjx6+Tbi2Tt9RY1sZ/P5eGwAiTZcuY+z49A0Bp6SlpJ+p2jqVI9l7+Dg7EL5HCesXGZku4cwf1FPljAxV26jh1xhGSmqFWsioZFr21ZzPOOAPDRdF2joMn6vAjdD8k+huA8iAk+SuMdoLtODkJHfdlWEXj4uv3D+j62G9Y1YZ1SK3pzWK/xnSdoqadoNTqpn1FnfLJW460DzgqwX9x05wMJf9umBER1A7d0VK/SP1NWY2nj+UEZ3Tydj8Oe9WUhBgETtjYybc0Sbm3Wrs7cI5GQqFyXYvQYt58cPF5jpIsf7Ofup+nmuv7cG2qrOE2EfEINNH5nVKyAmy0yO/j1uh9uIeAq9mahi/IbnU8gP7hQ3FyS8a9Lz+0ypKnvna0UkbI9yUpcIgMYGZuxUzN9gjs602W+FsJER0cdy6OtJfU/adnLqX3O02mcpnBgt+Gr2C2dVTdfKShu6H8DeYfsLnx72AACeuO/UN2WshIN+KZU2D0lzyiOLlM9OMEYTl1G2QJUHHN7GHq0UdXhdEYyAyYgIgSiQAQLzr7fjw+h496ufDa/DfVJ133L6Fr13YlYw5aIetZwu2dGKqjn1uWuqFT0hm2gEZ7VybfOz8rZMmk4M8YKzldn6y6uAmGIRL73Rgn7lxZ4PVxipJ7inlrOR3DVkHqdGBxm9Kigs7b9RpGD2eDafdzB1u1GjaVTs+yHfzeyMCQcVsglrhOPRsOvAU5hVWdAZLDh4bQXTdx4Io6gg3G3cuNj+adNxCCg9ABOvullBAlNOKamf9ePcOgQQtAYobA2aeEkQIdeQJ/gYuvm2snptKpEKXzDtmA4HyeQnkBfhS2A+cO6i5I4MkAdk8bmcGvbDtBvJNcVSZb9qyS910GIMRMK2SVuOPytbMitr32LpvJWVA0+3c/uXUswtCamOKPL3MTw384diX/XIutPPYQD21IrMJzLSRWmV8MPVYHKEdeH7GwL3wlT3ynxg5v4dwQerYlfGfY2nqdxQ0hzvVuBQDJEsenriOinszxO5FE/kf+k5XxMoYiBwQnSctg8zmHtxoLL5TEYT/nOciGlbm6H7oDGzlufkD5NeUpsf39l9Etjj3mzkFxZQGdf4NHgO4TkbWUCKezdVO8rwMz+uBA74FFzcQcD3O/ChB+Qj34moJ8zOnBBYPOC70Q/pOH1D2Pe0YNhvEfL4rcl6/PVBsLnzWuW4pOKXTP3azG9cUrI8cW6XMk5Z9NKoFVzO4gXCMtzOLAnvcfPjQn7o1/yF8QNHrdZ2WkSFgbN3ryqsOtvthM390Jy0K7eK6MwdKewM9JsQ1fo3QfPDp8c0xKLZXiOy6eV2WwVGiM1WtsDPdurU5gisKUix0JoOkZWbM0rOWdABiBnrz5kvi3hd3znNuvRXaLWsdTgq6EfpEvdLxiSYEQmxhqPcFVbQhEYUS/js4jHcvSXsohmzqlAEGQzrpNuGtQKtRjtjrGyHCT+OcVgaoqpb72NsyeyPwL4tjPgVInhFx+gWPn3dvHa+23DxxD7rzQWCkeruwF2JrRdfzPQPa7AUptKBipRMonSI3Rzwljbzb6Nab5GPYF9u4rINpCBHGWcgqXs2v2M7hXj4cbMAAhu7txEwliqU895AI79dZTNWfODA0OCpP0fY/JNnS5Cf+mNaETOhbhLzkF2b+6DDwU5pdfRmhdA+Q2ylGjeyaDcdggFA8y5VsN3Ox6+qfFejgEqlpzkiFmXZ0RE+LqRvAz5fS+OWjjqMZtFCLqZV7UldZwZIVjBeYr4Vkq+jarzK7wODQElKphQKocLYzrnO/CkaQuBYHssaosjuNVIDyRJFut0jIJbPEXTPLp7u0CX9aK7JEeRTE1LH8UjuRZQYWigt9bmcM2pw4gvK0aieZVRhlkzsu6JrRmKPls2AtwP+eBBJuoxCBRJUlq/KQl1cfCryAk0nfqdwvDNcTPj+KJaxPcTUT9lybcLj+FzWILcM57TZ+cse0KvKTiV1zddOTBMw+Sea2Epo0Qy2SN6icgjia5JoqjH8g+rzVrnpYXdVMobzN4lXKLnGY72vm0lTxncbAjtbRUHimKLGrp7Wy6kfSZ/bjM42dOVIqiyAuQSkpAWO0dYhrmYzh3cIyeTlPWlitjcysQkr9Z7Ju0iuW40bQR1i3osIVIo/FTpWpipnsDRGvtGoJ4k/je5mrJcAx8ExkAYCFuzCtvKi7L0I+KESip/5by2AhYPXaPkBI5ZpLoen9A8KpF7lv5HfqqjdP0u6ge8D+lnaWMX76zF5PX67z1o+dgwi1VDJX52A2z98SXj1exllBCi++KjIqde9YcR6qwYHwNCt03+SHdT1LyN2mX7G8p8+pB09K5kgG7v7sIGtlsAIyf8vYBrEIzu6AlJGmqW7CLdq9HdjaywHUDe/Gbgb8zQ71GFqkSvPvp++auLGWUTuZtu36yKCh2QUfj0CAFJ75qETv5KO3BKGgsVLn6a075DxLABlfhOWIvcATHHMhZ0byoGBmVVzA2vprFJ7N4PAniKSjJW4eOjJI+UghLZ2tmtee2p5jXyWi7yVxayHVwSEIhA4BDzIWXHWpwnrDNceul5JD7NOblvdv42/OfmeLN3GICbgpQ6Na0JUkShartDcA04Hu4NfXDEqWxK2+VzU/i5Y4+itU6rIHcCQoNlgnnd3FEu3BTodCviC5JcMPU0e5ZARNrV4+ynS9qpdvWNLIOFDihZfmYHBRom/j6KkHC3w0Axk+VTqBxr9UiZhsnxoNDoq5RHtQdtxj5VLCof3g2ML0dUlQBXftPOKAtjm5V1Lt6P8OQ4hBahY3a8T3g1cEf37+Oq3A8lqrCdlDGtfqEmGzAgkj/v9zjxsIQ4C8fT3Aj43tX2TfKPhiGR7YjAMGBj67BJO88WqzuR7pBmsmSOvFyZUXRMlbkMFMzmi/+ugcXvvmUFGJ'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LzntDecompress ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Gifsicleexe()

Func W100Jpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 ) ; Code Generated by BinaryToAu3Kompressor.
	Local $sFileBin = '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= 'AG4/+Ne/+cGujCVpYTF4bFqjSrvDV6OIVDE03Vw1Z0akaipYilePtaM3Hkq0+Zc8JSjdXMqyp16NWi6zpqrTnTdSlUUKsFUi481OevJUipXhJK8ZWaPzH/Ya/wCCXfwE/Yuii8YqLr4wftCakl1ceJvjv48tluNeTUdWubjUNbj8AaPPLe2vgDS7/Uby8uLiexmufFGq/aJH1nxBcCQ2sf6C+NvAvg74k+EfEPgLx94Y0Pxj4K8WaXcaJ4k8L+I9Ph1LRNb0u7UrPZahZTgpImSJYZ42jurO5WK8sp7a8hhnTs/Iuf8An0vf/AG4/wDjfv06dsYBFHkXXP8Aot7k/wDTjcD9fK/yfpX1PFPH/GvGnEsuMOJuIs2zTiP21KvRzSrialKtgXhqiq4SnlcMP7KlleHwc0pYPC5fTw2HwjjH6vSp2R42TcOcO5BlKyPKcuwOEyvknTqYSMIThiVVjyVp4uVTnnjKteLtXq4mVWpWv+8lK5+fH7Cn7CHhr9g5/j54S+G3ia+1f4RfFD4haD8Q/AfhnW3urvxD4Anh8NzaD4h8M32sylovEOlobTRj4d1dkh1X+zbc2WtR3F5ajUb77a8Z+NPD3w48JeJviB4t1CDSfC3gXw/rHjDxHqdzIsUFhoXhjTp9b1W6kdztAjsrGXZ/fkZI0DOyLVTx78Q/Afws0C+8V/Ezxn4W+HvhnTYJLi+17xvr2meFtKtoY1LszXetXNlGzYB2wwGaeVvkiikYhT+Juv8Aij4z/wDBef4wwfsMfsJ2HivRv2LtI8WaCf20f20J9Ju9G8Nv4P0/UYNUn8EeABq9vbyajc6oLFZdD0Se3/tvxzraaXcalpeh/DrTNY1fUf2vwx8LfFP6VHifQzLMaOZY3C43F5VLjfjrE4P6vgcLl2XYXB4CtXrYyNKlhsZnuJwGDhChhqbnjMwx0pYrEctL63iqXwHF3GPBvg7whVwuFqYShUoUcYsg4do1/a4itisVUrV4U6dHnnUoZfSxFdzqVJ2o4fDpUqXvexpS/Xf/AINiP2Z9D+If/BOvx3+0L8UPCsMV5+1J+2P+0R8d/Cwvn1GC4bwnq1z4T8DROUt9VtIzGfEXgHxH5EghxLCI5FeRHRiV/TV8Dfgj8Of2dfg58MvgR8J/D0Hhv4a/CLwV4e8AeCNDi/enT/D3hrToNNsFublh5l7qFwkJvdV1CbNxqOp3N3f3DPPcSMSv+iXD0KeGoUMNRjy0cPRp0KUdXy06UI04Ru9XaMUtdT/LqrVnWq1K1R81SrUnVm+86knKT+cm2etyBTkEAgkggjIPC9fx5+tflH+3l/wRV/4J0/8ABRzUT4g/aM+BFgnxPS1WK2+Nnwz1G4+HHxajjgdFgTUvEuhItn4uS2XK2cfjvR/FMdipK2SW6kglFbGZ/OF8U/8Ag3F/ZY+GnjrVvBvg79rj/gotpPh7SrbSDYafB+0J4FjitlutLtriWONYfgrDGsYlkcogQBA20fKAB59/w4A/Z/8A+jyv+Cjn/iQ/gr/5zNFFeZ/Y2US96WVZbKUtXKWBwrbb1bbdK7b6tnWsfjkkljcWktEliaySt2SnpsvuD/hwB+z/AP8AR5X/AAUc/wDEh/BX/wA5mj/hwB+z/wD9Hlf8FHP/ABIfwV/85miij+xcm/6FOWf+EGF/+VD/ALQx/wD0HYz/AMKa3/yfkvuD/hwB+z//ANHlf8FHP/Eh/BX/AM5mj/hwB+z/AP8AR5X/AAUc/wDEh/BX/wA5miij+xcm/wChTln/AIQYX/5UH9oY/wD6DsZ/4U1v/k/JfcH/AA4A/Z//AOjyv+Cjn/iQ/gr/AOczSN/wQB/Z/AJ/4bK/4KOf+JD+Cv8A5zVFFH9i5N/0Kcs/8IML/wDKg/tDH/8AQdjP/Cmt/wDJ+S+4++/2Vf8Ag1u/4JseM9N0D4rfHPxZ+1v+0le6bfaljwn8aPjtbXvhG8Fhql/BbJex+A/BHgLxNJCEtovNtofE0FtcfOtxDLHI8Z/qN+C/wU+Ef7P/AMPPD3wq+B/w38GfCb4beGLWO20DwR4B8P6d4Z8OaYhiTzJYdO0yCCGW9uSivfalcifUdQlzPfXVxMzSEorvpUaNCnGlQpU6NKPw06UI06cb6+7CCUVr2RzTqVKsnOpOdSb3nOTnJ+spNt/eesL0H5/nRRRWhB//2Q=='
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> W100Jpg()