#include <gtk/gtk.h>
#include <c_utils.h>
#include <asm_utils.h>
void check_button(Button *btn,long option) {

    
    if(option == 1){
        gtk_button_set_label(GTK_BUTTON(btn->buttonObj), "X");
        lock_unlock_buttons_grid((btn->col*3)+btn->row);//update the buttons
    }
    else if(option == 2){
        gtk_button_set_label(GTK_BUTTON(btn->buttonObj), "O");
        lock_unlock_buttons_grid((btn->col*3)+btn->row);//update the buttons
    }
    else if (option ==3)//the player is X
    {
        fill_grid("X",btn->gridNum);
        lock_grid(btn->gridNum);//lock the grid
        opeanAllUnlockedGrids();//open all the grids
    }else if (option ==4)//the player is O
    {
        fill_grid("O",btn->gridNum);
        lock_grid(btn->gridNum);//lock the grid
        opeanAllUnlockedGrids();//open all the grids
    }else if (option == 5)
    {
        call_win_screen(main_matriz[90]);//call the win screen passing the winner
    }
}