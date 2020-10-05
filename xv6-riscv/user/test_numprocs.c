
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int
main(int argc, char *argv[])
{
    printf("Inside Numprocs Test File\n");
	//system("forktest");
int parentPid = getpid();	
    for (int i = 0; i<3;i++){
	fork();}
    	sleep(3);
	//fork();
	//sleep(3);
	//fork();
	//sleep(3);
    int current_runnable = numprocs();
    //kill(a);
    sleep(3);
    if (current_runnable < 0){
        fprintf(2, "numprocs failed\n");
	exit(0);
  }
    if(getpid() == parentPid){
    fprintf(2,"abc ");
    printf("%d ", current_runnable);
    }

    sleep(3);
    exit(0);
}
