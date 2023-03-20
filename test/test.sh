SRC="./test/top.v"
OUTPUT="./test/risc_cpu_test.vvp"
CMD="./test/cmd.mk"

iverilog -g2012 -o ${OUTPUT} ${SRC} -c ${CMD} -Wall

if [ $? = 0 ]; then
	vvp ${OUTPUT} -fst -v
else
	echo "Exit."
fi

# gtkwave ./test/wave.fst &