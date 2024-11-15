#include <gtk/gtk.h>
#include <c_utils.h>

void button_clicked(GtkWidget *button, gpointer data) {
    
    Button* btn = (Button *)data;//cast the data to a button

    int Offset =btn->row+btn->col*3+btn->gridNum*9;//calculate the offset

    int i = record_movement(Offset);//get the player and record the movement in asm

    check_button(data,i);//check the button

    lock_unlock_buttons((btn->col*3)+btn->row);//update the buttons
}