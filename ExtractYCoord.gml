// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ExtractYCoord(str){

var ycoord = string_delete(str, 1, 2);
ycoord = real(ycoord);

return ycoord;
}