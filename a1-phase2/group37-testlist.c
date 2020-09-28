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

int printList(List * list){
    List * l = list;
    if (l->count == 0)
    {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    }
    l->current = list->head;
    while (l-> current != NULL ){
        printf("%s", (l->current)->item);
        l->current = (l->current)->next;
    }
}
int main(int argc, char *argv[])
{
    printf("create list\n");
    List *list1 = ListCreate();
    int i = 1;
    // ListInsert(list1, &1)
    // printf("ListAppend into an empty list\n");
    // int i = 1;
    // ListAppend(list1, &i);
    // printf("ListAdd\n");
    // int i = 2;
    ListAdd(list1, &i);
    printList(list1);
    int a = 2;
    ListAdd(list1, &a);
    int b = 3;
    ListAdd(list1, &b);
    printList(list1);
    return 0;
}

 