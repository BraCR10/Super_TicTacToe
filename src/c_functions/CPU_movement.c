#include <gtk/gtk.h>
#include <c_utils.h>
#include <asm_utils.h>
gboolean CPU_movement(gpointer builder) {
    if(main_matriz[90]==2 && CPUflag == true){
        GtkWidget *gridAux;//a pointer to the grid
        GtkWidget *button;//a pointer to the button
        
        for (int grid = 0; grid < 9; grid++) {//loop to get the grid
            gridAux = GTK_WIDGET(gtk_builder_get_object(builder, grid_names[grid]));//get the grid
            
            for (int row = 0; row < 3; row++) {//loop to get the row
                for (int col = 0; col < 3; col++) {//loop to get the col
                    button = gtk_grid_get_child_at(GTK_GRID(gridAux), col, row);//get the button
                    if (GTK_IS_BUTTON(button)) {//if the button is a button
                        if (gtk_widget_get_sensitive(button))//if the button is not locked
                        {
                        GtkButton *gtk_button = GTK_BUTTON(button); //cast the button to a GtkButton
                        const gchar *label = gtk_button_get_label(gtk_button);//get the label of the button
                         if (g_strcmp0(label, "") == 0)//if the butom is empty
                            {
                                int Offset =row+col*3+grid*9;//calculate the offset
                                long i =record_movement(Offset);//get the player and record the movement in asm
                                Button btn = {button, row, col, grid}; //create a button object temp
                                check_button(&btn, i);//check the button
                                displayWhoPlay();//display who plays
                                return true;//return true to continur the timeout
                            }
                        }
                    }
                }
            } 
        }
    }
    return true;//return true to continur the timeout
}