#NoEnv
#NoTrayIcon
#SingleInstance force

;;;;; ALTERNATE DIACRITICS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
<^>!y::SendUnicode("ţ")      ; t with cedilla
<^>!+y::SendUnicode("Ţ")     ; T with cedilla



;;;;; BULLETS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!+8::SendUnicode("•")        ; BULLET 
!+9::SendUnicode("◦")        ; EMPTY BULLET
!+0::SendUnicode("̦")        ; the coma from ș :)



;;;;; PUNCTUATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<^>!Space::SendUnicode(" ")  ; NON-BREAKING SPACE
!+-::SendUnicode("—")       ; EM DASH
<^>!+-::SendUnicode("–")     ; EN DASH
<^>!-::SendUnicode("‑")      ; NON-BREAKING HYPHEN

<^>!x::SendUnicode("×")       ; MULTIPLICATION SIGN

!+v::SendUnicode("✓")        ; CHECK MARK
!+x::SendUnicode("✗")        ; BALLOT X

!+;::SendUnicode("★")
!+'::SendUnicode("☆") ;; related ✰

!+l::SendUnicode("❤") ;; gimme some
!++::SendUnicode("✚") ;; for Google+ :)

; ♫  ;; related: ♩ ♪  ♬
; ♥  ;; related: ♠ ♣ ♦
#+w::SendUnicode("⚠") ; ⚠ (warning sign)
; ⨵ ⨮


;;;;; ARROWS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<^>!Left::  SendUnicode("←")
<^>!+Left::  SendUnicode("⇦") 
<^>!Up::    SendUnicode("↑")
<^>!+Up::    SendUnicode("⇧") 
<^>!Right:: SendUnicode("→")
<^>!+Right:: SendUnicode("⇨") 
; <^>!+.:: SendUnicode("➡")
<^>!Down::  SendUnicode("↓")
<^>!+Down::  SendUnicode("⇩")

;↔↕


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

