#ifndef BUTTON_H
#define BUTTON_H
typedef struct button{
    GtkWidget *buttonObj;
    int row;  
    int col; 
    int gridNum; 
} Button;

#endif