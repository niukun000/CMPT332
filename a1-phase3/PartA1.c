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
// #include <windows.h>

#include <standards.h>
#include <square.h>
#include <os.h>

PID parent;
int number_of_threads;
int deadline;
int number_of_square;
int finished_child;
int running_status = 1;

struct thread {
};


int * parse_args(int argc, char const *argv[]){
	if (argc != 4){
		printf("please enter 3 arguments only");
		exit(0);
	}
	
	number_of_threads = atoll(argv[1]);
	deadline = atoll(argv[2]);
	number_of_square = atoll(argv[3]);
	printf("%d", number_of_threads);
	if (number_of_threads <0 ){
		printf("the number of threads is %d must be greater than 0", number_of_threads);
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
int child_thread(){
	printf("child %d starting\n", MyPid());
	for (int i =0;i<number_of_square;i++){
		if (running_status){
			Square(i);
		}
		else{
			printf("child with pid %d took %d seconds to get %d\n", MyPid(), 1, i);
			Pexit();
		}
		// printf("%d\n", i);
	}
	finished_child+=1;
	printf("%dchild finished\n", finished_child);
}
PROCESS parent_thread(){
	printf("i am in parent thread\n");
	PID pids[number_of_threads];
	printf("%d threads will be created\n",number_of_threads);
	for (int i = 0; i<number_of_threads; i++){
		printf("creating %d\n", i);
		pids[i] = Create((void(*)()) child_thread,1600000, "child", NULL,
		   NORM, USR);
		// pids[i].join();
		printf("%d child threads has been created\n", i);
		// if (WaitForSingleObject(pids[i],10)) perror("parent creatted");
	}
	// for (int i = 0; i<number_of_threads; i++){
	// 	if (WaitForSingleObject(pids[i],10)) perror("parent creatted");
	// }

	Sleep(deadline);
	running_status = 0;
	printf("");
}

int mainp(int argc, char const *argv[])
{

	parse_args(argc,argv);
	parent = Create((void(*)()) parent_thread,16000, "parent", NULL,
		   NORM, USR);
	printf("%sparent:\n", parent);

	printf("parse_argus success failed\n");

	return 0;
}
