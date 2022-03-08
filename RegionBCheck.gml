// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function RegionBCheck(regb_array, b1, b2 = -10, b3 = -10){

var length = array_length(regb_array);

for(var xx = 0; xx < length; xx++;)
{
	if((b1 == regb_array[xx]) or (b2 == regb_array[xx]) or (b3 == regb_array[xx])) return true;
	
}

return false;
}