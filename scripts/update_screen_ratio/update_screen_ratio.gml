function update_screen_ratio(){
	var _ww = game_obj.ww;
	var _wh = game_obj.wh;
	
	if(window_get_width() < _ww) window_set_size(_ww, window_get_height());
	if(window_get_height() < _wh) window_set_size(window_get_width(), _wh);
	
	var max_w = max(window_get_width(), _ww);
	var max_h = max(window_get_height(), _wh);
	var intended_aspect = _ww / _wh;
	var aspect = max_w / max_h;
	
	
	game_obj.prev_window_width = max_w;
	game_obj.prev_window_height = max_h;
	
	if(surface_exists(game_obj.game_surf)) surface_free(game_obj.game_surf);
	if(surface_exists(game_obj.ui_surf)) surface_free(game_obj.ui_surf);
	if(surface_exists(game_obj.combo_surf)) surface_free(game_obj.combo_surf);
	
	if(aspect < intended_aspect)
	{
		//portrait
		var VIEW_WIDTH = max(_ww, max_w);
		var VIEW_HEIGHT = ceil(VIEW_WIDTH / aspect);
	}
	else
	{
		//landscape
		var VIEW_HEIGHT = max(_wh, max_h);
		var VIEW_WIDTH = ceil(VIEW_HEIGHT * aspect);
	}
	camera_set_view_size(view_camera[0], floor(VIEW_WIDTH), floor(VIEW_HEIGHT));
	camera_set_view_pos(view_camera[0], floor((ww - VIEW_WIDTH)/2), floor((wh - VIEW_HEIGHT)/2));

	surface_resize(application_surface, VIEW_WIDTH, VIEW_HEIGHT);
	game_obj.game_scale = min(VIEW_WIDTH / ww, VIEW_HEIGHT / wh);
	knobs_calculate_position();
}

function check_screen_ratio() {
	if(window_get_width() != game_obj.prev_window_width or window_get_height() != game_obj.prev_window_height)
	{
		update_screen_ratio();
	}
}

function get_screen_width() {
	return camera_get_view_width(view_camera[0]);
}

function get_screen_height() {
	return camera_get_view_height(view_camera[0]);
}