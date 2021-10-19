/*
Knobs For Turning
Copyright © 2021 davemakes

Check the license for this source in the included files folder, and have fun!

*/

// init game_obj
function game_init(){
	ww = 320;
	wh = 528;
	prev_window_width = ww;
	prev_window_height = wh;
	game_scale = 1;
	width = ww * game_scale;
	height = wh * game_scale;
	t = 0;
	
	c = [rgb_to_bgr($c128a7), rgb_to_bgr($2de5ac), rgb_to_bgr($f6fce5), rgb_to_bgr($ede338), rgb_to_bgr($38de3e)];
	bg_color = rgb_to_bgr($0e2430);
	bg_alpha_min = 0.6;
	bg_alpha = bg_alpha_min;
	
	a = [];
	a_width = 16;
	a_height = 16;
	a_count = a_width * a_height;
	spacing = 16;
	
	sprite_sub_num = sprite_get_number(circle_spr);
	
	var _surfw = get_screen_width();
	var _surfh = get_screen_height();
	game_surf = surface_create(_surfw, _surfh);
	ui_surf = surface_create(_surfw, _surfh);
	combo_surf = surface_create(_surfw, _surfh);
	
	surface_set_target(game_surf);
	draw_set_alpha(1);
	draw_rectangle_color(0, 0, _surfw, _surfh, bg_color, bg_color, bg_color, bg_color, false);
	surface_reset_target();
	
	for(var i = 0; i < a_count; i++)
	{
		array_push(a, new a_point(i));
	}
	
	knob = [];
	knob_count = 15;
	for(var i = 0; i < knob_count; i ++)
	{
		knob[i] = instance_create_layer(0, 0, "Knobs", knob_obj);
		knob[i].n = i;
	}
	knobs_calculate_position();
	
	for(var i = 11; i < 15; i ++)
	{
		knob[i].color = c[1];
	}
	
	instance_create_layer(0, 0, "Instances", audio_obj);
}

function a_point(_num) constructor{
	n = _num;
	nx = _num % 16;
	ny = floor(_num / 16);
	x = nx;
	y = ny;
	c = c_white;
	r = 1;
	a = 1;
	sub = 0;
}

