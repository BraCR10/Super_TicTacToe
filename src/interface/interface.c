#include <gtk/gtk.h>
#include <stdio.h>
#include <c_utils.h>
#include <stdbool.h>

//Global variables
#define ROWS 3
#define COLS 3
GtkWidget *window;
GtkWidget *main_grid;
GtkBuilder *builder;
Button *buttons[ROWS][COLS];//matriz for each space in the main_grid
const char *glade_path = "src/interface/interface.glade";
const char *grid_names[] = {"grid1", "grid2", "grid3", "grid4", "grid5", "grid6", "grid7", "grid8", "grid9"};


int closeWindow() {// this function is called when the user presses the close button in the window
    gtk_main_quit(); 
}

void lock_unlock_buttons(int gridNum) {
    GtkWidget *gridAux;//a pointer to the grid
    GtkWidget *button;//a pointer to the button
    bool lock = TRUE;// a flag to lock a unlock the buttons
    for (int grid = 0; grid < 9; grid++) {//loop to lock or unlock the buttons

        if (grid != gridNum) //if the grid is not the grid selected
            lock = FALSE;//unlock the buttons
        else
            lock = TRUE;

        gridAux = GTK_WIDGET(gtk_builder_get_object(builder, grid_names[grid]));//get the grid
        for (int row = 0; row < ROWS; row++) {
            for (int col = 0; col < COLS; col++) {
                button = gtk_grid_get_child_at(GTK_GRID(gridAux), col, row);//get the button
                if (GTK_IS_BUTTON(button)) {//if the button is a button
                    gtk_widget_set_sensitive(button, lock);//lock or unlock the button
                }
            }
        }
    }
}
void interface_call(int argc, char **argv){

    // Initialize GTK
    gtk_init(&argc, &argv); 

    // Load the interface from the glade file
    
    builder = gtk_builder_new_from_file(glade_path);

    if(builder == NULL){printf("Error: Could not load interface.glade\n");return;}

    // Get the main window from the glade file
    window = GTK_WIDGET(gtk_builder_get_object(builder, "main_window"));
    gtk_window_set_title(GTK_WINDOW(window), "Super Tic Tac Toe");

    if (window == NULL) {printf("Error: Could not find main_window in the Glade file\n");return;}

    // to connect glade signals in the glade file
    g_signal_connect(window, "destroy", G_CALLBACK(closeWindow), NULL);
    gtk_builder_connect_signals(builder, NULL);

  
    //configuring panels
    GtkWidget *panel = GTK_WIDGET(gtk_builder_get_object(builder, "left_panel"));
    if(panel == NULL){printf("Error: Could not find left_panel in the Glade file\n");return;}
    gtk_widget_set_size_request(panel, 185, 630);

    panel = GTK_WIDGET(gtk_builder_get_object(builder, "right_panel"));
    if(panel == NULL){printf("Error: Could not find left_panel in the Glade file\n");return;}
    gtk_widget_set_size_request(panel, 185, 630);


    // loading the buttons in the main_grid
    for(int gridNum=0; gridNum < 9; gridNum++){
        for(int i = 0; i < ROWS; i++){
            for(int j = 0; j < COLS; j++){
                buttons[i][j]= malloc(sizeof(Button));
                buttons[i][j]->buttonObj= gtk_button_new_with_label("");
                buttons[i][j]->row = i;
                buttons[i][j]->col = j;
                buttons[i][j]->gridNum = gridNum;
                gtk_widget_set_size_request(buttons[i][j]->buttonObj, 70, 70);
                gtk_grid_attach(GTK_GRID(gtk_builder_get_object(builder, grid_names[gridNum])), buttons[i][j]->buttonObj, buttons[i][j]->row, buttons[i][j]->col, 1, 1); 
                g_signal_connect(buttons[i][j]->buttonObj, "clicked", G_CALLBACK(button_clicked), buttons[i][j]);
                
            }
        }
    }
    
    // show the window
    gtk_window_set_default_size(GTK_WINDOW(window), 1000, 700);
    gtk_widget_show_all(window);
    // glade loop
    gtk_main();

}