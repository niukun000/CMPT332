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
#define LISTSIZE	6
#define NODESIZE	100

int listIndex=1;
int nodeIndex=0;

/* 	List pool to store lists*/
List listPool[LISTSIZE];

/*list of used node ready for reuse*/
List *freeNodePool = &listPool[0];
// freeNodePool.head = NULL
/* 	Node pool to store nodes*/
Node nodePool[NODESIZE];


List *ListCreate(){
    if (listIndex < LISTSIZE)
    {
        List *list;
        if (listIndex >LISTSIZE){
            return NULL;
        }
        list = &listPool[listIndex];
        if (list == NULL){
            return NULL;
        }
        list->count = 0;
        list->head=NULL;
        list->tail = NULL;
        list->current = NULL;
        listIndex+=1;
        printf("list created\n");
        return &listPool[listIndex];
    }
    else
    {
        // printf("failed to create: the max number of lists you can create is 5 you have exceed the limit");
        return NULL;
    }  
}

int ListAdd(List * list, void* item){
    if (list == NULL){
        return -1;
    }
    Node *new;
    if (freeNodePool->head !=NULL){
        new = freeNodePool->head;
        freeNodePool->head=freeNodePool->head->next;
    }
    else{
        new = &nodePool[nodeIndex];
        nodeIndex++;
    }
    if (new== NULL){
        return -1;
    } 
    new->next = NULL;
    new ->prev = NULL;   
    new->item = item;      
    if (list->head == NULL) //insert to empty list
    {
        list->head = new
        ;
        list->tail = new
        ;
        list ->current = new
        ;
        list->count++;
        return 0;
    }
    else 
    {    
        new->prev = list->current;
        new->next = (list->current)->next;
        
        if (list->current == list->tail){
            (list->current)->next = new
            ;
            list->tail = new
            ;
            list->current = new
            ;
            return 0; 
        }
        else
        {
            long i = (long)((list->current)->item);

            (list->current)->next -> prev = new
            ;
            list->current->next = new
            ;
            list->current = new
            ;
            return 0;
        }
            
    }
            


    return -1;
    
}
    
int ListInsert(List *list, void* item){
    if (list == NULL){
        return -1;
    }
    Node *new;
    if (freeNodePool->head !=NULL){
        new = freeNodePool->head;
        freeNodePool->head=freeNodePool->head->next;
    }
    else{
        new = &nodePool[nodeIndex];
        nodeIndex++;
    }
    if (new == NULL){
        return -1;
    } 
    new->next = NULL;
    new ->prev = NULL;
    new->item = item; 
    if (list->head==NULL) //insert to empty list
    {
        list->head = new ;
        list->tail = new ;
    }
    else
    {   
        new->prev = (list->current)->prev;
        new->next = list->current;

        if (list->current == list->head)//if current == head
        {
            (list->current)->prev = new;
            list->head = new;
        }
        else
        {
            ((list->current)->prev)->next = new;
            (list->current)->prev = new ;
        }                 
    }
    list->count++;
    list->current = new;
    return 0;

}
int ListAppend(List *list, void* item){
    if (list == NULL){
        return -1;
    }
    Node *new;    
    if (freeNodePool->head !=NULL){
        new = freeNodePool->head;
        freeNodePool->head=freeNodePool->head->next;
    }
    else{
        new = &nodePool[nodeIndex];
        nodeIndex++;
    }
   if (new == NULL){
        return -1;
    }
    new->next = NULL;
    new ->prev = NULL;
    new->item = item;
    if (list->head==NULL){            //append to empty list.
        list->head = new;
        list->tail = new;
        list->current = new;
        list->count++;
        return 0;
    }
    (list->tail)->next = new;
    new->prev = list->tail;
    list->current = new;
    list->tail = new;
    list->count ++;
    return 0;
}

int ListPrepend(List *list, void* item){   
    if (list == NULL){
        return -1;
    }
    Node* new;
    if (freeNodePool->head !=NULL){
        new = freeNodePool->head;
        freeNodePool->head=freeNodePool->head->next;
    }
    else{
        new = &nodePool[nodeIndex];
        nodeIndex++;
    }
    if (new == NULL){
        return -1;
    }
    new->next = NULL;
    new ->prev = NULL;

    new->item = item;
    nodeIndex++;
    if (list->head==NULL) {             //prepend to empty list.
        list->tail = new;
    } 
    else {                
        list->head->prev = new;
        new->next = list->head;
    }
    list->head = new;
    list->current = new;
    list->count++;
    return 0;
}
void ListConcat(List *list1, List *list2){
    if(list1->head==NULL){
        list1 = list2;
    } 
    else{ 
        if (list2->head!=NULL){
        (list1->tail->next) = list2->head;
        list2->head->prev = list1->tail;
        list1->tail = list2->tail;
        }
    }
    list2->count = 0;
    list2->current = NULL;
    list2->head = NULL;
    list2->tail = NULL;    
}


