#NoEnv
#SingleInstance force
; #NoTrayIcon
; MAYBE: Add a nice icon for the System Notification Area

Gui -MinimizeBox -MaximizeBox -SysMenu -Border +ToolWindow +LabelMainGui +AlwaysOnTop +LastFound
GroupAdd, GuiWindowGroup, % "ahk_id " . WinExist()
Gui, Margin, 0, 0
Gui, Font, s16, Arial Unicode MS
; MAYBE: Try to display dialog using the font of the focused control
Column := 0
Row := 0
MaxColumn := 0
; TODO: Stack these up in an in-memory array
; TODO: Extract the drawing into a method to also allow redrawing
; TODO: Enable searching through the symbols with the key "/" and using the descriptions in the CSV file
Loop, read, SymbolSelectDialog-Symbols.csv
{
    if StrLen(A_LoopReadLine) = 0
    {
        Column := 0
        Row := Row + 1
    } 
    else 
    {
        Loop, parse, A_LoopReadLine, CSV
        {
            Positioning := "x" . (40*Column) . " y" . (40*Row)
            Gui, Add, Button, %Positioning% w40 h40 vC%Column%R%Row% Disabled, %A_LoopField%
            break
        }
        Column := Column + 1
        if (MaxColumn < Column - 1)
            MaxColumn := Column - 1
    }
}
MaxRow := Row
Column := 0
Row := 0
GuiControl, -Disabled, C0R0
return

^!+'::
    Gui, Show, NoActivate
return

#IfWinExist ahk_group GuiWindowGroup
Enter::
    global Column
    global Row
    GuiControlGet, Label, , C%Column%R%Row%
    WindowClose()
    Sleep, 10
    SendUnicode(Label)
return
Escape:: WindowClose()
^!+':: WindowClose()
Up:: SetActive(0, -1)
Down:: SetActive(0, 1)
Left:: SetActive(-1, 0)
Right:: SetActive(1, 0)

WindowClose()
{
    Gui, Hide
}

SetActive(NewColumn, NewRow)
{
    global MaxColumn
    global MaxRow
    global Column
    global Row
    GuiControl, +Disabled, C%Column%R%Row%

    Column := Column + NewColumn
    if (Column < 0)
        Column := 0
    if (Column > MaxColumn)
        Column := MaxColumn

    Row := Row + NewRow
    if (Row < 0)
        Row := 0
    if (Row > MaxRow)
        Row := MaxRow

    GuiControl, -Disabled, C%Column%R%Row%
}
    

;;;;; utilities ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SendUnicode( UniSz )
{
  SetFormat, IntegerFast, Hex
  UniHex := SubStr( Asc(UniSz) . "", 3 )
  SetFormat, IntegerFast, d

  ; difference between GTK+ applications and all other Windows applications
  IfWinActive ahk_class gdkWindowToplevel
    SendInput, {Ctrl down}{Shift down}u{Ctrl up}%UniHex%{Shift up}
  Else
    SendInput, {U+%UniHex%}
}

