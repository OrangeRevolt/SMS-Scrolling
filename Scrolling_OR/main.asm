;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.3.2 #14359 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl ___SMS__SDSC_signature
	.globl ___SMS__SDSC_descr
	.globl ___SMS__SDSC_name
	.globl ___SMS__SDSC_author
	.globl ___SMS__SEGA_signature
	.globl _main
	.globl _cam_pan_down
	.globl _cam_pan_up
	.globl _cam_pan_left
	.globl _cam_pan_right
	.globl _redraw_stage
	.globl _init_camera
	.globl _SMS_VRAMmemsetW
	.globl _SMS_VRAMmemcpy
	.globl _SMS_getKeysHeld
	.globl _SMS_configureTextRenderer
	.globl _SMS_zeroSpritePalette
	.globl _SMS_zeroBGPalette
	.globl _SMS_loadSpritePalette
	.globl _SMS_loadBGPalette
	.globl _SMS_copySpritestoSAT
	.globl _SMS_initSprites
	.globl _SMS_loadPSGaidencompressedTilesatAddr
	.globl _SMS_waitForVBlank
	.globl _SMS_setBackdropColor
	.globl _SMS_setBGScrollY
	.globl _SMS_setBGScrollX
	.globl _SMS_VDPturnOffFeature
	.globl _SMS_VDPturnOnFeature
	.globl _camera
	.globl _SMS_SRAM
	.globl _SRAM_bank_to_be_mapped_on_slot2
	.globl _ROM_bank_to_be_mapped_on_slot0
	.globl _ROM_bank_to_be_mapped_on_slot1
	.globl _ROM_bank_to_be_mapped_on_slot2
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_SMS_VDPControlPort	=	0x00bf
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_ROM_bank_to_be_mapped_on_slot2	=	0xffff
_ROM_bank_to_be_mapped_on_slot1	=	0xfffe
_ROM_bank_to_be_mapped_on_slot0	=	0xfffd
_SRAM_bank_to_be_mapped_on_slot2	=	0xfffc
_SMS_SRAM	=	0x8000
_camera::
	.ds 10
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:43: void init_camera(void)
;	---------------------------------
; Function init_camera
; ---------------------------------
_init_camera::
;main.c:45: camera.view_x = CAM_START_X; //We can set it to a max of 128, which is at the width end of the tilemap.
	ld	hl, #0x0000
	ld	(_camera), hl
;main.c:46: camera.view_y = CAM_START_Y; //We can set it to a max of 24, which is at the height end of the tilemap.
	ld	((_camera + 2)), hl
;main.c:47: camera.scroll_x = 0;
	ld	bc, #_camera + 4
	xor	a, a
	ld	(bc), a
;main.c:48: camera.scroll_y = 0;
	ld	hl, #(_camera + 5)
	ld	(hl), #0x00
;main.c:49: camera.coloffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 6)), hl
;main.c:50: camera.rowoffset = 0;
	ld	((_camera + 8)), hl
;main.c:51: SMS_setBGScrollX(camera.scroll_x);
	ld	a, (bc)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	call	_SMS_setBGScrollX
;main.c:52: SMS_setBGScrollY(camera.scroll_y);
	ld	hl, #(_camera + 5)
	ld	l, (hl)
;	spillPairReg hl
;main.c:53: }
	jp	_SMS_setBGScrollY
;main.c:54: void redraw_stage(void)
;	---------------------------------
; Function redraw_stage
; ---------------------------------
_redraw_stage::
;main.c:56: SMS_mapROMBank(brawl_street_tilemap_bin_bank);
	ld	hl, #_ROM_bank_to_be_mapped_on_slot2
	ld	(hl), #0x03
;main.c:57: for(unsigned int y = 0; y < 28; y++) //load the fight stage.
	ld	bc, #0x0000
00103$:
	ld	a, c
	sub	a, #0x1c
	ld	a, b
	sbc	a, #0x00
	ret	NC
