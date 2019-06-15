onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /controlLogic_testbench/ALUOp
add wave -noupdate /controlLogic_testbench/ALUSrc
add wave -noupdate /controlLogic_testbench/BrTaken
add wave -noupdate /controlLogic_testbench/Imm12
add wave -noupdate /controlLogic_testbench/Imm19
add wave -noupdate /controlLogic_testbench/Imm26
add wave -noupdate /controlLogic_testbench/Imm9
add wave -noupdate /controlLogic_testbench/MemToReg
add wave -noupdate /controlLogic_testbench/MemWrite
add wave -noupdate /controlLogic_testbench/Rd
add wave -noupdate /controlLogic_testbench/Reg2Loc
add wave -noupdate /controlLogic_testbench/RegWrite
add wave -noupdate /controlLogic_testbench/Rm
add wave -noupdate /controlLogic_testbench/Rn
add wave -noupdate /controlLogic_testbench/SHAMT
add wave -noupdate /controlLogic_testbench/UnCondBr
add wave -noupdate /controlLogic_testbench/carry_out_new
add wave -noupdate /controlLogic_testbench/carryout
add wave -noupdate /controlLogic_testbench/memRead
add wave -noupdate /controlLogic_testbench/negative
add wave -noupdate /controlLogic_testbench/negative_new
add wave -noupdate /controlLogic_testbench/operation
add wave -noupdate /controlLogic_testbench/overflow
add wave -noupdate /controlLogic_testbench/overflow_new
add wave -noupdate /controlLogic_testbench/setFlag
add wave -noupdate /controlLogic_testbench/zero
add wave -noupdate /controlLogic_testbench/zero_new
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {828 ps}
