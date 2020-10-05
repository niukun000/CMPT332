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

extern List * freeNodePool;
void compareString(){
}
void compareInteger(void* a, void * b){
    // int *c = (int*)a;
    // int *d = (int*)b;
    // return NULL;
}           
void itemFree(void* item){
    
}
// ListSearch(list, compareInteger,3);
void printList(List * list){
    
    if (list->count == 0)
    {
        printf("empty list")  ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    }
    else{      
        printf("\nlist items: ");
        Node * l = list->head;
        do
        {
            int * s = (int*)(l->item);
            printf("%d\t",*s);
            l = l->next;
        }
        while (l != NULL);
        printf("list current: %d \n\n", *(int*)(list->current)->item);
    }
}

void printStringList(List * list){
    
    if (list->count == 0)
    {
        printf("empty list")  ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    }
    else{      
        printf("\nlist items: ");
        Node * l = list->head;
        do
        {
            char * s = (char*)(l->item);
            printf("%s\t",s);
            l = l->next;
        }
        while (l != NULL);
        printf("list current: %s \n\n", (char*)(list->current)->item);
    }
}

int main(int argc, char *argv[])
{
    int failed = 0;
    printf("create list1\n");
    List *list1 = ListCreate();
    assert(list1 != NULL);
    // char * list1name = "list1";
    printf("crreate list2");
    List *list2 = ListCreate();
    assert(list2 != NULL);
    printf("create list 3");
    List *list3 = ListCreate();
    assert(list3 != NULL);
     printf("create list 4");    List *list4 = ListCreate();
    assert(list4 != NULL);
     printf("create list 5");
    List *list5 = ListCreate();
    assert(list5 != NULL);

    // List *list6 = ListCreate();
    // assert(list6 != NULL, "over list limit");



    
    printf("append to empty list\n");
    int app = 1;
    printf("appending 1 to list3\n");
    ListAppend(list3, &app);
    printList(list3);

    printf("insert to empty list\n inserting 1 to list 4\n");
    ListInsert(list4, &app);
    printList(list4);

    int pp = 3;
    printf("prepend to empty list\n prepending 3 to list 5\n");
    ListPrepend(list5, &pp);
    printList(list5);

    printf("delete from list with 1 item\n removing from list4\n");
    ListRemove(list4);
    printList(list4);

    printf("removing from empty list");
    ListRemove(list4);
    printList(list4);
    
    printf("testing for list trim\n trim from list with 1 item\n");
    ListTrim(list5);
    printList(list5);

    printf("trmming from empty list\n");
    ListTrim(list5);

    // printf("insert to list with 1 itemn\n");
    // printf("inserting 2into list3 \n before insert\n");
    // int ins = 2;
    // // ListInsert(list3, &ins);
    // printf("after insert");
    // printList(list3);

    // printf("append to list with 1 item \appending 3 to list 3\n");
    // int appp = 3;
    // ListAppend(list3, &appp);
    // printList(list3);

    // printf("removing list when tail is current\n");
    // ListRemove(list3);
    // printList(list3);



    printf("testing for strings\n");
    printf("adding string into list2\n");
    char * string1 = "my string";
    ListAdd(list2, string1);
    printStringList(list2);

  

    printf("add to empty list\n");
    printf("adding 1\n");
    int a = 1;
    ListAdd(list1,  &a);

    printList( list1);
    printf("adding 2");
    int b = 2;
    if (ListAdd(list1,  &b) != 0)
    {
        printf("failed to add 2\n");
        failed++;
    }
    printList( list1);

    printf("adding 3");
    int c = 3;
    if (ListAdd(list1,  &c) != 0)
    {
        printf("failed 3\n ");
        failed++;
    }
    printList( list1);

    int d = 4;
 

    printf("inserting 4");
    if (ListInsert(list1,  &d) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList( list1);

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
    printList( list1);

    printf("prepending 6");
    if (ListPrepend(list1,  &f) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList( list1);

    printf("inserting 7");
    if (ListInsert(list1,  &g) != 0)
    {
        printf("failed 7\n ");
        failed++;
    }
    printList( list1);

    printf("inserting 8");
    if (ListInsert(list1,  &h) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList( list1);

    printf("appending 9");
        if (ListAppend(list1,  &i) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }
    printList( list1);

    printf("inserting 10");
    int j = 10;
        if (ListInsert(list1,  &j) != 0)
    {
        printf("failed 4\n ");
        failed++;
    }

    printList( list1);

    printf("trimming list");
    if (ListTrim(list1)==NULL){
        printf("failed to trim");
    }
    printList(list1);
    printf("removing current node");
    if (ListRemove(list1)==NULL){
        printf("failed to remove");

    }
    printList(list1);
    printf("\ndid 10 operations %d failed\n ", failed);
    printList(freeNodePool);

    printf("searching for 2 from the list");
    int searcha = 2;
    // void * comp = (void*)compareInteger;
    if(ListSearch(list1, NULL, &searcha)){
        printf("%d is in the list", searcha);
    }
    else printf("2 is not in the list");
    // ListFree(list1, NULL);
} 