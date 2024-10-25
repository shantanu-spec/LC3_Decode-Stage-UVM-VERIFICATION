p1_debug:
	qrun -64 -gui -visualizer -onfinish stop -classdebug -uvmcontrol=all -msgmode both -l run.log -f filelist.f -do "set IterationLimit 140000; set NoQuitOnFinish 1; onbreak {resume}; run -all; do wave.do;coverage save test_top.ucdb " +UVM_TESTNAME=test_top -debug,livesim -qwavedb=+signal+memory+transaction=1024+report+parameter+class+assertion+uvm_schematic+msg+classmemory=1024+statictaskfunc -top hdl_top -top hvl_top

p2_debug:
	qrun -64 -gui -visualizer -onfinish stop -classdebug -uvmcontrol=all -msgmode both -l run.log -f filelistp2.f -do "set IterationLimit 140000; set NoQuitOnFinish 1; onbreak {resume}; run -all; do wave.do;coverage save test_top.ucdb " +UVM_TESTNAME=test_top -debug,livesim -qwavedb=+signal+memory+transaction=1024+report+parameter+class+assertion+uvm_schematic+msg+classmemory=1024+statictaskfunc -top hdl_top -top hvl_top

clean:
	rm -rf design.bin
	rm -rf qrun.out
	rm -rf qwave.db
	rm -rf run.log
	rm -rf transaction.config
	rm -rf test_top.ucdb
	rm -rf .visualizer
	rm -rf visualizer.log
	rm -rf sysinfo.log
	rm -rf certe_dump.xml

coverage:
	visualizer -viewcov ./test_top.ucdb
