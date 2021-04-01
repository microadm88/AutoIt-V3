Func AndroInfo($param1)
Local $info
Local $imei3 = ""
	Switch $param1
		Case "version"
			$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell getprop ro.build.version.release", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		Case "sdcard"
			$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell echo $EXTERNAL_STORAGE", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		Case "model"
			$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell getprop ro.product.model", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		Case "imeiv4"
			$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell dumpsys iphonesubinfo", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		Case "imeiv5"
			$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell service call iphonesubinfo 1", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
	EndSwitch

	While ProcessExists($cPID)
		$stdError = StderrRead($cPID)
		If Not @error And $stdError <> '' Then
			$info = $stdError
		EndIf
		$stdOut = StdoutRead($cPID)
		$info &= $stdOut
	WEnd

	If $param1 == "imeiv4" And Not StringInStr($info,"error") And Not $info == "" Then
		$imei2 = _StringBetween($info,"Device ID = ",@CR)
		$info = Int($imei2[0])
	ElseIf $param1 == "imeiv4" And Not StringInStr($info,"error") And $info == "" Then
		$info = ""
		$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell su -c service call iphonesubinfo 1", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		While ProcessExists($cPID)
			$stdError = StderrRead($cPID)
		If Not @error And $stdError <> '' Then
			$info = $stdError
		EndIf
			$stdOut = StdoutRead($cPID)
			$info &= $stdOut
		WEnd
			If Not StringInStr($info,"error") Then
				$imei2 = _StringBetween($info," '","'")
				For $i = 0 To UBound($imei2) -1
					$imei3 &= $imei2[$i]
				Next
				$info = Int(StringReplace($imei3,".",""))
			EndIf
	ElseIf $param1 == "imeiv5" And Not StringInStr($info,"error") And Not StringInStr($info,"'..p.e.r.m.i.s.s.'")  Then
		$imei2 = _StringBetween($info," '","'")
		For $i = 0 To UBound($imei2) -1
			$imei3 &= $imei2[$i]
		Next
		$info = Int(StringReplace($imei3,".",""))
	ElseIf $param1 == "imeiv5" And StringInStr($info,".p.e.r.m.i.s.s.") Then
		$info = ""
		$cPID = Run(@ComSpec & " /c " & @TempDir&"\adb.exe" & " shell su -c service call iphonesubinfo 1", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		While ProcessExists($cPID)
			$stdError = StderrRead($cPID)
		If Not @error And $stdError <> '' Then
			$info = $stdError
		EndIf
			$stdOut = StdoutRead($cPID)
			$info &= $stdOut
		WEnd
			If Not StringInStr($info,"error") Then
				$imei2 = _StringBetween($info," '","'")
				For $i = 0 To UBound($imei2) -1
					$imei3 &= $imei2[$i]
				Next
				$info = Int(StringReplace($imei3,".",""))
			EndIf
	ElseIf $param1 == "version" And Not StringInStr($info,"error") And StringInStr ($info,"daemon started successfully") Then
		$info = StringStripCR($info)
		$info2 = _StringBetween($info,"y *"&@LF,@LF)
		$info = $info2[0]
		$info = Int(StringReplace($info,".",""))
	ElseIf $param1 == "version" And Not StringInStr($info,"error") Then
		$info = Int(StringReplace($info,".",""))
	ElseIf $param1 == "sdcard" And Not StringInStr($info,"error") Then
		$info = StringReplace(StringStripCR($info),@LF,"")&"/"
	ElseIf $param1 == "model" And Not StringInStr($info,"error") Then
		$info = StringReplace(StringStripCR($info),@LF,"")
	EndIf

Return $info

EndFunc