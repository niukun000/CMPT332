/*
Niu, Kun
kun869
11242427
*/

#ifndef LIST_H_
#define LIST_H_



#define LISTSIZE	5
#define NODESIZE	100

typedef struct Node{
    void *item;
	struct Node *next;
	struct Node *prev;
}Node;

typedef struct List{
	int count;
	struct Node *head;
    struct Node *tail;
	struct Node *current;
}List;


int listIndex;

int nodeIndex;

/* 	List pool to store lists*/
List listPool[LISTSIZE];

/* 	Node pool to store nodes*/
Node nodePool[NODESIZE];



/*
makes a new, empty list, and returns its reference on success. 
Returns a NULL pointer on failure.
*/
List *ListCreate();


/*
 returns the number of items in list.
*/
int ListCount(List *list);

/*
returns a pointer to the first item in list and makes 
the first item the current item.
*/
void *ListFirst(List *list);


/*
returns a pointer to the last item in list and makes the last item the current one.
*/
void *ListLast(List *list);


/*
advances the list's current node by one, and returns a pointer to the new current item. 
If this operation attempts to advances the current item beyond the end of the list, a NULL pointer is returned.
*/
void *ListNext(List *list);

/*
backs up the list's current node by one, and returns a pointer to the new current item. 
If this operation attempts to back up the current item beyond the start of the list, a NULL pointer is returned.
*/
void *ListPrev(List *list) ;

/*
returns a pointer to the current item in list.
*/
void *ListCurr(List *list);

/*
adds the new item to list directly after the current item, and makes item the current item. 
If the current pointer is at the end of the list, the item is added at the end. Returns 0 on success, -1 on failure.
*/
int ListAdd(List *list, void* item);

/*
adds item to list directly before the current item, and makes the new item the current one.
If the current pointer is at the start of the list, the item is added at the start.  Returns 0 on success, -1 on failure.
*/
int ListInsert(List *list, void* item);

/*
adds item to the end of list, and makes the new item the current one. Returns 0 on success, 
-1 on failure.
*/
int ListAppend(List *list, void* item);

/*
adds item to the front of list, and makes the new item the current one. Returns 0 on success, 
-1 on failure.
*/
int ListPrepend(List *list, void* item);

/*
 Return current item and take it out of list. Make the next item the current one.
*/
void *ListRemove(List *list);

/*
adds list2 to the end of list1. The current pointer is set to the current pointer of list1.
 List2 no longer exists after the operation.
*/
void ListConcat(List *list1, List *list2);

/*
delete list. itemFree is a pointer to a routine that frees an item. It should be invoked 
(within ListFree) as: (*itemFree)(itemToBeFreed);
*/
void ListFree(List *list, void* itemFree);

/*
Return last item and take it out of list. The current pointer shall be the new last item in the list.
*/
void *ListTrim(List *list);

/*
 searches list starting at the current item until the end is reached or a match is found.
*/
void *ListSearch(List *list, int comparator, void* comparisonArg);

#endif
