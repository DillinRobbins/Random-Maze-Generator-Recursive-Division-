/// @description Build the level
//Resize the room
room_width = (CELL_WIDTH/16) * 464;
room_height = (CELL_HEIGHT/16) * 464;

ground = 1;
wall = 2;
iteration = 0;

var reg0 = [];

// Set the grid width and height
width = room_width div CELL_WIDTH;
height = room_height div CELL_HEIGHT;

//Create the grids
grid = ds_grid_create(width, height);
datagrid = ds_grid_create(width, height);

//Fill the grids with the void
ds_grid_set_region(grid, 0, 0, width - 1, height - 1, VOID);

//Give every cell in the datagrid a number
for(var yy = 0; yy < height; yy++) {
	for(var xx =  0; xx < width; xx++){
	var grid_index = NameCell(xx,yy);
	datagrid[# xx, yy] = grid_index;
	}
}

// Randomize the engine randomizer seed
randomize();

//Fill the edges with walls
for(var xx = width-1; xx >= 0; xx--;) grid[# xx, 0] = WALL;
for(var xx = width-1; xx >= 0; xx--;) grid[# xx, height-1] = WALL;
for(var yy = height-1; yy >= 0; yy--;) grid[# width-1, yy] = WALL;
for(var yy = height-1; yy >= 0; yy--;) grid[# 0, yy] = WALL;


//Create an array for the initial region to divide by check all cells and adding non-wall cells
for(var yy = 0; yy < height; yy++) {
	for(var xx =  0; xx < width; xx++){
		if (grid[# xx, yy] != WALL) {
			// Add to reg0
			array_push(reg0, datagrid[# xx, yy])
		}
	}
}




//Divide the Room using an array of coordinates
function DivideRoom(reg_array){

//variable to use to check if the pop_seed is region a or b
var isregiona = true;

//Create set to keep track of which cells have been assigned to a region
set = ds_list_create();
ds_list_clear(set);

//create 2 new regions for the iteration
var rega = [];
var regb = [];
var regw = [];

var reg_array_index_cap = array_length(reg_array)-1;

//Choose 2 random index values from the region array
var irand1 = irandom(reg_array_index_cap);
var irand2 = irandom(reg_array_index_cap);

//convert to real coordinates from datagrid
var rand_coord1 = reg_array[irand1];
var rand_coord2 = reg_array[irand2];

//Check all sides of rand_coord1 and its own cell for rand_coord2 using datagrid and RegionSeedRandomizer function
var c2x = ExtractXCoord(rand_coord2);
var c2y = ExtractYCoord(rand_coord2);

if(rand_coord1 == rand_coord2 or (rand_coord1 == datagrid[# c2x+1, c2y]) or (rand_coord1 == datagrid[# c2x-1, c2y]) or (rand_coord1 == datagrid[# c2x, c2y+1]) or (rand_coord1 == datagrid[# c2x, c2y-1]))
rand_coord2 = RegionSeedRerandomize(reg_array, datagrid, rand_coord1, rand_coord2);

//set random values for seed coordinates random index values from the region array
var s1x = ExtractXCoord(rand_coord1);
var s1y = ExtractYCoord(rand_coord1);
var s2x = ExtractXCoord(rand_coord2);
var s2y = ExtractYCoord(rand_coord2);

//Create an array for each region
rega[0] = datagrid[# s1x, s1y];
regb[0] = datagrid[# s2x, s2y];
regw[0] = 0;

//Add the seed coordinates to the set list
ds_list_add(set, rega[0], regb[0]);

//Repeat the Cell division until the set is empty
while(ds_list_size(set) > 0){
	//repeat(50){

//Add the region seeds to a set to keep track o
var set_size_index_cap = ds_list_size(set)-1;
var rand = irandom(set_size_index_cap);
pop_seed = set[| rand];

cx = ExtractXCoord(pop_seed);
cy = ExtractYCoord(pop_seed);

//Create adjacent cell grid index value variables
var east_Cell = datagrid[# cx+1, cy];
var south_Cell = datagrid[# cx, cy-1];
var west_Cell = datagrid[# cx-1, cy];
var north_Cell = datagrid[# cx, cy+1];

//Check if the pop_seed is regiona
isregiona = RegionACheck(rega, pop_seed);

//check adjacent cells for other region a cells to prevent duplicates
if(isregiona = true){
var isregNa = RegionACheck(rega, datagrid[# cx, cy+1]);
var isregEa = RegionACheck(rega, datagrid[# cx+1, cy]);
var isregSa = RegionACheck(rega, datagrid[# cx, cy-1]);
var isregWa = RegionACheck(rega, datagrid[# cx-1, cy]);

//check all adjacent cells of East cell for bordering region b cells(1 cell seperation for walls)
if(grid[# cx+1, cy] != WALL and grid[# cx+1, cy] != DOOR and !isregEa){
	var b1 = datagrid[# cx+1, cy+1];
	var b2 = datagrid[# cx+2, cy];
	var b3 = datagrid[# cx+1, cy-1];
	var iscellEbad = RegionBCheck(regb, b1, b2, b3)
	
	//if no conflicts exist, add the cell's index value to the region and list
	if(!iscellEbad){
		array_push(rega, east_Cell);
		ds_list_add(set, east_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx+1, cy] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx+1, cy])
	}
}

// do the same for South
if(grid[# cx, cy-1] != WALL and grid[# cx, cy-1] != DOOR and !isregSa){
	var b1 = datagrid[# cx+1, cy-1];
	var b2 = datagrid[# cx, cy-2];
	var b3 = datagrid[# cx-1, cy-1];
	var iscellSbad = RegionBCheck(regb, b1, b2, b3);
	
	if(!iscellSbad){
		array_push(rega, south_Cell);
		ds_list_add(set, south_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx, cy-1] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx, cy-1]);
	}
}

//and West
if(grid[# cx-1, cy] != WALL and grid[# cx-1, cy] != DOOR and !isregWa){
	var b1 = datagrid[# cx-1, cy-1];
	var b2 = datagrid[# cx-2, cy];
	var b3 = datagrid[# cx-1, cy+1];
	var iscellWbad = RegionBCheck(regb, b1, b2, b3)
	
	if(!iscellWbad){
		array_push(rega, west_Cell);
		ds_list_add(set, west_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx-1, cy] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx-1, cy]);
	}
}

//and North
if(grid[# cx, cy+1] != WALL and grid[# cx, cy+1] != DOOR and !isregNa){
	var b1 = datagrid[# cx-1, cy+1];
	var b2 = datagrid[# cx, cy+2];
	var b3 = datagrid[# cx+1, cy+1];
	var iscellNbad = RegionBCheck(regb, b1, b2, b3)
	
	if(!iscellNbad){
		array_push(rega, north_Cell);
		ds_list_add(set, north_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx, cy+1] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx, cy+1]);
	}
	
	//After all adjacent cells have been added or skipped, remove the original seed_cell from the set list
	ds_list_delete(set, pop_seed);
}
}
else{
var isregNb = RegionBCheck(regb, datagrid[# cx, cy+1]);
var isregEb = RegionBCheck(regb, datagrid[# cx+1, cy]);
var isregSb = RegionBCheck(regb, datagrid[# cx, cy-1]);
var isregWb = RegionBCheck(regb, datagrid[# cx-1, cy]);

if(grid[# cx+1, cy] != WALL and grid[# cx+1, cy] != DOOR and !isregEb){
	var b1 = datagrid[# cx+1, cy+1];
	var b2 = datagrid[# cx+2, cy];
	var b3 = datagrid[# cx+1, cy-1];
	var iscellEbad = RegionACheck(rega, b1, b2, b3)
	
	
	//if no conflicts exist, add the cell's index value to the region and list
	if(!iscellEbad){
		array_push(regb, east_Cell);
		ds_list_add(set, east_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx+1, cy] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx+1, cy]);
	}
}

// do the same for South
if(grid[# cx, cy-1] != WALL and grid[# cx, cy-1] != DOOR and !isregSb){
	var b1 = datagrid[# cx+1, cy-1];
	var b2 = datagrid[# cx, cy-2];
	var b3 = datagrid[# cx-1, cy-1];
	var iscellSbad = RegionACheck(rega, b1, b2, b3);
	
	if(!iscellSbad){
		array_push(regb, south_Cell);
		ds_list_add(set, south_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx, cy-1] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx, cy-1]);
	}
}

//and West
if(grid[# cx-1, cy] != WALL and grid[# cx-1, cy] != DOOR and !isregWb){
	var b1 = datagrid[# cx-1, cy-1];
	var b2 = datagrid[# cx-2, cy];
	var b3 = datagrid[# cx-1, cy+1];
	var iscellWbad = RegionACheck(rega, b1, b2, b3)
	
	if(!iscellWbad){
		array_push(regb, west_Cell);
		ds_list_add(set, west_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx-1, cy] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx-1, cy]);
	}
}

//and North
if(grid[# cx, cy+1] != WALL and grid[# cx, cy+1] != DOOR and !isregNb){
	var b1 = datagrid[# cx-1, cy+1];
	var b2 = datagrid[# cx, cy+2];
	var b3 = datagrid[# cx+1, cy+1];
	var iscellNbad = RegionACheck(rega, b1, b2, b3)
	
	if(!iscellNbad){
		array_push(regb, north_Cell);
		ds_list_add(set, north_Cell);
	}
	else{
		var dup = false;
		for(xx = 0; xx < array_length(regw); xx++;){
			if(datagrid[# cx, cy+1] == regw[xx]){
				var dup = true;
				break;
			}
			}
			if(!dup) array_push(regw, datagrid[# cx, cy+1]);
	}
	}
}
var seed = ds_list_find_index(set, pop_seed);
	ds_list_delete(set, seed);
}
//Delete the place holder index in wall array
array_delete(regw, 0, 1);

//Determine number of doors to spawn by wall length
var regw_size = array_length(regw);

//if(8 < regw_size) var xx = 2;
//else if(  regw_size < 8) var xx = 1;
//else if(regw_size == 0) var xx = 0;

//Set doors
var door_count = 2;
var rand_doors = irandom(door_count)
if(rand_doors == 0) var xx = 2;
else xx = 1;
for(var draw = 0; draw < xx; draw++;){
	var regw_index_cap = array_length(regw);
	regw_index_cap -= 1;
	var rand = irandom(regw_index_cap);
	var door = regw[rand];
	var doorx = ExtractXCoord(door);
	var doory = ExtractYCoord(door);
	grid[# doorx, doory] = DOOR;
	array_delete(regw, rand, 1);
}




//Set walls
var regw_size = array_length(regw);
for(xx = 0; xx < regw_size; xx++;){
	var wall = regw[xx];
	var wallx = ExtractXCoord(wall);
	var wally = ExtractYCoord(wall);
	grid[# wallx, wally] = WALL;
}

//array_delete(regw, 0, array_length(regw));


if(array_length(rega) > 80){
	iteration += 1;
	DivideRoom(rega);
}

if(array_length(regb) > 80){
	iteration += 1;
	DivideRoom(regb);
}

//Check the total area of the region a. If room is too big,
//recursively run this funcion on that region.
/*if(array_length(rega) >= 30){
	iteration += 1;
	DivideRoom(rega);
}
else if(12 < array_length(rega) < 30){
	var rand = irandom(3);
	if(rand != 0){ 
		iteration += 1;
		DivideRoom(rega);
	}*/
}

//Do the same for region b
/*if(array_length(regb) > 15){
	iteration += 1;
	DivideRoom(regb);
}
else if(8 < array_length(regb) < 15){
	var rand = irandom(3);
	if(rand != 0){
		iteration += 1;
		DivideRoom(regb);
	}
}*/


DivideRoom(reg0);
//DivideRoom(rega);
//DivideRoom(regb);


ds_list_destroy(set);

// Draw the level using the grid
var lay_id = layer_get_id("Tiles_Map");
var map_id = layer_tilemap_get_id(lay_id);

for(var yy = 0; yy < height; yy++) {
	for(var xx =  0; xx < width; xx++){
		if (grid[# xx, yy] == FLOOR or grid[# xx, yy] == DOOR or grid[# xx, yy] == VOID) {
			// Draw the floor
			tilemap_set(map_id, ground, xx, yy)
		}
		else if(grid[# xx, yy] == WALL) {
			// Draw the wall
			tilemap_set(map_id, wall, xx, yy)
		}
	}
}