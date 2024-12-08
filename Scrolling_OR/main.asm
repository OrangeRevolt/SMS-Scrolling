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
	.globl _order_time
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
	.ds 12
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_order_time::
	.ds 2
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
;main.c:51: camera.pan_dir = -1;
	ld	hl, #0xffff
	ld	((_camera + 10)), hl
;main.c:52: SMS_setBGScrollX(camera.scroll_x);
	ld	a, (bc)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	call	_SMS_setBGScrollX
;main.c:53: SMS_setBGScrollY(camera.scroll_y);
	ld	hl, #(_camera + 5)
	ld	l, (hl)
;	spillPairReg hl
;main.c:54: }
	jp	_SMS_setBGScrollY
;main.c:55: void redraw_stage(void)
;	---------------------------------
; Function redraw_stage
; ---------------------------------
_redraw_stage::
;main.c:57: SMS_mapROMBank(brawl_street_tilemap_bin_bank);
	ld	hl, #_ROM_bank_to_be_mapped_on_slot2
	ld	(hl), #0x03
;main.c:58: for(unsigned int y = 0; y < 28; y++) //load the fight stage.
	ld	bc, #0x0000
00103$:
	ld	a, c
	sub	a, #0x1c
	ld	a, b
	sbc	a, #0x00
	ret	NC
;main.c:60: SMS_loadTileMap(0,y,brawl_street_tilemap_bin + camera.view_x + (((y + camera.view_y) * 96) * 2), 64); //96 * 2 == the tilemap width in tiles (3 screens.)
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
;main.c:58: for(unsigned int y = 0; y < 28; y++) //load the fight stage.
	inc	bc
;main.c:63: }
	jr	00103$
;main.c:80: void cam_pan_right(void) 
;	---------------------------------
; Function cam_pan_right
; ---------------------------------
_cam_pan_right::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-7
	add	hl, sp
	ld	sp, hl
