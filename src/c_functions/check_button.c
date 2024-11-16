#include <gtk/gtk.h>
#include <c_utils.h>

void check_button(gpointer data,int player,int gridNum) {
    Button* btn = (Button *)data;

    if(player == 1){
        gtk_button_set_label(GTK_BUTTON(btn->buttonObj), "X");
        lock_unlock_buttons(gridNum);//update the buttons
    }
    else if(player == 2){
        gtk_button_set_label(GTK_BUTTON(btn->buttonObj), "O");
        lock_unlock_buttons(gridNum);//update the buttons
    }
}