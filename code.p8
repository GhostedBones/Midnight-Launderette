
function _init()
	logs={}
 ents={}
 rain={}
 t=0
 sfx(26)

 -- vars
 days=1
 gold=4
 items={}
 customers=0

 -- forest
 herb={}
 for x=0,15 do for y=0,15 do
  if mget(16+x,y)==69 then
   add(herb,{x=x*8,y=y*8})
  end
 end end

 -- merchant
 merchant={}
 merchant_pool={}
 for i=0,7 do
  add(merchant_pool,32+i)
 end

 -- equipment
 shelves={{nil,1,nil,2,3}}
 stock={}
 shelves={{1,2,3,4,5,6,7,8,9}}
 stock={1,2}
 recipes = {0,1,2}

 forest={}

 -- parse data
 al={}
 rdat={}
 for i=0,32 do
  o={cost={},res={}}
  a=o.cost
  x=48
  for k=0,8 do
	  n=mget(x,i)
	  if n==2 then
	   break
	  elseif n==134 then
	   a=o.res
	  else
	   add(a,n)
	  end
	  x+=1
	 end
	 if #o.cost>0 then
	  add(rdat,o)
	  if i>0 then add(al,i) end
	 else
	  break
	 end
 end

 -- val
 val=mke(0,60,60)
 val.dr=dr_val
 walk=0
 wface=0
 val.ldx=0
 val.brd=true
 val.ldy=0
 val.dy=0
 val.dy=0
 wflp=false
 --character talk
 vm=0
 vd=0
 vb=0
 va=0
 vh=0
 vn=0
 vc=0
 vs=0
 vw=0



 new_day()
 if jump_to then
  scn=0
  reset_scene()
  loop(control)
 else
  init_intro()
 end


end

function run_away(e)

 moveto(e,e.x,e.y+32,24)
 e.dr=function(e)
  spr(11,e.x,e.y)
  spr(27,e.x,e.y+14,1,1,t%8<4)
 end
 wait(24,kl,e)
 wait(24,unfreeze)
end


function nhv(n)
 local sum=0
 for k in all(items) do
  if n==k then sum+=1 end
 end
 return sum
end

function hv(n)
 return nhv(n)>0
end


function rand(k)
 return flr(rnd(k))
end


function end_game()
 fading=loop(fade)

end

function control(e)
 if freeze then return end
 if ending then
  freeze=true
  sfx(24)
  wait(40,end_game)
  return
 end


 val.dx=0
 val.dy=0
 act=nil
 wcol()
 if btn(0) then wmove(-1,0) end
 if btn(1) then wmove(1,0) end
 if btn(2) then wmove(0,-1) end
 if btn(3) then wmove(0,1) end

 -- walk_cycle
 if is_moving() then
  if t%4==0 then
  	walk=(walk+1)%4
	 end
	 if t%8== 0 then
	  bs=4
	  if pcol(val.x+4,val.y+4,3) then
	   bs+=2
	  end
	  sfx(bs+(t%4))
	 end
	else
	 walk=0
 end

 -- interact
 if btnp(4) then
  if act then
  	act.act(act)
  end

 end

end

function net_catch(e)
 walk=1

 if e.t%4 == 0 then

  val.dx,val.dy=-val.ldy,val.ldx
 end

 val.net=-e.t/20
 if e.t==20 then
  val.net = nil
  unfreeze()
  kl(e)
 end
end

function ending_screen(win)
 --pal()
 t=0
 tdy=0
 ens=function()
  rectfill(0,0,127,127,win and 3 or 8)
  if win then
   camera(-23,-40)
   talk("congratulations!",t,80,64)
   camera()
  else
   print("game over",46,60,7)
  end
  if t>40 and btnp(4) then
  -- reboot()
  end
 end


end

function fade(e)
 if e.light then
  e.t-=1.5
 end
 k=e.t/4
 for i=0,15 do
  pal(i,sget(16+i,24+k+i/16))
 end
 if k>5 and not e.light then
  e.light=true
  days+=1
  if ending then
   ending_screen(true)
 elseif days==100 then
   ending_screen(false)
  else
   new_day()
  end

 end
 if k<=0 then
  init_intro()
  fading=nil
  pal()
  kl(e)
 end

end


function new_day()

 -- reset
 scn=0
 reset_scene()
 val.x=60
 val.y=60
 walk=0
 wface=0
 val.dx=0
 val.dy=0


end

function init_intro()
 if days>1 then sfx(27) end
 tdy=0
 loop(nil,dr_intro)
end

