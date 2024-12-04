#ifndef C_UTILS_H
#define C_UTILS_H

typedef struct button{
    GtkWidget *buttonObj;
    int row;  
    int col; 
    int gridNum; 
} Button;

void button_clicked(GtkWidget *widget, gpointer data); 

long record_movement(long offset);

void check_button(Button *btn,long player);

void lock_unlock_buttons_grid(int gridNum);

void displayWhoPlay();

void fill_grid();

void lock_grid(int num);

void opeanAllUnlockedGrids();

void call_win_screen();

#include <stdbool.h>
extern bool CPUflag;//to check if the CPU was selected  for 
extern const char * grid_names[9];//the names of the grids
gboolean CPU_movement(gpointer builder);

#endif