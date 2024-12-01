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
vdisp=0
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

function _update()
  local t=0
  local maxspeed=0
  local powa=0

  -- extract out hv manip?  negative if leftie? if/elseif/else block at beginning?
  if (btn(0)) then
    leftie=true
    --nx-=1
    if (running and not jumping) then
     hv=-0.2
    else
     hv=-0.1
    end
   end

   if (btn(1)) then
    --nx+=1
    leftie=false
    if(running and not jumping) then
     hv=0.2
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
  end
  
  if (btn(5)) then
   running = true
  else
   running=false
  end
  
  powa=abs(speed)
  slowdown = powa < maxrun and powa > maxwalk and not running
  
  jumping=
  (jbtn and ny==inity) or
  (vdisp > 0)
  
  if(jumping) then
    v=15
    jtick+=1
    t=(jtick/jdiv)
    if (jbtn and not btnrls and jtick<10) then
     btntick+=0.5
    else
     btnrls=true
    end
    v=v+(btntick)
    vdisp=ydiff(v,t,g)
  else
    v=0
    jtick=0
    vdisp=0
    ny=inity
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
  
  speed = max(min(speed+hv,maxspeed),maxspeed*-1)
  
  if (abs(speed) < 0.1) then
   speed=0
  end
  
  if (jumping) then
   nx+=(speed/1.1)
  else
   nx+=speed
  end


end

function _draw()
 cls()
 spr(1,nx,min(inity,ny-vdisp),1,1,leftie)
 
 --print(vdisp)
 --print(running)
 --print(jumping)
 print("speed: "..tostr(speed))
 print("v: "..tostr(hv))
 --print(inity)
 --print(ny-vdisp)
end

-->8
function ydiff(v,t,g)
 return (v*t) - (0.5*g*t*t)
end
__gfx__
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088222800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070008e2e2800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700008e222800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700008eee2800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070008e2e2800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000008eee8800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