function dr_intro(e)

 y=128-min(e.t/10,1)*48

 rectfill(0,y-1,127,y+30,7)
 rectfill(0,y,127,y+29,8)
 rectfill(0,y+31,127,y+31,1)

	print("12:00 pm ",54,y+2,14)

	by=y+9
	if not e.skip then
		camera(-1,-by)
		clip(0,by,128,y+56)
		t=-1
		talk("h𝘦𝘭𝘭𝘰, 𝘵𝘩𝘢𝘯𝘬𝘴 𝘧𝘰𝘳 𝘫𝘰𝘪𝘯𝘪𝘯𝘨 𝘶𝘴 𝘵𝘰𝘯𝘪𝘨𝘩𝘵 𝘢𝘴 𝘸𝘦 𝘱𝘢𝘺 𝘢 𝘷𝘪𝘴𝘪𝘵 𝘵𝘰 𝘵𝘩𝘦 midnight launderette.",e.t,126,13)
		clip()
		camera()
	end
	if e.skip then
	 e.t-=2
	 if e.t<0 then
	  kl(e)
		loop(control)

	 end
	elseif btnp(4) then
	 sfx(28)
	 e.skip=true
	 e.t=10
	end

end


function get_act()
 for e in all(ents) do
  if e.act then
   local x=e.x
   local y=e.y
   if e.rx then
    x+=e.rx
    y+=e.ry
   end
   dx=x-val.x-4
   dy=y-val.y-4
   if sqrt(dx*dx+dy*dy)<4 then
    return e
   end
  end
 end
 return nil
end

function is_moving()
 return val.dx!=0 or val.dy!=0
end

function wmove(dx,dy)
 local spd=1.5
 if hv(35) then spd+=1 end

 val.x+=dx*spd
 val.y+=dy*spd

	while wcol() do
	 val.x-=dx
	 val.y-=dy
	end
	val.dx=dx
	val.dy=dy


end

function wcol()
 a={0,0,0,7,7,0,7,7}
 for i=0,3 do
  local x=val.x+a[1+i*2]
  local y=val.y+a[2+i*2]
  if pcol(x,y,0) then return true end
 end


 for e in all(ents) do
  if e.rx then
  	dx=(e.x+e.rx)-(val.x+4)
 		dy=(e.y+e.ry)-(val.y+2)

 		function chk(lim)
 		 e.wn=abs(dx)+abs(dy)
 		 return abs(dx)< 4+e.rx+lim and abs(dy)< 4+e.ry+lim
 		end
 		if chk(6) and e.act then
 		 if not act or ( act.wn> e.wn ) then
 		  act=e
 		 end
 		end
 		if chk(0) then
 		 return true
 		end
  end
 end

 return false
end

function pcol(x,y,n)

 tl=mget(scn*16+x/8,y/8)
 return fget(tl,n)
end

function inc_sum(a,inc)
 if not sum then
  sum={0,0,0,0,0,0,0,0,0,0,0}
 end
 for i=1,9 do
  if a[i] then
   sum[a[i]]+=inc
  end
 end
 return sum
end

function reset_scene()
 ents={}
 add(ents,val)
 if fading then
 add(ents,fading)
 end


-------------characters and items ----------

--𝘴pooky
	spooky=mke(137,5,20)
	spooky.brd=true
	spooky.act=act_spook
	spooky.szy=2
	spooky.rx=0
	spooky.ry=6
	spooky.float=true

--𝘵owel
	towel=mke(4,13,25)
	towel.float=true
	towel.brd=true

--hilda
	e=mke(139,40,12)
	e.brd=true
	e.szy=2
	e.act=act_hilda
	e.rx=0
	e.ry=11

--plant
	plnt=mke(15,32,9)
	plnt.szy=2
	plnt.brd=true

--spray bottle
	spray=mke(6,49,18)
	spray.brd=true

--charolette spider
	leg1=mke(187,116,8)
	leg2=mke(187,115,11)
	leg3=mke(187,114,13)
	leg4=mke(187,104,8)
	leg5=mke(187,105,11)
	leg6=mke(187,106,13)
	e=mke(171,110,14)
	e.brd=true
	e.act=act_charl
	e.rx=0
	e.ry=11
	e.float=true

--𝘥igby
	digby=mke(178,60,43)
	digby.brd=true
	digby.szx=2
	digby.act=act_dig
	digby.rx=3
	digby.ry=3

--𝘮ike
	e=mke(138,78,36)
	e.brd=true
	e.szy=2
	e.act=act_mike
	e.rx=2
	e.ry=6

--baskets
	bask_f=mke(177,88,45)
	bask_f.brd=true
	bask_f2=mke(177,80,106)
	bask_f2.brd=true
	bask_e=mke(176,64,106)
	bask_e.brd=true

--𝘣ob the blob
	blob=mke(135,52,77)
	blob.act=act_bob
	blob.rx=2
	blob.ry=3
	rotate=0
	blob.upd=function(blob)

	end
	blob.dr=function(blob)
		if t>0 then
			if t%5==0 then rotate=(rotate+1)%4 end
		--animation of rotation
		sspr(56,64+rotate*8,8,8,52,77,8,8)
		end

	end

--detergent
	deter=mke(3,46,66)
	deter.brd=true

