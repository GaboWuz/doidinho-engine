function onCreate()
makeAnimatedLuaSprite('dedbg', 'ded/deadfool', 0, 0)
addAnimationByPrefix('dedbg', 'eh', 'eh', 24, false)
addAnimationByPrefix('dedbg', 'idle', 'ded', 24, false)
setObjectCamera('dedbg', 'camHUD')
scaleObject('dedbg', 1, 0.62);
screenCenter('dedbg', 'xy')
addLuaSprite('dedbg', false)

makeAnimatedLuaSprite('static', 'ded/gaboisded', -30, 0)
addAnimationByPrefix('static', 'eh', 'eh', 24, false)
addAnimationByPrefix('static', 'idle', 'ded', 24, false)
setObjectCamera('static', 'camHUD')
screenCenter('static', 'y')
addLuaSprite('static', false)

setProperty('static.alpha', 0)
end

function onStepHit()
if curStep == 1 then
playAnim('dedbg', 'idle')
playAnim('static', 'idle')
end
if curStep == 8 then
doTweenAlpha('eh', 'static', 1, 0.3, 'expoOut') 
end
if curStep == 25 then 
doTweenAlpha('eh', 'static', 0, 0.27, 'expoIn') 
end
end	