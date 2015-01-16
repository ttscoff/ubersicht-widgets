tell application "Simplify"
	set _jacket to name of active jacket
	
	if _jacket is "Sidecar" or _jacket is "Sidecar13" then
		if active variation of jacket _jacket is "Absence of dark" then
			make active jacket _jacket with variation "Wallflower"
		else
			make active jacket _jacket with variation "Absence of dark"
		end if
		move jacket to {top:0.0, left:0.0}
		
	end if
end tell