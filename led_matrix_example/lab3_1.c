x#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <led_matrix.h>

int main() {

  pid_t pid = fork();
  
  open_led_matrix();
  
  if (pid < 0){
    perror("Could not fork new process");
    return -1;
  }

  if (pid ==0){
    set_led(int 1, int 1, uint16_t RGB565_RED);
    printf("I'm the child!\n");
  }else {
    set_led(int 2, int 2, unit16_t RGB565_BLUE);
    printf("I'm the parent of process %d!\n", pid);
  }

  return 0;


}
