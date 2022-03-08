// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SimpleRerandomize(int1, int2, xx){

while(int2 == int1)
{
	int2 = irandom(xx)
}

return int2;
}