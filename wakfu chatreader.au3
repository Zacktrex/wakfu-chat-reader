#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>


    HotKeySet("!{F12}","leave") ; press alt+f12 to insta quit
    Func leave()
	   MsgBox(4096,"system call", " program ended:" & @error)
    	Exit
	 EndFunc
	  MsgBox(4096,"system call", " press alt + f12 to end program")

;------------------------------------------translator code------------------------------------------------------------------
        Global $g_sMytext='', $g_sFrom, $g_sTo, $g_Url, $g_oHTTP, $g_sData ,$msg="",$sub="", $text=""

$g_sFrom   = "auto"
$g_sTo     = "en"
;-----------------------------------------------------------------------------------------------------------
Local $hGUI =GUICreate("Wakfu chat reader (close : alt+f12)", 400, 150)
Local $BoxID = GUICtrlCreateEdit("", 0, 0, 400, 150)
GUISetState(@SW_SHOW,$hGUI)
WinSetOnTop($hGUI, "", $WINDOWS_ONTOP)

Dim $aChatlog, $TotalLine ,$count

While 1
$chatlog ="C:\Users\"&@UserName&"\AppData\Roaming\zaap\wakfu\logs\wakfu_chat.log"
$TimeStamp = FileGetTime($chatlog, 0, 1)
If Not _FileReadToArray($chatlog, $aChatlog) Then
   MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
   Exit
EndIf
$TotalLine = $aChatlog[0]


    If FileGetTime($chatlog, 0, 1) <> $TimeStamp Then
	   $newLines = ""
        $TimeStamp = FileGetTime($chatlog, 0, 1)
        _FileReadToArray($chatlog, $aChatlog)
        If IsArray($aChatlog) Then

            For $i = $TotalLine To $aChatlog[0]
                $newLines &= $aChatlog[$i] & @CRLF
            Next
		 EndIf
;----------------------------------------------------translator ocde----------------------------------------------------------------------------------------

	  $text =  StringSplit($newLines, ':') ;text msg

;ConsoleWrite("> Result : " & UBound($text,  $UBOUND_ROWS) & @CRLF)
$count=UBound($text,  $UBOUND_ROWS)
if ($count>4)Then
$g_sMytext = $text[4]
ConsoleWrite("> Result : " &$g_sMytext & @CRLF)
Else
   $g_sMytext = "error occur"
EndIf

$g_Url     = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=" & $g_sFrom & "&tl=" & $g_sTo & "&dt=t&q=" & $g_sMytext
$g_sData = BinaryToString(InetRead($g_Url), 4)
$g_sData = StringMid($g_sData, 5, StringInStr($g_sData, '","')-5) & @CRLF


;--------------------------------------------------------------------------------------------------------------------------------------------
		     ;$data = ConsoleRead()

            ConsoleWrite(StringSplit($newLines, ':', $STR_ENTIRESPLIT)[3]&$g_sData & @CRLF)
			$sub =StringSplit(StringSplit($newLines, ':', $STR_ENTIRESPLIT)[3],'-',$STR_ENTIRESPLIT)[2]
			$msg =$sub&": "&$g_sData
			GUICtrlSetData($BoxID, @CRLF & $msg,1)

    EndIf
    Sleep(100)

WEnd

; Delete the previous GUI and all controls.
   GUIDelete($hGUI)