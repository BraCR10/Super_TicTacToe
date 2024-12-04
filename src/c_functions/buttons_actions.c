#include <gtk/gtk.h>
#include <c_utils.h>
#include <asm_utils.h>
void button_clicked(GtkWidget *button, gpointer data) {
    if(CPUflag == TRUE && main_matriz[90]==2 ) return;//if the CPU return
    Button* btn = (Button *)data;//cast the data to a button

    int Offset =btn->row+btn->col*3+btn->gridNum*9;//calculate the offset

    long i = record_movement(Offset);//get the player and record the movement in asm

    check_button(btn,i);//check the button

    displayWhoPlay();//display who plays
}