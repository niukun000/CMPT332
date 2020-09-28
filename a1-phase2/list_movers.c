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

#include "list.h"

void *ListNext(List *list){
    printf("Got to procedure ListNext");
}
void *ListPrev(List *list){
printf("Got to procedure ListPrev");
}
void *ListFirst(List *list){
printf("Got to procedure ListFirst");
}
void *ListLast(List *list){
printf("Got to procedure ListLast");
}
void *ListCurr(List *list){
printf("Got to procedure ListCurr");
}
void *ListSearch(List *list, void* comparator, void *comparisonArg){
printf("Got to procedure ListSearch");
}