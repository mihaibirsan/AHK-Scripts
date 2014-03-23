#NoEnv
#SingleInstance force
#NoTrayIcon

; TODO: When not filtered, the symbols should be sorted by "most used" on the first row and "pinned" on the second row; no other rows should be displayed
; TODO: Show the window near the cursor on the screen, if any, or centered otherwise
; TODO: Close the window if the originally focused control loses focus
; MAYBE: Add a display mode in which the names of the symbols are displayed
; MAYBE: Try to display dialog using the font of the focused control

; Grid configuration options
STATIC_GRID_COLUMNS := 10
STATIC_GRID_ROWS := 4
GRID_WIDTH := 30
GRID_HEIGHT := 30

; Setup system notification tray
Menu, Tray, Icon, SymbolSelectDialog.ico, , 1
Menu, Tray, Tip, Symbol Select Dialog`nCtrl+Alt+Shift+' ; MAYBE: Automatically generate keyboard shortcut tooltip
Menu, Tray, Icon

; Setup GUI window
Gui -MinimizeBox -MaximizeBox -SysMenu -Border -Caption +ToolWindow +LabelMainGui +AlwaysOnTop +LastFound
GroupAdd, GuiWindowGroup, % "ahk_id " . WinExist()
Gui, Color, FFFFFF, 0000FF
Gui, Margin, 0, 0
Gui, Font, s16, Arial Unicode MS

; Prepare font antialiasing
; @see http://www.autohotkey.com/community/viewtopic.php?t=41243
nHeight    := 28  ; font size
fnWeight   := 400 ; FW_NORMAL
fdwCharSet := 0x1 ; DEFAULT_CHARSET
lpszFace := "Arial Unicode MS"
CLEARTYPE_QUALITY := 0x5
hFont := DllCall( "CreateFont", Int,nHeight, Int,0, Int,0, Int,0, UInt,fnWeight, Int,0
,Int,0, Int,0, UInt,fdwCharSet, Int,0, Int,0, Int,CLEARTYPE_QUALITY, Int,0, Str,lpszFace )

; Setup permanent GUI elements
Gui, Add, Edit, -Theme -E0x200 +Background x0 y%GRID_HEIGHT% w%GRID_WIDTH% h%GRID_HEIGHT% vSelectionBox, 
; TODO: Add "No symbols match your filter" text field

; Setup a static grid of blanks onto which a dynamic grid of symbols will be drawn
; this method is preferred because of memory implications
Loop %STATIC_GRID_COLUMNS%
{
    Column := A_Index-1
    Loop %STATIC_GRID_ROWS%
    {
        Row := A_Index-1
        Positioning := "x" . (GRID_WIDTH*Column) . " y" . (GRID_HEIGHT*Row+GRID_HEIGHT) . " w" . (GRID_WIDTH+1) . " h" . (GRID_HEIGHT+1)
        Gui, Add, Text, %Positioning% vC%Column%R%Row% hwndHC%Column%R%Row% +Border +Center +BackgroundTrans, 
        CurrentControlHwnd := HC%Column%R%Row%
        SendMessage, 0x30, hFont, 1,, ahk_id %CurrentControlHwnd%
    }
}

; Reset active grid item
Column := 0
Row := 0
GuiControl, +CFFFFFF, C0R0

; Setup Edit Field
WINDOW_WIDTH := GRID_WIDTH*STATIC_GRID_COLUMNS
Gui, Add, Edit, -Background x0 y0 w%WINDOW_WIDTH% h%GRID_HEIGHT% vEditField gEditFieldUpdated

; Read symbols data
SymbolsCount = 0 ; VARDEFINE: The number of items in the Symbols array
Loop, read, SymbolSelectDialog-Symbols.csv
{
    StringSplit, ReadLineSymbols, A_LoopReadLine, `,

    SymbolsCount += 1
    Symbols%SymbolsCount% := ReadLineSymbols1 ; VARDEFINE: The actual Unicode symbol in the Symbols array
    SymbolsUnicodeName%SymbolsCount% := ReadLineSymbols2 ; VARDEFINE: Used with low priority for full-text search
    SymbolsKeywords%SymbolsCount% := ReadLineSymbols3 ; VARDEFINE: Used with high priority for full-text search
    SymbolsLineGroup%SymbolsCount% := ReadLineSymbols4 ; VARDEFINE: Used for grouping into lines of the grid
    SymbolsVisible%SymbolsCount% := true ; VARDEFINE: Whether the corresponding symbol will be drawn or not. Used for filtering
}

