#include <gtk/gtk.h>
#include <stdio.h>
#include <c_utils.h>

//Global variables
//Login window
GtkWidget *login_window;
GtkWidget *login_button;
bool login = FALSE;
const gchar *player1Name;
const gchar *player2Name;
GtkWidget *cpu_option;
bool CPUflag = FALSE;//this variable is declared in c_utils.h as global to ask if the CPU was selected
//Game window
#define ROWS 3
#define COLS 3
GtkWidget *window;
GtkWidget *main_grid;
GtkBuilder *builder;
const char *glade_path = "src/interface/interface.glade";
const char *grid_names[] = {"grid1", "grid2", "grid3", "grid4", "grid5", "grid6", "grid7", "grid8", "grid9"};
int lockGrids[] = {-1, -1, -1, -1, -1, -1, -1, -1, -1};
//winner window
GtkWidget *win_screen;

int closeWindow() {// this function is called when the user presses the close button in the window
    gtk_main_quit();
    login = FALSE;
    return 0; 
}

//win screen function
void call_win_screen(int winner) {
    // Hide the main window
    gtk_widget_hide(GTK_WIDGET(window));  // Only hide the main window
    gtk_main_quit();

    // Get the UI objects
    win_screen = GTK_WIDGET(gtk_builder_get_object(builder, "win_screen"));
    GtkWidget *win_label = GTK_WIDGET(gtk_builder_get_object(builder, "winner_label"));
    GtkWidget *close_buttom = GTK_WIDGET(gtk_builder_get_object(builder, "close_buttom"));

    // Check if the objects exist
    if (win_label == NULL) {
        printf("Error: Could not find winner_label in the Glade file\n");
        return;
    }
    if (win_screen == NULL) {
        printf("Error: Could not find win_screen in the Glade file\n");
        return;
    }
    if (close_buttom == NULL) {
        printf("Error: Could not find close_button in the Glade file\n");
        return;
    }

    // Set up the winner window
    gtk_window_set_title(GTK_WINDOW(win_screen), "Super Tic Tac Toe - Winner");

    // Connect signals for "destroy" and "clicked" to close the window
    g_signal_connect(win_screen, "destroy", G_CALLBACK(closeWindow), NULL);
    g_signal_connect(close_buttom, "clicked", G_CALLBACK(closeWindow), NULL);

    // Set the winner's name on the label
    if (winner == 1) {
        gtk_label_set_text(GTK_LABEL(win_label), player1Name);
    } else if (winner == 2) {
        gtk_label_set_text(GTK_LABEL(win_label), player2Name);
    }

    // Show the winner window
    gtk_window_set_default_size(GTK_WINDOW(win_screen), 400, 150);
    gtk_widget_show_all(win_screen);  // Make sure to show the winner screen
    gtk_main();
    
    
}

//game functions
void lock_grid(int num){
    for (int i = 0; i < 9; i++)
    {
        if (lockGrids[i] == -1)
        {
            lockGrids[i] = num;
            break;
        }
    }
}

