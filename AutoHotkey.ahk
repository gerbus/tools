!Left::send {Home} ; Alt-left
!Right::send {End} ; Alt-right
+!Left::send +{Home} ; Alt-Shift-left
+!Right::send +{End} ; Alt-Shift-right

!^Left::SnapShrinkLeft()
!^Right::SnapShrinkRight()
!^Up::FullScreen()

SnapShrinkLeft() {
	SysGet, WorkArea, MonitorWorkArea
	WinGetPos, WinX, WinY, WinWidth, WinHeight, A
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop

	if (WinX <> WorkAreaLeft) {
		ToWidth := WorkAreaWidth * 0.9
	} else if (WinWidth > WorkAreaWidth * 0.8) {
		ToWidth := WorkAreaWidth * 0.8
	} else if (WinWidth > WorkAreaWidth * 0.6) {
		ToWidth := WorkAreaWidth * 0.6
	} else if (WinWidth > WorkAreaWidth * 0.5) {
		ToWidth := WorkAreaWidth * 0.5
	} else if (WinWidth > WorkAreaWidth * 0.3) {
		ToWidth := WorkAreaWidth * 0.3
	} else {
		ToWidth := WorkAreaWidth * 0.9
	}

	WinMove, A,, WorkAreaLeft, 0, ToWidth, WorkAreaHeight
}
SnapShrinkRight() {
	SysGet, WorkArea, MonitorWorkArea
	WinGetPos, WinX, WinY, WinWidth, WinHeight, A
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop
	WinRight := WinX + WinWidth

	if (WinRight < WorkAreaRight - 1) {
		ToX := WorkAreaRight - WorkAreaWidth * 0.9
		ToWidth := WorkAreaWidth * 0.9
	} else if (WinWidth > WorkAreaWidth * 0.8) {
		ToX := WorkAreaRight - WorkAreaWidth * 0.8
		ToWidth := WorkAreaWidth * 0.8
	} else if (WinWidth > WorkAreaWidth * 0.6) {
		ToX := WorkAreaRight - WorkAreaWidth * 0.6
		ToWidth := WorkAreaWidth * 0.6
	} else if (WinWidth > WorkAreaWidth * 0.5) {
		ToX := WorkAreaRight - WorkAreaWidth * 0.5
		ToWidth := WorkAreaWidth * 0.5
	} else if (WinWidth > WorkAreaWidth * 0.3) {
		ToX := WorkAreaRight - WorkAreaWidth * 0.3
		ToWidth := WorkAreaWidth * 0.3
	} else {
		ToX := WorkAreaRight - WorkAreaWidth * 0.9
		ToWidth := WorkAreaWidth * 0.9
	}

	WinMove, A,, ToX, 0, ToWidth, WorkAreaHeight
}

FullScreen() {
	SysGet, WorkArea, MonitorWorkArea
	WorkAreaWidth := WorkAreaRight - WorkAreaLeft
	WorkAreaHeight := WorkAreaBottom - WorkAreaTop
	WinMove, A,, WorkAreaLeft, WorkAreaTop, WorkAreaWidth, WorkAreaHeight
}
