pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--shooter
--charlotte laudien


function _init()
	 p={x=60,y=90,speed=1,5}
	 bullets={}
	 enemies={}
	 explosions={}
	 create_stars()
	 score=0
	 state=0
end

function _update60()
	if (state==0) update_game()
	if (state==1) update_gameover()	
end

function _draw()
	if (state==0) draw_game()
	if (state==1) draw_gameover()
end

function update_game()
	update_player()
	update_bullets()
	update_stars()
	if #enemies==0 then
		spawn_enemies(ceil(rnd(7)))
	end
	update_enemies()
	update_explosions()
end

function draw_game()
	cls()
	--stars
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	--big_stars
	for s in all(big_stars) do
		spr(6,s.x,s.y)
	end
	--bullets
	for b in all(bullets) do
		spr(2,b.x,b.y) 
	end
	--enemies
	for e in all(enemies) do
		spr(3,e.x,e.y)
	end
	--explosions
	draw_explosions()
	--spaceship
	spr(1,p.x,p.y)
	--score
	//print("score:\n"..score,2,2,7)	
	print("score:",2,2,7)
	print(score,2,8,2)
end
-->8
--bullets

function shoot()
	new_bullet={
		x=p.x,
		y=p.y,
		speed=4
	}
	add(bullets, new_bullet)
	sfx(0)
end

function update_bullets()
	for b in all(bullets) do
		b.y-=b.speed
		if b.y<0 then
			del(bullets,b)
		end
	end
end

-->8
--stars

function create_stars()
	stars={}
	big_stars = {}
	pack_stars(stars, 9, 5, 1) 
	pack_stars(stars, 3, 13, 2)
	pack_stars(stars, 2, 2, 2)

	pack_big_stars(big_stars, 1, 1, 0)
	pack_big_stars(big_stars, 1, 1, 1)
end

function update_stars()
	for s in all(stars) do 
		s.y+=s.speed
		if s.y>128 then
			s.y=0
			s.x=rnd(128)
		end
	end
	for s in all(big_stars) do 
		s.y+=s.speed
		if s.y>128 then
			s.y=0
			s.x=s.side * 67 + rnd(57)
		end
	end
end

function pack_stars(stars, nb_stars, col, speed)
	for i=1,nb_stars do
		local new_star={
			x=rnd(128),
			y=rnd(128),
			col=col,
			speed=speed+rnd(1)
		}
		add(stars, new_star)
	end
end

function pack_big_stars(big_stars, nb_big_stars, speed, side)
	for i=1,nb_big_stars do
		-- local new_x = rnd()
		-- if (side) local new_x = 67 + rnd(60)
		local new_big_star={
			x= side * 67 + rnd(57),
			y=rnd(128),
			speed= speed,
			side= side
		}
		add(big_stars, new_big_star)
	end
end
-->8
--enemies

function spawn_enemies(amount)
	gap=(128-8*amount)/(amount+1)
	for i=1,amount do
		new_enemy={
			x=gap*i+8*(i-1),
			y=-20,
			life=4
		}
		add(enemies,new_enemy)	
	end
end

function update_enemies()
	for e in all(enemies) do
		e.y+=0.3
		if e.y > 128 then
			del(enemies,e)
		end
		--collision
		for b in all(bullets) do
			if collision(e,b) then
			create_explosion(b.x+4,b.y+2)
			del(bullets,b)
			e.life-=1
			if e.life==0 then
				del(enemies,e)
				score+=100
				end
			end
		end
	end
end
-->8
--collision

function collision(a,b)
	if a.x>b.x+8
	or a.y>b.y+8
	or a.x+8<b.x
	or a.y+8<b.y then
		return false
	else return true
	end
end
-->8
--explosions

function create_explosion(x,y)
	sfx(1)
	add(explosions,{x=x,
																	y=y,timer=0})
end

function update_explosions()
	for e in all(explosions) do
		e.timer+=1
		if e.timer==13 then
			del(explosions,e)
		end
	end
end

function draw_explosions()
 for e in all(explosions) do
	 circ(e.x,e.y,e.timer/3,
	 					8+e.timer%3)
	end
end
-->8
--player

function update_player()
	if (btn(➡️)) p.x +=p.speed 
	if (btn(⬅️)) p.x -=p.speed 
	if (btn(⬆️)) p.y -=p.speed 
	if (btn(⬇️)) p.y +=p.speed
	if (btnp(❎)) shoot()
	
	for e in all(enemies) do
		if collision(e,p) then
			state=1
		end
	end
end
-->8
--gameover

function update_gameover()
	if (btn(🅾️)) _init()
end

function draw_gameover()
	cls(2)
	print("score:",50,50,6)
	print(score,50,58,7)
	local gameover_text = "press 🅾️ or c to continue"
	local gameover_px_size = print(gameover_text, 0, -100)
	local start_text = (128-gameover_px_size)/2
	print(gameover_text,start_text,90,6)
end


__gfx__
000000000020020000e00e000066670000000000e020020e00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000056650000e00e00066cc66008055080e020020e00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700205c75020020020006c07c6000566500e02ee20e00000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700050dccd050000000056cccc6505689650e0edde0e00050000000000000000000000000000000000000000000000000000000000000000000000000000
00077000566dd665002002005511115505698650eeec7eee005d5000000000000000000000000000000000000000000000000000000000000000000000000000
0070070066666666000000008555555800566500022cc22000050000000000000000000000000000000000000000000000000000000000000000000000000000
00000000068dd8600000000090811809080550800200002000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009009000000000000900900000000000020020000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077007700770777077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700070007070707070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777070007070770077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007070007070707070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00770007707700707077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00202022202220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002022202220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000005d500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000002000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000005d5000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000066670000000000000666700000000000006667000000000000066670000000000000666700000000000006667000000000000066670000d000000
000000000066cc660000000000066cc660000000000066cc660000000000066cc660000000000066cc660000000000066cc660000000000066cc660000000000
00000000006c07c6000000000006c07c6000000000006c07c6000000000006c07c6000000000006c07c6000000000006c07c6000000000006c07c60000000000
00000000056cccc6500000000056cccc6500000000056cccc6500000000056cccc6500000000056cccc6500000000056cccc6500000000056cccc65000000000
00000000055111155000000000551111550000000005511115500000000055111155000000000551111550000000005511115500000000055111155000000000
00000000085555558000000000855555580000000008555555800000000085555558000000000855555580000000008555555800000000085555558000000000
00000000090811809000000000908118090000000009081180900000000090811809000000000908118090000000009081180900000000090811809000000000
00000000000900900000000000009009000000000000090090000000000000900900000000000009009000000000000090090000000000000900900000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000200200000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000566500000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000205c7502000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000050dccd05000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000566dd665000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000066666666000000000000000000000000050000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000068dd860000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000900900000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000
0000000000000000000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
0001000008550105502b550225500f5500d5500a550075500655005540035300152000510115000f5000f5000f5000f5000f5000f5000f5000f5000f5000f5000f50006500135001350013500155000150000500
010100000a11318123161330e13306123031130211301113011130411308103081030010305103001030010300103011030010300103001030010300103001030010300103001030010300103001030010300103
