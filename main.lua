-- Lunar Lander Clone
    displayMode(FULLSCREEN)
-- Use this function to perform your initial setup
function setup()
    ship = {x=WIDTH-300,y=HEIGHT,v=vec2(0,0),a=.06,maxS=vec2(5,5),fric=.2,fire=false,angle=0,landed=false,crash=false}
    img = image(WIDTH*3,HEIGHT*3)
    lineH = 0 -- height off ship fire
    left = false
    right = false
    up = false
    gravity = 0.03
    touch_ids={l=0,r=0,u=0} -- touch ida
    leftBTN = vec2(100,100)
    rightBTN = vec2(200,100)
    upBTN = vec2(WIDTH-100,100)
    turnS = 3
    -- build train 
    newGame()
    stars = image(img.width,img.height)
    for i=1,100 do
        setContext(stars)
        pushStyle()
        fill(255, 219, 0, 255)
        strokeWidth(0)
        ellipse(math.random(0,img.width),math.random(0,img.height),math.random(2,8))
        popStyle()
        
        setContext()
    end
end


function newGame()
--    pushStyle()
    train = image(img.width,img.height)
    cam = vec2((WIDTH/2)-ship.x,HEIGHT/2-ship.y)
    setContext(train)
    level = 1
    level_l = {100,50,20,-40,30,0}
    l = level_l[level] 
    lc = {{x=660-cam.x+300,xx=720-cam.x+300}}
    map = {}
    for i=1,img.width do 
        -- 
        local x,y = i,400+400*noise(i/(200+l))
        local xx,yy = i+1,400+400*noise((i+1)/(200+l))
        strokeWidth(3)
            line(x,y,xx,yy)
        map[x] = y
        --
    end
    stroke(255, 73, 0, 255)
    strokeWidth(5)
    line(lc[level].x,map[lc[level].x]+3,lc[level].xx,map[lc[level].xx]+3)
    strokeWidth(3)
    stroke(255, 255, 255, 255)
    setContext()
    cam = vec2(0,0)
    zoom = 1
    ship = {x=WIDTH-300,y=HEIGHT,v=vec2(0,0),a=.06,maxS=vec2(5,5),fric=.2,fire=false,angle=0,landed=false,crash=false}
  --  popStyle()
