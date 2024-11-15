#ifndef C_UTILS_H
#define C_UTILS_H

typedef struct button{
    GtkWidget *buttonObj;
    int row;  
    int col; 
    int gridNum; 
} Button;

void button_clicked(GtkWidget *widget, gpointer data); 

int record_movement(int offset);

void check_button(gpointer data,int player);

void lock_unlock_buttons(int gridNum);
#endif