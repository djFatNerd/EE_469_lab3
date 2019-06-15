# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./mux_2x1.sv"
vlog "./mux_4x1.sv"
vlog "./mux_8x1.sv"
vlog "./mux_16x1.sv"
vlog "./mux_32x1.sv"



vlog "./mux_5x2x1.sv"
vlog "./mux_64x2x1.sv"
vlog "./mux_64x4x1.sv"

vlog "./Decoder_1x2.sv"
vlog "./Decoder_2x4.sv"
vlog "./Decoder_4x16.sv"
vlog "./Decoder_5x32.sv"

vlog "./fullAdder.sv"
vlog "./adder_64.sv"

vlog "./ALU_single.sv"
vlog "./alu.sv"

vlog "./check_zero.sv"
vlog "./math.sv"

vlog "./instructmem.sv"
vlog "./datamem.sv"

vlog "./regfile.sv"
vlog "./controlLogic.sv"

vlog "./signExtend9.sv"
vlog "./signExtend19.sv"
vlog "./signExtend26.sv"

vlog "./zeroExtend12.sv"

vlog "./D_FF.sv"
vlog "./D_FF_x64.sv"

vlog "./flag_update.sv"

vlog "./cpu.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpu_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpu_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