end
-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    pushMatrix()
    cam = vec2((WIDTH/2)-ship.x,HEIGHT/2-ship.y)
    if zoom ==1 then 
    translate(cam.x,cam.y) else translate(cam.x*zoom-WIDTH/2,cam.y*zoom-HEIGHT/2) end 
    scale(zoom)
   -- setContext(img)
    background(0, 0, 0, 255)
    sprite(stars,img.width/2,img.height/2)
    sprite(train,img.width/2,img.height/2)
    pushMatrix()
    --drawplayer
    pushStyle()
    pushMatrix()
        translate(ship.x,ship.y)
        rotate(ship.angle)
        strokeWidth(2)
        stroke(255, 255, 255, 255)
        line(-5,0,0,10)
        line(5,0,0,10)
    line(-5,0,5,0)
    local xx = math.random(-3,3)
    line(-3,0,0,-lineH)
    line(3,0,0,-lineH)
    
    if ship.crash==true then 
        sprite("Tyrian Remastered:Explosion Huge",0,0,50+math.random(-10,10),50+math.random(-10,10))
    end
    popMatrix()
    popStyle()
    -- ellipse(ship.x,map[math.floor(ship.x)],10)
        popMatrix()
    setContext()
    -- draw the scene
    sprite(img,WIDTH*1.5,HEIGHT*1.5)
    
    popMatrix()
    -- draw touch keys 
    pushStyle()
    fill(255, 255, 255, 255)
    --text("FPS: " ..math.floor(1/DeltaTime),50,HEIGHT-30)
    -- text("fs: " .. math.floor(ship.v.y*100),50,HEIGHT-60)
         fill(127, 127, 127, 40)
            strokeWidth(4)
    stroke(168, 115, 166, 255)
    ellipse(leftBTN.x,leftBTN.y,100)
    ellipse(rightBTN.x,rightBTN.y,100)
    ellipse(upBTN.x,upBTN.y,100)
    sprite("Tyrian Remastered:Flame 2",upBTN.x,upBTN.y,20,20)
    popStyle()
    -- movement 
    if ship.crash==false and ship.landed==false then
    if left == true then 
        ship.angle = ship.angle + turnS
    end
    if right == true then 
        ship.angle = ship.angle - turnS
    end
    if up then 
        if lineH<15 then 
            lineH = lineH + 1
            --sound(SOUND_EXPLODE, 40774)
            else 
            lineH = 15 + math.random(-5,5)
            --sound(SOUND_EXPLODE, 20740)
        end
        -- add velocity 
        ship.v.x = ship.v.x + ship.a * math.sin(math.rad(-ship.angle))
        ship.v.y = ship.v.y + ship.a * math.cos(math.rad(-ship.angle))
    end
    end
  
    -- limit velocity 
    if ship.v.y<-ship.maxS.y then 
        ship.v.y = -ship.maxS.y 
        elseif ship.v.y>ship.maxS.y then 
            ship.v.y = ship.maxS.y
    end
     if ship.v.x<-ship.maxS.x then 
        ship.v.x = -ship.maxS.x
        elseif ship.v.x>ship.maxS.x then 
            ship.v.x = ship.maxS.x
    end
   -- zoom camera
    if math.abs(ship.x-lc[level].x+20)<100 and math.abs(ship.y-map[lc[level].x]+3)<100 and zoom ==1 then 
        zoom = 2
    elseif zoom ==2 and math.abs(ship.x-lc[level].x+20)>100 and math.abs(ship.y-map[lc[level].x]+3)>100 then 
        zoom =1
    end
    -- land 
    if ship.x>lc[level].x and ship.x<lc[level].xx then 
        if ship.y<map[lc[level].x]+3 then 
            if ship.v.y>-1 and math.abs(ship.angle-0)<20 then 
                ship.landed = true
                ship.crash = false
                ship.y = map[lc[level].x]+3
                else 
                ship.crash = true
                ship.y = map[lc[level].x]+5
            end
        end
        else
        local yy,yyy,y = map[math.floor(ship.x)],map[math.floor(ship.x)+10],map[math.floor(ship.x-10)]
    if vec2(ship.x,ship.y):dist(vec2(ship.x,yy))<10 then 
        ship.crash = true
    end
    end
    
    -- landed and crash mood
    if ship.landed == true then 
        text("Lended ",WIDTH/2,HEIGHT-200)
         text("touch to play new game ",WIDTH/2,HEIGHT-300)
        if CurrentTouch.state==BEGAN and CurrentTouch.y>HEIGHT/2 then 
            
                ship = {x=WIDTH-300,y=HEIGHT,v=vec2(0,0),a=.06,maxS=vec2(5,5),fric=.2,fire=false,angle=0,landed=false,crash=false}
        end
    elseif ship.crash==true then 
        text("crashed ",WIDTH/2,HEIGHT-200)
 text("touch to play new game ",WIDTH/2,HEIGHT-300)
        if CurrentTouch.state==BEGAN and CurrentTouch.y>HEIGHT/2 then 
                ship = {x=WIDTH-300,y=HEIGHT,v=vec2(0,0),a=.06,maxS=vec2(5,5),fric=.2,fire=false,angle=0,landed=false,crash=false}
        end
        popStyle()
        else 
         ship.v.y = ship.v.y - gravity
         ship.x = ship.x + ship.v.x
         ship.y = ship.y + ship.v.y  
    end
    -- coll 
    
   
end

function touched(t)
  print(t.x)
    if t.state == BEGAN then 
        if vec2(t.x,t.y):dist(leftBTN)<100/2 then 
            left = true
            touch_ids.l = t.id
          --  print(1)
        end
          if vec2(t.x,t.y):dist(rightBTN)<100/2 then 
            right = true
            touch_ids.r = t.id
        end
          if vec2(t.x,t.y):dist(upBTN)<100/2 then 
            up = true
            touch_ids.u = t.id
        end
    end
    
     if t.state == ENDED then 
        if t.id == touch_ids.l then 
            left = false
            touch_ids.l = nil
            --right=false
        end
          if  t.id == touch_ids.r then 
            right = false
            --left=false
            touch_ids.r = nil
        end
          if t.id == touch_ids.u then 
            up = false
            touch_ids.u = nil
            lineH = 0
        end
    end
end
