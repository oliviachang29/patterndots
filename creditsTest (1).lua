--
-- Project: patterndots
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 
--2c.go to creditsScene
function toCredits()
	transition.to(playbutton, {time = 600, x = display.contentHeight - 2000})
	transition.to(helpbutton, {time = 600, x = display.contentHeight - 2000})
	transition.to(creditsbutton, {time = 600, x = display.contentHeight - 2000})
	transition.to(gameTitle, {time = 600, x = display.contentHeight - 2000, onComplete = showCreditsText})
end