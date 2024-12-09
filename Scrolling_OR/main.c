/*
    Sega Master System 8 way scrolling template by Orange Revolt.

    This example is to help those that want to scroll the screen in eight directions without additional liberies.
    It does not do meta tiles (16x16 tiles etc), so the map arrays will be much larger. You will need to design your game to not use many large maps or you will eat up your program code space quickly.
    
    Code was only tested with one of my game maps, that is 3 screens (1 screen = 256 x 224) wide by two screen tall (using NTSC resolution 256 x 192). There is possible bugs when a larger map, 
    so report if you find any on my Github. 
    
    I used my tile font from a game to debug the code - you can discard the code/comments relating to printing text.
*/


#include "libs/SMSlib.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "bank3.h"

#define RIGHT           0 //defines for camera panning direction.
#define LEFT            1
#define UP              2
#define DOWN            3
#define DOWN_RIGHT      4
#define DOWN_LEFT       5
#define UP_LEFT         6
#define UP_RIGHT        7

#define CAM_START_X     64 //defines for start position of camera.
#define CAM_START_Y     24

//Create a struct to store all variables related to scrolling. We are using doing variable naming in relation to a camera.
struct View {
    unsigned int view_x; //values that set the position of the camera's view.
    int view_y; //
    unsigned char scroll_x; //Scroll register variables for the SMS_setBGScroll functions..
    unsigned char scroll_y;
    signed int coloffset; //Store the position of the current row/column while scrolling the screen. 
    signed int rowoffset;
    int pan_dir; //Direction of camera pan.
};
struct View camera;
void init_camera(void)
{
    camera.view_x = CAM_START_X; //We can set it to a max of 128, which is at the width end of the tilemap.
    camera.view_y = CAM_START_Y; //We can set it to a max of 24, which is at the height end of the tilemap.
    camera.scroll_x = 0;
    camera.scroll_y = 0;
    camera.coloffset = 0;
    camera.rowoffset = 0;
    camera.pan_dir = -1;
    SMS_setBGScrollX(camera.scroll_x);
    SMS_setBGScrollY(camera.scroll_y);
}
void redraw_stage(void)
{
    SMS_mapROMBank(brawl_street_tilemap_bin_bank);
    for(unsigned int y = 0; y < 28; y++) //load the fight stage.
    {
        SMS_loadTileMap(0,y,brawl_street_tilemap_bin + camera.view_x + (((y + camera.view_y) * 96) * 2), 64); //96 * 2 == the tilemap width in tiles (3 screens.)
    }
    
}

// void value_to_str_print(unsigned char x, unsigned char y, int val)
// {
//     char str[8];
//     sprintf(str,"%d",val);
//     SMS_printatXY(x,y,str);
// }
// void print_debug(void)
// {
//     SMS_printatXY(1,1,"CO:");
//     SMS_printatXY(6,1,"   ");
//     value_to_str_print(6,1, camera.coloffset); //
//     SMS_printatXY(1,2,"RO:");
//     value_to_str_print(6,2,camera.rowoffset);//
// }

