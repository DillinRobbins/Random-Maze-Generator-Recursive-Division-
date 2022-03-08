// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function RegionSeedRerandomize(array, datagrid, coord1, coord2){
	
	var c2x = ExtractXCoord(coord2);
	var c2y = ExtractYCoord(coord2);
	
	//Check
	while (coord1 == coord2 or (coord1 == datagrid[# c2x+1, c2y]) or (coord1 == datagrid[# c2x-1, c2y]) or (coord1 == datagrid[# c2x, c2y+1]) or (coord1 == datagrid[# c2x, c2y-1]))
	{
		SimpleRerandomize(coord2, coord1, array_length(array)-1);
	}

}