;main.c:83: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	ld	a, (#(_camera + 4) + 0)
	and	a, #0x07
;main.c:87: for (unsigned char y = 0; y < 28; y++)
;main.c:83: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	or	a,#0x00
	jp	NZ, 00112$
	ld	hl, #_camera
	ld	a, (hl)
	ld	-7 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-6 (ix), a
	ld	a, -7 (ix)
	sub	a, #0x80
	ld	a, -6 (ix)
	sbc	a, #0x00
	jp	NC, 00112$
;main.c:85: if (camera.rowoffset == 0) //No offset on the row, so we don't need to split the row code.
	ld	hl, #(_camera + 8)
	ld	a, (hl)
	ld	-2 (ix), a
	inc	hl
	ld	a, (hl)
;main.c:87: for (unsigned char y = 0; y < 28; y++)
;main.c:85: if (camera.rowoffset == 0) //No offset on the row, so we don't need to split the row code.
	ld	-1 (ix), a
	or	a, -2 (ix)
	jr	NZ, 00109$
;main.c:87: for (unsigned char y = 0; y < 28; y++)
	ld	-1 (ix), #0x00
00121$:
;main.c:83: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	ld	hl, #_camera
	ld	a, (hl)
	ld	-7 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-6 (ix), a
;main.c:87: for (unsigned char y = 0; y < 28; y++)
	ld	a, -1 (ix)
	sub	a, #0x1c
	jp	NC, 00110$
;main.c:89: SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
	ld	a, -7 (ix)
	add	a, #0x40
	ld	c, a
	ld	a, -6 (ix)
	adc	a, #0x00
	ld	b, a
	ld	hl, #_brawl_street_tilemap_bin
	add	hl, bc
	ex	de, hl
	ld	c, -1 (ix)
	ld	b, #0x00
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
	ld	hl, (#(_camera + 8) + 0)
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	a, (#(_camera + 6) + 0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, #0x0002
	push	bc
	call	_SMS_VRAMmemcpy
;main.c:87: for (unsigned char y = 0; y < 28; y++)
	inc	-1 (ix)
	jr	00121$
00109$:
;main.c:92: else if (camera.rowoffset != 0)
	ld	a, -1 (ix)
	or	a, -2 (ix)
	jp	Z, 00110$
;main.c:94: camera.rowoffset = (camera.scroll_y / 8);
	ld	a, (#(_camera + 5) + 0)
	ld	c, a
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	((_camera + 8)), bc
;main.c:95: for (unsigned char y = 0; y < 28; y++)
	ld	-1 (ix), #0x00
00124$:
;main.c:83: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	ld	hl, #_camera
	ld	a, (hl)
	ld	-7 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-6 (ix), a
;main.c:95: for (unsigned char y = 0; y < 28; y++)
	ld	a, -1 (ix)
	sub	a, #0x1c
	jp	NC, 00110$
;main.c:98: if (y < 28 - (camera.scroll_y / 8)) 
	ld	a, (#(_camera + 5) + 0)
	ld	c, a
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	hl, #0x001c
	cp	a, a
	sbc	hl, bc
	ex	de, hl
	ld	c, -1 (ix)
	ld	b, #0x00
;main.c:85: if (camera.rowoffset == 0) //No offset on the row, so we don't need to split the row code.
	ld	hl, #(_camera + 8)
	ld	a, (hl)
	ld	-5 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-4 (ix), a
;main.c:89: SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
	ld	a, -7 (ix)
	add	a, #0x40
	ld	-3 (ix), a
	ld	a, -6 (ix)
	adc	a, #0x00
	ld	-2 (ix), a
;main.c:98: if (y < 28 - (camera.scroll_y / 8)) 
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	PO, 00223$
	xor	a, #0x80
00223$:
	jp	P, 00103$
;main.c:100: SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
	ld	a, -3 (ix)
	add	a, #<(_brawl_street_tilemap_bin)
	ld	e, a
	ld	a, -2 (ix)
	adc	a, #>(_brawl_street_tilemap_bin)
	ld	d, a
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
	ld	l, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	a, (#(_camera + 6) + 0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, #0x0002
	push	bc
	call	_SMS_VRAMmemcpy
	jr	00125$
00103$:
;main.c:104: SMS_loadTileMap(camera.coloffset,camera.rowoffset - 28 + y,brawl_street_tilemap_bin + (camera.view_x + 64) + (((y + camera.view_y) * 96) * 2),2);
	ld	a, #<(_brawl_street_tilemap_bin)
	add	a, -3 (ix)
	ld	e, a
	ld	a, #>(_brawl_street_tilemap_bin)
	adc	a, -2 (ix)
	ld	d, a
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
	ld	a, -5 (ix)
	add	a, #0xe4
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -4 (ix)
	adc	a, #0xff
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	a, (#(_camera + 6) + 0)
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, #0x0002
	push	bc
	call	_SMS_VRAMmemcpy
00125$:
;main.c:95: for (unsigned char y = 0; y < 28; y++)
	inc	-1 (ix)
	jp	00124$
00110$:
;main.c:109: camera.view_x+= 2;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	ld	(_camera), bc
00112$:
;main.c:83: if (camera.scroll_x % 8 == 0 && camera.view_x < 128) //When scroll_x remainder is zero, it's time to place tiles. Also don't draw tiles when at map end.
	ld	hl, (#_camera + 0)
	ld	de, #0x0080
	cp	a, a
	sbc	hl, de
	ld	a, #0x00
	rla
;main.c:111: if (camera.view_x < 128 || camera.view_x >= 128 && camera.scroll_x % 32 != 0)
	or	a, a
	jr	NZ, 00114$
	ld	c, a
	bit	0, c
	jr	NZ, 00115$
	ld	a, (#(_camera + 4) + 0)
	and	a, #0x1f
	jr	Z, 00115$
00114$:
;main.c:113: camera.scroll_x--;
	ld	a, (#(_camera + 4) + 0)
	dec	a
	ld	(#(_camera + 4)),a
;main.c:114: camera.coloffset = 32 - (camera.scroll_x / 8); //Get the position of the x scroll register in tiles.
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
00115$:
;main.c:118: if (camera.coloffset == 32)
	ld	hl, (#(_camera + 6) + 0)
	ld	a, l
	sub	a, #0x20
	or	a, h
	jr	NZ, 00126$
;main.c:120: camera.coloffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 6)), hl
00126$:
;main.c:123: }
	ld	sp, ix
	pop	ix
	ret
;main.c:125: void cam_pan_left(void)
;	---------------------------------
; Function cam_pan_left
; ---------------------------------
_cam_pan_left::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-7
	add	hl, sp
	ld	sp, hl
;main.c:127: if (camera.view_x > 0)
	ld	hl, (#_camera + 0)
	ld	a, h
	or	a, l
	jr	Z, 00102$
;main.c:129: camera.scroll_x++;
	ld	bc, #_camera+4
	ld	a, (bc)
	inc	a
	ld	(bc), a
00102$:
;main.c:132: camera.coloffset = 32 - (camera.scroll_x / 8); //Get the position of the x scroll register in tiles.
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
;main.c:133: if (camera.coloffset == 32)
	ld	a, e
	sub	a, #0x20
	or	a, d
	jr	NZ, 00104$
;main.c:135: camera.coloffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 6)), hl
00104$:
;main.c:139: if (camera.scroll_x % 8 == 0 && camera.view_x > 0)
	ld	a, (bc)
	and	a, #0x07
	jp	NZ,00124$
	ld	hl, #_camera
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
	or	a, -3 (ix)
	jp	Z, 00124$
;main.c:141: if (camera.rowoffset == 0)
	ld	hl, #(_camera + 8)
	ld	a, (hl)
	ld	-5 (ix), a
	inc	hl
	ld	a, (hl)
;main.c:143: for (unsigned char y = 0; y < 28; y++)
;main.c:141: if (camera.rowoffset == 0)
	ld	-4 (ix), a
	or	a, -5 (ix)
	jr	NZ, 00113$
;main.c:143: for (unsigned char y = 0; y < 28; y++)
	ld	-1 (ix), #0x00
00119$:
;main.c:139: if (camera.scroll_x % 8 == 0 && camera.view_x > 0)
	ld	hl, #_camera
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
;main.c:143: for (unsigned char y = 0; y < 28; y++)
	ld	a, -1 (ix)
	sub	a, #0x1c
	jp	NC, 00114$
;main.c:145: SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	dec	bc
	dec	bc
	ld	hl, #_brawl_street_tilemap_bin
	add	hl, bc
	ex	de, hl
	ld	c, -1 (ix)
	ld	b, #0x00
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
	ld	hl, (#(_camera + 8) + 0)
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	a, (#(_camera + 6) + 0)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, #0x0002
	push	bc
	call	_SMS_VRAMmemcpy
;main.c:143: for (unsigned char y = 0; y < 28; y++)
	inc	-1 (ix)
	jr	00119$
00113$:
;main.c:148: else if (camera.rowoffset != 0)
	ld	a, -4 (ix)
	or	a, -5 (ix)
	jp	Z, 00114$
;main.c:150: camera.rowoffset = (camera.scroll_y / 8);
	ld	a, (#(_camera + 5) + 0)
	ld	c, a
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	((_camera + 8)), bc
;main.c:151: for (unsigned char y = 0; y < 28; y++)
	ld	-1 (ix), #0x00
00122$:
;main.c:139: if (camera.scroll_x % 8 == 0 && camera.view_x > 0)
	ld	hl, #_camera
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
;main.c:151: for (unsigned char y = 0; y < 28; y++)
	ld	a, -1 (ix)
	sub	a, #0x1c
	jp	NC, 00114$
;main.c:154: if (y < 28 - (camera.scroll_y / 8)) 
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
	ld	-7 (ix), a
	sbc	a, a
	sub	a, b
	ld	-6 (ix), a
	ld	c, -1 (ix)
	ld	b, #0x00
;main.c:141: if (camera.rowoffset == 0)
	ld	de, (#(_camera + 8) + 0)
;main.c:145: SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
	ld	hl, #(_camera + 6)
	ld	l, (hl)
;	spillPairReg hl
	ld	a, -3 (ix)
	add	a, #0xfe
	ld	-5 (ix), a
	ld	a, -2 (ix)
	adc	a, #0xff
	ld	-4 (ix), a
;main.c:156: SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
	ld	-3 (ix), l
	ld	-2 (ix), #0x00
;main.c:154: if (y < 28 - (camera.scroll_y / 8)) 
	ld	a, c
	sub	a, -7 (ix)
	ld	a, b
	sbc	a, -6 (ix)
	jp	PO, 00218$
	xor	a, #0x80
00218$:
	jp	P, 00107$
;main.c:156: SMS_loadTileMap(camera.coloffset,camera.rowoffset + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
	ld	iy, #_brawl_street_tilemap_bin
	push	bc
	ld	c, -5 (ix)
	ld	b, -4 (ix)
	add	iy, bc
	pop	bc
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
	push	bc
	ld	c, l
	ld	b, h
	add	iy, bc
	pop	bc
	ex	de, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e, -3 (ix)
	ld	d, #0x00
	add	hl, de
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, #0x0002
	push	de
	push	iy
	pop	de
	call	_SMS_VRAMmemcpy
	jr	00123$
00107$:
;main.c:160: SMS_loadTileMap(camera.coloffset,camera.rowoffset - 28 + y,brawl_street_tilemap_bin + (camera.view_x - 2) + (((y + camera.view_y) * 96) * 2),2);
	ld	iy, #_brawl_street_tilemap_bin
	push	bc
	ld	c, -5 (ix)
	ld	b, -4 (ix)
	add	iy, bc
	pop	bc
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
	push	bc
	ld	c, l
	ld	b, h
	add	iy, bc
	pop	bc
	ld	a, e
	add	a, #0xe4
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, d
	adc	a, #0xff
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e, -3 (ix)
	ld	d, #0x00
	add	hl, de
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, #0x0002
	push	de
	push	iy
	pop	de
	call	_SMS_VRAMmemcpy
00123$:
;main.c:151: for (unsigned char y = 0; y < 28; y++)
	inc	-1 (ix)
	jp	00122$
00114$:
;main.c:165: camera.view_x-= 2;
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	dec	bc
	dec	bc
	ld	(_camera), bc
00124$:
;main.c:168: }
	ld	sp, ix
	pop	ix
	ret
;main.c:170: void cam_pan_up(void)
;	---------------------------------
; Function cam_pan_up
; ---------------------------------
_cam_pan_up::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-12
	add	hl, sp
	ld	sp, hl
;main.c:172: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register.
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
;main.c:174: if (camera.rowoffset == 28) //Tile placement is from 0-27. So when it hits 28 we need to reset the rowoffset.
	ld	a, c
	sub	a, #0x1c
	or	a, b
	jr	NZ, 00102$
;main.c:176: camera.rowoffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 8)), hl
00102$:
;main.c:181: if (camera.scroll_y % 8 == 0 && camera.view_y > 0)
	ld	a, (#(_camera + 5) + 0)
	ld	-4 (ix), a
	ld	-3 (ix), #0x00
	ld	a, -4 (ix)
	and	a, #0x07
	or	a,#0x00
	jp	NZ, 00116$
	ld	hl, (#(_camera + 2) + 0)
	xor	a, a
	cp	a, l
	sbc	a, h
	jp	PO, 00232$
	xor	a, #0x80
00232$:
	jp	P, 00116$
;main.c:186: if (camera.coloffset == 0)
	ld	hl, #(_camera + 6)
	ld	a, (hl)
	ld	-2 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-1 (ix), a
	or	a, -2 (ix)
	jr	NZ, 00113$
;main.c:188: for (unsigned char x = 0; x < 32; x++)
	ld	c, #0x00
00124$:
	ld	a, c
	sub	a, #0x20
	jp	NC, 00114$
;main.c:190: SMS_loadTileMap(camera.coloffset + x,-camera.rowoffset + 27,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
	ld	de, (#_camera + 0)
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, de
	ex	de, hl
	ld	iy, #_brawl_street_tilemap_bin
	add	iy, de
	ld	hl, (#(_camera + 2) + 0)
	dec	hl
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
	ld	hl, (#(_camera + 8) + 0)
	xor	a, a
	sub	a, l
	ld	e, a
	sbc	a, a
	sub	a, h
	ld	d, a
	ld	hl, #0x001b
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	a, (#(_camera + 6) + 0)
	ld	b, c
	add	a, b
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
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
;main.c:188: for (unsigned char x = 0; x < 32; x++)
	inc	c
	jr	00124$
00113$:
;main.c:193: else if (camera.coloffset != 0)
	ld	a, -1 (ix)
	or	a, -2 (ix)
	jp	Z, 00114$
;main.c:195: camera.rowoffset = (camera.scroll_y / 8); //(camera.scroll_y / 8) - 1
	ld	c, -4 (ix)
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	((_camera + 8)), bc
;main.c:196: if (camera.rowoffset == 0)
	ld	hl, (#(_camera + 8) + 0)
	ld	a, h
	or	a, l
	jr	NZ, 00145$
;main.c:198: camera.rowoffset = 28;
	ld	hl, #0x001c
	ld	((_camera + 8)), hl
;main.c:200: for (unsigned char x = 0; x < 32; x++)
00145$:
	ld	-1 (ix), #0x00
00127$:
	ld	a, -1 (ix)
	sub	a, #0x20
	jp	NC, 00114$
;main.c:202: if (x < 32 - camera.coloffset)
	ld	bc, (#(_camera + 6) + 0)
	ld	a, #0x20
	sub	a, c
	ld	-12 (ix), a
	sbc	a, a
	sub	a, b
	ld	-11 (ix), a
	ld	a, -1 (ix)
	ld	-10 (ix), a
	ld	-9 (ix), #0x00
;main.c:190: SMS_loadTileMap(camera.coloffset + x,-camera.rowoffset + 27,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
	ld	hl, #_camera
	ld	a, (hl)
	ld	-8 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-7 (ix), a
	ld	de, (#(_camera + 2) + 0)
	ld	hl, #(_camera + 8)
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
;main.c:204: SMS_loadTileMap(camera.coloffset + x,camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
	ld	l, -10 (ix)
	ld	h, -9 (ix)
	add	hl, hl
	ld	a, -1 (ix)
	ld	-6 (ix), a
	dec	de
	ld	a, -3 (ix)
	add	a, #0xff
	ld	-5 (ix), a
	ld	a, -2 (ix)
	adc	a, #0xff
	ld	-4 (ix), a
	ld	a, -8 (ix)
	add	a, l
	ld	-3 (ix), a
	ld	a, -7 (ix)
	adc	a, h
	ld	-2 (ix), a
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
	ld	l, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	-5 (ix), l
	ld	-4 (ix), h
;main.c:202: if (x < 32 - camera.coloffset)
	ld	a, -10 (ix)
	sub	a, -12 (ix)
	ld	a, -9 (ix)
	sbc	a, -11 (ix)
	jp	PO, 00233$
	xor	a, #0x80
00233$:
	jp	P, 00107$
;main.c:204: SMS_loadTileMap(camera.coloffset + x,camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
	ld	a, #<(_brawl_street_tilemap_bin)
	add	a, -3 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #>(_brawl_street_tilemap_bin)
	adc	a, -2 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	ex	de, hl
	ld	a, c
	add	a, -6 (ix)
	ld	c, a
	ld	b, #0x00
	ld	l, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, #0x0002
	push	bc
	call	_SMS_VRAMmemcpy
	jr	00128$
00107$:
;main.c:208: SMS_loadTileMap(camera.coloffset - 32 + x,camera.rowoffset - 1,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y - 1) * 96) * 2),2);
	ld	a, #<(_brawl_street_tilemap_bin)
	add	a, -3 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #>(_brawl_street_tilemap_bin)
	adc	a, -2 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	ex	de, hl
	ld	a, c
	add	a, #0xe0
	add	a, -6 (ix)
	ld	c, a
	ld	b, #0x00
	ld	l, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, #0x0002
	push	bc
	call	_SMS_VRAMmemcpy
00128$:
;main.c:200: for (unsigned char x = 0; x < 32; x++)
	inc	-1 (ix)
	jp	00127$
00114$:
;main.c:214: camera.view_y--;
	ld	bc, (#(_camera + 2) + 0)
	dec	bc
	ld	((_camera + 2)), bc
00116$:
;main.c:217: if (camera.view_y > 0 || camera.scroll_y % 32 != 0)
	ld	bc, (#(_camera + 2) + 0)
;main.c:172: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register.
	ld	hl, #(_camera + 5)
	ld	e, (hl)
;main.c:217: if (camera.view_y > 0 || camera.scroll_y % 32 != 0)
	xor	a, a
	cp	a, c
	sbc	a, b
	jp	PO, 00234$
	xor	a, #0x80
00234$:
	jp	M, 00120$
	ld	a, e
	and	a, #0x1f
	jr	Z, 00129$
00120$:
;main.c:220: camera.scroll_y--;
	dec	e
	ld	hl, #(_camera + 5)
	ld	(hl), e
;main.c:221: if (camera.scroll_y > 223)
	ld	a, #0xdf
	sub	a, e
	jr	NC, 00129$
;main.c:223: camera.scroll_y = 223;
	ld	(hl), #0xdf
00129$:
;main.c:228: }
	ld	sp, ix
	pop	ix
	ret
;main.c:230: void cam_pan_down(void)
;	---------------------------------
; Function cam_pan_down
; ---------------------------------
_cam_pan_down::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-11
	add	hl, sp
	ld	sp, hl
;main.c:233: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register in tiles.
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
;main.c:236: if (camera.view_y < 24)
	ld	hl, (#(_camera + 2) + 0)
	ld	de, #0x8018
	add	hl, hl
	ccf
	rr	h
	rr	l
	sbc	hl, de
	jr	NC, 00102$
;main.c:238: camera.scroll_y++;
	ld	a, (bc)
	inc	a
	ld	(bc), a
00102$:
;main.c:241: if (camera.scroll_y > 223)
	ld	a, (bc)
	ld	e, a
	ld	a, #0xdf
	sub	a, e
	jr	NC, 00104$
;main.c:243: camera.scroll_y = 0;
	xor	a, a
	ld	(bc), a
00104$:
;main.c:233: camera.rowoffset = 28 - (camera.scroll_y/8); //Get the position of the y scroll register in tiles.
	ld	a, (bc)
;main.c:245: if (camera.scroll_y % 8 == 0 && camera.view_y < 24)
	ld	-7 (ix), a
	ld	-6 (ix), #0x00
	ld	a, -7 (ix)
	and	a, #0x07
	jp	NZ,00117$
;main.c:236: if (camera.view_y < 24)
	ld	hl, #(_camera + 2)
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
;main.c:245: if (camera.scroll_y % 8 == 0 && camera.view_y < 24)
	ld	a, -3 (ix)
	sub	a, #0x18
	ld	a, -2 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jp	NC, 00117$
;main.c:248: if (camera.coloffset == 0)
	ld	hl, #(_camera + 6)
	ld	a, (hl)
	ld	-5 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-4 (ix), a
	or	a, -5 (ix)
	jr	NZ, 00114$
;main.c:250: for (unsigned char x = 0; x < 32; x ++)
	ld	c, #0x00
00122$:
;main.c:236: if (camera.view_y < 24)
	ld	hl, #(_camera + 2)
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
;main.c:250: for (unsigned char x = 0; x < 32; x ++)
	ld	a, c
	sub	a, #0x20
	jp	NC, 00115$
;main.c:252: SMS_loadTileMap(camera.coloffset + x,-camera.rowoffset + 28,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	de, (#_camera + 0)
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, de
	ex	de, hl
	ld	iy, #_brawl_street_tilemap_bin
	add	iy, de
	ld	l, -3 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	de, #0x001c
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
	ld	hl, (#(_camera + 8) + 0)
	xor	a, a
	sub	a, l
	ld	e, a
	sbc	a, a
	sub	a, h
	ld	d, a
	ld	hl, #0x001c
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	a, (#(_camera + 6) + 0)
	ld	b, c
	add	a, b
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
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
;main.c:250: for (unsigned char x = 0; x < 32; x ++)
	inc	c
	jr	00122$
00114$:
;main.c:255: else if (camera.coloffset != 0 && camera.view_y < 23)
	ld	a, -4 (ix)
	or	a, -5 (ix)
	jp	Z, 00115$
	ld	a, -3 (ix)
	sub	a, #0x17
	ld	a, -2 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jp	NC, 00115$
;main.c:257: camera.rowoffset = (camera.scroll_y / 8) - 1;
	ld	c, -7 (ix)
	ld	b, #0x00
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	dec	bc
	ld	((_camera + 8)), bc
;main.c:258: for (unsigned char x = 0; x < 32; x++)
	ld	-1 (ix), #0x00
00125$:
;main.c:236: if (camera.view_y < 24)
	ld	hl, #(_camera + 2)
	ld	a, (hl)
	ld	-3 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-2 (ix), a
;main.c:258: for (unsigned char x = 0; x < 32; x++)
	ld	a, -1 (ix)
	sub	a, #0x20
	jp	NC, 00115$
;main.c:260: if (x < 32 - camera.coloffset)
	ld	bc, (#(_camera + 6) + 0)
	ld	a, #0x20
	sub	a, c
	ld	-11 (ix), a
	sbc	a, a
	sub	a, b
	ld	-10 (ix), a
	ld	a, -1 (ix)
	ld	-9 (ix), a
	ld	-8 (ix), #0x00
;main.c:252: SMS_loadTileMap(camera.coloffset + x,-camera.rowoffset + 28,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	hl, #_camera
	ld	a, (hl)
	ld	-7 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-6 (ix), a
	ld	de, (#(_camera + 8) + 0)
;main.c:262: SMS_loadTileMap(camera.coloffset + x,camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	add	hl, hl
	ld	-5 (ix), c
	ld	a, -1 (ix)
	ld	-4 (ix), a
;main.c:252: SMS_loadTileMap(camera.coloffset + x,-camera.rowoffset + 28,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	a, -3 (ix)
	add	a, #0x1c
	ld	c, a
	ld	a, -2 (ix)
	adc	a, #0x00
	ld	b, a
;main.c:262: SMS_loadTileMap(camera.coloffset + x,camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	a, -7 (ix)
	add	a, l
	ld	-3 (ix), a
	ld	a, -6 (ix)
	adc	a, h
	ld	-2 (ix), a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ex	de, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
;main.c:260: if (x < 32 - camera.coloffset)
	ld	a, -9 (ix)
	sub	a, -11 (ix)
	ld	a, -8 (ix)
	sbc	a, -10 (ix)
	jp	PO, 00230$
	xor	a, #0x80
00230$:
	jp	P, 00107$
;main.c:262: SMS_loadTileMap(camera.coloffset + x,camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	a, #<(_brawl_street_tilemap_bin)
	add	a, -3 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #>(_brawl_street_tilemap_bin)
	adc	a, -2 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, -5 (ix)
	add	a, -4 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, #0x0002
	push	de
	ld	e, c
	ld	d, b
	call	_SMS_VRAMmemcpy
	jr	00126$
00107$:
;main.c:266: SMS_loadTileMap(camera.coloffset - 32 + x,camera.rowoffset,brawl_street_tilemap_bin + (camera.view_x + (x * 2)) + (((camera.view_y + 28) * 96) * 2),2);
	ld	a, #<(_brawl_street_tilemap_bin)
	add	a, -3 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #>(_brawl_street_tilemap_bin)
	adc	a, -2 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, -5 (ix)
	add	a, #0xe0
	add	a, -4 (ix)
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
	ld	de, #0x0002
	push	de
	ld	e, c
	ld	d, b
	call	_SMS_VRAMmemcpy
00126$:
;main.c:258: for (unsigned char x = 0; x < 32; x++)
	inc	-1 (ix)
	jp	00125$
00115$:
;main.c:271: camera.view_y++;
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	inc	bc
	ld	((_camera + 2)), bc
00117$:
;main.c:273: if (camera.rowoffset == 28)
	ld	hl, (#(_camera + 8) + 0)
	ld	a, l
	sub	a, #0x1c
	or	a, h
	jr	NZ, 00127$
;main.c:275: camera.rowoffset = 0;
	ld	hl, #0x0000
	ld	((_camera + 8)), hl
00127$:
;main.c:278: }
	ld	sp, ix
	pop	ix
	ret
;main.c:282: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:285: SMS_displayOff();
	ld	hl, #0x0140
	call	_SMS_VDPturnOffFeature
;main.c:287: SMS_VRAMmemsetW(0, 0x0000, 16384);
	ld	hl, #0x4000
	push	hl
	ld	de, #0x0000
	ld	h, l
	call	_SMS_VRAMmemsetW
;main.c:288: SMS_zeroBGPalette();
	call	_SMS_zeroBGPalette
;main.c:289: SMS_zeroSpritePalette();
	call	_SMS_zeroSpritePalette
;main.c:292: SMS_VDPturnOnFeature(VDPFEATURE_LEFTCOLBLANK);
	ld	hl, #0x0020
	call	_SMS_VDPturnOnFeature
;main.c:293: SMS_VDPturnOnFeature(VDPFEATURE_HIDEFIRSTCOL);
	ld	hl, #0x0020
	call	_SMS_VDPturnOnFeature
;main.c:295: SMS_mapROMBank(bg_pal_bin_bank);
	ld	hl, #_ROM_bank_to_be_mapped_on_slot2
	ld	(hl), #0x03
;main.c:296: SMS_loadBGPalette(bg_pal_bin);
	ld	hl, #_bg_pal_bin
	call	_SMS_loadBGPalette
;main.c:297: SMS_loadSpritePalette(spr_pal_bin);
	ld	hl, #_spr_pal_bin
	call	_SMS_loadSpritePalette
;main.c:299: SMS_setBackdropColor(15);
	ld	l, #0x0f
;	spillPairReg hl
;	spillPairReg hl
	call	_SMS_setBackdropColor
;main.c:302: SMS_loadPSGaidencompressedTiles(font_8x8_psgcompr,192);
	ld	de, #0x5800
	ld	hl, #_font_8x8_psgcompr
	call	_SMS_loadPSGaidencompressedTilesatAddr
;main.c:303: SMS_configureTextRenderer(160);
	ld	hl, #0x00a0
	call	_SMS_configureTextRenderer
;main.c:307: SMS_mapROMBank(brawl_street_tiles_psgcompr_bank);
	ld	hl, #_ROM_bank_to_be_mapped_on_slot2
	ld	(hl), #0x03
;main.c:308: SMS_loadPSGaidencompressedTiles(brawl_street_tiles_psgcompr,0);
	ld	de, #0x4000
	ld	hl, #_brawl_street_tiles_psgcompr
	call	_SMS_loadPSGaidencompressedTilesatAddr
;main.c:309: redraw_stage(); //Draw map at current view position.
	call	_redraw_stage
;main.c:312: init_camera();
	call	_init_camera
;main.c:315: SMS_displayOn();
	ld	hl, #0x0140
	call	_SMS_VDPturnOnFeature
00174$:
;main.c:321: if ((SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && (SMS_getKeysHeld() & PORT_A_KEY_DOWN) && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && camera.view_x < 130 && camera.view_y < 24)
	call	_SMS_getKeysHeld
	bit	3, e
	jr	Z, 00131$
	call	_SMS_getKeysHeld
	bit	1, e
	jr	Z, 00131$
	call	_SMS_getKeysHeld
	bit	2, e
	jr	NZ, 00131$
	call	_SMS_getKeysHeld
	bit	0, e
	jr	NZ, 00131$
	ld	hl, (#_camera + 0)
	ld	de, #0x0082
	cp	a, a
	sbc	hl, de
	jr	NC, 00131$
	ld	hl, (#_camera + 2)
	ld	de, #0x8018
	add	hl, hl
	ccf
	rr	h
	rr	l
	sbc	hl, de
	jr	NC, 00131$
;main.c:323: camera.pan_dir = DOWN_RIGHT;
	ld	hl, #0x0004
	ld	((_camera + 10)), hl
;main.c:324: cam_pan_down();
	call	_cam_pan_down
;main.c:325: cam_pan_right();            
	call	_cam_pan_right
	jp	00132$
00131$:
;main.c:327: else if ((SMS_getKeysHeld() & PORT_A_KEY_LEFT) && (SMS_getKeysHeld() & PORT_A_KEY_DOWN) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && camera.view_x > 0 && camera.view_y < 24)
	call	_SMS_getKeysHeld
	bit	2, e
	jr	Z, 00123$
	call	_SMS_getKeysHeld
	bit	1, e
	jr	Z, 00123$
	call	_SMS_getKeysHeld
	bit	3, e
	jr	NZ, 00123$
	call	_SMS_getKeysHeld
	bit	0, e
	jr	NZ, 00123$
	ld	hl, (#_camera + 0)
	ld	a, h
	or	a, l
	jr	Z, 00123$
	ld	hl, (#_camera + 2)
	ld	de, #0x8018
	add	hl, hl
	ccf
	rr	h
	rr	l
	sbc	hl, de
	jr	NC, 00123$
;main.c:329: camera.pan_dir = DOWN_LEFT;
	ld	hl, #0x0005
	ld	((_camera + 10)), hl
;main.c:330: cam_pan_down();
	call	_cam_pan_down
;main.c:331: cam_pan_left();       
	call	_cam_pan_left
	jp	00132$
00123$:
;main.c:333: else if ((SMS_getKeysHeld() & PORT_A_KEY_UP) && (SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.view_x > 0 && camera.scroll_y > 0)
	call	_SMS_getKeysHeld
	bit	0, e
	jr	Z, 00115$
	call	_SMS_getKeysHeld
	bit	2, e
	jr	Z, 00115$
	call	_SMS_getKeysHeld
	bit	3, e
	jr	NZ, 00115$
	call	_SMS_getKeysHeld
	bit	1, e
	jr	NZ, 00115$
	ld	hl, (#_camera + 0)
	ld	a, h
	or	a, l
	jr	Z, 00115$
	ld	a, (#_camera + 5)
	or	a, a
	jr	Z, 00115$
;main.c:335: camera.pan_dir = UP_LEFT;
	ld	hl, #0x0006
	ld	((_camera + 10)), hl
;main.c:336: cam_pan_up();
	call	_cam_pan_up
;main.c:337: cam_pan_left();
	call	_cam_pan_left
	jr	00132$
00115$:
;main.c:339: else if ((SMS_getKeysHeld() & PORT_A_KEY_UP) && (SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.view_x < 130 && camera.scroll_y > 0)
	call	_SMS_getKeysHeld
	bit	0, e
	jr	Z, 00107$
	call	_SMS_getKeysHeld
	bit	3, e
	jr	Z, 00107$
	call	_SMS_getKeysHeld
	bit	2, e
	jr	NZ, 00107$
	call	_SMS_getKeysHeld
	bit	1, e
	jr	NZ, 00107$
	ld	hl, (#_camera + 0)
	ld	de, #0x0082
	cp	a, a
	sbc	hl, de
	jr	NC, 00107$
	ld	a, (#_camera + 5)
	or	a, a
	jr	Z, 00107$
;main.c:341: camera.pan_dir = UP_RIGHT;
	ld	hl, #0x0007
	ld	((_camera + 10)), hl
;main.c:342: cam_pan_up();
	call	_cam_pan_up
;main.c:343: cam_pan_right();            
	call	_cam_pan_right
	jr	00132$
00107$:
;main.c:347: if (camera.pan_dir == DOWN_LEFT || camera.pan_dir == DOWN_RIGHT || camera.pan_dir == UP_LEFT || camera.pan_dir == UP_RIGHT)
	ld	hl, (#(_camera + 10) + 0)
	ld	a, l
	sub	a, #0x05
	or	a, h
	jr	Z, 00101$
	ld	a, l
	sub	a, #0x04
	or	a, h
	jr	Z, 00101$
	ld	a, l
	sub	a, #0x06
	or	a, h
	jr	Z, 00101$
	ld	a, l
	sub	a, #0x07
	or	a, h
	jr	NZ, 00132$
00101$:
;main.c:349: camera.pan_dir = -1;
	ld	hl, #0xffff
	ld	((_camera + 10)), hl
00132$:
;main.c:353: if (SMS_getKeysHeld() & PORT_A_KEY_RIGHT && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT)
	call	_SMS_getKeysHeld
	bit	3, e
	jr	Z, 00165$
	call	_SMS_getKeysHeld
	bit	0, e
	jr	NZ, 00165$
	call	_SMS_getKeysHeld
	bit	1, e
	jr	NZ, 00165$
	ld	hl, (#(_camera + 10) + 0)
	ld	a, l
	sub	a, #0x04
	or	a, h
	jr	Z, 00165$
	ld	a, l
	sub	a, #0x05
	or	a, h
	jr	Z, 00165$
	ld	a, l
	sub	a, #0x07
	or	a, h
	jr	Z, 00165$
	ld	a, l
	sub	a, #0x06
	or	a, h
	jr	Z, 00165$
;main.c:355: camera.pan_dir = RIGHT;
	ld	hl, #0x0000
	ld	((_camera + 10)), hl
;main.c:356: cam_pan_right();
	call	_cam_pan_right
	jp	00166$
00165$:
;main.c:358: else if (SMS_getKeysHeld() & PORT_A_KEY_LEFT && !(SMS_getKeysHeld() & PORT_A_KEY_UP) && !(SMS_getKeysHeld() & PORT_A_KEY_DOWN) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT )
	call	_SMS_getKeysHeld
	bit	2, e
	jr	Z, 00156$
	call	_SMS_getKeysHeld
	bit	0, e
	jr	NZ, 00156$
	call	_SMS_getKeysHeld
	bit	1, e
	jr	NZ, 00156$
	ld	hl, (#(_camera + 10) + 0)
	ld	a, l
	sub	a, #0x04
	or	a, h
	jr	Z, 00156$
	ld	a, l
	sub	a, #0x05
	or	a, h
	jr	Z, 00156$
	ld	a, l
	sub	a, #0x07
	or	a, h
	jr	Z, 00156$
	ld	a, l
	sub	a, #0x06
	or	a, h
	jr	Z, 00156$
;main.c:360: camera.pan_dir = LEFT;
	ld	hl, #0x0001
	ld	((_camera + 10)), hl
;main.c:361: cam_pan_left();
	call	_cam_pan_left
	jr	00166$
00156$:
;main.c:363: else if (SMS_getKeysHeld() & PORT_A_KEY_UP && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT)
	call	_SMS_getKeysHeld
	bit	0, e
	jr	Z, 00147$
	call	_SMS_getKeysHeld
	bit	2, e
	jr	NZ, 00147$
	call	_SMS_getKeysHeld
	bit	3, e
	jr	NZ, 00147$
	ld	hl, (#(_camera + 10) + 0)
	ld	a, l
	sub	a, #0x04
	or	a, h
	jr	Z, 00147$
	ld	a, l
	sub	a, #0x05
	or	a, h
	jr	Z, 00147$
	ld	a, l
	sub	a, #0x07
	or	a, h
	jr	Z, 00147$
	ld	a, l
	sub	a, #0x06
	or	a, h
	jr	Z, 00147$
;main.c:365: camera.pan_dir = UP;
	ld	hl, #0x0002
	ld	((_camera + 10)), hl
;main.c:366: cam_pan_up();
	call	_cam_pan_up
	jr	00166$
00147$:
;main.c:368: else if (SMS_getKeysHeld() & PORT_A_KEY_DOWN && !(SMS_getKeysHeld() & PORT_A_KEY_LEFT) && !(SMS_getKeysHeld() & PORT_A_KEY_RIGHT) && camera.pan_dir != DOWN_RIGHT && camera.pan_dir != DOWN_LEFT && camera.pan_dir != UP_RIGHT && camera.pan_dir != UP_LEFT)
	call	_SMS_getKeysHeld
	bit	1, e
	jr	Z, 00166$
	call	_SMS_getKeysHeld
	bit	2, e
	jr	NZ, 00166$
	call	_SMS_getKeysHeld
	bit	3, e
	jr	NZ, 00166$
	ld	hl, (#(_camera + 10) + 0)
	ld	a, l
	sub	a, #0x04
	or	a, h
	jr	Z, 00166$
	ld	a, l
	sub	a, #0x05
	or	a, h
	jr	Z, 00166$
	ld	a, l
	sub	a, #0x07
	or	a, h
	jr	Z, 00166$
	ld	a, l
	sub	a, #0x06
	or	a, h
	jr	Z, 00166$
;main.c:370: camera.pan_dir = DOWN;
	ld	hl, #0x0003
	ld	((_camera + 10)), hl
;main.c:371: cam_pan_down();
	call	_cam_pan_down
00166$:
;main.c:373: SMS_waitForVBlank();
	call	_SMS_waitForVBlank
;main.c:375: SMS_setBGScrollX(camera.scroll_x);
	ld	hl, #_camera + 4
	ld	l, (hl)
;	spillPairReg hl
	call	_SMS_setBGScrollX
;main.c:376: SMS_setBGScrollY(camera.scroll_y);
	ld	hl, #_camera + 5
	ld	l, (hl)
;	spillPairReg hl
	call	_SMS_setBGScrollY
;main.c:377: SMS_initSprites();
	call	_SMS_initSprites
;main.c:378: SMS_copySpritestoSAT();
	call	_SMS_copySpritestoSAT
;main.c:381: }
	jp	00174$
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
__xinit__order_time:
	.dw #0x0000
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
