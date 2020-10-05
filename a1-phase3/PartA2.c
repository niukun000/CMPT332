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
#include <unistd.h>
#include <time.h>

#include <square.h>
#include <pthread.h>

long number_of_threads;
long deadline;
long number_of_square;
int running_status = 1;
int *result;
int completedChildThread = 0;

struct thread {
	// pthread_t pid;
	// int current_number;
};

int parse_args(int argc, char const *argv[]){
	if (argc != 4){
		printf("please enter 3 arguments only");
		exit(0);
	}
	
	number_of_threads = atoll(argv[1]);
	deadline = atoll(argv[2]);
	number_of_square = atoll(argv[3]);
	if (number_of_threads <0 ){
		printf("the number of threads must be greater than 0");
		exit(0);
	}
	if (deadline < 0){
		printf("the deadline time must be greater than 0s");
		exit(0);
	}
	if (number_of_square < 1){
		printf("the max integer must be possitive integers" );
		exit(0);
	}
	return 0;

}
// int Square(int N){
//     if (N == 0) return 0;
// 	return (Square(N-1) + N + N - 1);
// }
void* Child_thread(){
	pthread_t pthread_self();

	printf("\n");
	printf("IN CHILD_THREAD\n");
	printf("Child %u starts \n", pthread_self());

	time_t start, stop;
	start = time(NULL);
	for (int i =0;i<number_of_square;i++){
		if (running_status==1){
			Square(i);
		}
		// create array contains uncompleted child threads' inforamtion such as PID, time, and stopped at which number of square.
		else{
			stop = time(NULL);

			result[0] = pthread_self();
			result[1] = stop-start;
			result[2] = i;
			printf("\n");
			printf("Child thread %u stops at %d \n", pthread_self(), i );
			printf("The number of second for child thread to run is %ld \n", stop - start);

			pthread_exit(0);
			return result;
		}
	}
	return NULL;

}

void* Parent_thread(void * param){
	printf("\n");
	printf("IN Parent_thread \n");
	printf("Creating child thread, Number of Thread %d \n", number_of_threads);

	result = (int *)malloc(sizeof(int)); // array to contain information

	pthread_t tids[number_of_threads];
	int returnValue_Child;
	for (long i = 0; i<number_of_threads;i++){
		returnValue_Child = pthread_create(&tids[i],NULL, Child_thread,(void *)number_of_square);
		if(returnValue_Child){
			 printf("\n ERROR: return code from pthread_create is %d \n", returnValue_Child);
			 exit(1);
		}
		printf("Created a new child thread (%u)... \n", tids[i]);
	}
	sleep(deadline);
	running_status = 0;

	// Check all child threads, which is uncompleted then use its pthread_t to kill it
	//
	//pthread_kill(pthread_t ,3);
	//
	// TO_DO
	for (long j = 0; j<number_of_threads;j++){
		pthread_join(tids[j], (void*) result);
		//printf("The result is %u \n", result);
		//
		// Need to change how to deal with the result as a pointer, derefernece result
		//
		// TO_DO
	}
}


int main(int argc, char const *argv[])
{
	parse_args(argc,argv);
	printf("Exectuing parse_argus succeed \n");

	int returnValue_Parent;
	pthread_t id;

	returnValue_Parent = pthread_create(&id, NULL, Parent_thread,NULL);
	if(returnValue_Parent)
    {
      printf("\n ERROR: return code from pthread_create is %d \n", returnValue_Parent);
      exit(-1);
    }
    printf("Created a new parent thread (%u)... \n", id);

    /* Last thing that main() should do */
    pthread_exit(NULL);
}




