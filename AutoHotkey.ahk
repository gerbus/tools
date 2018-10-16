!Left::send {Home} ; Alt-left
!Right::send {End} ; Alt-right
+!Left::send +{Home} ; Alt-Shift-left
+!Right::send +{End} ; Alt-Shift-right

!^Left::SnapShrinkLeft()
!^Right::SnapShrinkRight()
!^Up::FullScreen()
!^Down::Minimize()
!^R::DisableTouch()
!^T::EnableTouch()

EnableTouch() {
	MsgBox, Enabling Touch Screen in 3 seconds...
	RunWait, DevManView.exe /enable "HID-compliant touch screen", C:\Program Files\DevManView
}
DisableTouch() {
	MsgBox, Enabling Redwood Mode in 3 seconds...
	RunWait, DevManView.exe /disable "HID-compliant touch screen", C:\Program Files\DevManView
}
_GetNextShrinkWidth(WinWidth, WorkAreaWidth) {
	if (WinWidth > WorkAreaWidth * 0.65) {
		Scale = 0.65
	} else if (WinWidth > WorkAreaWidth * 0.5) {
		Scale = 0.5
	} else if (WinWidth > WorkAreaWidth * 0.35) {
		Scale = 0.35
	} else {
		Scale = 0.9
	}

	return Scale
}	
SnapShrinkLeft() {
	SysGet, WorkArea, MonitorWorkArea
	SysGet, WinXBorder, 32
	SysGet, WinYBorder, 33
	WinGetPos, WinX, WinY, WinWidth, WinHeight, A
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop 

	if (WinX + WinXBorder <> WorkAreaLeft) {
		Scale = 0.9
	} else {
		Scale := _GetNextShrinkWidth(WinWidth - 2*WinXBorder, WorkAreaWidth)
	}
	ToWidth := WorkAreaWidth*Scale + 2*WinXBorder
	;MsgBox, %WinWidth% %WorkAreaWidth% %ToWidth%
	WinMove, A,, WorkAreaLeft - WinXBorder, 0, ToWidth, WorkAreaHeight + WinYBorder
}
SnapShrinkRight() {
	SysGet, WorkArea, MonitorWorkArea
	SysGet, WinXBorder, 32
	SysGet, WinYBorder, 33
	WinGetPos, WinX, WinY, WinWidth, WinHeight, A
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop
	WinRight := WinX + WinWidth

	if (WinRight < WorkAreaRight - 1) {
		Scale = 0.9
	} else {
		Scale := _GetNextShrinkWidth(WinWidth - 2*WinXBorder, WorkAreaWidth)
	}
	ToX := WorkAreaRight - WorkAreaWidth*Scale - WinXBorder
	ToWidth := WorkAreaWidth*Scale + 2*WinXBorder
	WinMove, A,, ToX, 0, ToWidth, WorkAreaHeight + WinYBorder
}

FullScreen() {
	SysGet, WorkArea, MonitorWorkArea
	SysGet, WinXBorder, 32
	SysGet, WinYBorder, 33
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft + 2*WinXBorder
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop + WinYBorder
	WinMove, A,, WorkAreaLeft - WinXBorder, WorkAreaTop, WorkAreaWidth, WorkAreaHeight
}
Minimize() {
	WinMinimize, A
}
