#include <gtk/gtk.h>
#include "c_utils.h"

void button_clicked(GtkWidget *button, gpointer data) {
    Button* btn = (Button *)data;
    int Offset =btn->row+btn->col*3+btn->gridNum*9;
}