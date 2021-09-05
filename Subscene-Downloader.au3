#cs ----------------

 AutoIt Version: 3.3.14.5
 Author:         musahi0128

 Script Function:
	Download subtitle from subscene.com

#ce ----------------

#include <File.au3>
#include <Array.au3>
#include <String.au3>
#include "wd_core.au3"
#include "wd_helper.au3"

Global $title = "Subscene.com Downloader"
Global $sDesiredCapabilities, $sSession
Global $subs_url = []
Global $language = ['english','indonesian']
Global $max_dl = 10
Global $zip = "C:\Program Files\7-Zip\7z.exe"
Global $sfk = "C:\Users\User1\Apps\sfk\sfk198.exe"
Global $_WD_DEBUG = $_WD_DEBUG_None
Global $sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"goog:chromeOptions": {"w3c": true, "args": ["--allow-running-insecure-content"] }}}}'

_WD_Option('Driver', 'chromedriver.exe')
_WD_Option('Port', 9515)
_WD_Option('DriverParams', '--log-path="' & @ScriptDir & '\chrome.log"')
_WD_Startup()

$sSession = _WD_CreateSession($sDesiredCapabilities)

; ----------------

_DoDownloadSubs("https://subscene.com/subtitles/the-queens-corgi","The.Queen's.Corgi.2019")

; ----------------

_WD_DeleteSession($sSession)
_WD_Shutdown()

; ----------------

Func _DoDownloadSubs($main_url = "", $vid_filename = "", $dl_dir = @UserProfileDir & "\Downloads\Video")
	If $main_url = "" Then
		MsgBox(0, $title, "No link to the subtitle is provided. Exiting now.")
		_WD_DeleteSession($sSession)
		_WD_Shutdown()
		Exit
	EndIf
	If $vid_filename = "" Then
		$tmp1 = _StringExplode($main_url, "/")
		$vid_filename = $tmp1[UBound($tmp1)-1]
	EndIf
	For $a In $language
		Local $workingdir = $dl_dir & "\" & $vid_filename & "\" & StringLeft($a, 3)
		DirCreate($workingdir)
		Global $subs_url = [""]
		_WD_Navigate($sSession, $main_url & "/" & $a)
		For $b = 1 To _WD_ElementActionEx($sSession, _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, "//tbody"), 'childcount') -1
			$bElements = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, "//tbody/tr[" & $b & "]/td[1]/a[1]")
			_ArrayAdd($subs_url, _WD_ElementAction($sSession, $bElements, 'property', 'href'))
		Next
		$subs_url = _ArrayUnique($subs_url)
		If UBound($subs_url) = 2 Then
			DirRemove($workingdir, 1)
			MsgBox(0, $title, "No subtitle found. Exiting now.")
		ElseIf UBound($subs_url)-1 >= $max_dl Then
			$dl_count = $max_dl+1
		Else
			$dl_count = UBound($subs_url)-1
		EndIf
		For $b = 1 To $dl_count
			_WD_Navigate($sSession, $subs_url[$b])
			$bElements = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, "//a[@id='downloadButton']")
			InetGet(_WD_ElementAction($sSession, $bElements, 'property', 'href'), _TempFile($workingdir, $vid_filename & "." & StringLeft($a, 3) & "-", ".zip"))
		Next
		ShellExecuteWait($zip, "e -aou *.zip", $workingdir, "", @SW_HIDE)
		ShellExecuteWait($sfk, "dupfind -dir .\ +del!", $workingdir, "", @SW_HIDE)
		Local $tmp1 = _FileListToArray($workingdir, "*.srt", 1)
		For $b In $tmp1
			FileMove($workingdir & "\" & $b, _TempFile($workingdir & "\..\", $vid_filename & "." & StringLeft($a, 3) & "-", ".srt", 3))
		Next
		DirRemove($workingdir, 1)
	Next
EndFunc
