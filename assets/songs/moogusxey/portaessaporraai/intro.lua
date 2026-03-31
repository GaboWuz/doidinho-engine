--This script was created by Nes, AlexZocktGaming and Meow Christodoulos
function onCreate()
     makeLuaSprite('box', '', -740, 190)
	makeGraphic('box', 540, 140, 'ffffff')
	setProperty('box.alpha', 0.5)
	--scaleObject('box', 0.5)
	setObjectCamera('box', 'other')
	addLuaSprite('box', true)

    makeLuaText('songname', songName,1000, getProperty('box.x') + 70, getProperty('box.y') + 15)
	setTextAlignment('songname', 'left')
	setObjectCamera('songname', 'other')
	setTextSize('songname', 30)
	addLuaText('songname', true)

	makeLuaText('composer', 'Composer: GaboWuz, GabkXey', 1000, getProperty('box.x') + 70, getProperty('box.y') + 50)
	setTextAlignment('composer', 'left')
	setObjectCamera('composer', 'other')
	setTextSize('composer', 30)
	addLuaText('composer', true)

    end

    function onUpdate()
     setProperty('songname.x', getProperty('box.x') + 70)
     setProperty('chart.x', getProperty('box.x') + 70)
     setProperty('composer.x', getProperty('box.x') + 70)
    end
    
    function onSongStart()
     doTweenAlpha('1ta', '1', 1, 0.2, '')
     doTweenAlpha('2ta', '2', 1, 0.2, '')
     doTweenAlpha('3ta', '3', 1, 0.2, '')
     doTweenAlpha('4ta', '4', 1, 0.2, '')
     doTweenAlpha('tta', 'songNameTxt', 1, 0.2, '')
     doTweenX('sidebarin', 'box', -50, 1.2, 'expoOut')
    end
    
    function onTweenCompleted(tag)
     if tag == 'sidebarin' then
         runTimer('tweentimer', 2.5)
     end
     if tag == 'sidebarout' then
         removeLuaText('composer')
         removeLuaText('chart')
         removeLuaText('songname')
         removeLuaSprite('box')
     end
 end
 
 function onTimerCompleted(tag)
     if tag == 'tweentimer' then
         doTweenX('songtweenout','box', -740, 0.8,'expoIn')
     end
 end
 
 function onBeatHit()
if curBeat == 20 then
removeLuaText('composer')
removeLuaText('chart')
removeLuaText('songname')
removeLuaSprite('box')
 end
 end