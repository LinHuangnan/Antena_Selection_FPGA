from myhdl import *
import os

module = 'sfu_check'
testbench = 'test_%s' % module

srcs = []
srcs.append('../src/%s.v' % module)
srcs.append('%s.v' % testbench)

src=' '.join(srcs)
print(src)

build_cmd = 'iverilog -o %s.vvp %s' % (testbench, src)

def bench():
    #Parameters
    DATA_WIDTH = 8
    LABEL_WIDTH = 4 #16个输入天线

    #Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))
    x_valid = Signal(bool(0))
    x_0 = Signal(intbv(0)[DATA_WIDTH:])
    x_1 = Signal(intbv(0)[DATA_WIDTH:])
    x_label_0 = Signal(intbv(0)[LABEL_WIDTH:])
    x_label_1 = Signal(intbv(0)[LABEL_WIDTH:])

    #Outputs
    y_0 = Signal(intbv(0)[DATA_WIDTH:])
    y_1 = Signal(intbv(0)[DATA_WIDTH:])
    flag_same_sfu = Signal(bool(0))
    y_valid = Signal(bool(0))

    if os.system(build_cmd):
        raise Exception("Error running build command")
    
    dut = Cosimulation(
        "vvp -m ../myhdl %s.vvp -lxt2" % testbench,
        clk = clk,
        rst = rst,
        x_valid = x_valid,
        x_0 = x_0,
        x_1 = x_1,
        x_label_0 = x_label_0,
        x_label_1 = x_label_1,
        y_0 = y_0,
        y_1 = y_1,
        flag_same_sfu = flag_same_sfu,
        y_valid = y_valid
    )

    @always(delay(2))
    def clkgen():
        clk.next = not clk

    @always(clk.posedge)
    def set_input():
        if(rst==0 and x_label_0 < 8):
            x_label_0.next = x_label_0 + 1
            x_valid.next = 1
            x_label_1.next = 5
            x_0.next = 10
            x_1.next = 20
        elif(rst==0 and x_label_0 >= 8  and x_label_1 < 15):
            x_label_1.next = x_label_1 + 1
            x_valid.next = 1
            x_label_0.next = 8
            x_0.next = 30
            x_1.next = 40
        else:
            x_valid.next = 0

    
    @instance
    def rstctrl():
        rst.next = 1
        yield delay(5)
        yield clk.posedge
        rst.next = 0
        yield clk.posedge
        yield delay(100)

        raise StopSimulation
    
    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()