; Set initial filter variable and paint initial grid
ClearFilter()

; Sets the filter blank and draws the symbols
ClearFilter()
{
    global
    ; Empty the EditField and the subroutine will take control
    GuiControl, , EditField, 
}

; Sets the filter to the parameter and draws the symbols
SetFilter(NewValue)
{
    global
    ; Set the EditField and the subroutine will take control
    GuiControl, , EditField, %NewValue%
}

; Create a separete list of filtered symbols
ApplyFilter()
{
    global
    FilteredSymbolsCount := 0

    ; Collect symbols that match the filter
    Loop %SymbolsCount%
    {
        If (Filter != "" && (InStr(SymbolsUnicodeName%A_Index%, Filter) == false))
            Continue

        FilteredSymbolsCount += 1
        FilteredSymbolsIndex%FilteredSymbolsCount% := A_Index
    }
}

; Draws all the filtered symbols
DrawGridSymbols()
{
    global

    ; TODO: Allow dynamic scrolling through symbols if there are more then grid spaces

    ; Fill in symbols that match the filter
    Loop %FilteredSymbolsCount%
    {
        SymbolIndex := FilteredSymbolsIndex%A_Index%

        FilteredSymbolColumn := Mod(A_Index-1, STATIC_GRID_COLUMNS)
        FilteredSymbolRow := (A_Index-1) // STATIC_GRID_COLUMNS
        GuiControl, , C%FilteredSymbolColumn%R%FilteredSymbolRow%, % Symbols%SymbolIndex%

        If (A_Index == STATIC_GRID_COLUMNS*STATIC_GRID_ROWS)
            Break
    }

    ; Clear remaining grid items
    Loop % STATIC_GRID_COLUMNS*STATIC_GRID_ROWS - FilteredSymbolsCount
    {
        FilteredSymbolColumn := Mod(FilteredSymbolsCount+A_Index-1, STATIC_GRID_COLUMNS)
        FilteredSymbolRow := (FilteredSymbolsCount+A_Index-1) // STATIC_GRID_COLUMNS
        GuiControl, , C%FilteredSymbolColumn%R%FilteredSymbolRow%,
        ; Maybe hide the controls that don't need to be shown
    }

    ; TODO: The active grid item might need repositioning; calculate the new position and set it; keep previously selected symbols selected, if possible
}

; 
SetActiveGridItem(NewColumn, NewRow)
{
    global
    GuiControl, +C000000, C%Column%R%Row%

    Column := Column + NewColumn
    if (Column < 0)
        Column := 0
    if (Column > STATIC_GRID_COLUMNS-1)
        Column := STATIC_GRID_COLUMNS-1

    Row := Row + NewRow
    if (Row < 0)
        Row := 0
    if (Row > STATIC_GRID_ROWS-1)
        Row := STATIC_GRID_ROWS-1

    GuiControl, +CFFFFFF, C%Column%R%Row%
    ; MAYBE: Pick up the x and y of C%Column%R%Row%
    GuiControl, MoveDraw, SelectionBox, % "x" . (GRID_WIDTH*Column) . " y" . (GRID_HEIGHT*Row+GRID_HEIGHT)
}

WindowClose()
{
    Gui, Hide
}

^!+'::
    ClearFilter()
    Gui, Show, NoActivate Center
return

#IfWinExist ahk_group GuiWindowGroup
Enter::
    GuiControlGet, Label, , C%Column%R%Row%
    WindowClose()
    Sleep, 10
    SendUnicode(Label)
return
/::
    GuiControl, Focus, EditField
    Gui, Show
return
; MAYBE: Re-enable quick searches
; InputValue := "Box"
; InputValue := "Dingbat"
!F4:: WindowClose()
Escape:: WindowClose()
^!+':: WindowClose()
Up:: SetActiveGridItem(0, -1)
Down:: SetActiveGridItem(0, 1)
Left:: SetActiveGridItem(-1, 0)
Right:: SetActiveGridItem(1, 0)


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

;;;;; subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Following this line only subroutines are defined
return

; Update the filter whenever the Edit Field is updated
EditFieldUpdated:
    GuiControlGet, Filter, , EditField
    ApplyFilter()
    DrawGridSymbols()
return
