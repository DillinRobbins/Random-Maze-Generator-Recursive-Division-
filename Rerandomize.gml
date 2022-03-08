// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Rerandomize(int1, int2, xx, yy){

while(int2 == int1 or int2 == (int1-1) or int2 == (int1+1))
{
	int2 = irandom_range(xx, yy)
}

return int2;
}