--cart
	cart=mke(198,105,90)
	cart.szy=4
	cart.szx=2
	cart.depth=1
	cart.brd=true

--𝘸ayne the 𝘣at
	e=mke(170,109,91)
	e.brd=true
	e.depth=1
	e.act=act_wayne
	e.rx=0
	e.ry=3

-- 𝘢denoid
	 e=mke(12,32,99)
	 e.szy=2
	 e.brd=true
	 e.act=act_adenoid
	 e.rx=0
	 e.ry=3

--𝘪ron
	iron=mke(5,11,95)
	iron.brd=true
--𝘪roning board
	board=mke(181,20,99)

--𝘯oodle 𝘴nake
	e=mke(180,80,99)
	e.brd=true
	e.rx=0
	e.ry=3
	e.act=act_noodle
	e.float=true
	e.act=act_noodle


end

function item_get(fr)
	if it then kl(it) end
	if victory then kl(victory) end
	victory=mke(226,val.x,val.y-8)
	it=mke(fr, val.x,val.y-16)
	freeze=true
	name = ""
	it.ttl=50
	flash=0
	drift=0
	it.float=true
	it.brd=true
	it.depth=2
	val.depth=3
	val.it=fr
	if fr==7     then name="hedgehog"
	elseif fr==2 then name="basket"
	elseif fr==23 then name="webs"
	elseif fr==6 then name="spray bottle"
	elseif fr==9 then name="bucket"
	elseif fr==3 then name="detergent"
	elseif fr==5 then name="iron"
	elseif fr==4 then name="  towel"
	elseif fr==1 then name="hanger"

	end
	sfx(25)
	it.upd=function(it)
		it.ttl-=1
		if it.ttl<=0 then
			kl(it)
			kl(victory)
			val.depth=0
			unfreeze()
		end
	end

	it.dr=function(it)
		flash+=0.5
		drift+=0.08
		victory.szx=2
		victory.szy=2
		victory.brd=true
		victory.depth=0
		print(name,val.x-10,val.y-20-drift,8+flash%2)
	end
end
function game_over()
	t=0
	tdy=0
	ens=function()
	  rectfill(0,0,127,127,12)
		camera(-23,-40)
		talk("thanks for playing!",t,80,64)
		camera()
	end
end
-----------------dialogue-------------------
function act_mike(e)

		function vm4()
			msg("i'm so ready for some sleep!!!",140,game_over)
		end
		function vm3()
			msg("awwww nooo, that should have been the first place i checked... oh well let's get home to bed!",174,vm4)
		end
	 function vm2()
		 msg("it's just a cheap hanger, there's got to be plenty in this launderette.",140)
		end
	 function vm1()
		 msg("alright, no worries, i'll see if i can find a spare.",140)
		 vm=1
		end

	if (val.it==1 and vm==1) then
		msg("it was under digby the whole time!",140,vm3)
	elseif vm==1 then
		msg("i could of swore i brought a hanger just for this reason... i can't remember where it is...",174,vm2)
	else
		--mike
		msg("hey hunny, i forgot the hanger for my dress shirt! we need to find one before we go home.",174,vm1)
	end

end

function act_dig(e)
	function vd_it()
		item_get(7)
	end
	function vd_it2()
		item_get(1)
		vd=2
		kl(digby)
		--𝘥igby
			digby=mke(194,60,43)
			digby.brd=true
			digby.szx=2
			digby.act=act_dig
			digby.rx=3
			digby.ry=3
	end

	function vd3()
		msg("i love being a burrito! oops i was laying on something...",202,vd_it2)
		vd=2
	end
	function vd2()
			msg("aww, don't worry digs, i'll find you something soft to snuggle in.",140)
	end
	function vd1()
			msg("digby, what's that in your mouth?",140,vd_it)
			vd=1
	end

	if vd==2 then
		msg("let's never leave.",202)
	elseif (val.it==4 and vd==1) then
		msg("here digby, stand up real quick so i can wrap you up like a tortilla.",140,vd3)
	elseif vd==1 then
		msg("so cozy and warm in here... still i wish i had a soft blanket.",202,vd2)
	else
		msg("i'm so tired, this place just makes me so sleepy, i can barely hold this toy i just found.",202,vd1)
	end
end

function act_bob(e)
	function vb_it()
		item_get(3)
		vb=2
		kl(deter)
		bucket=mke(9,50,66)
		bucket.brd=true
		kl(e)

	end
	function vb5()
		msg("finally! here you can take all the spare detergent i found while i was in there",236,vb_it)
	end
	function vb4()
			msg("yup! you can come out now...",140,vb5)
	end
	function vb3()
		msg("oh... my... glob... you are not helping... i can't talk! i am so distressed!",236)
	end
	function vb2()
			msg("no not yet... do you know where i can find one?",140,vb3)
	end
	function vb1()
			msg("...uhh yeah right away.",140)
			vb=1
	end
	if vb==2 then
		msg("i think he fainted",140)
	elseif (val.it==9 and vb==1) then
		msg("is that a bucket i see? i really can't tell i'm incredibly dizzy.",236,vb4)
	elseif vb==1 then
		msg("do you have the bucket for me?",236,vb2)
	else
		msg("omg, please help! i need a bucket to fill up and hold my composure.",236,vb1)
	end
