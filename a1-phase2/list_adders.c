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

void printnode(){
    for(int i = 0; i < 8; i++){
    long * n = (long* )((&nodePool[i])->item);
    printf("%d\t", &nodePool[i]);
    printf("%d item pool\n", *n); 
    }
}
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
        return &listPool[listIndex];
    }
    else
    {
        printf("failed to create: the max number of lists you can create is 5 you have exceed the limit");
        // return -1;
    }
    
}
int ListCount(List *list){
    printf("Got to procedure ListCount\n");
    return list->count;
}
int ListAdd(List * list, void* item){
	printf("Got to procedure ListAdd\n");
    Node *new
    ;
    new
     = &nodePool[nodeIndex];
    new
    ->next = NULL;
    new
    ->prev = NULL;

    nodeIndex++;
    // printf("\nnode index %d\n", nodeIndex);
    if (new
     == NULL){
        printf("failed to create item");
        return -1;
    }    
    else
    {
        
        new->item = &item;
        if (list->count == 0) //insert to empty list
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
            // long * n = (long* )((&nodePool[0])->item);
            // printf("%d item pool\n", *n);      
            new
            ->prev = list->current;
            new
            ->next = (list->current)->next;
          
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
                printf("current item%d",i);
                (list->current)->next -> prev = new
                ;
                list->current->next = new
                ;
                list->current = new
                ;
                return 0;
            }
               
        }
            
    }

    return -1;
    
}
    
int ListInsert(List *list, void* item){
    printf("Got to procedure ListInsert\n");
    Node *new
    ;
    new= &nodePool[nodeIndex];
    if (new
     == NULL){
        printf("failed to create item");
        return -1;
    }  
    else
    {
        nodeIndex++;
        new->item = &item;
            
   
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
            // long * n = (long* )((&nodePool[0])->item);
            // printf("%d item pool\n", *n);    
            new
            ->prev = (list->current)->prev;
            new
            ->next = list->current;

            if (list->current == list->head)//if current == head
            {
                (list->current)->prev = new
                ;
                list->head = new
                ;
                return 0;
            }
            else
            {
                ((list->current)->prev)->next = new
                ;
                (list->current)->prev = new
                ;
                list->current = new
                ;
                return 0;
            }
                
            
            
        }
    }
        
    return -1;

}
int ListAppend(List *list, void* item){
    printf("Got to procedure Append\n");
    Node *new;
    new = &nodePool[nodeIndex];
    if (new == NULL){
        printf("failed to add item %d \n", *(int*)item);
        return -1;
    }
    nodeIndex++;
    new->item = &item;
    new->next = NULL;
    new->prev = NULL;

    if (list->head == NULL){
        list->head = new;
        list->tail = new;
        list->current = new;
        list->count++;
      
        //Node append to empty list.
        return 0;
    }
    (list->tail)->next = new;
    new->prev = list->tail;
    list->current = new;
    list->tail = new;
    list->count +=1;
  
            //     long * n = (long* )((&nodePool[0])->item);
            // printf("%d item pool\n", *n); 

    return 0;
}

int ListPrepend(List *list, void* item){
    printf("Got to procedure ListPrepend\n");
    
    
    if (list == NULL){
        return -1;
    }
    Node* new;
    new= &nodePool[nodeIndex];
    new->next = NULL;
    new->prev = NULL;
    new->item = &item;
    nodeIndex++;
    /* If list is empty */
    if (list->count == 0) {
        list->tail = new;
        new->next = NULL;
    } else {
                 
        list->head->prev = new;
        new->next = list->head;
    }

    list->head = new;
    new->prev = NULL;
    list->current = new;
    list->count++;
    
    //    long * n = (long* )((&nodePool[1])->item);
    //         printf("%d item pool\n", *n);  
    return 0;
    
}
void ListConcat(List *list1, List *list2){
    printf("Got to procedure ListConcat");
}