void cam_pan_right(void) 
{

    if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
    {
        if (camera.rowoffset == 0) //No offset on the row, so we don't need to split the row code.
        {
            for (unsigned char y = 0; y < 28; y++)
            {
                SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
            }
        }
        else if (camera.rowoffset != 0)
        {
            camera.rowoffset = (camera.scroll_y / 8);
            for (unsigned char y = 0; y < 28; y++)
            {
                
                if (y < 28 - (camera.scroll_y / 8)) 
                {
                    SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
                }
                else
                {
                    SMS_loadTileMap(camera.coloffset,camera.rowoffset - 28 + y,brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
                }
                
            }            
        }
        camera.view_x+= 2;
    }
    if (camera.view_x < 128 || camera.view_x >= 128 && camera.scroll_x % 32 != 0)
    {
        camera.scroll_x--;
        camera.coloffset = 32 - (camera.scroll_x / 8); //Get the position of the x scroll register in tiles.
    }
    
    
    if (camera.coloffset == 32)
    {
        camera.coloffset = 0;
    }
    //print_debug();    
}

void cam_pan_left(void)
{
    if (camera.view_x > 0)
    {
        camera.scroll_x++;
    }
    
    camera.coloffset = 32 - (camera.scroll_x / 8); //Get the position of the x scroll register in tiles.
    if (camera.coloffset == 32)
    {
        camera.coloffset = 0;
    }
    //value_to_str_print(6,1, camera.coloffset);  

    if (camera.scroll_x % 8 == 0 && camera.view_x > 0)
    {
        if (camera.rowoffset == 0)
        {
            for (unsigned char y = 0; y < 28; y++)
            {
                SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
            }
        }
        else if (camera.rowoffset != 0)
        {
            camera.rowoffset = (camera.scroll_y / 8);
            for (unsigned char y = 0; y < 28; y++)
            {
                
                if (y < 28 - (camera.scroll_y / 8)) 
                {
                    SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
                }
                else
                {
                    SMS_loadTileMap(camera.coloffset,camera.rowoffset - 28 + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
                }
                
            }              
        }
        camera.view_x-= 2;
    }
    //print_debug();
}

void cam_pan_up(void)
{
    camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register.
    
    if (camera.rowoffset == 28) //Tile placement is from 0-27. So when it hits 28 we need to reset the rowoffset.
    {
        camera.rowoffset = 0;
    }



    if (camera.scroll_y % 8 == 0 && camera.view_y > 0)
    {
        //SMS_printatXY(6,1,"   ");
        //value_to_str_print(6,1, camera.rowoffset);  

        if (camera.coloffset == 0)
        {
            for (unsigned char x = 0; x < 32; x++)
            {
                SMS_loadTileMap(camera.coloffset + x,-camera.rowoffset + 27,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
            }
        }
        else if (camera.coloffset != 0)
        {
            camera.rowoffset = (camera.scroll_y / 8); //(camera.scroll_y / 8) - 1
            if (camera.rowoffset == 0)
            {
                camera.rowoffset = 28;
            }
            for (unsigned char x = 0; x < 32; x++)
            {
                if (x < 32 - camera.coloffset)
                {
                    SMS_loadTileMap(camera.coloffset + x,camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
                }
                else
                {
                    SMS_loadTileMap(camera.coloffset - 32 + x,camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
                }

            }            
        }
        
        camera.view_y--;

    }
    if (camera.view_y > 0 || camera.scroll_y % 32 != 0)
    {

        camera.scroll_y--;
        if (camera.scroll_y > 223)
        {
            camera.scroll_y = 223;
        }
    }
    
    //print_debug();
}

void cam_pan_down(void)
{ 
     
    camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register in tiles.


    if (camera.view_y < 24)
    {
        camera.scroll_y++;
    }
    
    if (camera.scroll_y > 223)
    {
        camera.scroll_y = 0;
    }
    if (camera.scroll_y % 8 == 0 && camera.view_y < 24)
    {

        if (camera.coloffset == 0)
        {
            for (unsigned char x = 0; x < 32; x ++)
            {
                SMS_loadTileMap(camera.coloffset + x,-camera.rowoffset + 28,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
            }
        }
        else if (camera.coloffset != 0 && camera.view_y < 23)
        {
            camera.rowoffset = (camera.scroll_y / 8) - 1;
            for (unsigned char x = 0; x < 32; x++)
            {
                if (x < 32 - camera.coloffset)
                {
                    SMS_loadTileMap(camera.coloffset + x,camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
                }
                else
                {
                    SMS_loadTileMap(camera.coloffset - 32 + x,camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
                }

            }
        }
        camera.view_y++;
    }
    if (camera.rowoffset == 28)
    {
        camera.rowoffset = 0;
    }
    //print_debug();
}


int order_time = 0;
void main(void)
{
    //Do initial setup.
    SMS_displayOff();
    // Clear VRAM
    SMS_VRAMmemsetW(0, 0x0000, 16384);
    SMS_zeroBGPalette();
    SMS_zeroSpritePalette();

    //Turn on blanking of the first column to do scrolling.
    SMS_VDPturnOnFeature(VDPFEATURE_LEFTCOLBLANK);
    SMS_VDPturnOnFeature(VDPFEATURE_HIDEFIRSTCOL);
    //Load the palettes.
    SMS_mapROMBank(bg_pal_bin_bank);
    SMS_loadBGPalette(bg_pal_bin);
    SMS_loadSpritePalette(spr_pal_bin);
    //Set the backdrop color to black.
    SMS_setBackdropColor(15);

    //I used my game font to debug things on screen, you can ignore this////////////////////////////
    SMS_loadPSGaidencompressedTiles(font_8x8_psgcompr,192);
    SMS_configureTextRenderer(160);
    ///////////////////////////////////////////////////////////////////////////////////////////////////

    //Load the tilemap.
    SMS_mapROMBank(brawl_street_tiles_psgcompr_bank);
    SMS_loadPSGaidencompressedTiles(brawl_street_tiles_psgcompr,0);
    

    //Init the game camera struct.
    init_camera();
    redraw_stage(); //Draw map at current view position.

    //Turn the display on.
    SMS_displayOn();


    for(;;)
    {   
        //Inputs
        if ((SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && (SMS_getKeysHeld() & PORT_A_KEY_DOWN) && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && camera.view_x < 130 && camera.view_y < 24)
        {
            camera.pan_dir = DOWN_RIGHT;
            cam_pan_down();
            cam_pan_right();            
        }
        else if ((SMS_getKeysHeld() & PORT_A_KEY_LEFT) && (SMS_getKeysHeld() & PORT_A_KEY_DOWN) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && camera.view_x > 0 && camera.view_y < 24)
        {
            camera.pan_dir = DOWN_LEFT;
            cam_pan_down();
            cam_pan_left();       
        }
        else if ((SMS_getKeysHeld() & PORT_A_KEY_UP) && (SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.view_x > 0 && camera.scroll_y > 0)
        {
            camera.pan_dir = UP_LEFT;
            cam_pan_up();
            cam_pan_left();
        }
        else if ((SMS_getKeysHeld() & PORT_A_KEY_UP) && (SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.view_x < 130 && camera.scroll_y > 0)
        {
            camera.pan_dir = UP_RIGHT;
            cam_pan_up();
            cam_pan_right();            
        }
        else
        {
            if (camera.pan_dir == DOWN_LEFT || camera.pan_dir == DOWN_RIGHT || camera.pan_dir == UP_LEFT || camera.pan_dir == UP_RIGHT)
            {
                camera.pan_dir = -1;
            }
        }

        if (SMS_getKeysHeld() & PORT_A_KEY_RIGHT && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT)
        {
            camera.pan_dir = RIGHT;
            cam_pan_right();
        }
        else if (SMS_getKeysHeld() & PORT_A_KEY_LEFT && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT )
        {
            camera.pan_dir = LEFT;
            cam_pan_left();
        }  
        else if (SMS_getKeysHeld() & PORT_A_KEY_UP && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT)
        {
            camera.pan_dir = UP;
            cam_pan_up();
        }
        else if (SMS_getKeysHeld() & PORT_A_KEY_DOWN && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT)
        {
            camera.pan_dir = DOWN;
            cam_pan_down();
        }         
        SMS_waitForVBlank();
        //Updates the scrolling
        SMS_setBGScrollX(camera.scroll_x);
        SMS_setBGScrollY(camera.scroll_y);
        SMS_initSprites();
        SMS_copySpritestoSAT();
    }

}

//Header info needed to use rom on a real Sega Master System.
SMS_EMBED_SEGA_ROM_HEADER(9999,0);
SMS_EMBED_SDSC_HEADER_AUTO_DATE(1,0,"OrangeRevolt","Scrolling","8 way smooth scrolling example.");