end

function act_adenoid(e)
	function va_it()
		item_get(5)
		va=2
		kl(iron)
	end
	function va8()
		msg("an iron huh? okay that's a good weapon i guess...",140,va_it)
	end
	function va7()
		msg("besides the warm fuzzy feeling you get from helping a poor old man, you will be rewarded with the iron and board next to me.",172,va8)
	end
	function va6()
		msg("hold up, what do i get in return?",140,va7)
	end
	function va5()
		msg("𝘸𝘩𝘺 𝘥𝘰 𝘺𝘰𝘶 𝘵𝘩𝘪𝘯𝘬 𝘪 𝘯𝘦𝘦𝘥 𝘵𝘩𝘪𝘴?",172)
	end
	function va4()
		msg("yeah well... you smell like you haven't washed your clothes in weeks.",140,va5)
	end
	function va3()
		msg("wow rude... 𝘦𝘷𝘦𝘳𝘺𝘰𝘯𝘦 𝘯𝘦𝘦𝘥𝘴 𝘴𝘰𝘮𝘦𝘵𝘩𝘪𝘯𝘨 𝘢𝘳𝘰𝘶𝘯𝘥 𝘩𝘦𝘳𝘦...",140)
		va=1
	end
	function va2()
			msg("i need a bottle of laundry detergent before we talk anymore.",172,va3)
	end
	function va1()
		msg("no, actually i was hoping you worked here, i'm looking for a-",140,va2)
	end

	if va==2 then
		msg("what am i still doing here?",172,run_away(e))
	elseif (val.it==3 and va==1) then
		msg("ahh yes, that clean smell... with haste! give me that soap!",172,va6)
	elseif va==1 then
		msg("leave me be little one, i can smell the lack of detergent with you.",172,va4)
	else
	msg("little girl, do you work here?",172,va1)
	end
end

function act_hilda(e)
	function vh_it()
		item_get(6)
		vh=2
		kl(spray)
	end
	function vh11()
		kl(plnt)
		plnt=mke(14,32,9)
		plnt.szy=2
		plnt.brd=true

		msg("okay, this could work... here take the poison spray. keep it away from my family.", 142,vh_it)
	end
	function vh10()
		msg("whoa, wait for serious? okay act cool, be cool...", 142)
	end
	function vh9()
		msg("shhh... not now, too many eyes on us.",140,vh10)
	end
	function vh8()
		msg("anything that can stop this drooping plant and i'll trade you this poison spray.", 142)
		vh=1
	end
	function vh7()
		msg("like string or clips or glue? i dunno.",140,vh8)
	end
	function vh6()
		msg("oh whoops, okay i need something to hold it up until i can find the proper nutrition.", 142,vh7)
	end
	function vh5()
		msg("that's not water, that's some cleaning chemical stuff, you are definitely killing it.",140,vh6)
	end
	function vh4()
		msg("i'm trying to figure out how to take care of this life form next to me. it seems to dislike the water i've been spraying at it.", 142,vh5)
	end
	function vh3()
		msg("the ones in my closet don't read books.",140,vh4)
	end
	function vh2()
		msg("haven't you seen a skeleton before?", 142,vh3)
	end
	function vh1()
		msg("i don't know, i haven't figured it out yet.",140,vh2)
	end

	if vh==2 then
		msg("shut up, i keep reading the same line over and over because of you.",142)
	elseif (val.it==23 and vh==1)then
			msg("i have an idea, let me see your plant real quick",140,vh11)
	elseif vh==1 then
		msg("you got the goods?", 142,vh9)
	else
		msg("what are you looking at?", 142,vh1)
	end

end

function act_noodle(e)
	function vn_it()
		item_get(2)
		vn=2
		kl(bask_e)
	end
	function vn6()
		msg("all i heard was 'hedgehog' those are my favorite! gimmie! oh here you can have my spare basket too",206,vn_it)
	end
	function vn5()
		msg("hey, i'm hungry too but you don't hear my complaining.",140)
	end
	function vn4()
		msg("lisssssten, i don't want any trouble, jusssst find me one of your ssssnick sssnacksss and i'll be out of here to feed up elsewhere.",206)
		vn=1
	end
	function vn3()
		msg("you better not eat my hubby or i'll turn you into an ugly scarf!",140,vn4)
	end
	function vn2()
		msg("i need more than a sssssssnick sssssssnack like you but that man over there looks like a full meal.",206,vn3)
	end
	function vn1()
		msg("yeah, there's no snick snack vending machines in here, just don't eat your tail!",140,vn2)
	end

	if vn==2 then
		msg("i'll leave soon it's just raining right now....",206)
	elseif (val.it==7 and vn==1) then
		msg("i found this anti-static dryer thing that's shaped like a hedgehog, will that do?",140,vn6)
	elseif vn==1 then
		msg("ssssssnick sssnaaaack?",206,vn5)
	else
		msg("i'm sssssoooooo hungry but this launderette doesn't have any food.",206,vn1)
	end
