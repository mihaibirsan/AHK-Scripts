#NoEnv
#NoTrayIcon
#SingleInstance force

;;;;; APPS KEY ;;;;;
~RControl::Ticks := A_TickCount
RControl Up::
    If (A_TickCount - Ticks) < 100
    {
        Send {AppsKey}
    }
Return

;;;;; PIDGIN BUDDY LIST ;;;;;
#IfWinActive Buddy List ahk_class gdkWindowToplevel
!^+.::WinClose
#IfWinActive

;;;;; TWEET DECK ;;;;;
; #IfWinActive TweetDeck ahk_class QWidget
; !F4:: WinHide
; !^+':: WinHide
; #IfWinActive
; !^+'::
;     DetectHiddenWindows On
;     IfWinNotExist 
;     {
;         Run "C:\Program Files\Twitter\TweetDeck\TweetDeck.exe"
;         WinWait TweetDeck ahk_class QWidget
;         WinActivate
;     }
;     Else
;     {
;         WinShow
;         WinActivate
;     }
; Return
 
;;;;; NOTEPAD ;;;;;
#IfWinActive ahk_class Notepad
^Backspace::Send {Ctrl down}{Shift down}{Left}{Ctrl up}{Shift up}{Delete}
!Up::
    AutoTrim Off  ; Retain any leading and trailing whitespace on the clipboard.
    ClipboardOld = %ClipboardAll%  ; Save clipboard contents
    Send {Home}{Shift down}{End}{Right}{Shift up}{Ctrl down}x{Ctrl up}{Up}{Ctrl down}v{Ctrl up}{Up}
    Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
Return
!Down::
    AutoTrim Off  ; Retain any leading and trailing whitespace on the clipboard.
    ClipboardOld = %ClipboardAll%  ; Save clipboard contents
    Send {Home}{Shift down}{End}{Right}{Shift up}{Ctrl down}x{Ctrl up}{Down}{Ctrl down}v{Ctrl up}{Up}
    Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
Return
#IfWinActive

;;;;; TOTALCMD ;;;;;
#F1::
    DetectHiddenWindows, On
    WinActivate ahk_class TTOTAL_CMD
Return

;;;;; CHROME ;;;;;
SC056::
    PreviousWindowID := WinExist("A")
    Run, C:\Users\mihai.birsan.mihaibirsan-PC\AppData\Local\Google\Chrome\Application\chrome.exe
    If PreviousWindowID = 0
        WinWaitActive, ahk_class Chrome_WidgetWin_0
    Else
        WinWaitNotActive, ahk_id %PreviousWindowID%
    IfWinActive, ahk_class Chrome_WidgetWin_0
    {
        WinRestore, A
        WinMove, A,, 0, 0, 1024, A_ScreenHeight
    }
Return
+SC056::
    PreviousWindowID := WinExist("A")
    Run, C:\Users\mihai.birsan.mihaibirsan-PC\AppData\Local\Google\Chrome\Application\chrome.exe --incognito
    If PreviousWindowID = 0
        WinWaitActive, ahk_class Chrome_WidgetWin_0
    Else
        WinWaitNotActive, ahk_id %PreviousWindowID%
    IfWinActive, ahk_class Chrome_WidgetWin_0
    {
        WinRestore, A
        WinMove, A,, 0, 0, 1024, A_ScreenHeight
    }
Return

;;;;; TAGS ;;;;;
^!/::
    InputBox, TagString, Surround with tag, Enter the tag. You may include attributes.
    if (not ErrorLevel)
    {
        Pos := RegExMatch(TagString, "^.+?\b", JustTheTag)
        
        if (Pos > 0)
        {
            AutoTrim Off  ; Retain any leading and trailing whitespace on the clipboard.
            ClipboardOld = %ClipboardAll%
            Clipboard =  ; Must start off blank for detection to work.
            Send ^c
            ClipWait 1
            Clipboard = <%TagString%>%Clipboard%</%JustTheTag%>
            Send ^v
            Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
        }
    }
Return

;;;; TEST SCANNING
; #1::
;     SendInput `%4274110000000001`;{Enter}
; Return
; #+1::
;     SendInput `%4274000000000001`;{Enter}
; Return
; #2::
;     SendInput `777869124242`;{Enter}
; Return
