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
extern List *freeNodePool;
// extern FreeList *freeList;
// freeNodePool = ListCreate();

void *ListRemove(List *list){
    if (list->head==NULL){                    //remove from empty list
        return NULL;
    }
    Node *new = list->current;
    if (list->head==list->tail){                    //remove only item in the list
        list->count = 0;
        list->head=NULL;
        list->tail = NULL;
        list->current = NULL;
    }
    else {
        if(list->current==list->head){     //remove list head
            list->current = list->current->next;
            list->head = list->current;
            list->head->prev = NULL;
        }  
        else {
            if (list->current==list->tail){    //remove list tail
                    list->current = list->current->prev;
                    list->tail = list->current;
                    list->tail->next = NULL;
            }
            else {                                  //remove from middle of the list
                new->prev->next = new->next;
                new->next->prev = new->prev;
                list->current = new->next;
            }
        }
    }

    /*prepending removed node to freenodepool*/
    new->next = freeNodePool->head;
    freeNodePool->head = new;

    return new->item;

}
void ListFree(List *list, void* itemFree){
    void (*fun_ptr)(void*) = itemFree;
    Node *iter = list->head;
    while (iter!=NULL){
        (*fun_ptr)(iter->item);
        iter = iter->next;
        // iter->item=NULL;
    }
    
    ListConcat(freeNodePool, list);
    // FreeList *new = freeList;
    // if (freeList->head == NULL){
    //     freeList->head = list;
    //     freeList->next = NULL;
    // }
    // else{
    //     freeList->head = list;
    //     freeList->next = new;
    //     {
    //         /* data */
    //     };
        
    // }
}
void *ListTrim(List *list){
    Node *new = list->tail;
    if (list->head==NULL){                    // Trim an empty list
        return NULL;
    }
    if (list->head==list->tail){                    //Trim list head
        list->count = 0;
        list->head=NULL;
        list->tail = NULL;
        list->current = NULL;
    }
    else {
        list->tail = new->prev;
        list->current = list->tail;
        list->tail->next=NULL;
    }

    /*prepending removed node to freenodepool*/
    new->next = freeNodePool->head;
    freeNodePool->head = new;
    // new->prev = freeNodePool->tail;
    // if (freeNodePool->count==0){
    //     freeNodePool->head=new;
    // }
    // else{
    //     freeNodePool->tail->next = new;
    // }
    // new->prev = freeNodePool->tail;
    // new->next = NULL;
    // freeNodePool->tail = new;   
    // freeNodePool->count++;
    // freeNodePool->current = new;

    return new->item;
}

// int main(int argc, char const *argv[])
// {
//     /* code */
//     return 0;
// }
