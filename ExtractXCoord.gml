// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ExtractXCoord(str){

var xcoord = string_delete(str, 3, 2);
xcoord = real(xcoord);

return xcoord;
}