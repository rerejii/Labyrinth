AS = arm-none-eabi-as
LD = arm-none-eabi-ld
ARMELF = -m armelf -no-undefined
OBJ = arm-none-eabi-objcopy
CP = .img /media/boot/kernel7.img

Bad_Apple_main.elf: Bad_Apple_main.o bad_pv.o bad_music.o
	$(LD) $(ARMELF) $+ -o $@

labyrinth.elf: labyrinth.o print.o input.o move.o torch.o inputReset.o led.o gameoverPrint.o
	$(LD) $(ARMELF) $+ -o $@

%.o: %.s
	$(AS) $< -o $@

%.elf: %.o
	$(LD) $(ARMELF) $< -o $@

%.img: %.elf
	$(OBJ) $< -O binary $@

.PHONY: clean boot eject  git_labyrinth.s git_input.s git_move.s git_input.s git_move.s git_inputReset.s git_led.s boot_Bad_Apple_main

clean:
	rm -f *.o *~ *.elf a.out

boot_Bad_Apple_main:
	make Bad_Apple_main.img
	cp Bad_Apple_main$(CP)
	make clean
	eject boot


boot_labyrinth:
	make labyrinth.img
	cp labyrinth$(CP)
	make clean
	eject boot

git_labyrinth.s:
	git add labyrinth.s
	git commit -m 'Automatic update by make'
	git push

git_input.s:
	git add input.s
	git commit -m 'Automatic update by make'
	git push

git_move.s:
	git add move.s
	git commit -m 'Automatic update by make'
	git push

git_print.s:
	git add print.s
	git commit -m 'Automatic update by make'
	git push

git_torch.s:
	git add torch.s
	git commit -m 'Automatic update by make'
	git push

git_inputReset.s:
	git add inputReset.s
	git commit -m 'Automatic update by make'
	git push

git_led.s:
	git add led.s
	git commit -m 'Automatic update by make'
	git push
