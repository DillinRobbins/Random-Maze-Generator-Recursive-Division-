// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function NameCell(xcoord, ycoord){
var char12 = string(xcoord);
var char34 = string(ycoord);

if(string_length(char12) == 1) char12 = "0" + char12;
if(string_length(char34) == 1) char34 = "0" + char34;

var cellid = char12 + char34;

return cellid;
}