--
-- Project:  patternDots
-- Description: 
--by: Olivia Chang
-- Version: 1.0


-- Copyright 2013 . All Rights Reserved.

--To do
-- update  tutorialText to different words
--fix all the vast horrible moo bugs a.ka. IMPOSSIBLE
--add paused

-- housekeeping stuff

display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX
local centerY = display.contentCenterY

--music and audio
local GGMusic = require( "GGMusic" )
local music = GGMusic:new()
music:add( "track1.mp3" )
music:add("track2.mp3")
music:setVolume( 0.3)
music:play()
-- preload audio
ding = audio.loadSound("ding.wav")
successSound = audio.loadSound("success.wav")
failSound = audio.loadSound("fail.wav")
audio.setVolume(0.6)
-- set up forward references
--functions
local userDotCopy
--variables
local score
local scoreText
local pauseButton
local pause
local timeText

--run variables
local isRunning = false
local didRun1 = false
local didRun2 = false
local didRun3 = false
local didRun4 = false

local ttTime = 400
--dot glow functions -- make this a for loop eventually
local function glow1Remove(obj)
    --    if paused == false then
    audio.play(ding)
    transition.to(obj, {time = ttTime, alpha = 1, onComplete = findPatternDot2 })
    --    end
end

local function glow2Remove(obj)
    audio.play(ding)
    transition.to(obj, {time = ttTime, alpha = 1, onComplete = findPatternDot3 })
    --    end
end

local function glow3Remove(obj)
    --    if paused == false then
    audio.play(ding)
    transition.to(obj, {time = ttTime, alpha = 1, onComplete = findPatternDot4 })
    --    end
end

local function glow4Remove(obj)
    --    if paused == false then
    audio.play(ding)
    transition.to(obj, {time = ttTime, alpha = 1, onComplete = userDotCopy })
    --    end
end

-- game functions
local function gameLostMenu()
    isRunning = false
    endGameNil()
    --create scoretext
    local scoreText1 = display.newText("score:", 0, 0, "Quicksand", 50)
    local scoreText2 = display.newText(score, 0, 0, "Quicksand", 50)
    scoreText1.x, scoreText1.y = display.contentWidth - 160, display.contentHeight - 375
    scoreText2.x, scoreText2.y = display.contentWidth - 160, display.contentHeight - 320
    scoreText1.alpha, scoreText2.alpha = 0
    scoreText1:setTextColor( 0, 0, 0)
    scoreText2:setTextColor( 0, 0, 0)
    --create button to play again
    local playAgainButton = display.newImage("playAgain.png")
    playAgainButton.alpha = 0
    playAgainButton.x, playAgainButton.y = display.contentWidth - 160, display.contentHeight - 200
    --create button to go back to menu
    local menuButton = display.newImage("menuButton.png")
    menuButton.alpha = 0
    menuButton.x, menuButton.y = display.contentWidth - 160, display.contentHeight - 100
    --transition.to alpha to 1
    transition.to(playAgainButton, {alpha = 1})
    transition.to(menuButton, {alpha = 1})
    --    if paused == false then
    audio.play(ding)
    transition.to(scoreText1, {alpha = 1})
    transition.to(scoreText2, {alpha = 1})
    --functions 
    local function disappearPlay()
        transition.to(playAgainButton, {alpha = 0})
        transition.to(menuButton, {alpha = 0})
        transition.to(scoreText1, {alpha = 0})
        transition.to(scoreText2, {alpha = 0, onComplete = setUpGame})
    end
    
    local function disappearMenu()
        transition.to(playAgainButton, {alpha = 0})
        transition.to(menuButton, {alpha = 0})
        transition.to(scoreText1, {alpha = 0})
        transition.to(scoreText2, {alpha = 0, onComplete = createPlayScreen})
    end
    --add event listeners "tap" to buttons so they can do what they are supposed to do
    playAgainButton:addEventListener("tap", disappearPlay)
    menuButton:addEventListener("tap", disappearMenu)
end

local function lostLife()
    audio.play(failSound)
    numLife = numLife - 1
    if numLife == 2  then
        transition.to(life3, {time = 250, alpha = 0})
        timer.performWithDelay(1000, compDotSelect)
    elseif numLife == 1 then
        transition.to(life2, {time = 250, alpha = 0})
        timer.performWithDelay(1000, compDotSelect)
    elseif numLife == 0 then
        transition.to(life1, {time = 250, alpha = 0})
        timer.cancel(timerHandler)
        gameLostMenu()
    else
        print("lost life if then else didn't work.")
    end
    print("user lost a life, lives: " .. numLife)