function game_step(){
	// loop through every dot
	for(var i = 0; i < a_count; i ++)
	{
		var dot = a[i]; //
		var _kv; // knob value (defaults to 0, can range between -1 and 1)
		
		
		// --- ROW 1 --- //
		
		_kv = knob[0].value;
		if(_kv >= 0)
		{
			// cool motion
			var _modifier = _kv * 3;
			dot.x = dot.nx + sin(t * 0.94 + dot.n * 3) * _modifier;
			dot.y = dot.ny + cos(t * 1.7 + dot.n * 5) * _modifier;
		}
		else
		{
			// square motion
			var _modifier = -_kv * 3;
			dot.x = dot.nx + sin(t * 1.3 + dot.n % 16 * 12) * _modifier;
			dot.y = dot.ny + cos(t * 1.07 + floor(dot.n/16) * 12) * _modifier;
		}
		
		_kv = knob[1].value;
		if(_kv >= 0)
		{
			// depth motion
			dot.r = 0.5 + sin(-t * 2.3 + dot.nx) * 0.4 * _kv + 0.1;
			dot.a = 1 - dot.r;
		}
		else
		{
			// masking motion
			var squarex = (dot.nx - 7.5) * (dot.nx - 7.5);
			var squarey = (dot.ny - 7.5) * (dot.ny - 7.5);
			dot.r = sqrt(squarex + squarey) * (sin(t * 1.69) * 0.25 + 1) * -_kv + 0.1;
			dot.a = 1 - dot.r;
		}
		
		_kv = knob[2].value;
		if(_kv >= 0)
		{
			// whole block motion
			var pullx = sin(t * 1.21) * 32;
			var pully = cos(t * 0.83) * 32;
			dot.x = lerp(dot.x, dot.x + pullx, _kv * 0.2);
			dot.y = lerp(dot.y, dot.y + pully, _kv * 0.2);
		}
		else
		{
			// zooming motion
			var pullx = dot.x/16 * 32 - 7.5;
			var pully = dot.y/16 * 32 - 7.5;
			dot.x = lerp(dot.x, pullx, -_kv * sin(t * 1.55));
			dot.y = lerp(dot.y, pully, -_kv * sin(t * 1.55));
			dot.r *= -_kv * sin(t * 1.55) + 1;
			dot.a = 1 - dot.r;
		}
		
		_kv = knob[3].value;
		if(_kv >= 0)
		{
			// size increase
			dot.r += _kv + _kv * cos(dot.ny + t * 3.4 * _kv) * 0.2;
		}
		else
		{
			// draw clear reduction
			bg_alpha = lerp(bg_alpha_min, 0, -_kv);
		}
		
		_kv = knob[4].value;
		if(_kv >= 0)
		{
			// banding colors
			dot.c = colorify(_kv * sin(dot.nx * _kv + dot.ny * _kv + t * 1.34));
		}
		else
		{
			// unified colors cycling
			dot.c = colorify(sin(-t * _kv));
		}
		
		// --- ROW 2 --- //
		
		_kv = knob[5].value;
		if(_kv >= 0)
		{
			// flag waving
			dot.y += sin(dot.nx / 1.5 - t * 4.6) * _kv;
		}
		else
		{
			// twisting motion
			dot.x += cos(dot.n * t * 0.047) * _kv * 0.5;
		}
		
		
		_kv = knob[6].value;
		if(_kv >= 0)
		{
			// 3D plane rotation effect
			dot.y = lerp(dot.y, 7.5, _kv);
			dot.x = lerp(dot.x, (dot.ny - 7.5) * 1.5 + 7.5, _kv);
		}
		else
		{
			// snap to coordinates
			dot.x = lerp(dot.x, round(dot.x / 2) * 2, -_kv);
			dot.y = lerp(dot.y, round(dot.y / 2) * 2, -_kv);
		}
		
		_kv = knob[7].value;
		if(_kv >= 0)
		{
			// switch dot sprite
			dot.sub = floor(_kv * (sprite_sub_num - 1));
		}
		else
		{
			// change dot sprite in diagonal pattern
			dot.sub = (dot.x * -_kv - dot.y * -_kv + t * 2.3) % sprite_sub_num;
		}
		
		_kv = knob[8].value;
		if(_kv >= 0)
		{
			// a bunch of different positional mirroring
			var _mirror = round(_kv * 4);
			switch(_mirror)
			{
				case 1:
					if(dot.nx % 2 == 0) dot.y = dot.y * -1 + 15;
				break;
				
				case 2:
					if(dot.ny % 2 == 0) dot.x = dot.x * -1 + 15;
				break;
				
				case 3:
					if(dot.n % 3 == 0)
					{
						dot.x = dot.x + 3;
						dot.y = dot.y + 3;
					}
					if(dot.n % 2 == 0)
					{
						dot.x = dot.x -3;
						dot.y = dot.y -3;
					}
				break;
				
				case 4:
					if((dot.nx + dot.ny % 2) % 2 == 0)
					{
						dot.x = dot.x * -1 + 15;
						dot.y = dot.y * -1 + 15;
					}
				break;
			}
		}
		else
		{
			var _mirror = round(-_kv * 4);
			switch(_mirror)
			{
				case 1:
					if(dot.nx > 7.5)
					{
						dot.y = dot.y * -1 + 15;
					}

				break;
				
				case 2:
					if(dot.ny > 7.5)
					{
						dot.x = dot.x * -1 + 15;
					}
				break;
				
				case 3:
					if(dot.nx > 7.5)
					{
						dot.y = dot.y * -1 + 15;
					}
					if(dot.ny > 7.5)
					{
						dot.x = dot.x * -1 + 15;
					}
				break;
				
				case 4:
					if(dot.nx < 7.5)
					{
						dot.y = dot.y * -1 + 15 + 3 * sin(t * 0.2);
					}
					if(dot.ny < 7.5)
					{
						dot.x = dot.x * -1 + 15 - 3 * cos(t * 0.44);
					}
				break;
			}
		}
		
		_kv = knob[9].value;
		if(_kv >= 0)
		{
			if(dot.ny > sin(t * 0.9) * 7.5 + 7.5)
			{
				// dot radius wave effect
				dot.r += sin(t * 1.4) * _kv;
			}
			else
			{
				dot.r += cos(t * 1.4) * _kv;
			}
		}
		else
		{
			// really wild pattern stretching effect
			var _modifier = ((arctan2(dot.ny-7.5, dot.x + 7.5) - tan(t * 0.67))*2 - 1) * _kv;
			//dot.r += _modifier;
			dot.y = dot.y * _modifier + 7.5;
		}
		
		// --- ROW 3 --- //
		
		_kv = knob[10].value;
		if(_kv >= 0)
		{
			// tube effect
			dot.x = lerp(dot.x, (dot.x + 7.5 - cos(t * 0.23 + dot.nx / 2.55) * 8) * 0.5, _kv * 2);
			dot.y = lerp(dot.y, (dot.y + dot.y + sin(t * 0.23 + dot.nx / 2.55) * 2) * 0.5 + 0.5, _kv * 2);
		}
		else
		{
			// stretch and wave
			dot.y = lerp(dot.y, (dot.y - cos(t * 0.23 + dot.ny / 4) * 2) * 0.75, _kv * 2);
			dot.x = lerp(dot.x, (dot.x + dot.x + sin(t * 0.33 * 2 + dot.ny / 2) * 2) * 0.5, _kv * 2);
		}
		
		// audio knobs
		for(var j = 11; j < 15; j++)
		{
			
			_kv = knob[j].value;
			var _audio_setting = round(_kv * 2);
			var _track_num = j - 11;
			var _new_audio = -1;
			
			switch(_audio_setting)
			{
				case -3:
				case -2:
					_new_audio = 0;
				break;
				
				case -1:
					_new_audio = 1;
				break;
				
				case 1:
					_new_audio = 2;
				break;
				
				case 2:
				case 3:
					_new_audio = 3;
				break;
				
				case 0:
				default:
					_new_audio = -1;
				break;
			}
				
			audio_check_track_change(_track_num, _new_audio);
		}
		
	}
	
	if(keyboard_check_released(ord("F"))) window_set_fullscreen(!window_get_fullscreen());
	if(keyboard_check_released(ord("R"))) {
		var _knob_num = array_length(game_obj.knob);
		for(var i = 0; i < _knob_num; i ++)
		{
			game_obj.knob[i].value = 0;
		}
	}
	
	t += delta_time / 1000000;
}

