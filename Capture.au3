
Func Capture($internalst, $localpath = -1, $resol = -1)
$info = ""
$quot = Chr(13)
	If StringInStr($internalst,"/") Then
		$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell screencap -p "&$internalst&"cap.png", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		 While ProcessExists($cPID)
			$stdError = StderrRead($cPID)
			If Not @error And $stdError <> '' Then
				$info = $stdError
			EndIf
			$stdOut = StdoutRead($cPID)
			$info &= $stdOut
		WEnd
				If StringInStr($info,"error") Then
					MsgBox("","","Opps!!! an error,check the info: "&$info)
				EndIf
		If $localpath <> -1 Then
			$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " pull "&$internalst&"cap.png"&" "&$quot&$localpath&$quot, "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
				While ProcessExists($cPID)
					$stdError = StderrRead($cPID)
					If Not @error And $stdError <> '' Then
						$info = $stdError
					EndIf
						$stdOut = StdoutRead($cPID)
						$info &= $stdOut
				WEnd
		Else
			$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " pull "&$internalst&"cap.png", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
				While ProcessExists($cPID)
					$stdError = StderrRead($cPID)
					If Not @error And $stdError <> '' Then
						$info = $stdError
					EndIf
						$stdOut = StdoutRead($cPID)
						$info &= $stdOut
				WEnd

		EndIf
		If $resol <> -1 And $localpath <> -1 And Not StringInStr($info,"error") Then
			_GDIPlus_Startup()
			$resolimg = _GDIPlus_ImageLoadFromFile($localpath&"\cap.png")
			$imgDimen = _GDIPlus_ImageGetDimension($resolimg)
			_GDIPlus_ImageDispose($resolimg)
			$info = ""
			$info = $imgDimen[0]&"|"&$imgDimen[1]
			_GDIPlus_Shutdown()
		ElseIf $resol <> -1 And Not StringInStr($info,"error") Then
			_GDIPlus_Startup()
			$resolimg = _GDIPlus_ImageLoadFromFile(@ScriptDir&"\cap.png")
			$imgDimen = _GDIPlus_ImageGetDimension($resolimg)
			_GDIPlus_ImageDispose($resolimg)
			$info = ""
			$info = $imgDimen[0]&"|"&$imgDimen[1]
			_GDIPlus_Shutdown()
		EndIf
	Else
		MsgBox("","","Opps!!! an error,check the info: "&$info)
	EndIf

	Return $info
EndFunc