end

--function pauseScreen()
--    pauseButton:removeEventListener("tap", pauseScreen)
--    paused = true
--    timer.pause(timerHandler)
--    background.alpha = 0.9
--    local unPauseButton = display.newImage("unpauseButton.png")
--    unPauseButton.x, unPauseButton.y = centerX, centerY
--    local backToMenuButton = display.newImage("menuButton.png")
--    backToMenuButton.x, backToMenuButton.y = centerX, centerY - 200
--    local function resumeScreen()
--        background.alpha = 1
--        timer.resume(timerHandler)
--        paused = false
--        unPauseButton:removeEventListener("tap", resumeScreen)
--        transition.to(unPauseButton, {time = 250, alpha = 0})
--        transition.to(backToMenuButton, {time = 250, alpha = 0})
--        unPauseButton = nil
--        backToMenuButton = nil
--    end
--    local function backToMenu()
--        createPlayScreen()
--        unPauseButton = nil
--        backToMenuButton = nil
--    end
--    unPauseButton:addEventListener("tap", resumeScreen)
--    backToMenuButton:addEventListener("tap", backToMenu)
--end

--5. Check if user copied right


local function checkIfScore()
    if userSelectCorrect1 == true and userSelectCorrect2 == true and userSelectCorrect3 == true and userSelectCorrect4 == true and timeUsed == false then
        score = score + 1
        scoreText.text = score
        audio.play(successSound)
        timer.performWithDelay(1000, compDotSelect)
        else if timeUsed == true then
            lostLife()
        else 
            lostLife()
        end
    end
 if didRun1 == false then
       removeEventListener1()
   else if didRun2== false then
        removeEventListener2()
    else if didRun3 == false then
        removeEventListener3()
    end
    end
    end