end


function act_charl(e)
	function vc_it()
		item_get(23)
		vc=2
	end

	function vc15()
		msg("that's what i thought",238,vc_it)
	end
	function vc14()
		msg("baskets are amazing and it's difficult for me to part with this...",140,vc15)
	end
	function vc13()
		msg("what's that?... you were mubling, i didn't hear you.",238,vc14)
	end
	function vc12()
		msg("basketsarenotsillyimsorryitakeitbackpleasegivemewebabilities",140,vc13)
	end
	function vc11()
		msg("baskets are not silly, take that back or you'll get nothing!",238,vc12)
	end
	function vc10()
		msg("fingertips?! that makes absolutely no sends, of course i'll take it!",140)
	end
	function vc9()
		msg("whoa, easy there nerd. do you want to shoot webs out your fingertips or not?",238,vc10)
	end
	function vc8()
		msg("peter parker made those web shooters himself! he never had that power imbued in-",140,vc9)
	end
	function vc7()
		msg("yeah, wouldn't you like to shoot webs from your hands?",238,vc8)
	end
	function vc6()
		msg("spider powers? like spider-man?",140,vc7)
	end
	function vc5()
		msg("how about... spider powers?",238,vc6)
	end
	function vc4()
			msg("if you get me a basket, that you didn't steal, i'll give you something better...",238)
			vc=1
	end
	function vc3()
		msg("if i get you a basket can i have that hanger there?",140,vc4)
	end
	function vc2()
		msg("you don't want these lame hangers... the only quality thing they have here are these amazingly strong baskets, it holds better than my webs, it would be great for my babies.",238,vc3)
	end
	function vc1()
		msg("whoa, easy there spider. i just wanted to get one of those cheap hangers, that can't be worth much to you can it?",140,vc2)
	end

	if vc==2 then
		msg("i can't lay my eggs if you keep looking at me.",238)
	elseif (val.it==2 and vc==1) then
		msg("here's your silly basket, spider-powers now plzthxbye.",140,vc11)
	elseif vc==1 then
		msg("wait what's better than a hanger?.... i mean a lot of things are but you are so vague!",140,vc5)
	else
		msg("backup, this inventory belongs to the midnight launderette and i will protect it 'til my last dying breath!",238,vc1)
	end

end



function act_spook(e)

	function vs_it()
		item_get(4)
		vs=2
		kl(towel)
		kl(spooky)
		--𝘴pooky
			spooky=mke(136,5,20)
			spooky.brd=true
			spooky.act=act_spook
			spooky.szy=2
			spooky.rx=0
			spooky.ry=6
			spooky.float=true
	end
	function vs10()
		msg("this is why i don't talk to people... whatever take your towel.",234,vs_it)
	end
	function vs9()
		msg("i hope that's not your new catch phrase.",140,vs10)
	end
	function vs8()
		msg("haha i'm joking, keep your sheets white, i'll find you an iron hold on.",140)
	end
	function vs7()
		msg("awww what nooo... ghosts are always- that's a thing for- you can't-",234,vs8)
	end
	function vs6()
		msg("hey that's my line!",140,vs7)
	end
	function vs5()
		msg("trade hmm? okay give me an iron and i'll give you my spooky towel.",234)
		vs=1
	end
	function vs4()
		msg("nope, looks comfy though, i'll trade you for it.",140,vs5)
	end
	function vs3()
		msg("my usual white sheets have so many wrinkles i need to iron it out, all i have left is this fuzzy blue towel... it's not spooky looking at all is it?",234,vs4)
	end
	function vs2()
		msg("honestly, i noticed your floating towel first!",140,vs3)
	end
	function vs1()
		msg("holy macaroni don't scare me!... i didn't think you could see me...",234,vs2)
	end

	if vs==2 then
		msg("....................",234)
	elseif (val.it==5 and vs==1) then
		msg("it's ironing time!",234,vs9)
	elseif vs==1 then
		msg("boo!!!!!!!!!!!!!",234,vs6)
	else
		msg("boo!!!!!!!!!!!!!!",140,vs1)
	end
end

