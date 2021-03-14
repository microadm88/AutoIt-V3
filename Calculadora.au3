#Include <GUIConstants.Au3>
Opt ('GUIOnEventMode','1')

Global $Button_Row['5']['4'], $Display_String = '', $Real_String = ''

GUICreate ('    Cool Calculator v1.0','151','166','-1','-1','-1','144')
GUISetOnEvent ($GUI_EVENT_CLOSE, '_Exit')
GUISetBkColor ('0x0000FF')
$Display = GUICtrlCreateInput ('','11','15','129','20','1')
GUICtrlSetState ($Display, $GUI_DISABLE)
GUICtrlSetFont ($Display, '10','','','New Times Roman')
_Create_Buttons ()
_Set_Text ()
GUISetState (@SW_SHOW)

While ('1')
Sleep ('750')
_Random_Color ()
WEnd

Func _Create_Buttons ()
Local $Top = ('0')
For $Array_1 = '1' To '4'
For $Array_2 = '0' To '3'
$Button_Row[$Array_1][$Array_2] = GUICtrlCreateButton ('','30' * $Array_2 + '18', '50' + $Top, '25','23')
GUICtrlSetFont ('-1', '10','','','Arial')
Next
$Top = $Top + '26'
Next
GUICtrlSetState ($Display, $GUI_FOCUS)
EndFunc

Func _Random_Color ()
$Random = Random ('0x000000','0xFFFFFF')
GUISetBkColor ($Random)
$Random = Random ('10','20')
Sleep ($Random)
EndFunc

Func _Set_Text ()
GUICtrlSetData ($Button_Row['1']['0'], '7')
GUICtrlSetOnEvent ($Button_Row['1']['0'], '_Set_7')
GUICtrlSetData ($Button_Row['1']['1'], '8')
GUICtrlSetOnEvent ($Button_Row['1']['1'], '_Set_8')
GUICtrlSetData ($Button_Row['1']['2'], '9')
GUICtrlSetOnEvent ($Button_Row['1']['2'], '_Set_9')
GUICtrlSetData ($Button_Row['1']['3'], '÷')
GUICtrlSetOnEvent ($Button_Row['1']['3'], '_Divide')
GUICtrlSetData ($Button_Row['2']['0'], '4')
GUICtrlSetOnEvent ($Button_Row['2']['0'], '_Set_4')
GUICtrlSetData ($Button_Row['2']['1'], '5')
GUICtrlSetOnEvent ($Button_Row['2']['1'], '_Set_5')
GUICtrlSetData ($Button_Row['2']['2'], '6')
GUICtrlSetOnEvent ($Button_Row['2']['2'], '_Set_6')
GUICtrlSetData ($Button_Row['2']['3'], '×')
GUICtrlSetOnEvent ($Button_Row['2']['3'], '_Multiply')
GUICtrlSetData ($Button_Row['3']['0'], '1')
GUICtrlSetOnEvent ($Button_Row['3']['0'], '_Set_1')
GUICtrlSetData ($Button_Row['3']['1'], '2')
GUICtrlSetOnEvent ($Button_Row['3']['1'], '_Set_2')
GUICtrlSetData ($Button_Row['3']['2'], '3')
GUICtrlSetOnEvent ($Button_Row['3']['2'], '_Set_3')
GUICtrlSetData ($Button_Row['3']['3'], '-')
GUICtrlSetOnEvent ($Button_Row['3']['3'], '_Subtract')
GUICtrlSetData ($Button_Row['4']['0'], '0')
GUICtrlSetOnEvent ($Button_Row['4']['0'], '_Set_0')
GUICtrlSetData ($Button_Row['4']['1'], 'C')
GUICtrlSetOnEvent ($Button_Row['4']['1'], '_Clear')
GUICtrlSetData ($Button_Row['4']['2'], '=')
GUICtrlSetOnEvent ($Button_Row['4']['2'], '_Equal')
GUICtrlSetData ($Button_Row['4']['3'], '+')
GUICtrlSetOnEvent ($Button_Row['4']['3'], '_Add')
EndFunc

Func _Set_0 ()
_Set_Number ('0')
EndFunc

Func _Set_1 ()
_Set_Number ('1')
EndFunc

Func _Set_2 ()
_Set_Number ('2')
EndFunc

Func _Set_3 ()
_Set_Number ('3')
EndFunc

Func _Set_4 ()
_Set_Number ('4')
EndFunc

Func _Set_5 ()
_Set_Number ('5')
EndFunc

Func _Set_6 ()
_Set_Number ('6')
EndFunc

Func _Set_7 ()
_Set_Number ('7')
EndFunc

Func _Set_8 ()
_Set_Number ('8')
EndFunc

Func _Set_9 ()
_Set_Number ('9')
EndFunc

Func _Clear ()
GUICtrlSetData ($Display, '')
$String = ''
EndFunc

Func _Divide ()
$Display_String = ($Display_String & ' ÷ ')
$Real_String = ($Real_String & ' / ')
GUICtrlSetData ($Display, $Display_String)
GUICtrlSetState ($Display, $GUI_FOCUS)
EndFunc

Func _Multiply ()
$Display_String = ($Display_String & ' × ')
$Real_String = ($Real_String & ' * ')
GUICtrlSetData ($Display, $Display_String)
GUICtrlSetState ($Display, $GUI_FOCUS)
EndFunc

Func _Subtract ()
$Display_String = ($Display_String & ' - ')
$Real_String = ($Real_String & ' - ')
GUICtrlSetData ($Display, $Display_String)
GUICtrlSetState ($Display, $GUI_FOCUS)
EndFunc

Func _Add ()
$Display_String = ($Display_String & ' + ')
$Real_String = ($Real_String & ' + ')
GUICtrlSetData ($Display, $Display_String)
GUICtrlSetState ($Display, $GUI_FOCUS)
EndFunc

Func _Equal ()
$Equal = Execute ($Real_String)
GUICtrlSetData ($Display, $Equal)
$Display_String = ($Equal)
$Real_String = ($Equal)
GUICtrlSetState ($Display, $GUI_FOCUS)
EndFunc

Func _Set_Number ($Number)
$Display_String = ($Display_String & $Number)
$Real_String = ($Real_String & $Number)
GUICtrlSetData ($Display, $Display_String)
GUICtrlSetState ($Display, $GUI_FOCUS)
EndFunc

Func _Exit ()
Exit
EndFunc