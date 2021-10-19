
function audio_init(){
	
	track_setting = [-1, -1, -1, -1];
	
	track = [ambient_0, ambient_1, ambient_2, ambient_3, bass_0, bass_1, bass_2, bass_3, mid_0, mid_1, mid_2, mid_3, lead_0, lead_1, lead_2, lead_3];

}

function audio_step(){
	
}

function audio_check_track_change(_track, _new_audio){
	with(audio_obj)
	{
		if(track_setting[_track] != _new_audio)
		{
			var _current_audio = get_current_audio_id(_track);
		
			// check for stopping track
			if(_new_audio < 0)
			{
				if(_current_audio >= 0)
				{
					
					audio_stop_sound(_current_audio);
				}
				track_setting[_track] = -1;
			}
			else
			{
				// if a track is playing
				if(_current_audio >= 0)
				{
					audio_stop_sound(_current_audio);
					
				}
				else
				{
					
				}
			
				audio_play_sound(get_audio_id(_track, _new_audio), 0, true);
				track_setting[_track] = _new_audio;
			}
			track_change_sfx();
		}
	}
}

function get_audio_id(_track, _num){
	
	if(_num < 0) return _num;
	
	return(audio_obj.track[_track * 4 + _num]);
}

function get_current_audio_id(_track){
	return(get_audio_id(_track, audio_obj.track_setting[_track]));	
}

function track_change_sfx(){
	audio_play_sound(knob_click, 0, false);
}