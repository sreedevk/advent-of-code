#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <string.h>

#define PROGRAM_MEMORY        4000 /* 4000 x 16 bytes */
#define INIT_EXEC_HIST_SIZE   1000

typedef struct {
  char          opcode[4];
  long int      argument;
} instruction;

typedef struct {
  int stack_ptr; 
  long int     accumulator;
  instruction *instructions;
  int         *exec_hist;
  int         *last_iseq_index;
} machine;

void load_instructions(machine *sys, const char *instructions_path) {
  FILE *file = fopen(instructions_path, "r");
  uint32_t instr_count = 0;
  while(!feof(file)){
    char *opcode = malloc(sizeof(char) * 6);
    int   arg;
    fscanf(file, "%s %d", opcode, &arg);
    instruction *current_inst = malloc(sizeof(instruction));
    strcpy(current_inst->opcode, opcode);
    current_inst->argument = arg;
    sys->instructions[instr_count] = *current_inst;
    instr_count++;
  }
}

void init_machine(machine *sys) {
  sys->stack_ptr       = 0;
  sys->accumulator     = 0;
  sys->last_iseq_index = 0;
  sys->instructions    = malloc(sizeof(instruction) * PROGRAM_MEMORY);
  sys->exec_hist       = malloc(INIT_EXEC_HIST_SIZE);
}

void jmp(machine *sys, int arg) {
  sys->stack_ptr += arg; 
}

void acc(machine *sys, int arg) {
  sys->accumulator += arg;
  sys->stack_ptr++; 
}

void nop(machine *sys, int arg){
  sys->stack_ptr++; 
}

void record_exec_history(machine *sys) {

}

void run(machine *sys){
}

void realloc_history(machine *sys) {
}

int main(){
  machine *sys = malloc(sizeof(machine));
  init_machine(sys);
  load_instructions(sys, "./data.txt");
  
  run(sys);

  return EXIT_SUCCESS;
}
