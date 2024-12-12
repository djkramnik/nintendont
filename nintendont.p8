pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
inity=96
nx=16
ny=inity
leftie=false
jumping=false
jtick=0
jdiv=8
jbtn=false
jrelease=true
vdisp=0
initv=15
v=0
g=9
btntick=0
btnrls=false
-- horizontal speed saga
hv=0
speed=0
running=false
maxrun=2.5
maxwalk=1.2
slowdown=false
maxspeed=0
spover=-1
ass="???"
fallmax=4
log=false
ydelta=0
bumphead=false
-- goomba saga
gx=96
gy=96
ghv=0
gspeed=0
maxgspeed=0.5
gleftie=false


function _update()
  local t=0
  local powa=0
  local xdelta = 0
  local nxtvdisp = 0
  local ogdisp = vdisp
  
  ydelta = 0
  
  -- ass is used for jump and is more strict
  ass=touchgrass(nx,ny)
  -- extract out hv manip?  negative if leftie? if/elseif/else block at beginning?
  if (btn(0)) then
    leftie=true
    --nx-=1
    if (running and not jumping) then
     hv=-0.15
    else
     hv=-0.1
    end
   end

   if (btn(1)) then
    --nx+=1
    leftie=false
    if(running and not jumping) then
     hv=0.15
    else
     hv=0.1
    end
  end

  if (not btn(0) and not btn(1)) then
    if (speed > 0) then
      hv=-0.05
    elseif (speed < 0) then
      hv=0.05
    else
      hv=0
    end
  end
  if (btn(4)) then
    jbtn=true
  else
    jbtn=false
    jrelease=touchgrass(nx,ny)
  end
  
  if (btn(5)) then
   running = true
  else
   running=false
  end
  
  powa=abs(speed)
  
  slowdown = powa <= maxrun 
  and powa > maxwalk 
  and not running
  
  if(not jumping) then
   local jtest=bejump(false,jbtn,ass,jrelease)
  
  if (jtest) then
    if (jbtn) then
     initv = running and 18 or 15
    else
     initv = 0
    end
  end  
  end
  -- i no this is fucked but i need this
  jumping= 
  bejump(jumping,jbtn,ass,jrelease)
  
  if(jumping) then
    jrelease = not jbtn
    v=initv
    jtick+=1
    t=(jtick/jdiv)
    if (jbtn and not btnrls and jtick<10) then
     btntick+=0.5
    else
     btnrls=true
    end
    v=initv+(btntick)
    nxtvdisp = ydiff(v,t,g)
    ydelta=nxtvdisp - vdisp
    ydelta=min(
    max(ydelta,fallmax*-1),
    fallmax)
    
    vdisp=nxtvdisp
    
    if(ydelta>0) then
      if(bumph(nx,ny - ydelta)) then
       bumphead=true
       initv=0
       btnrls=true
      end
    end
    -- if on the way up (+vdisp?)
    -- and bumph then
    -- set bump head flag
    -- set initv to 0
    -- where ny is updated use bump head flag
    
  else
    v=0
    jtick=0
    vdisp=0
    btntick=0
    btnrls=false
  end
  
  if (slowdown) then
   maxspeed=powa
   --decrease our actual speed until we at max walk speed again
     if (speed > 0) then
      hv=-0.05
     else
      hv=0.05
     end
  elseif (running) then
   maxspeed=maxrun
  else
   maxspeed=maxwalk
  end
  
  speed = max(min(speed+hv
  ,maxspeed),maxspeed*-1)
  
  if (abs(speed) < 0.1) then
   speed=0
  end
  
  leftbump = bumpl(nx,ny)
  
  if (jumping) then
   xdelta=(speed/1.1)
  else
   xdelta=speed
  end 
  
  ny -= ydelta
  nx += xdelta
  
  if (bumphead) then
   ny = nearestprevmultiple(ceil(ny))
   bumphead=false
  end
  
  
  leftbump = bumpl(nx,ny)
  rightbump = bumpr(nx,ny)

  if(leftbump) then
   if (leftie) then
    nx = nearestprevmultiple(
    flr(nx)
    )
   end
   speed=0
  elseif(rightbump) then
   if (not leftie) then
    nx = nearestmultiple(ceil(nx))
   end
   speed=0
  end
  
  if(touchgrass(nx,ny)) then
   log=true
   ny = nearestmultiple(flr(ny))  
  end
  
  if (ny > 128 or ny < 0) then
   ny = 0
  end
  if (nx > 128) then
   nx = 0
  elseif (nx < 0) then
   nx = 128
  end
  
  -- goomba horizontal movement
    
  if(gleftie) then
   ghv=-0.1
  else
   ghv=0.1
  end
  gspeed = max(min(gspeed+ghv
  ,maxgspeed),maxgspeed*-1)
  
  --gx+=gspeed
  
  if (gx > 128) then
   gx = 0
  elseif (gx < 0) then
   gx=128
  end
  
  leftgbump = bumpl(gx,gy)
  rightgbump = bumpr(gx,gy)
  
  if(leftgbump) then
   if (gleftie) then
    gx = nearestprevmultiple(
    flr(gx)
    )
   end
   gleftie=false
   gspeed = gspeed * -1
  elseif(rightgbump) then
   if (not gleftie) then
    gx = nearestmultiple(
    ceil(gx))
   end
   gleftie=true
   gspeed = gspeed * -1
  end

  
