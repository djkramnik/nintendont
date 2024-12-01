try to forget I'm forty years old

in my spare time I will fiddle with this thing... 

goal for this is maybe to just make a fair proximity to mario world 1-1... 
just to try out game dev, particularly platforming concepts 
and just trying to figure out things by myself as much as possible

after this is done I'll maybe look at code from other pico8 games... try to prototype something
from my natty mountain platforming idea 

## TODO

update logic to determine if we be jumping... 

so maybe after the descent part of the jump we no longer count it as jumping
we count it as falling 
and we continue to fall, perhaps accumulating negative vertical velocity up until a max 
until we hit the ground or fall off the screen

maybe in testing for the ground below our feet we can use three pixels, 
the bottomleft, bottom middle and bottom right corner of our player sprite 

```
  jumping=
   (jbtn and ny==inity) or
   (vdisp > 0)
```

(jbtn and ny==inity) ===> this is making sure you can't jump in the air. but this has to be
changed to the touchinggrass function 

jumping = !touching grass or jbtn and touching grass
so we dont' really want vdisp...
we moreso want a y delta 
I suppose we can still use vdisp for that... 
up to a max y delta btw 

and then in the section where we currently make one time init updates at the onset of jumping,
we would set the initv as we do currently, or if we are simply not touching grass, we would 
set initv to 0 I suppose

we check touching grass eery update
if not touching grass, and not jumping (ascent part only remember)
we are FALLING
as long as are we falling we accumulate negative y velocity up to max 
whenever we are not falling all those falling variable reset 
can be generalized for jumping on shit 


function touchinggrass(nx, ny, type= ground | enemy etc )
  bl = nx, ny+8
  br = nx+8, ny+8

  so take bl maybe with a small tolerance 
  and then do 

  leftcheck = mget(blx - 4, bly + 4) == ground
  rightcheck = mget(brx +4, bry +4) == ground 
end



// can also check this whilst jumping or falling
// whilst jumping will immediately send it to falling 
// whilst 
function bustinghead(nx, ny)
  similar thing
end


