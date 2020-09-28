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
#include <assert.h>
#include "list.h"

void printList(List * list){
    
    if (list->count == 0)
    {
        printf("empty list")  ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    }
    else{
        // Node * l = list->head;
        long * h = (long* )((list->head)->next->item);
        printf("%ld", *h);
        long * c = (long* )((list->current)->item);
        printf("%ld", *c);
        // while (l-> next != NULL ){
            long * t = (long* )((list->tail)->item);
            printf("%ld", *t);
            // l = l->next;
        // }
    }
}
int main(int argc, char *argv[])
{


    printf("create list\n");
    List *list1 = ListCreate();
    assert(list1 != NULL);
    // ListInsert(list1, &1)
    // printf("ListAdd into an empty list\n");
    // int i = 1;
    // ListAdd(list1, &i);
    // printf("ListAdd\n");
    // int i = 2;
    int failed = 0;
    if (ListAdd(list1,  (void*)1) != 0)
    {
        printf("failed to add in a empty list\n");
        failed++;
    }
    // printList(list1);
    if (ListAdd(list1,  (void*)2) != 0)
    {
        printf("failed to add 2\n");
        failed++;
    }
    // printList(list1);
    if (ListAdd(list1,  (void*)3) != 0)
    {
        printf("failed 3\n ");
        failed++;
    }

      if (ListInsert(list1,  (void*)4) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    if (ListInsert(list1,  (void*)5) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    if (ListPrepend(list1,  (void*)6) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }

    if (ListInsert(list1,  (void*)7) != 0)
    {
        printf("failed 7\n ");
        failed++;
    }
    if (ListInsert(list1,  (void*)8) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
        if (ListInsert(list1,  (void*)9) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
        if (ListInsert(list1,  (void*)8) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printf("did 10 operations %d failed\n ", failed);
    // printList(list1);
    // int a = 2;
    // ListAdd(list1, &a);
    // int b = 3;
    // ListAdd(list1, &b);
    // printList(list1);
    // printnode();
    
}
 
