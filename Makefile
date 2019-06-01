AS = arm-none-eabi-as
LD = arm-none-eabi-ld
ARMELF = -m armelf -no-undefined
OBJ = arm-none-eabi-objcopy
CP = .img /media/boot/kernel7.img

main.elf: main.o print.o input.o move.o torch.o inputReset.o led.o gameoverPrint.o mapSelect_print.o mapChange.o unabara.o labyrinthData.o musicStop.o bad_pv.o bad_music.o reset_check.o difficultyChange.o DQ_dead.o clearPrint.o Fanfare.o akisisters.o bigbridge.o kirakira.o musicSelect_print.o musicChange.o musicMode_check.o back_check.o check_cheatComand.o startAnimation.o movePlayCheck.o heian.o katyusya.o firstMovie.o Labymoji.o naito.o greengreens.o Fanfare_soundVer.o DQ_dead_soundVer.o
	$(LD) $(ARMELF) $+ -o $@

%.o: %.s
	$(AS) $< -o $@

%.elf: %.o
	$(LD) $(ARMELF) $< -o $@

%.img: %.elf
	$(OBJ) $< -O binary $@

.PHONY: clean boot eject  git_labyrinth.s git_input.s git_move.s git_input.s git_move.s git_inputReset.s git_led.s git_all boot_main bigbridge.s

clean:
	rm -f *.o *~ *.elf a.out

boot_main:
	make main.img
	cp main$(CP)
	make clean
	eject boot

git_all:
	git add Makefile
	git add gameoverPrint.s
	git add include.inc
	git add input.s
	git add inputReset.s
	git add labyrinthData.s
	git add led.s
	git add main.s
	git add mapChange.s
	git add mapData.txt
	git add mapSelect_print.s
	git add move.s
	git add print.s
	git add torch.s
	git add unabara.s
	git add labyrinthData.s
	git add musicStop.s
	git add bad_music.s
	git add bad_pv.s
	git add reset_check.s
	git add difficultyChange.s
	git add DQ_dead.s
	git add clearPrint.s
	git add Fanfare.s
	git add akisisters.s
	git add bigbridge.s
	git add kirakira.s
	git add musicSelect_print.s
	git add musicChange.s
	git add musicMode_check.s
	git add clear.txt
	git add back_check.s
	git add check_cheatComand.s
	git add startAnimation.s
	git add movePlayCheck.s
	git add heian.s
	git add katyusya.s
	git add firstMovie.s
	git add Labymoji.s
	git add naito.s
	git add greengreens.s
	git add Fanfare_soundVer.s
	git add DQ_dead_soundVer.s
