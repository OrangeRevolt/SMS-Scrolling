echo Build Main
sdcc -c -mz80 --peep-file peep-rules.txt main.c
@if %errorlevel% NEQ 0 goto :EOF

echo Linking

sdcc -o scrolling_or.ihx -mz80 --no-std-crt0 --data-loc 0xC000 -Wl-b_BANK3=0x38000 crt0_sms.rel SMSlib.lib main.rel bank3.rel

makesms -pm scrolling_or.ihx scrolling_or.sms


::echo clean up files
::del *.lst
::del *.sym
::del *.lk
::del *.map
::del *.noi
::del *.ihx
::del *.asm