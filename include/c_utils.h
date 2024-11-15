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

#endif