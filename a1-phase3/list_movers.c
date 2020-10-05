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

int ListCount(List *list){
    return list->count;
}

void *ListNext(List *list){

    if(list->count==0){
        printf("empty list");
        return NULL;
    }
    if (list->current->next==NULL){

        return NULL;
    }
    list->current = list->current->next;
}

void *ListPrev(List *list){
    if (list->count==0){
        printf("empty list");
    }
    if (list->current->prev==NULL){
        return NULL;
    }
}

void *ListFirst(List *list){
    if (list->current==0){
        printf("empty list\n");
        return NULL;
    }
    // List *newlist = list ;
    list->current = list->head;
    return list->current->item;
}

void *ListLast(List *list){
        if (list->current == 0){
        return NULL;
    }
    list->current = list->tail;
    return list->current->item;
}

void *ListCurr(List *list){
        if (list->current == 0){
        return NULL;
    }
    return list->current->item;
}

void *ListSearch(List *list, void* comparator, void *comparisonArg){
    if (list->count==0){
        return NULL;
    }
    Node* n = list->current;
    int (*fun_ptr)(void* , void*)= comparator;
    do{
        // if ((*fun_ptr) (n->item, comparisonArg)){
        //     return 0;
        // }
        n = n->next;
    }while (n != NULL);
    return NULL;
}