/// @desc rgb_to_bgr - converts RGB int/hex to BGR real
/// @param rgb_color {real} example: $00BBFF or 48127
function rgb_to_bgr(argument0) {
	return (argument0 & $FF) << 16 | (argument0 & $FF00) | (argument0 & $FF0000) >> 16;
}
