/*
Kun Niu
kun869
11242427
*/

/*
Boru sun, 
bos226, 
11233036
*/

#include <stdio.h>
#include <stdlib.h>

int Square(int N){
    if (N == 0) return 0;
	return (Square(N-1) + N + N - 1);
}