;main.c:59: SMS_loadTileMap(0,y,brawl_street_tilemap_bin + camera.view_x + (((y + camera.view_y) * 96) * 2), 64); //96 * 2 == the tilemap width in tiles (3 screens.)
	ld	de, (#_camera + 0)
	ld	hl, #_brawl_street_tilemap_bin
	add	hl, de
	ex	de, hl
	ld	hl, (#(_camera + 2) + 0)
	add	hl, bc
	push	de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	pop	de
	add	hl, de
	ex	de, hl
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	ld	bc, #0x0040
	push	bc
	call	_SMS_VRAMmemcpy
	pop	bc
;main.c:57: for(unsigned int y = 0; y < 28; y++) //load the fight stage.
	inc	bc
;main.c:62: }
	jr	00103$
;main.c:64: void cam_pan_right(void) 
;	---------------------------------
; Function cam_pan_right
; ---------------------------------
_cam_pan_right::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-6
	add	hl, sp
	ld	sp, hl
;main.c:67: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	ld	a, (#(_camera + 4) + 0)
	and	a, #0x07
;main.c:74: for (unsigned char y = 0; y < 28; y++)
;main.c:67: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	or	a,#0x00
	jp	NZ, 00106$
	ld	hl, (#_camera + 0)
	ld	de, #0x0080
	cp	a, a
	sbc	hl, de
	jp	NC, 00106$
;main.c:69: camera.rowoffset = (camera.scroll_y / 8);
	ld	a, (#_camera + 5)
	ld	c, a
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	((_camera + 8)), bc
;main.c:71: unsigned char rowoffset = camera.rowoffset; //Save the last state of rowoffset in a temp variable.
;main.c:72: unsigned char ydex = 0; //We store the current y loop position, in order to subtract from the loop, to start at zero again when at last tile position.
	ld	-6 (ix), #0x00
;main.c:74: for (unsigned char y = 0; y < 28; y++)
	ld	-1 (ix), #0x00
00115$:
;main.c:67: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	ld	hl, #_camera
	ld	a, (hl)
	ld	-5 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-4 (ix), a
;main.c:74: for (unsigned char y = 0; y < 28; y++)
	ld	a, -1 (ix)
	sub	a, #0x1c
	jp	NC, 00104$
;main.c:76: if (y >= 28 - rowoffset && rowoffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
	ld	e, c
	ld	d, #0x00
	ld	hl, #0x001c
	cp	a, a
	sbc	hl, de
	ld	a, -1 (ix)
	ld	-3 (ix), a
	ld	-2 (ix), #0x00
	ld	a, -3 (ix)
	sub	a, l
	ld	a, -2 (ix)
	sbc	a, h
	jp	PO, 00189$
	xor	a, #0x80
00189$:
	jp	M, 00102$
	ld	a, c
	or	a, a
	jr	Z, 00102$
;main.c:78: rowoffset = 0; //removes the offset from the equation. we need to start at zero.
	ld	c, #0x00
;main.c:79: ydex = y; //store the y loop current index, to subtract it.
	ld	a, -1 (ix)
	ld	-6 (ix), a
00102$:
;main.c:81: SMS_loadTileMap(camera.coloffset,rowoffset + (y - ydex),brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
	ld	l, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	de, #0x0040
	add	hl, de
	ld	iy, #_brawl_street_tilemap_bin
	ex	de, hl
	add	iy, de
	ld	hl, (#_camera + 2)
	ld	e, -3 (ix)
	ld	d, -2 (ix)
	add	hl, de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	add	iy, de
	ld	e, c
	ld	d, #0x00
	ld	l, -6 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	b, #0x00
	ld	a, -3 (ix)
	sub	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -2 (ix)
	sbc	a, b
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	a, (#(_camera + 6) + 0)
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	ld	de, #0x0002
	push	de
	push	iy
	pop	de
	call	_SMS_VRAMmemcpy
	pop	bc
;main.c:74: for (unsigned char y = 0; y < 28; y++)
	inc	-1 (ix)
	jp	00115$
00104$:
;main.c:84: camera.view_x+= 2;
	ld	c, -5 (ix)
	ld	b, -4 (ix)
	inc	bc
	inc	bc
	ld	(_camera), bc
00106$:
;main.c:67: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	ld	hl, (#_camera + 0)
;main.c:86: if (camera.view_x < 128 || camera.view_x >= 128 && camera.scroll_x % 32 != 0)
	ld	de, #0x0080
	cp	a, a
	sbc	hl, de
	ld	a, #0x00
	rla
	or	a, a
	jr	NZ, 00108$
	ld	c, a
	bit	0, c
	jr	NZ, 00109$
	ld	a, (#(_camera + 4) + 0)
	and	a, #0x1f
	jr	Z, 00109$
00108$:
;main.c:88: camera.scroll_x--;
	ld	a, (#(_camera + 4) + 0)
	dec	a
	ld	(#(_camera + 4)),a
;main.c:89: camera.coloffset = 32 - (camera.scroll_x / 8); //Get the position of the x scroll register in tiles.
	ld	c, a
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, #0x20
	sub	a, c
	ld	c, a
	sbc	a, a
	sub	a, b
	ld	b, a
	ld	((_camera + 6)), bc
00109$:
;main.c:93: if (camera.coloffset == 32)
	ld	hl, (#(_camera + 6) + 0)
	ld	a, l
	sub	a, #0x20
	or	a, h
	jr	NZ, 00117$
;main.c:95: camera.coloffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 6)), hl
00117$:
;main.c:98: }
	ld	sp, ix
	pop	ix
	ret
;main.c:100: void cam_pan_left(void)
;	---------------------------------
; Function cam_pan_left
; ---------------------------------
_cam_pan_left::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-6
	add	hl, sp
	ld	sp, hl
;main.c:102: if (camera.view_x > 0)
	ld	hl, (#_camera + 0)
	ld	a, h
	or	a, l
	jr	Z, 00102$
;main.c:104: camera.scroll_x++;
	ld	bc, #_camera+4
	ld	a, (bc)
	inc	a
	ld	(bc), a
00102$:
;main.c:107: camera.coloffset = 32 - (camera.scroll_x / 8); //Get the position of the x scroll register in tiles.
	ld	bc, #_camera + 4
	ld	a, (bc)
	ld	e, a
	ld	d, #0x00
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	hl, #0x0020
	cp	a, a
	sbc	hl, de
	ex	de, hl
	ld	((_camera + 6)), de
;main.c:108: if (camera.coloffset == 32)
	ld	a, e
	sub	a, #0x20
	or	a, d
	jr	NZ, 00104$
;main.c:110: camera.coloffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 6)), hl
00104$:
;main.c:113: if (camera.scroll_x % 8 == 0 && camera.view_x > 0)
	ld	a, (bc)
	and	a, #0x07
	jp	NZ,00115$
	ld	hl, (#_camera + 0)
	ld	a, h
	or	a, l
	jp	Z, 00115$
;main.c:115: camera.rowoffset = (camera.scroll_y / 8);
	ld	a, (#_camera + 5)
	ld	c, a
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	((_camera + 8)), bc
;main.c:118: unsigned char rowoffset = camera.rowoffset; //Save the last state of rowoffset in a temp variable.
;main.c:119: unsigned char ydex = 0; //We store the current y loop position, in order to subtract from the loop, to start at zero again when at last tile position.
	ld	-6 (ix), #0x00
;main.c:120: for (unsigned char y = 0; y < 28; y++)
	ld	-1 (ix), #0x00
00113$:
;main.c:113: if (camera.scroll_x % 8 == 0 && camera.view_x > 0)
	ld	hl, (#_camera + 0)
;main.c:127: SMS_loadTileMap(camera.coloffset,rowoffset + (y - ydex),brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);            
	ld	a, l
	add	a, #0xfe
	ld	-5 (ix), a
	ld	a, h
	adc	a, #0xff
	ld	-4 (ix), a
;main.c:120: for (unsigned char y = 0; y < 28; y++)
	ld	a, -1 (ix)
	sub	a, #0x1c
	jp	NC, 00108$
;main.c:122: if (y >= 28 - rowoffset && rowoffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
	ld	e, c
	ld	d, #0x00
	ld	hl, #0x001c
	cp	a, a
	sbc	hl, de
	ld	a, -1 (ix)
	ld	-3 (ix), a
	ld	-2 (ix), #0x00
	ld	a, -3 (ix)
	sub	a, l
	ld	a, -2 (ix)
	sbc	a, h
	jp	PO, 00184$
	xor	a, #0x80
00184$:
	jp	M, 00106$
	ld	a, c
	or	a, a
	jr	Z, 00106$
;main.c:124: rowoffset = 0; //removes the offset from the equation. we need to start at zero.
	ld	c, #0x00
;main.c:125: ydex = y; //store the y loop current index, to subtract it.
	ld	a, -1 (ix)
	ld	-6 (ix), a
00106$:
;main.c:127: SMS_loadTileMap(camera.coloffset,rowoffset + (y - ydex),brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);            
	ld	iy, #_brawl_street_tilemap_bin
	ld	e, -5 (ix)
	ld	d, -4 (ix)
	add	iy, de
	ld	hl, (#_camera + 2)
	ld	e, -3 (ix)
	ld	d, -2 (ix)
	add	hl, de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	add	iy, de
	ld	e, c
	ld	d, #0x00
	ld	l, -6 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	b, #0x00
	ld	a, -3 (ix)
	sub	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -2 (ix)
	sbc	a, b
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	a, (#(_camera + 6) + 0)
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	ld	de, #0x0002
	push	de
	push	iy
	pop	de
	call	_SMS_VRAMmemcpy
	pop	bc
;main.c:120: for (unsigned char y = 0; y < 28; y++)
	inc	-1 (ix)
	jp	00113$
00108$:
;main.c:130: camera.view_x-= 2;
	ld	hl, #_camera
	ld	a, -5 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -4 (ix)
	ld	(hl), a
00115$:
;main.c:133: }
	ld	sp, ix
	pop	ix
	ret
;main.c:135: void cam_pan_up(void)
;	---------------------------------
; Function cam_pan_up
; ---------------------------------
_cam_pan_up::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;main.c:137: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register.
	ld	a, (#(_camera + 5) + 0)
	ld	c, a
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, #0x1c
	sub	a, c
	ld	c, a
	sbc	a, a
	sub	a, b
	ld	b, a
	ld	((_camera + 8)), bc
;main.c:139: if (camera.rowoffset == 28) //Tile placement is from 0-27. So when it hits 28 we need to reset the rowoffset.
	ld	a, c
	sub	a, #0x1c
	or	a, b
	jr	NZ, 00102$
;main.c:141: camera.rowoffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 8)), hl
00102$:
;main.c:145: if (camera.scroll_y % 8 == 0 && camera.view_y > 0)
	ld	a, (#(_camera + 5) + 0)
	ld	c, a
	ld	b, #0x00
	ld	a, c
	and	a, #0x07
	ld	e, a
	ld	d, #0x00
	ld	a, d
	or	a, e
	jp	NZ, 00108$
	ld	hl, (#(_camera + 2) + 0)
	xor	a, a
	cp	a, l
	sbc	a, h
	jp	PO, 00192$
	xor	a, #0x80
00192$:
	jp	P, 00108$
;main.c:147: camera.rowoffset = (camera.scroll_y / 8);
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	((_camera + 8)), bc
;main.c:149: unsigned char coloffset = camera.coloffset; //Save the last state of coloffset in a temp variable.
	ld	hl, #_camera + 6
	ld	c, (hl)
;main.c:150: unsigned char xdex = 0; //We store the current x loop position, in order to subtract from the loop, to start at zero again when at last tile position.
	ld	-4 (ix), #0x00
;main.c:152: for (unsigned char x = 0; x < 32; x++)
	ld	-1 (ix), #0x00
00116$:
;main.c:159: SMS_loadTileMap(coloffset + (x - xdex),camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);         
	ld	hl, (#(_camera + 2) + 0)
	ld	a, l
	add	a, #0xff
	ld	-3 (ix), a
	ld	a, h
	adc	a, #0xff
	ld	-2 (ix), a
;main.c:152: for (unsigned char x = 0; x < 32; x++)
	ld	a, -1 (ix)
	sub	a, #0x20
	jr	NC, 00106$
;main.c:154: if (x >= 32 - coloffset && coloffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
	ld	e, c
	ld	d, #0x00
	ld	hl, #0x0020
	cp	a, a
	sbc	hl, de
	ld	e, -1 (ix)
	ld	d, #0x00
	ld	a, e
	sub	a, l
	ld	a, d
	sbc	a, h
	jp	PO, 00193$
	xor	a, #0x80
00193$:
	jp	M, 00104$
	ld	a, c
	or	a, a
	jr	Z, 00104$
;main.c:156: coloffset = 0; //removes the offset from the equation. we need to start at zero.
	ld	c, #0x00
;main.c:157: xdex = x; //store the x loop current index, to subtract it.
	ld	a, -1 (ix)
	ld	-4 (ix), a
00104$:
;main.c:159: SMS_loadTileMap(coloffset + (x - xdex),camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);         
	ld	hl, (#_camera + 0)
	ex	de, hl
	add	hl, hl
	ex	de, hl
	add	hl, de
	ex	de, hl
	ld	iy, #_brawl_street_tilemap_bin
	add	iy, de
	ld	e, -3 (ix)
	ld	d, -2 (ix)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	add	iy, de
	ld	hl, (#(_camera + 8) + 0)
	dec	hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, -1 (ix)
	sub	a, -4 (ix)
	add	a, c
	ld	d, #0x00
	ld	e, a
	add	hl, de
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	ld	de, #0x0002
	push	de
	push	iy
	pop	de
	call	_SMS_VRAMmemcpy
	pop	bc
;main.c:152: for (unsigned char x = 0; x < 32; x++)
	inc	-1 (ix)
	jp	00116$
00106$:
;main.c:162: camera.view_y--;
	ld	hl, #(_camera + 2)
	ld	a, -3 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -2 (ix)
	ld	(hl), a
00108$:
;main.c:165: if (camera.view_y > 0 || camera.scroll_y % 32 != 0)
	ld	bc, (#(_camera + 2) + 0)
;main.c:137: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register.
	ld	hl, #(_camera + 5)
	ld	e, (hl)
;main.c:165: if (camera.view_y > 0 || camera.scroll_y % 32 != 0)
	xor	a, a
	cp	a, c
	sbc	a, b
	jp	PO, 00194$
	xor	a, #0x80
00194$:
	jp	M, 00112$
	ld	a, e
	and	a, #0x1f
	jr	Z, 00118$
00112$:
;main.c:168: camera.scroll_y--;
	dec	e
	ld	hl, #(_camera + 5)
	ld	(hl), e
;main.c:169: if (camera.scroll_y > 223)
	ld	a, #0xdf
	sub	a, e
	jr	NC, 00118$
;main.c:171: camera.scroll_y = 223;
	ld	(hl), #0xdf
00118$:
;main.c:175: }
	ld	sp, ix
	pop	ix
	ret
;main.c:177: void cam_pan_down(void)
;	---------------------------------
; Function cam_pan_down
; ---------------------------------
_cam_pan_down::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;main.c:180: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register in tiles.
	ld	bc, #_camera + 5
	ld	a, (bc)
	ld	e, a
	ld	d, #0x00
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	hl, #0x001c
	cp	a, a
	sbc	hl, de
	ex	de, hl
	ld	((_camera + 8)), de
;main.c:182: if (camera.view_y < 24) //Prvent the scrolling from going past the height of the map. 24 tiles = 192 pixels
	ld	hl, (#(_camera + 2) + 0)
	ld	de, #0x8018
	add	hl, hl
	ccf
	rr	h
	rr	l
	sbc	hl, de
	jr	NC, 00102$
;main.c:184: camera.scroll_y++;
	ld	a, (bc)
	inc	a
	ld	(bc), a
00102$:
;main.c:187: if (camera.scroll_y > 223) //We need to reset the scroll_y to prevent it from hitching the screen, from overflow.
	ld	a, (bc)
	ld	e, a
	ld	a, #0xdf
	sub	a, e
	jr	NC, 00104$
;main.c:189: camera.scroll_y = 0;
	xor	a, a
	ld	(bc), a
00104$:
;main.c:180: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register in tiles.
	ld	a, (bc)
;main.c:192: if (camera.scroll_y % 8 == 0 && camera.view_y < 24) //Time to update the row with tiles. Happens every 1 tile of scrolling. 8 x 8 pixels = 1 tile.
	ld	c, a
	ld	b, #0x00
	ld	a, c
	and	a, #0x07
	jp	NZ,00110$
	ld	hl, (#(_camera + 2) + 0)
	ld	de, #0x8018
	add	hl, hl
	ccf
	rr	h
	rr	l
	sbc	hl, de
	jp	NC, 00110$
;main.c:195: camera.rowoffset = (camera.scroll_y / 8) - 1;
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	dec	bc
	ld	((_camera + 8)), bc
;main.c:197: unsigned char coloffset = camera.coloffset; //Save the last state of coloffset in a temp variable.
	ld	hl, #_camera + 6
	ld	c, (hl)
;main.c:198: unsigned char xdex = 0; //We store the current x loop position, in order to subtract from the loop, to start at zero again when at last tile position.
	ld	-4 (ix), #0x00
;main.c:200: for (unsigned char x = 0; x < 32; x ++)
	ld	-1 (ix), #0x00
00115$:
;main.c:182: if (camera.view_y < 24) //Prvent the scrolling from going past the height of the map. 24 tiles = 192 pixels
	ld	hl, #(_camera + 2)
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
;main.c:200: for (unsigned char x = 0; x < 32; x ++)
	ld	a, -1 (ix)
	sub	a, #0x20
	jr	NC, 00108$
;main.c:202: if (x >= 32 - coloffset && coloffset != 0)//When screen is offset, as the loop reaches the edge of the screen, we need to reset the loop so it begins at zero to finish off tiling.
	ld	e, c
	ld	d, #0x00
	ld	hl, #0x0020
	cp	a, a
	sbc	hl, de
	ld	e, -1 (ix)
	ld	d, #0x00
	ld	a, e
	sub	a, l
	ld	a, d
	sbc	a, h
	jp	PO, 00191$
	xor	a, #0x80
00191$:
	jp	M, 00106$
	ld	a, c
	or	a, a
	jr	Z, 00106$
;main.c:204: coloffset = 0; //removes the offset from the equation. we need to start at zero.
	ld	c, #0x00
;main.c:205: xdex = x; //store the x loop current index, to subtract it.
	ld	a, -1 (ix)
	ld	-4 (ix), a
00106$:
;main.c:207: SMS_loadTileMap(coloffset + (x - xdex),camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	hl, (#_camera + 0)
	ex	de, hl
	add	hl, hl
	ex	de, hl
	add	hl, de
	ex	de, hl
	ld	hl, #_brawl_street_tilemap_bin
	add	hl, de
	ex	de, hl
	ld	a, -3 (ix)
	add	a, #0x1c
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -2 (ix)
	adc	a, #0x00
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	pop	de
	add	hl, de
	ex	de, hl
	ld	hl, (#(_camera + 8) + 0)
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, -1 (ix)
	sub	a, -4 (ix)
	add	a, c
	ld	b, #0x00
	add	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, b
	adc	a, h
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	ld	bc, #0x0002
	push	bc
	call	_SMS_VRAMmemcpy
	pop	bc
;main.c:200: for (unsigned char x = 0; x < 32; x ++)
	inc	-1 (ix)
	jp	00115$
00108$:
;main.c:211: camera.view_y++; //Increase the view_y by 1.
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	inc	bc
	ld	((_camera + 2)), bc
00110$:
;main.c:213: if (camera.rowoffset == 28) //Reset rowoffset because the nametable(the tilemap table in VRAM) only has 28 tiles in height (256 x 224. the 32 extra pixels in height is cropped in NTSC resolution..)
	ld	hl, (#(_camera + 8) + 0)
	ld	a, l
	sub	a, #0x1c
	or	a, h
	jr	NZ, 00117$
;main.c:215: camera.rowoffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 8)), hl
00117$:
;main.c:218: }
	ld	sp, ix
	pop	ix
	ret
;main.c:222: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:225: SMS_displayOff();
	ld	hl, #0x0140
	call	_SMS_VDPturnOffFeature
;main.c:228: SMS_VRAMmemsetW(0, 0x0000, 16384);
	ld	hl, #0x4000
	push	hl
	ld	de, #0x0000
	ld	h, l
	call	_SMS_VRAMmemsetW
;main.c:229: SMS_zeroBGPalette();
	call	_SMS_zeroBGPalette
;main.c:230: SMS_zeroSpritePalette();
	call	_SMS_zeroSpritePalette
;main.c:233: SMS_VDPturnOnFeature(VDPFEATURE_LEFTCOLBLANK);
	ld	hl, #0x0020
	call	_SMS_VDPturnOnFeature
;main.c:234: SMS_VDPturnOnFeature(VDPFEATURE_HIDEFIRSTCOL);
	ld	hl, #0x0020
	call	_SMS_VDPturnOnFeature
;main.c:237: SMS_mapROMBank(bg_pal_bin_bank);
	ld	hl, #_ROM_bank_to_be_mapped_on_slot2
	ld	(hl), #0x03
;main.c:238: SMS_loadBGPalette(bg_pal_bin);
	ld	hl, #_bg_pal_bin
	call	_SMS_loadBGPalette
;main.c:239: SMS_loadSpritePalette(spr_pal_bin);
	ld	hl, #_spr_pal_bin
	call	_SMS_loadSpritePalette
;main.c:242: SMS_setBackdropColor(15);
	ld	l, #0x0f
;	spillPairReg hl
;	spillPairReg hl
	call	_SMS_setBackdropColor
;main.c:245: SMS_loadPSGaidencompressedTiles(font_8x8_psgcompr,192);
	ld	de, #0x5800
	ld	hl, #_font_8x8_psgcompr
	call	_SMS_loadPSGaidencompressedTilesatAddr
;main.c:246: SMS_configureTextRenderer(160);
	ld	hl, #0x00a0
	call	_SMS_configureTextRenderer
;main.c:250: SMS_mapROMBank(brawl_street_tiles_psgcompr_bank);
	ld	hl, #_ROM_bank_to_be_mapped_on_slot2
	ld	(hl), #0x03
;main.c:251: SMS_loadPSGaidencompressedTiles(brawl_street_tiles_psgcompr,0);
	ld	de, #0x4000
	ld	hl, #_brawl_street_tiles_psgcompr
	call	_SMS_loadPSGaidencompressedTilesatAddr
;main.c:255: init_camera();
	call	_init_camera
;main.c:256: redraw_stage(); //Draw map at current view position.
	call	_redraw_stage
;main.c:259: SMS_displayOn();
	ld	hl, #0x0140
	call	_SMS_VDPturnOnFeature
00110$:
;main.c:266: if (SMS_getKeysHeld() & PORT_A_KEY_RIGHT)
	call	_SMS_getKeysHeld
	bit	3, e
	jr	Z, 00102$
;main.c:269: cam_pan_right();
	call	_cam_pan_right
00102$:
;main.c:271: if (SMS_getKeysHeld() & PORT_A_KEY_LEFT)
	call	_SMS_getKeysHeld
	bit	2, e
	jr	Z, 00104$
;main.c:274: cam_pan_left();
	call	_cam_pan_left
00104$:
;main.c:276: if (SMS_getKeysHeld() & PORT_A_KEY_UP)
	call	_SMS_getKeysHeld
	bit	0, e
	jr	Z, 00106$
;main.c:278: cam_pan_up();
	call	_cam_pan_up
00106$:
;main.c:280: if (SMS_getKeysHeld() & PORT_A_KEY_DOWN)
	call	_SMS_getKeysHeld
	bit	1, e
	jr	Z, 00108$
;main.c:282: cam_pan_down();
	call	_cam_pan_down
00108$:
;main.c:284: SMS_waitForVBlank();
	call	_SMS_waitForVBlank
;main.c:286: SMS_setBGScrollX(camera.scroll_x);
	ld	hl, #_camera + 4
	ld	l, (hl)
;	spillPairReg hl
	call	_SMS_setBGScrollX
;main.c:287: SMS_setBGScrollY(camera.scroll_y);
	ld	hl, #_camera + 5
	ld	l, (hl)
;	spillPairReg hl
	call	_SMS_setBGScrollY
;main.c:288: SMS_initSprites();
	call	_SMS_initSprites
;main.c:290: SMS_copySpritestoSAT();
	call	_SMS_copySpritestoSAT
;main.c:293: }
	jr	00110$
	.area _CODE
__str_0:
	.ascii "OrangeRevolt"
	.db 0x00
__str_1:
	.ascii "Scrolling"
	.db 0x00
__str_2:
	.ascii "8 way smooth scrolling example."
	.db 0x00
	.area _INITIALIZER
	.area _CABS (ABS)
	.org 0x7FF0
___SMS__SEGA_signature:
	.db #0x54	; 84	'T'
	.db #0x4d	; 77	'M'
	.db #0x52	; 82	'R'
	.db #0x20	; 32
	.db #0x53	; 83	'S'
	.db #0x45	; 69	'E'
	.db #0x47	; 71	'G'
	.db #0x41	; 65	'A'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x99	; 153
	.db #0x99	; 153
	.db #0x00	; 0
	.db #0x4c	; 76	'L'
	.org 0x7FD3
___SMS__SDSC_author:
	.ascii "OrangeRevolt"
	.db 0x00
	.org 0x7FC9
___SMS__SDSC_name:
	.ascii "Scrolling"
	.db 0x00
	.org 0x7FA9
___SMS__SDSC_descr:
	.ascii "8 way smooth scrolling example."
	.db 0x00
	.org 0x7FE0
___SMS__SDSC_signature:
	.db #0x53	; 83	'S'
	.db #0x44	; 68	'D'
	.db #0x53	; 83	'S'
	.db #0x43	; 67	'C'
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xd3	; 211
	.db #0x7f	; 127
	.db #0xc9	; 201
	.db #0x7f	; 127
	.db #0xa9	; 169
	.db #0x7f	; 127
