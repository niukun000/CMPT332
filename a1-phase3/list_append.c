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

void printList(char *listname, List * list){
    // char* s = (char*)listname;
    if (list->count == 0)
    {
        printf("empty list")  ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    }
    else{
        printf("list name: %s \tcurrent position: %d \n list items: ", *listname, *(int*)(list->current)->item);
        Node * l = list->head;
        do
        {
            printf("%d\t",*(int*)(l->item));
            l = l->next;
        }while (l != NULL);
        printf("\n\n");
    }
}

int main(int argc, char *argv[])
{

    int failed = 0;
    printf("create list1\n");
    List *list1 = ListCreate();
    assert(list1 != NULL);
    char * list1name = "list1";
    printf("adding 1\n");
    int a = 1;
    if (ListAdd(list1,  &a) != 0)
    {
        printf("failed to add in a empty list\n");
        failed++;
    }
    printf("1 added");
    printList(list1name, list1);

    printf("adding 2");
    int b = 2;
    if (ListAdd(list1,  &b) != 0)
    {
        printf("failed to add 2\n");
        failed++;
    }
    printList(list1name, list1);

    printf("adding 3");
    int c = 3;
    if (ListAdd(list1,  &c) != 0)
    {
        printf("failed 3\n ");
        failed++;
    }
    printList(list1name, list1);

    int d = 4;
 

    printf("inserting 4");
    if (ListInsert(list1,  &d) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList(list1name, list1);

    int e,f,g,h,i;
    e = 5;
    f = 6;
    g = 7;
    h = 8;
    i = 9;

    printf("inserting 5");
    if (ListInsert(list1,  &e) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList(list1name, list1);

    printf("prepending 6");
    if (ListPrepend(list1,  &f) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList(list1name, list1);

    printf("inserting 7");
    if (ListInsert(list1,  &g) != 0)
    {
        printf("failed 7\n ");
        failed++;
    }
    printList(list1name, list1);

    printf("inserting 8");
    if (ListInsert(list1,  &h) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList(list1name, list1);

    printf("appending 9");
        if (ListAppend(list1,  &i) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList(list1name, list1);

    printf("inserting 10");
    int j = 10;
        if (ListInsert(list1,  &j) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList(list1name, list1);
    printf("\ndid 10 operations %d failed\n ", failed);


}