end

function _draw()
 cls()
 spr(3,nx,ny,1,1,leftie)
 spr(4,gx,gy)
 map()
 print(gspeed)
 print(gx)
 --print(jumping)
 --print(ass)
 --print(ny)
 --print("wtf"..tostr(mget(7,10)))
 --print(vdisp)
 --print(running)
 --print(jumping)
 --print("speed: "..tostr(speed))
 --print("maxspeed: "..tostr(maxspeed))
 --print("slowdown?: "..tostr(slowdown))
 --print(inity)
 --print(ny-vdisp)
end

-->8

-- so we have touched grass big deal
-- are we touching from the top

function nearestmultiple(n)
  if (n % 8 == 0) then
    return n
  else
    return nearestmultiple(n-1)
  end
end

--dont ask
function nearestprevmultiple(n)
if (n % 8 == 0) then
  return n
else
  return nearestprevmultiple(n+1)
end
end



function bejump(
prev,jbtn,ass,jr)
  return not ass or 
  (jbtn and (not prev) and jr)
end

function ydiff(v,t,g)
 return (v*t) - (0.5*g*t*t)
end


function bumph(x,y)
 lx = x+1
 rx = x+7
 cxl = flr(lx/8)
 cxr = flr(rx/8)
 cy = flr(y/8)
 
 lt = mget(cxl,cy) == 2
 rt = mget(cxr,cy) == 2
 
 return lt or rt
end

function bumpr(x,y)
  rx= x+8
  ry = y+4
  cxr = flr(rx/8)
  cyr = flr(ry/8)
  
  return mget(cxr,cyr)==2
end
--need to flr these?
function bumpl(x,y)
// round x and y to nearest 
  lx = x
  ly = y+4

  cxl = flr(lx/8)
  cyl = flr(ly/8)
 
  return mget(cxl,cyl)==2
end

function touchgrass(x,y)
  lx = x+1
  ly = y+8
  rx = x+7
  ry = y+8
  
  cxl = flr(lx/8)
  cyl = flr(ly/8)
  cxr = flr(rx/8)
  cyr = flr(ry/8)
  
  lt = mget(cxl,cyl) == 2
  rt = mget(cxr,cyr) == 2
  
  return lt or rt
end

function squish(incr,cx,cy)
--4,6,7,8,9,10

local sframes = {4, 6, 7, 8, 9, 10}
local index = flr(incr/5)

if (index > 5) then
 mset(cx,cy,63)
 return -1
end

return sframes[index]

end
__gfx__
00000000aa8888aabbbbbbbbbbbbbbbb000000001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a882228abbbbbbbbbbbbbbbb000000001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700a8e2e28a44444444bbbbbbbb004444001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aae222aa44444444bbb0bb0b044444401111111104444440004444000000000000000000000000000000000000000000000000000000000000000000
00077000aaeee2aa44444444bbbbbbbb44ffff441111111144444444044444400444444000000000000000000000000000000000000000000000000000000000
00700700a8e2e28a44444444bb0bbbb00f0ff0f0111111110f0ff0f0444444444444444400000000000000000000000000000000000000000000000000000000
00000000a8eee88a44444444bbb0000b0dffffd0111111110dffffd00dffffd04444444444444444000000000000000000000000000000000000000000000000
00000000aa8888aa44444444bbbbbbbbddd00ddd11111111ddd00dddddd00dddddd00ddd4d4444d4444444440000000000000000000000000000000000000000
__map__
3030303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3002300000300000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000300000020000303002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202023030020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
