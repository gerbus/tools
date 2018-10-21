!Left::send {Home} ; Alt-left
!Right::send {End} ; Alt-right
+!Left::send +{Home} ; Alt-Shift-left
+!Right::send +{End} ; Alt-Shift-right

!^Left::SnapShrinkLeft()
!^Right::SnapShrinkRight()
!^Up::WinMaximize, A
!^Down::WinMinimize, A
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

_GetNextShrink(WinWidth, WorkAreaWidth) {
	if (WinWidth - 1 > Ceil(WorkAreaWidth * 0.65)) {
		Scale = 0.65
	} else if (WinWidth - 1 > Ceil(WorkAreaWidth * 0.5)) {
		Scale = 0.5
	} else if (WinWidth - 1 > Ceil(WorkAreaWidth * 0.35)) {
		Scale = 0.35
	} else {
		Scale = 0.9
	}

	return Scale
}
SnapShrinkLeft() {
	CurrentMonitor := _GetCurrentMonitor()
	SysGet, WorkArea, MonitorWorkArea, %CurrentMonitor%
	SysGet, WinXBorder, 32
	SysGet, WinYBorder, 33
	WinGetPos, WinX, WinY, WinWidth, WinHeight, A
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop 
	WinGet, WinMinMax, MinMax, A

	if (WinX > WorkAreaLeft - WinXBorder) {
		Scale = 0.9
	} else {
		Scale := _GetNextShrink(WinWidth - 2*WinXBorder, WorkAreaWidth)
	}
	if (WinMinMax = 1) {
		WinRestore, A
		Scale = 0.9
	}

	ToWidth := Ceil(WorkAreaWidth*Scale) + 2*WinXBorder
	;MsgBox, %WinWidth% %WorkAreaWidth% %ToWidth%
	WinMove, A,, WorkAreaLeft - WinXBorder, WorkAreaTop, ToWidth, WorkAreaHeight + WinYBorder
}
SnapShrinkRight() {
	CurrentMonitor := _GetCurrentMonitor()
	SysGet, WorkArea, MonitorWorkArea, %CurrentMonitor%
	SysGet, WinXBorder, 32
	SysGet, WinYBorder, 33
	WinGetPos, WinX, WinY, WinWidth, WinHeight, A
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop
	WinRight := WinX + WinWidth
	WinGet, WinMinMax, MinMax, A
	
	;MsgBox %WinRight% %WorkAreaRight% %WinXBorder%
	if (WinRight < WorkAreaRight + WinXBorder - 2) {
		Scale = 0.9
	} else {
		Scale := _GetNextShrink(WinWidth - 2*WinXBorder, WorkAreaWidth)
	}
	if (WinMinMax = 1) {
		WinRestore, A
		Scale = 0.9
	}

	ToX := WorkAreaRight - Ceil(WorkAreaWidth*Scale) - WinXBorder
	ToWidth := Ceil(WorkAreaWidth*Scale) + 2*WinXBorder
	WinMove, A,, ToX, WorkAreaTop, ToWidth, WorkAreaHeight + WinYBorder
}

_GetCurrentMonitor() {
  	SysGet, numberOfMonitors, MonitorCount
  	WinGetPos, winX, winY, winWidth, winHeight, A
  	winMidX := winX + winWidth / 2
  	winMidY := winY + winHeight / 2
  	;MsgBox %numberOfMonitors%
  	Loop %numberOfMonitors% {
    	SysGet, monArea, MonitorWorkArea, %A_Index%
    	;MsgBox, %A_Index% %monAreaLeft% %winX%
    	if (winMidX > monAreaLeft && winMidX < monAreaRight && winMidY < monAreaBottom && winMidY > monAreaTop)
      		return A_Index ; starts with a 1, not 0
  	}
  	MsgBox, No Monitor Found
}
_GetNextMonitor() {
  	SysGet, numberOfMonitors, MonitorCount
  	ThisMonitor := _GetCurrentMonitor()
  	NextMonitor := ThisMonitor + 1
  	if (NextMonitor > numberOfMonitors) {
  		return 1
  	}
  	return NextMonitor
}
