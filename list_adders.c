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

#include list.h


LIST *ListCreate(){
	printf("Got to procedure Listcreate")
	List * list;
	list->ListFirst = NULL;
	list->ListLast = NULL;
	list->ListCurr = NULL;
	list->ListCount = 0;
}
int ListCount(list){
    printf("Got to procedure ListCount")
}
int ListAdd(list, item){
	printf("Got to procedure ListAdd")
}
int ListInsert(list, item){
    printf("Got to procedure ListInsert")
}
int ListAppend(list, item){
    printf("Got to procedure ListAppend")
}
int ListPrepend(list, item){
    printf("Got to procedure ListPrepend")
}
void ListConcat(list1, list2){
    printf("Got to procedure ListConcat")
}