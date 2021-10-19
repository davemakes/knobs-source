
function knob_create(){
	value = 0;
	width = 48;
	height = 48;
	mx = 0;
	my = 0;
	clicked = false;
	color = game_obj.c[2];
	knobx = 0;
	knoby = 0;
	scale = 0.5;
}

function knobs_calculate_position(){
	var _scale = game_obj.game_scale;
	var _spacing = 48;
	var _knobsw = _spacing * _scale * 5 - 5 * _scale;
	var _knobsh = _spacing * _scale * 4 - 4 * _scale;
	var _camw = get_screen_width();
	var _camh = get_screen_height();
	var _knob_num = array_length(game_obj.knob);
	for(var i = 0; i < _knob_num; i ++)
	{
		game_obj.knob[i].x = (i % 5) * _spacing * _scale + (_camw - _knobsw - 5 * _scale) / 2;
		game_obj.knob[i].y = floor(i / 5) * _spacing * _scale + (_camh - _knobsh + 364 * _scale) / 2;
		game_obj.knob[i].width = _spacing * _scale;
		game_obj.knob[i].height = game_obj.knob[i].width;
	}
}

function knob_step(){
	if(clicked = false)
	{
		if(mouse_check_button_pressed(mb_left))
		{
			var _mx = window_mouse_get_x();
			var _my = window_mouse_get_y();
			if(point_in_rectangle(_mx, _my, x, y, x + width, y + height))
			{
				mx = window_mouse_get_x();
				my = window_mouse_get_y();
				clicked = true;
			}
		}
	}
	
	if(clicked = true)
	{
		value = clamp(value + (window_mouse_get_x() - mx + my - window_mouse_get_y()) * 0.01, -1, 1);
		mx = window_mouse_get_x();
		my = window_mouse_get_y();
		
		if(!mouse_check_button(mb_left)) clicked = false;
	}
}

function knob_draw(){
	var _scale = game_obj.game_scale;
	var _knobx = (x + 24 * _scale);
	var _knoby = (y + 24 * _scale);
	var _knobscale = 0.5 * _scale;
	var _dotscale = _knobscale * 0.2;
	draw_sprite_ext(circle_spr, 0, _knobx, _knoby, _knobscale, _knobscale, 0, color, 1);
	draw_sprite_ext(circle_spr, 0, (_knobx - sin(-value * pi * 0.75) * 5 * _scale), (_knoby - cos(-value * pi * 0.75) * 5 * _scale), _dotscale, _dotscale, 0, game_obj.bg_color, 1);
	draw_sprite_ext(label_spr, n, x, y, _knobscale, _knobscale, 0, color, 1);
}