void opeanAllUnlockedGrids(){
    GtkWidget *gridAux;//a pointer to the grid
    GtkWidget *button;//a pointer to the button
    bool lock;
    for (int gridNum = 0; gridNum < 9; gridNum++)
    {
        bool lock = TRUE;// a flag to lock a unlock the buttons
        for (int i = 0; i < 9; i++)//check if the grid is closed
        {
            if (lockGrids[i] == gridNum)
            {
                lock = FALSE;
                break;
            }
        }
        gridAux = GTK_WIDGET(gtk_builder_get_object(builder, grid_names[gridNum]));//get the grid
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

void fill_grid(char *player, int gridNum){
    GtkWidget *gridAux;//a pointer to the grid
    GtkWidget *button;//a pointer to the button
    gridAux = GTK_WIDGET(gtk_builder_get_object(builder, grid_names[gridNum]));//get the grid
    for (int row = 0; row < ROWS; row++) {
        for (int col = 0; col < COLS; col++) {
            button = gtk_grid_get_child_at(GTK_GRID(gridAux), col, row);//get the button
            if (GTK_IS_BUTTON(button)) {//if the button is a button
                gtk_button_set_label(GTK_BUTTON(button), player);//set the label of the button
            }
        }
    } 
    
}

void lock_unlock_buttons_grid(int gridNum) {
    GtkWidget *gridAux;//a pointer to the grid
    GtkWidget *button;//a pointer to the button
    bool lock = TRUE;// a flag to lock a unlock the buttons
    
    for (int grid = 0; grid < 9; grid++) {//loop to lock or unlock the buttons
        gridAux = GTK_WIDGET(gtk_builder_get_object(builder, grid_names[grid]));//get the grid
        if (grid != gridNum) //if the grid is not the grid selected
            lock = FALSE;//unlock the buttons
        else{
            for (int i = 0; i < 9; i++)//check if the grid is closed or finished
            {
                lock = TRUE;// a flag to lock a unlock the buttons
                if (lockGrids[i] == gridNum)//if the grid is closed
                {
                    opeanAllUnlockedGrids();//open all the grids
                    return;
                }
            }     
        }
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

void displayWhoPlay(){
    extern long main_matriz[91];
    GtkWidget *turnO = GTK_WIDGET(gtk_builder_get_object(builder, "O_buttom"));
    GtkWidget *turnX = GTK_WIDGET(gtk_builder_get_object(builder, "X_buttom"));
    if (turnO == NULL || turnX == NULL) {printf("Error: Could not find O_button or X_button in the Glade file\n");return;}
    if (GTK_IS_BUTTON(turnO) && GTK_IS_BUTTON(turnX)) {//if the buttons are buttons
        if(main_matriz[90] == 1){
            gtk_widget_set_sensitive(turnO, FALSE);//lock or unlock the button
            gtk_widget_set_sensitive(turnX, TRUE);//lock or unlock the button
        }else{
            gtk_widget_set_sensitive(turnO, TRUE);//lock or unlock the button
            gtk_widget_set_sensitive(turnX, FALSE);//lock or unlock the button 
        }
    }
}

void call_game(){
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

    //configuring the labels
    GtkWidget *player1 = GTK_WIDGET(gtk_builder_get_object(builder, "display_player1"));
    if(player1 == NULL){printf("Error: Could not find display_player1 or display_player2 in the Glade file\n");return;}
    gtk_widget_set_size_request(player1, 40, 40);

    GtkWidget *player2 = GTK_WIDGET(gtk_builder_get_object(builder, "display_player2"));
    if( player2 == NULL){printf("Error: Could not find display_player1 or display_player2 in the Glade file\n");return;}
    gtk_widget_set_size_request(player2, 40, 40);

    //putting the player names in the panel
    gtk_label_set_text(GTK_LABEL(player1), player1Name);
    gtk_label_set_text(GTK_LABEL(player2), player2Name);

    //display who plays first
    displayWhoPlay();
    Button *buttons[ROWS][COLS];//matriz for each space in the main_grid
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
    
    // CPU action
    if (CPUflag )
        g_timeout_add_seconds(4, CPU_movement, builder); // Call the CPU movement every 10 seconds
    
    // show the window
    gtk_window_set_default_size(GTK_WINDOW(window), 1000, 700);
    gtk_widget_show_all(window);
    // glade loop
    gtk_main();

}


//login function
void check_cpu(){
    if(CPUflag == FALSE){
        GtkWidget *name2= GTK_WIDGET(gtk_builder_get_object(builder, "player_name_2"));
        gtk_entry_set_text(GTK_ENTRY(name2), "CPU");
        gtk_widget_set_sensitive(name2, FALSE);
        CPUflag = TRUE;
    }else{
        GtkWidget *name2= GTK_WIDGET(gtk_builder_get_object(builder, "player_name_2"));
        gtk_entry_set_text(GTK_ENTRY(name2), "");
        gtk_widget_set_sensitive(name2, TRUE);
        CPUflag = FALSE;
    }
}

void start_game(){
    //validations
    GtkWidget *name1= GTK_WIDGET(gtk_builder_get_object(builder, "player_name_1"));
    GtkWidget *name2= GTK_WIDGET(gtk_builder_get_object(builder, "player_name_2"));
    if(name1 == NULL || name2 == NULL){printf("Error: Could not find player_name_1 or player_name_2 in the Glade file\n");return;}

    player1Name = gtk_entry_get_text(GTK_ENTRY(name1));
    player2Name = gtk_entry_get_text(GTK_ENTRY(name2));

    if(strlen(player1Name) == 0 || strlen(player2Name) == 0){
        GtkWidget *dialog = gtk_message_dialog_new(GTK_WINDOW(login_window), GTK_DIALOG_DESTROY_WITH_PARENT, GTK_MESSAGE_ERROR, GTK_BUTTONS_OK, "Please fill the player names");
        gtk_dialog_run(GTK_DIALOG(dialog));
        gtk_widget_destroy(dialog);
        return;
    }else if(strcmp(player1Name, player2Name) == 0){
        GtkWidget *dialog = gtk_message_dialog_new(GTK_WINDOW(login_window), GTK_DIALOG_DESTROY_WITH_PARENT, GTK_MESSAGE_ERROR, GTK_BUTTONS_OK, "The players names must be different");
        gtk_dialog_run(GTK_DIALOG(dialog));
        gtk_widget_destroy(dialog);
        return;
    }else if (strlen(player1Name)> 10 || strlen(player2Name)> 10){
        GtkWidget *dialog = gtk_message_dialog_new(GTK_WINDOW(login_window), GTK_DIALOG_DESTROY_WITH_PARENT, GTK_MESSAGE_ERROR, GTK_BUTTONS_OK, "The players names must be less than 10 characters");
        gtk_dialog_run(GTK_DIALOG(dialog));
        gtk_widget_destroy(dialog);
        return;
    }else{
        //close login window
        gtk_widget_hide(GTK_WIDGET(login_window));
        gtk_main_quit();
        login = TRUE;
        return;
    }
}

void call_login(int argc, char **argv){
 // Initialize GTK
    gtk_init(&argc, &argv); 

    // Load the interface from the glade file
    builder = gtk_builder_new_from_file(glade_path);

    if(builder == NULL){printf("Error: Could not load interface.glade\n");return;}
    // Get the login window from the glade file
    login_window = GTK_WIDGET(gtk_builder_get_object(builder, "login_window"));
    gtk_window_set_title(GTK_WINDOW(login_window), "Super Tic Tac Toe");
    if (login_window == NULL) {printf("Error: Could not find login_window in the Glade file\n");return;}

    // to connect glade signals in the glade file
    g_signal_connect(login_window, "destroy", G_CALLBACK(closeWindow), NULL);
    gtk_builder_connect_signals(builder, NULL);

    //loading the login button
    login_button= GTK_WIDGET(gtk_builder_get_object(builder, "login_button"));
    g_signal_connect(login_button, "clicked", G_CALLBACK(start_game), NULL); 

    //loading the cpu option
    cpu_option = GTK_WIDGET(gtk_builder_get_object(builder, "CPU_option"));
    if (cpu_option == NULL) {printf("Error: Could not find cpu_option in the Glade file\n");return;}
    g_signal_connect(cpu_option, "notify::active", G_CALLBACK(check_cpu), NULL);

    
    // glade loop
    gtk_widget_show_all(login_window);
    gtk_main();

    //If the user close the window or don't login properly
    if (login == FALSE) return;
    else call_game();
}