function game_draw(){
	
	var _surfw = get_screen_width();
	var _surfh = get_screen_height();
	var _camx = camera_get_view_x(view_camera[0]);
	var _camy = camera_get_view_y(view_camera[0]);
	
	if(!surface_exists(game_surf))
	{
		
		game_surf = surface_create(_surfw, _surfh);
		surface_set_target(game_surf);
		draw_set_alpha(1);
		draw_rectangle_color(0, 0, _surfw, _surfh, bg_color, bg_color, bg_color, bg_color, false);
		surface_reset_target();
	}
	if(!surface_exists(ui_surf)) ui_surf = surface_create(_surfw, _surfh);
	if(!surface_exists(combo_surf)) combo_surf = surface_create(_surfw, _surfh);
	
	
	
	surface_set_target(game_surf);
	gpu_set_colorwriteenable(true, true, true, false);
	draw_set_alpha(bg_alpha);
	draw_rectangle_color(0, 0, _surfw, _surfh, bg_color, bg_color, bg_color, bg_color, false);
	draw_set_alpha(1);
	
	var _scale = game_obj.game_scale;
	var _dotsize = spacing * _scale * 16 - 16 * _scale;
	var _camw = _surfw;
	var _camh = _surfh;
	for(var i = 0; i < a_count; i ++)
	{
		var dot = a[i];
		var _dotx = (dot.x * spacing * _scale) + (_camw - _dotsize) / 2;
		var _doty = (dot.y * spacing * _scale) + (_camh - _dotsize - 208 * _scale) / 2;
		draw_sprite_ext(circle_spr, dot.sub, _dotx, _doty, dot.r * 0.5 * _scale, dot.r * 0.5 * _scale, 0, dot.c, dot.a);
	}
	
	gpu_set_colorwriteenable(true, true, true, true);

	
	surface_reset_target();
	
	surface_set_target(ui_surf);
	draw_clear_alpha(c_white, 0);
	for(var i = 0; i < knob_count; i++)
	{
		with(knob[i]) knob_draw();
	}
	surface_reset_target();
	
	surface_set_target(combo_surf);
	draw_clear_alpha(bg_color, 1);
	
	gpu_set_colorwriteenable(true, true, true, false);
	
	draw_surface(game_surf, 0, 0);
	draw_surface(ui_surf, 0, 0);

	
	surface_reset_target();
	
	draw_surface_stretched(combo_surf, _camx, _camy, surface_get_width(application_surface), surface_get_height(application_surface));
	
	if(keyboard_check_released(ord("S")) and (os_type == os_windows))
	{
		var _suggested = concat("knobs_", current_year,"-",current_month,"-",current_day,"_",current_hour,"-",current_minute,"-",current_second,".png");
		var _fname = get_save_filename("screenshot|*.png", _suggested);
		if(_fname != ""){
			screen_save(_fname);
		}
	}
	
	gpu_set_colorwriteenable(true, true, true, true);
	
}

function normalify(_num){
	return (_num + 1) * 0.5;
}

function colorify(_value){
	_value = normalify(_value);
	_value = clamp(_value, 0, 1);
	var _color_floor = floor(_value * 4);
	var _color_ceil = ceil(_value * 4);
	return(merge_color(c[_color_floor], c[_color_ceil], (_value - _color_floor / 4) * 4));
}