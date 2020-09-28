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

int listIndex;

int nodeIndex;

/* 	List pool to store lists*/
List listPool[LISTSIZE];

/* 	Node pool to store nodes*/
Node nodePool[NODESIZE];
// List *freeNodePool;

// List freeNodesPool;
List *ListCreate(){
	printf("Got to procedure List create\n");
    if (listIndex < LISTSIZE)
    {
        List *list;
        list = &listPool[listIndex];
        if (list == NULL){
            printf("failed to create list.\n");
            return NULL;
        }
        // List %d is created.
        list->count = 0;
        list->head=NULL;
        list->tail = NULL;
        list->current = NULL;
        listIndex+=1;
        printf("list created\n");
        return list;
    }
    else
    {
        printf("failed to create: the max number of lists you can create is 5 you have exceed the limit");
    }
    
}
int ListCount(List *list){
    printf("Got to procedure ListCount\n");
    return list->count;
}
int ListAdd(List * list, void* item){
	printf("Got to procedure ListAdd\n");
    Node *newItem;
    newItem = &nodePool[nodeIndex];
    if (newItem == NULL)
        printf("failed to create item");
    else
    {
        newItem->item = &item;
        if (list->head == NULL) //insert to empty list
        {
            list->head = newItem;
            list->tail = newItem;
            list ->current = newItem;
            list->count++;
        }
        else 
        {
            newItem->prev = list->current;
            newItem->next = (list->current)->next;
            if (list->head == list->tail) //only one item in the
            {
                (list->current)->next = newItem; 
                list->tail = newItem;
                list->current = newItem;
            }
            else
            {
                (list->current)->next -> prev = newItem;
                list->current->next = newItem;
                list->current = newItem;
            }    
        }
            
    }
}
    
int ListInsert(List *list, void* item){
    printf("Got to procedure ListInsert");
    // Node newItem;
    // newItem = &nodePool[nodeIndex];
    // if (newItem == Null)
    //     printf("failed to create item");
    // else
    //     newItem->item = &item;
    //     if () 
}
int ListAppend(List *list, void* item){
    printf("Got to procedure ListAppend\n");
}
int ListPrepend(List *list, void* item){
    printf("Got to procedure ListPrepend");
}
void ListConcat(List *list1, List *list2){
    printf("Got to procedure ListConcat");
}