function act_wayne()
	function vw_it()
		item_get(9)
		vw=2
	end

	function vw19()
		msg("no, it was painful. here is your bright red bucket.",204,vw_it)
	end

	function vw18()
		msg("yes, did you like it?",140,vw19)
	end

	function vw17()
		msg("was that a pun because i sleep like this?",204,vw18)
	end

	function vw16()
		msg("well turn that frown upside down because i got this fair and square!",140,vw17)
	end


	function vw15()
		msg("no, stop pesking me, i'll get it eventually.",140)
	end

	function vw14()
		msg("well do you have it?",204,vw15)
	end

	function vw13()
		msg("you have to stop saying things like that",140,vw14)
	end


	function vw12()
		msg("for you miss, only the reddest",204)
		vw=1
	end

	function vw11()
		msg("deal, but it better be the reddest bucket i ever laid eyes on.",140,vw12)
	end

	function vw10()
		msg("i'll give you a red bucket in return...",204,vw11)
	end

	function vw9()
		msg("hmmm i dunno, you seem super suspect.",140,vw10)
	end

	function vw8()
		msg("haha oh no dear miss, this poison is for research purpose only, i assure you.",204,vw9)
	end

	function vw7()
		msg("are you threating me? i feel like a vampire is threatening me.",140,vw8)
	end

	function vw6()
		msg("that, my dear, is drowning. it is quicker than poison.",204,vw7)
	end

	function vw5()
		msg("oh yeah? what about water?",140,vw6)
	end

	function vw4()
		msg("what most don't realize is technically anything is poison in high enough quantities.",204,vw5)
	end

	function vw3()
		msg("well you are a strange little bat aren't you?",140,vw4)
	end

	function vw2()
		msg("i ask it, to everyone, every day.",204,vw3)
	end

	function vw1()
		msg("now there's a question you don't get asked every day.",140,vw2)
	end

	if vw==2 then
		msg("hahahaha... oh you're still here? ...",204)
	elseif (val.it==6 and vw==1)then
		msg("i frown upon thievery.",204,vw16)
	elseif vw==1 then
		msg("there's a face of someone with poison!",204,vw13)
	else
		msg("good evening miss, would you perchance happen to have poison on you?",204,vw1)
	end
end


function border(f,a,b,c)
 apal(1)
 camera(0,1)
 f(a,b,c)
 camera(1,0)
 f(a,b,c)
 camera(0,-1)
 f(a,b,c)
 camera(-1,0)
 f(a,b,c)
 pal()
 camera()
 f(a,b,c)
end


function unfreeze()
 freeze=false
end


function init_load()
  freeze=true
 	reset_pos()
 	--loop(load_wagon,dr_load)
end

function reset_pos()
 wx=0
 wy=0
 ws=0
end
function give(n,fx,fy)
 sfx(17)
 local a,b=seek_ing(nil)
 if not a then return end
 x,y=get_shelf_pos(a,b)

 if n==10 then
  ending=true
 end

 local e=mke(n,fx,fy)
 e.jump=40
 e.depth=0
 function f()
  sfx(4)
  kl(e)
  shelves[a+1][b+1]=n
 end
 moveto(e,x,y,20,f)

end

function seek_ing(n,rmv)
 a=0
 for sh in all(shelves) do
  for b=0,8 do
   if sh[b+1]==n then
    if rmv then sh[b+1]=nil end
    return a,b
   end
  end
  a+=1
 end
 return nil,nil
end

function get_shelf_pos(a,b)
 	return a*40+16+(b%3)*8, 16+flr(b/3)*8
end

function wait(t,f,a,b,c,d)
 e=mke(-1,0,0)
 e.life=t
 e.nxt=function() f(a,b,c,d) end
end

function can_pay(a)
 sum=nil
 for sh in all(shelves) do
  inc_sum(sh,1)
 end
 inc_sum(a,-1)

 local k=0
 for n in all(sum) do
  if n<0 then
   return false
  end
  k+=1
 end
 return true
end

