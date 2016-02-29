; SysGet wa, MonitorWorkArea
; MsgBox % waLeft ", " waTop ", " waRight ", " waBottom

waLeft := 0
waTop := 0
waRight := 1538
waBottom := 900
; WorkArea(waLeft, waTop, waRight, waBottom)

; see: http://stackoverflow.com/questions/6267206/how-can-i-resize-the-desktop-work-area-using-the-spi-setworkarea-flag
; https://autohotkey.com/board/topic/69054-act-upon-workstation-lock-unlock/
WorkArea(0, 0, 1500, 900)

WorkArea(lm,tm,rm,bm) {
    VarSetCapacity(area, 16, 0 )
    NumPut(lm,area,0,"UInt"), NumPut(tm,area,4,"UInt"), NumPut(rm,area,8,"UInt"), NumPut(bm,area,12,"UInt")
    DllCall("SystemParametersInfo","uint",0x2F,"uint",0,"UPtr",&area,"uint",0) ; SPI_SETWORKAREA
}