end
    --4. User copies
    function userDotCopy()
        timeUsed = false
        local function timeCount()
            time = time -1
            timeText.text = time
            if time == 0 then
                timeUsed = true
                checkIfScore()
            end
        end
        time = 10
        timeText.text = time
        timerHandler =  timer.performWithDelay(1000, timeCount, 10)
        selectLight.alpha = 1
        local function userDotCopy4()
            local function afterGlowRemove4() 
                didRun4 = true
                if userDot4 == patternDot4 then
                    userSelectCorrect4 = true    
                end
                print("4th dot: " .. tostring(userSelectCorrect4))
                if timeUsed == false then
                    checkIfScore()               
                end
            end
            
            local function onTouch4(event)
                userDot4 = event.target
                local function glowRemove4(obj)
                    transition.to(obj, {time = 200, alpha = 1, onComplete = afterGlowRemove4})
                end
                transition.to(event.target, {time = 150, alpha = 0.2, onComplete = glowRemove4})
                userSelectCorrect4 = false
                function removeEventListener4()
                    dot1:removeEventListener("touch", onTouch4)
                    dot2:removeEventListener("touch", onTouch4)
                    dot3:removeEventListener("touch", onTouch4)
                    dot4:removeEventListener("touch", onTouch4)
                    dot5:removeEventListener("touch", onTouch4)
                    dot6:removeEventListener("touch", onTouch4)
                    dot7:removeEventListener("touch", onTouch4)
                    dot8:removeEventListener("touch", onTouch4)
                    dot9:removeEventListener("touch", onTouch4)
                end
            end
            
            dot1:addEventListener("touch", onTouch4)
            dot2:addEventListener("touch", onTouch4)
            dot3:addEventListener("touch", onTouch4)
            dot4:addEventListener("touch", onTouch4)
            dot5:addEventListener("touch", onTouch4)
            dot6:addEventListener("touch", onTouch4)
            dot7:addEventListener("touch", onTouch4)
            dot8:addEventListener("touch", onTouch4)
            dot9:addEventListener("touch", onTouch4)
        end
        
        local function userDotCopy3()
            local function afterGlowRemove3() 
                didRun3 = true
                audio.play(ding)
                if userDot3 == patternDot3 then
                    userSelectCorrect3 = true 
                end
                print("3rd dot: " .. tostring(userSelectCorrect3))
                userDotCopy4()
                
            end
            
            local function onTouch3(event)
                userDot3 = event.target
                local function glowRemove3(obj)
                    transition.to(obj, {time = 200, alpha = 1, onComplete = afterGlowRemove3})
                end
                transition.to(event.target, {time = 150, alpha = 0.2, onComplete = glowRemove3})
                userSelectCorrect3 = false
                function removeEventListener3()
                    dot1:removeEventListener("touch", onTouch3)
                    dot2:removeEventListener("touch", onTouch3)
                    dot3:removeEventListener("touch", onTouch3)
                    dot4:removeEventListener("touch", onTouch3)
                    dot5:removeEventListener("touch", onTouch3)
                    dot6:removeEventListener("touch", onTouch3)
                    dot7:removeEventListener("touch", onTouch3)
                    dot8:removeEventListener("touch", onTouch3)
                    dot9:removeEventListener("touch", onTouch3)
                end
            end
            
            dot1:addEventListener("touch", onTouch3)
            dot2:addEventListener("touch", onTouch3)
            dot3:addEventListener("touch", onTouch3)
            dot4:addEventListener("touch", onTouch3)
            dot5:addEventListener("touch", onTouch3)
            dot6:addEventListener("touch", onTouch3)
            dot7:addEventListener("touch", onTouch3)
            dot8:addEventListener("touch", onTouch3)
            dot9:addEventListener("touch", onTouch3)
        end
        
        local function userDotCopy2()
            local function afterGlowRemove2()
                didRun2 = true
                audio.play(ding)
                if userDot2 == patternDot2 then
                    userSelectCorrect2 = true 
                    
                end
                print("2nd dot: " .. tostring(userSelectCorrect2))
                
                --next userdotcopy
                userDotCopy3()
            end
            
            local function onTouch2(event)
                userDot2 = event.target
                local function glowRemove2(obj)
                    transition.to(obj, {time = 200, alpha = 1, onComplete = afterGlowRemove2})
                end
                transition.to(event.target, {time = 150, alpha = 0.2, onComplete = glowRemove2})
                userSelectCorrect2 = false
                function removeEventListener2()
                    dot1:removeEventListener("touch", onTouch2)
                    dot2:removeEventListener("touch", onTouch2)
                    dot3:removeEventListener("touch", onTouch2)
                    dot4:removeEventListener("touch", onTouch2)
                    dot5:removeEventListener("touch", onTouch2)
                    dot6:removeEventListener("touch", onTouch2)
                    dot7:removeEventListener("touch", onTouch2)
                    dot8:removeEventListener("touch", onTouch2)
                    dot9:removeEventListener("touch", onTouch2)
                end
                removeEventListener2()
            end
            
            dot1:addEventListener("touch", onTouch2)
            dot2:addEventListener("touch", onTouch2)
            dot3:addEventListener("touch", onTouch2)
            dot4:addEventListener("touch", onTouch2)
            dot5:addEventListener("touch", onTouch2)
            dot6:addEventListener("touch", onTouch2)
            dot7:addEventListener("touch", onTouch2)
            dot8:addEventListener("touch", onTouch2)
            dot9:addEventListener("touch", onTouch2)
        end
        
        local function userDotCopy1()
            local function afterGlowRemove1() 
                didRun1 = true
                audio.play(ding)
                if userDot1 == patternDot1 then
                    userSelectCorrect1 = true 
                end
                print("1st dot: " .. tostring(userSelectCorrect1))
                
                userDotCopy2()
            end
            
            local function onTouch(event)
                userDot1 = event.target
                local function glowRemove1(obj)
                    transition.to(obj, {time = 200, alpha = 1, onComplete = afterGlowRemove1})
                end
                transition.to(event.target, {time = 150, alpha = 0.2, onComplete = glowRemove1})
                userSelectCorrect1 = false
                function removeEventListener1()
                    dot1:removeEventListener("touch", onTouch)
                    dot2:removeEventListener("touch", onTouch)
                    dot3:removeEventListener("touch", onTouch)
                    dot4:removeEventListener("touch", onTouch)
                    dot5:removeEventListener("touch", onTouch)
                    dot6:removeEventListener("touch", onTouch)
                    dot7:removeEventListener("touch", onTouch)
                    dot8:removeEventListener("touch", onTouch)
                    dot9:removeEventListener("touch", onTouch)
                end
                removeEventListener1()
            end
            dot1:addEventListener("touch", onTouch)
            dot2:addEventListener("touch", onTouch)
            dot3:addEventListener("touch", onTouch)
            dot4:addEventListener("touch", onTouch)
            dot5:addEventListener("touch", onTouch)
            dot6:addEventListener("touch", onTouch)
            dot7:addEventListener("touch", onTouch)
            dot8:addEventListener("touch", onTouch)
            dot9:addEventListener("touch", onTouch)
        end
        --start functions
        userDotCopy1()
    end
    
    --3. Computer selects 
    function compDotSelect()
        if isRunning == true then
            selectLight.alpha = 0.2
            timeText.text = "10"
            time = 10
        end
        function findPatternDot4()
            --find random dot
            patternDot4 = math.random(9)
            print("pattern dot 4 is " .. patternDot4)
            if patternDot4 == 1 then
                transition.to(dot1, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot1
            elseif patternDot4 == 2 then
                transition.to(dot2, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot2
            elseif patternDot4 == 3 then
                transition.to(dot3, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot3
            elseif patternDot4 == 4 then
                transition.to(dot4, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot4
            elseif patternDot4 == 5 then
                transition.to(dot5, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot5
            elseif patternDot4== 6 then
                transition.to(dot6, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot6
            elseif patternDot4 == 7 then
                transition.to(dot7, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot7
            elseif patternDot4 == 8 then
                transition.to(dot8, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot8
            elseif patternDot4 == 9 then
                transition.to(dot9, {time = ttTime, alpha = 0.2, onComplete = glow4Remove})
                patternDot4 = dot9	
            else
                print("ERROR: Something went wrong with the patterndot4. Didn't work. ")
            end	
        end
        --3. same as findPatternDot1 except it finds 3
        function findPatternDot3()
            --find random dot
            
            patternDot3 = math.random(9)
            
            print("pattern dot 3 is " .. patternDot3)
            if patternDot3 == 1 then
                transition.to(dot1, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot1
            elseif patternDot3 == 2 then
                transition.to(dot2, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot2
            elseif patternDot3 == 3 then
                transition.to(dot3, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot3
            elseif patternDot3 == 4 then
                transition.to(dot4, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot4
            elseif patternDot3 == 5 then
                transition.to(dot5, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot5
            elseif patternDot3== 6 then
                transition.to(dot6, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot6
            elseif patternDot3 == 7 then
                transition.to(dot7, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot7
            elseif patternDot3 == 8 then
                transition.to(dot8, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot8
            elseif patternDot3 == 9 then
                transition.to(dot9, {time = ttTime, alpha = 0.2, onComplete = glow3Remove})
                patternDot3 = dot9	
            else
                print("ERROR: Something went wrong with the patterndot3. Didn't work. ")
            end	
        end
        --2. Find the second dot in the pattern
        function findPatternDot2()
            patternDot2 = math.random(9)
            print("pattern dot 2 is" ..  patternDot2) --> print which dot patternDot2 is
            if patternDot2 == 1 then
                transition.to(dot1, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot1
            elseif patternDot2 == 2 then
                transition.to(dot2, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot2
            elseif patternDot2 == 3 then
                transition.to(dot3, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot3
            elseif patternDot2 == 4 then
                transition.to(dot4, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot4
            elseif patternDot2 == 5 then
                transition.to(dot5, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot5
            elseif patternDot2== 6 then
                transition.to(dot6, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot6
            elseif patternDot2 == 7 then
                transition.to(dot7, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot7
            elseif patternDot2 == 8 then
                transition.to(dot8, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})
                patternDot2 = dot8
            elseif patternDot2 == 9 then
                transition.to(dot9, {time = ttTime, alpha = 0.2, onComplete = glow2Remove})	
                patternDot2 = dot9
            else
                print("ERROR: Something went wrong with the patterndot2. Didn't work. ")
            end	
            
        end
        --1. find the first dot in the pattern
        function findPatternDot1()
            --find random dot
            math.randomseed(os.time())
            patternDot1 = math.random(9)
            
            print ("pattern dot 1 is " .. patternDot1) --> print which dot patternDot1 is
            --find out which dot patternDot1 is and then blink that dot
            if patternDot1 == 1 then
                transition.to(dot1, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot1
            elseif patternDot1 == 2 then
                transition.to(dot2, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot2
            elseif patternDot1 == 3 then 
                transition.to(dot3, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot3
            elseif patternDot1 == 4 then
                transition.to(dot4, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot4
            elseif patternDot1 == 5 then
                transition.to(dot5, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot5
            elseif patternDot1== 6 then
                transition.to(dot6, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot6
            elseif patternDot1 == 7 then
                transition.to(dot7, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot7
            elseif patternDot1 == 8 then
                transition.to(dot8, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot8
            elseif patternDot1 == 9 then
                transition.to(dot9, {time = ttTime, alpha = 0.2, onComplete = glow1Remove})
                patternDot1 = dot9	
            else
                print("ERROR: Something went wrong with the patterndot1. Didn't work. ")
            end	
            
        end
        --start finding
        if isRunning == true then
            findPatternDot1()
        end
    end
    
    
    --2a. Set Up Game
    function setUpGame()
        isRunning = true
        --create all the dots		 
        --Dot order:
        --1   2   3
        --4   5   6
        --7   8   9
        --Dot color order : roygbpbsg 
        dot1 = display.newImage("red.png")
        dot2 = display.newImage("red.png")
        dot3 = display.newImage("red.png")
        dot4 = display.newImage("red.png")
        dot5 = display.newImage("red.png")
        dot6 = display.newImage("red.png")
        dot7 = display.newImage("red.png")
        dot8 = display.newImage("red.png")
        dot9 = display.newImage("red.png")
        --set top row dots (x, y) coordinates
        dot1.x, dot1.y  = display.contentWidth - 280, display.contentHeight - 375
        dot2.x, dot2.y = display.contentWidth - 160, display.contentHeight - 375
        dot3.x, dot3.y  = display. contentWidth - 40, display.contentHeight - 375
        --set middle row dots (x, y) coordinates
        dot4.x, dot4.y  = display.contentWidth - 280, display.contentHeight - 250
        dot5.x, dot5.y = display.contentWidth - 160, display.contentHeight - 250
        dot6.x, dot6.y  = display. contentWidth - 40, display.contentHeight - 250
        --set bottom row dots (x,y) coordinates
        dot7.x, dot7.y  = display.contentWidth - 280, display.contentHeight - 125
        dot8.x, dot8.y = display.contentWidth - 160, display.contentHeight - 125
        dot9.x, dot9.y  = display. contentWidth - 40, display.contentHeight - 125
        
        --threeboxes
        threeboxes = display.newImage("threeboxes.png")
        threeboxes.x, threeboxes.y = display.contentWidth - 160, display.contentHeight - 460
        --create the three lives dots and the text "lives:"
        --Lives order:
        --Lives: 1 2 3
        numLife = 3
        life1 = display.newImage("redLife.png")
        life2 = display.newImage("redLife.png")
        life3 = display.newImage("redLife.png")
        life1.x, life1.y = display.contentWidth - 290, display.contentHeight - 455
        life2.x, life2.y = display.contentWidth - 260, display.contentHeight - 455
        life3.x, life3.y = display.contentWidth - 230, display.contentHeight - 455
        
        --create score text and set x, y coordiantes
        score = 0
        scoreText = display.newText(score, 0, 0, "Quicksand", 20)
        scoreText.x, scoreText.y = display.contentWidth - 60, display.contentHeight - 455
        scoreText:setTextColor(0, 0, 0)
        --create the time thing:
        
        timeText = display.newText("10" , 0, 0, "Quicksand", 20)
        timeText.x, timeText.y = display.contentWidth - 160, display.contentHeight - 455
        timeText:setTextColor(0, 0, 0)
        --create the light that shows whether the computer or the user selects
        selectLight = display.newImage("compLight.png")
        selectLight.x, selectLight.y = display.contentWidth - 160, display.contentHeight - 40
        
        function endGameNil()
            --dots alpha is 0
            dot1.alpha, dot2.alpha, dot3.alpha, dot4.alpha, dot5.alpha, dot6.alpha, dot7.alpha, dot8.alpha, dot9.alpha = 0
            --other stuff alpha is 0
            life1.alpha, life2.alpha, life3.alpha, threeboxes.alpha, scoreText.alpha, timeText.alpha, selectLight.alpha = 0
            --make stuff nil
            dot1, dot2, dot3, dot4, dot5, dot6, dot7, dot8, dot9 = nil
            life1, life2, life3, threeboxes, scoreText, timeText, selectLight = nil
        end
        --    --create the pause button
        --    pauseButton = display.newImage("pauseButton.png")
        --    pauseButton.x, pauseButton.y = display.contentWidth - 125, display.contentHeight - 900
        --    paused = false
        --    pauseButton:addEventListener("tap", pauseScreen)
        --go to the next step and start the game
        compDotSelect()
    end
    
    -- 1. Show then Hide Menu 
    function createPlayScreen()
        --2c. Show or hide credits text
        local function showCreditsText()
            local function hideCreditsText()
                transition.to(creditsText, {time = 500, alpha = 0})
                transition.to(creditsMenuButton, {time = 500, alpha = 0})
                creditsMenuButton:removeEventListener("tap", hideCreditsText)
                creditsText = nil
                createPlayScreen()
            end
            creditsMenuButton = display.newImage("menubutton.png")
            creditsMenuButton.alpha = 0
            creditsMenuButton.x, creditsMenuButton.y = display.contentWidth - 260, display.contentHeight - 450
            local creditsText = display.newImage("creditsText.png")
            creditsText.x, creditsText.y= centerX, centerY
            creditsText.alpha = 0
            transition.to(creditsText, {time = 500, alpha = 1})
            transition.to(creditsMenuButton, {time = 500, alpha = 1})
            creditsMenuButton:addEventListener("tap", hideCreditsText)
        end
        
        --2b. Show or hide tutorial text
        local function showTutorialText()
            local function hideTutorialText()
                transition.to(helpText, {time = 500, alpha = 0})
                transition.to(menuButton, {time = 500, alpha = 0})
                menuButton:removeEventListener("tap", hideTutorialText)
                createPlayScreen()
            end
            menuButton = display.newImage("menubutton.png")
            menuButton.alpha = 0
            menuButton.x, menuButton.y = display.contentWidth - 260, display.contentHeight - 450
            local helpText = display.newImage("tutorialText.png")
            helpText.x, helpText.y= centerX, centerY
            helpText.alpha = 0
            transition.to(helpText, {time = 500, alpha = 1})
            transition.to(menuButton, {time = 500, alpha = 1})
            menuButton:addEventListener("tap", hideTutorialText)
        end
        
        --display background
        local background = display.newImage("background.png")
        background.x = centerX
        background.y = centerY
        
        --display game title
        local gameTitle = display.newImage("gametitle.png")
        gameTitle.x = centerX
        gameTitle.y = display.contentHeight - 500
        
        --display playbutton
        local playbutton  = display.newImage("playbutton.png")
        playbutton.x =  display.contentWidth - 260
        playbutton.y = display.contentHeight + 200
        
        --display helpbutton
        helpbutton  = display.newImage("helpbutton.png")
        helpbutton.x =  display.contentWidth - 160
        helpbutton.y = display.contentHeight + 200
        
        --display creditsbutton
        creditsbutton  = display.newImage("creditsbutton.png")
        creditsbutton.x =  display.contentWidth - 55
        creditsbutton.y = display.contentHeight  + 200
        
        --2c.go to creditsScene
        local function toCredits()
            transition.to(playbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(helpbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(creditsbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(gameTitle, {time = 600, x = display.contentHeight - 2000, onComplete = showCreditsText})
        end
        --2b.go to tutorial screen
        local function toTutorial()
            transition.to(playbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(helpbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(creditsbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(gameTitle, {time = 600, x = display.contentHeight - 2000, onComplete = showTutorialText})
        end
        
        --2a. disappear if prompted by playbutton
        local function toGame()
            transition.to(playbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(helpbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(creditsbutton, {time = 600, x = display.contentHeight - 2000})
            transition.to(gameTitle, {time = 600, x = display.contentHeight - 2000, onComplete = setUpGame})
            
            -- used onComplete to go to second step
        end
        
        --1. appear into screen
        transition.to(gameTitle,{time = 1000 , y = display.contentHeight - 400,})
        transition.to(playbutton, {time = 1000, y = display.contentHeight - 75,})
        transition.to(helpbutton, {time = 1000, y = display.contentHeight - 75,})
        transition.to(creditsbutton, {time = 1000, y = display.contentHeight - 75,})
        playbutton:addEventListener("tap", toGame)
        helpbutton:addEventListener("tap", toTutorial)
        creditsbutton:addEventListener("tap", toCredits)
        
    end
    
    --load the game
    createPlayScreen()

local monitorMem = function()

    collectgarbage()
    print( "MemUsage: " .. collectgarbage("count") )

    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    print( "TexMem:   " .. textMem )
end

Runtime:addEventListener( "enterFrame", monitorMem )