function draw_rec(ri,x,y)

 map(7,16,x,y,5,5)
 local o=rdat[ri+1]

 function ings(a,by)
  local ki=0
  local ec=10
  if #a>=4 then ec=6 end
	 for n in all(a) do
	  spr(n,x+17+ki*ec-#a*flr(ec/2),by)
	  ki+=1
	 end
 end

 if o.cost[1]!=48 then
	 ings(o.cost,8+y)
	 spr(96,x+12,y+16)
	 ings(o.res,24+y)
 else
  ings(o.cost,16+y)
 end

end

function any_but()
 for i=0,5 do
  if btn(i) then return true end
 end
 return false
end

function msg(str,prt,nxt)

 port=prt or 140
 nxt=nxt or unfreeze
 freeze=true
 ms=mke(-1,0,0)
 tdy=0

 ms.upd=function(ms)

  if price then
   if btnp(0) or btnp(1) then
    choice=1-choice
    sfx(9)
   end
   if btnp(4) and ms.t>1 then
    kl(ms)
    if choice==0 then
     pay_gold(price,seller,buy_stuff)
	    sfx(15)
    else
     sfx(16)
     unfreeze()
    end
    price=nil
   end

  elseif any_but() then
   if ms.t>= #str then
    kl(ms)
    nxt()
   else
    ms.t+=2
   end
  end


 end
 ms.dr=function(ms)
	 ms.t-=0.5
  rectfill(7,107,120,124,7)
  rectfill(8,108,119,123,13)
		spr(port,8,108,2,2)

		camera(-26,-110)
		clip(9,109,110,14)
		talk(str,ms.t,94,6)
		clip()
		camera()

		if price and ms.t>10 then
			for i=0,1 do
			 txt=i==0 and "yes" or "no"
			 bx=48+i*36
				print(txt,bx,117, 7)
				if choice==i then
				 spr(49,bx-8,117)
				end
			end
		end

 end
 ms.depth=2

end


function dr_cauldron(e)
 camera(-e.x,-e.y)
 sspr(88,24,16,8,0,10)
 dx=0
 if e.recipe then dx=-16 end
 sspr(88+dx,16,16,8,0,2)
 camera()
end

function kl(e)
 del(ents,e)
 if e.nxt then e.nxt(e) end
end


function loop(f,dr)
 local e=mke(-1,0,0)
 e.upd=f
 e.dr=dr
 e.depth=2
 return e
end


function dr_val(e)
 ddy=0
 if pcol(e.x+4,e.y+4,1) then
  ddy=-4
 end
	camera(-e.x,ddy-e.y)
	-- shade
	--for x=0,8 do
	 --for y=5,9 do
	 -- n=pget(x,y)
	 -- pset(x,y,shd(n,0))
	-- end
	--end

 -- body
 if is_moving() then
	 wface=0
	 wflp=val.dx==-1
	 if val.dy<0 then wface=1 end
	 if val.dx!=0 then wface=2 end
	 val.ldx=val.dx
	 val.ldy=val.dy
	 val.depth=0
 end
 local dy=walk%2
 sspr(0+walk*12,64+wface*8,12,8,-2,-dy,12,8,wflp)

 -- head
 if wface==2 then wface+=walk end
 sspr(48,64+wface*5,8,5,0,-5-dy,8,5,wflp)
 if wface>=2 then wface=2 end

 camera()

end


function mke(fr,x,y)
 e={fr=fr,x=x,y=y, depth=0, t=0,
  vx=0,vy=0,frict=0,szx=1,szy=1

 }
 add(ents,e)
 return e
end

function upe(e)
 e.x+=e.vx
 e.y+=e.vy

 e.t+=1
 if e.upd then e.upd(e) end
 if e.life then
  e.life-=1
  if e.life<=0 then kl(e) end
 end

 -- counters
 for v,n in pairs(e) do
  if sub(v,1,1)=="c" then
   n-=1
   e[v]= n>0 and n or nil
  end
 end

 --tween
 if e.twc then
  local c=min(e.twc+1/e.tws,1)
  e.x=e.sx+(e.ex-e.sx)*c
  e.y=e.sy+(e.ey-e.sy)*c
  if e.jump then
   --local cc=sqrt(c)
   e.y+=sin(c/2)*e.jump
  end

  e.twc=c
  if c==1 then
   e.twc=nil
   e.jump=nil
   f=e.twf
   if f then
    e.twf=nil
    f()
   end
  end
 end

end

function moveto(e,tx,ty,n,f)
 e.sx=e.x
 e.sy=e.y
 e.ex=tx
 e.ey=ty
 e.twc=0
 e.tws=n
 e.twf=f
end

function dre(e)

 npal=false
	if e.depth!=depth then return end
 if e==act and t%6<=1 and not freeze then
  cl=7
  if e.price and e.price>gold then
   cl=8
  end
  apal(cl)
  npal=true
 end

 if e.cbl then
  apal(7)
  npal=true
 end

 if e.spoiled then
  pal(3,4)
  pal(11,9)
  npal=true
 end


 if e.fr> 0 and (not e.cblk or t%4<2 )then
  -- auto_anim
  if fget(e.fr,3) and e.t%4==0 then
   e.fr+=1
   if fget(e.fr,0) then
    kl(e)
    return
   end
  end
  local fr=e.fr
  local x=e.x
  local y=e.y
  if e.float then
   y += flr(sin(t/20+x/7)+.5)
  end
  if e.fly then
   fr=57+flr(cos(t/10)+.5)
  end

  spr(fr,x,y,e.szx,e.szy)
 end

 if e.dr then e.dr(e) end
 if npal then pal() end

end


function rspr(fr,x,y,rot)
	for gx=0,7 do for gy=0,7 do
  px=(fr%16)*8
  py=flr(fr/16)*8
  p=sget(px+gx,py+gy)
  if p>0 then
   dx=gx
   dy=gy
   for i=1,rot do
    dx,dy=7-dy,dx
   end
   pset(x+dx,y+dy,p)
  end
 end end
end

function dr_shelves()

 -- slots
 n=2
 for sh in all(shelves) do
 	map(0,16,n*40+5,0,5,5)
 	for i=0,8 do
 	 id=sh[i+1]
 	 if id then
 	  x,y=get_shelf_pos(n,i)
 	  clip(x,y-8,x,y)
 	  spr(id,x+6,y-9)
 	  clip()
 	 end
 	end
 	n+=1
 end

 --sides
 n=2
 for sh in all(shelves) do
  bx=n*40+15
  for i=0,1 do
   x=(bx+i*25)+5
 	 rectfill(x,0,x+2,40,12)
		end
		rectfill(bx+5,0,bx+32,8,13)
		n+=1
 end

end

--------particles library---------
function rain_particles()
	add(rain,{
		x=rnd(100),
		y=1,
		dx=-3,
		dy=4,
		life=5,
		dr=function(self)
			pset(self.x,self.y,12)
		end,
		upd=function(self)
			self.x+=self.dx
			self.y+=self.dy
			self.life-=1
			if self.life<0 then del(rain,self) end
		end
})
end
--------particles library---------


function _update()
 logp={}
 t=t+1
 ysort(ents)
 foreach(ents,upe)
 for r in all(rain) do r:upd() end
end

function _draw()
 cls()

 if ens then
  ens()
  return
 end

 map(0,0)
 if scn==0 then
	rain_particles()
	rain_particles()
	sfx(33)

  dr_shelves()
	print("midnight",40,5,12)
	print("𝘭𝘢𝘶𝘯𝘥𝘦𝘳𝘦𝘵𝘵𝘦",50,10,12)
	print("open",6,10,8)
	--rectfill(100,31,100,0,6)
	rectfill(3,20,5,24,6)
	rectfill(39,3,71,3,8) --top red line
	rectfill(49,16,93,16,8)--bottom red line
	line(0,0,99,0,6)
	line(0,31,0,0,6)
	line(27,31,27,0,6)
	rectfill(40,42,86,52,14)
	rectfill(40,49,86,49,7)
	line(7,106,17,116,6) ----ironing board leg
	line(17,106,7,116,6) ----ironing board leg
	rectfill(1,100,20,106,11) --ironing board
	circ(114,16,4,7) --spiderweb
	circ(114,16,7,7) --spiderweb
	line(114,16,127,10,7) --spiderweb
	line(114,16,100,10,7) --spiderweb
	line(114,16,100,15,7) --spiderweb
	line(114,16,127,15,7) --spiderweb
	line(114,16,100,20,7) --spiderweb
	line(114,16,127,20,7) --spiderweb

	for r in all(rain) do r:dr() end



 end


 -- ents
 dr_ents(0)
 dr_ents(1)
 dr_ents(2)


 -- logs
 color(7)
 cursor(0,0)
 for str in all(logs) do
  print(str)
 end
 for p in all(logp) do
  pset(p.x,p.y,t%15)
 end

end

function dr_ents(dp)

 depth=dp
 for e in all(ents) do

  if e.lpy then
   clip(e.x-1,e.y-1,e.x+10,e.lpy)
  end

  if e.brd and not fading then
   --dre(e)
   border(dre,e)
  else
   dre(e)
  end

  clip()
 end


end

function log(n)
 add(logs,n)
 if #logs>16 then
  del(logs,logs[1])
 end
end

function log_pt(x,y)
 add(logp,{x=x,y=y})
end

function drop_shadow(dr)
 apal(1)
 camera(-1,-1)
 dr()
 camera()
 pal()
 dr()
end

function apal(n)
 for i=0,15 do pal(i,n) end
end

function shd(n,k)
 local x = (n%4)+(k%2)*4
 local y = n/4+flr(k/2)*4
 return sget(x,y)
end

function ysort(a)
 for i=1,#a do
  local j = i
  while j > 1 and a[j-1].y > a[j].y do
   a[j],a[j-1] = a[j-1],a[j]
   j = j - 1
  end
 end
end


function talk(text,cur,xmax,lim)

 local x=0
 local y=-tdy

 if cur<#text and t%5==0 then
  bs=9
  if port==172 then bs=11 end
	if port==142 then bs=2 end
	if port==204 then bs=4 end
	if port==140 then bs=9 end
	if port==236 then bs=16 end
  sfx(bs+rand(2))
 end

	 for i=1,cur do

  ch=sub(text,i,i)
  if ch==" " then
   vx=x
   for k=i+1,#text do
    vx+=5
    if sub(text,k,k)==" " then
     break
    end
   end
   if vx>xmax then
    x=0
    y+=6
   else
    print(ch,x,y,7)
    x+=4
   end
  else
   print(ch,x,y,7)
   x+=4
  end
 end
 if y>lim then
  tdy+=0.6
 end
end

function mk_anim(sx,sy,sz,le)
 local e=mke(0,x,y)
 local fr=0
 e.dr=function(e)
  fr=flr(e.t/4)
  if fr==le then
   kl(e)
  else
   sspr(sx,sy+fr*sz,sz,sz,e.x-sz/2,e.y-sz/2)
  end
 end
 return e
end



