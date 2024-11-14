#include <gtk/gtk.h>
#include <stdio.h>

GtkWidget *window;
GtkWidget *main_grid;

int closeWindow() {// this function is called when the user presses the close button in the window
    gtk_main_quit(); 
}


void interface_call(int argc, char **argv){
    GtkBuilder *builder;
    GtkBut
    const char *glade_path = "src/interface/interface.glade";

    // Initialize GTK
    gtk_init(&argc, &argv); 

    // Load the interface from the glade file
    
    builder = gtk_builder_new_from_file(glade_path);

    if(builder == NULL){printf("Error: Could not load interface.glade\n");return;}

    // Get the main window from the glade file
    window = GTK_WIDGET(gtk_builder_get_object(builder, "main_window"));

    if (window == NULL) {printf("Error: Could not find main_window in the Glade file\n");return;}

    // to connect glade signals in the glade file
    g_signal_connect(window, "destroy", G_CALLBACK(closeWindow), NULL);
    gtk_builder_connect_signals(builder, NULL);

    // show the window
     gtk_window_set_default_size(GTK_WINDOW(window), 1000, 800);
    gtk_widget_show_all(window);

    // glade loop
    gtk_main();

}