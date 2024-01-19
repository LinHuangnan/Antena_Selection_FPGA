from myhdl import *
import os

top = 'ssr_cal'
module1 = 'magnitude'
module2 = 'mul'
module3 = 'multi'
testbench = 'test_%s' % top

srcs = []
srcs.append('../src/%s.v' % top)
srcs.append('../src/%s.v' % module1)
srcs.append('../src/%s.v' % module2)
srcs.append('../src/%s.v' % module3)
srcs.append('%s.v' % testbench)

src=' '.join(srcs)
print(src)

build_cmd = 'iverilog -o %s.vvp %s' % (testbench, src)

def bench():
    #Parameters
    DATA_WIDTH = 32
    ANTENA_NUM = 1

    #Inputs
    real_part = Signal(intbv(0)[DATA_WIDTH:])
    imag_part = Signal(intbv(0)[DATA_WIDTH:])

    #Outputs
    ssr = Signal(intbv(0)[DATA_WIDTH:])

    if os.system(build_cmd):
        raise Exception("Error running build command")
    
    dut = Cosimulation(
        "vvp -m ../myhdl %s.vvp -lxt2" % testbench,
        real_part = real_part,
        imag_part = imag_part,
        ssr = ssr
    )
    
    @instance
    def check():
        real_part.next = 100
        imag_part.next = 100
        yield(10)
        real_part.next = -100
        imag_part.next = -10
        yield(10)

        raise StopSimulation
    
    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()