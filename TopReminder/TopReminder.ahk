#SingleInstance Force

; Set relevant icon
Menu, Tray, Icon, TopReminder.ico

; Windows Messages
WM_WTSSESSION_CHANGE := 0x02B1
SPI_SETWORKAREA := 0x2F

; Load goal from file
IniRead, SavedText, TopReminder.ini, Goal, Goal, Click to update goal reminder

; Prepare font antialiasing
; @see http://www.autohotkey.com/community/viewtopic.php?t=41243
nHeight    := 28  ; font size
fnWeight   := 400 ; FW_NORMAL
fdwCharSet := 0x1 ; DEFAULT_CHARSET
lpszFace := "Segoe UI Symbol"
CLEARTYPE_QUALITY := 0x5
hFont := DllCall( "CreateFont", Int,nHeight, Int,0, Int,0, Int,0, UInt,fnWeight, Int,0
,Int,0, Int,0, UInt,fdwCharSet, Int,0, Int,0, Int,CLEARTYPE_QUALITY, Int,0, Str,lpszFace )

; Setup Work Area and GUI
GuiHeight := 22
SysGet wa, MonitorWorkArea
CustomWorkArea()
    WorkArea(waLeft, waTop + GuiHeight, waRight, waBottom)

Gui, New, AlwaysOnTop -SysMenu +ToolWindow -Caption +HwndGuiHwnd
Gui, Color, 000080
Gui, Margin, 0, 0
Gui, Font, s11 cFFFFFF, Segoe UI Symbol
Gui, Add, Text, vNote x5 y0 w%waRight% h%GuiHeight% gUpdate +Center, %SavedText%
Gui, Show, X%waLeft% Y%waTop% W%waRight% H%GuiHeight% NoActivate

DllCall("Wtsapi32.dll\WTSRegisterSessionNotification", "uint", GuiHwnd, "uint", 0) ; registering the gui, but only for this session
OnMessage(WM_WTSSESSION_CHANGE, "OnSessionChange")

OnExit OnExit
return

OnExit:
    WorkArea(waLeft, waTop, waRight, waBottom)
    ExitApp
return

OnSessionChange(wParam) {
    if (wParam == 8) {
        Sleep, 1000
        CustomWorkArea()
    }
}

Update:
    InputBox, NewText, Update goal, Goal, , , , , , , , %NewText%
    GuiControl, , Note, %NewText%
    ; Save goal to file
    IniWrite, %NewText%, TopReminder.ini, Goal, Goal
return

CustomWorkArea() {
    global
    WorkArea(waLeft, waTop + GuiHeight, waRight, waBottom)
    ; MsgBox % [ waLeft, waTop + GuiHeight, waRight, waBottom ].join(" ")
    ; MsgBox % waLeft . " " . (waTop + GuiHeight) . " " . waRight . " " . waBottom 
}

WorkArea(lm, tm, rm, bm) {
    global
    VarSetCapacity(area, 16, 0 )
    NumPut(lm,area,0,"UInt"), NumPut(tm,area,4,"UInt"), NumPut(rm,area,8,"UInt"), NumPut(bm,area,12,"UInt")
    DllCall("SystemParametersInfo", "uint", SPI_SETWORKAREA, "uint", 0, "UPtr", &area, "uint", 3)
}

