/*
    Sega Master System 8 way scrolling template by Orange Revolt.

    This example is to help those that want to scroll the screen in eight directions without additional liberies.
    It does not do meta tiles (16x16 tiles etc) nor collision, so the map arrays will be much larger and you'll have to make
    an array for the map collisions. Use GSlib instead like described on the devkitSMS github for more features like meta tiles, collisions etc.
    
    Code was only tested with one of my game maps, that is 3 screens (1 screen = 256 x 224) wide by two screen tall (using NTSC resolution 256 x 192). There is possible bugs when a larger map, 
    so report if you find any on my Github. 
    
    I used my tile font from a game to debug the code - you can discard the code/comments relating to printing text.
*/


#include "libs/SMSlib.h"
#include <stdio.h>
#include <stdlib.h>
#include "bank3.h"

#define RIGHT           0 //defines for camera panning direction.
#define LEFT            1
#define UP              2
#define DOWN            3
#define DOWN_RIGHT      4
#define DOWN_LEFT       5
#define UP_LEFT         6
#define UP_RIGHT        7

#define CAM_START_X     0 //defines for start position of camera.
#define CAM_START_Y     0

//Create a struct to store all variables related to scrolling. We are using doing variable naming in relation to a camera.
struct View {
    unsigned int view_x; //values that set the position of the camera's view.
    int view_y; //
    unsigned char scroll_x; //Scroll register variables for the SMS_setBGScroll functions..
    unsigned char scroll_y;
    signed int coloffset; //Store the position of the current row/column in tile index while scrolling the screen. 
    signed int rowoffset;
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

void cam_pan_right(void) 
{

    if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
    {
        camera.rowoffset = (camera.scroll_y / 8);
        //Variables for when the screen is offset.
        unsigned char rowoffset = camera.rowoffset; //Save the last state of rowoffset in a temp variable.
        unsigned char ydex = 0; //We store the current y loop position, in order to subtract from the loop, to start at zero again when at last tile position.
                
        for (unsigned char y = 0; y < 28; y++)
        {
            if (y >= 28 - rowoffset && rowoffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
            {
                rowoffset = 0; //removes the offset from the equation. we need to start at zero.
                ydex = y; //store the y loop current index, to subtract it.
            }
            SMS_loadTileMap(camera.coloffset,rowoffset + (y - ydex),brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
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

    if (camera.scroll_x % 8 == 0 && camera.view_x > 0)
    {
        camera.rowoffset = (camera.scroll_y / 8);

        //Variables for when the screen is offset.
        unsigned char rowoffset = camera.rowoffset; //Save the last state of rowoffset in a temp variable.
        unsigned char ydex = 0; //We store the current y loop position, in order to subtract from the loop, to start at zero again when at last tile position.
        for (unsigned char y = 0; y < 28; y++)
        {
            if (y >= 28 - rowoffset && rowoffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
            {
                rowoffset = 0; //removes the offset from the equation. we need to start at zero.
                ydex = y; //store the y loop current index, to subtract it.
            }
            SMS_loadTileMap(camera.coloffset,rowoffset + (y - ydex),brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);            
        }

        camera.view_x-= 2;
    }
    
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
        camera.rowoffset = (camera.scroll_y / 8);
        //Variables for when the screen is offset.
        unsigned char coloffset = camera.coloffset; //Save the last state of coloffset in a temp variable.
        unsigned char xdex = 0; //We store the current x loop position, in order to subtract from the loop, to start at zero again when at last tile position.
        
        for (unsigned char x = 0; x < 32; x++)
        {
            if (x >= 32 - coloffset && coloffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
            {
                coloffset = 0; //removes the offset from the equation. we need to start at zero.
                xdex = x; //store the x loop current index, to subtract it.
            }
            SMS_loadTileMap(coloffset + (x - xdex),camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);         
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
    
}

void cam_pan_down(void)
{ 
     
    camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register in tiles.
    
    if (camera.view_y < 24) //Prvent the scrolling from going past the height of the map. 24 tiles = 192 pixels
    {
        camera.scroll_y++;
    }
    
    if (camera.scroll_y > 223) //We need to reset the scroll_y to prevent it from hitching the screen, from overflow.
    {
        camera.scroll_y = 0;
    }

    if (camera.scroll_y % 8 == 0 && camera.view_y < 24) //Time to update the row with tiles. Happens every 1 tile of scrolling. 8 x 8 pixels = 1 tile.
    {
        
        camera.rowoffset = (camera.scroll_y / 8) - 1;
        //Variables for when the screen is offset.
        unsigned char coloffset = camera.coloffset; //Save the last state of coloffset in a temp variable.
        unsigned char xdex = 0; //We store the current x loop position, in order to subtract from the loop, to start at zero again when at last tile position.
        
        for (unsigned char x = 0; x < 32; x ++)
        {
            if (x >= 32 - coloffset && coloffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
            {
                coloffset = 0; //removes the offset from the equation. we need to start at zero.
                xdex = x; //store the x loop current index, to subtract it.
            }
            SMS_loadTileMap(coloffset + (x - xdex),camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
                    
        }

         camera.view_y++; //Increase the view_y by 1.
    }
    if (camera.rowoffset == 28) //Reset rowoffset because the nametable(the tilemap table in VRAM) only has 28 tiles in height (256 x 224. the 32 extra pixels in height is cropped in NTSC resolution..)
    {
        camera.rowoffset = 0;
    }
    
}



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

        //Handle inputs.
        if (SMS_getKeysHeld() & PORT_A_KEY_RIGHT)
        {
            
            cam_pan_right();
        }
        if (SMS_getKeysHeld() & PORT_A_KEY_LEFT)
        {
            
            cam_pan_left();
        }  
        if (SMS_getKeysHeld() & PORT_A_KEY_UP)
        {
            cam_pan_up();
        }
        if (SMS_getKeysHeld() & PORT_A_KEY_DOWN)
        {
            cam_pan_down();
        }         
        SMS_waitForVBlank();
        //Updates the scrolling after vblank. 
        SMS_setBGScrollX(camera.scroll_x);
        SMS_setBGScrollY(camera.scroll_y);
        SMS_initSprites();
        //Here is where you would update your sprites..
        SMS_copySpritestoSAT();
    }

}

//Header info needed to use the rom on a real Sega Master System.
SMS_EMBED_SEGA_ROM_HEADER(9999,0);
SMS_EMBED_SDSC_HEADER_AUTO_DATE(1,0,"OrangeRevolt","Scrolling","8 way smooth scrolling example.");