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
    input_min = -2**(ANTENA_NUM*DATA_WIDTH-1)
    input_max = 2**(ANTENA_NUM*DATA_WIDTH-1)-1
    output_min = -2**(2*ANTENA_NUM*DATA_WIDTH-1)
    output_max = 2**(2*ANTENA_NUM*DATA_WIDTH-1)-1

    #Inputs
    real_part = Signal(intbv(0,min = input_min ,max = input_max ))
    imag_part = Signal(intbv(0,min = input_min ,max = input_max ))

    #Outputs
    ssr = Signal(intbv( min = output_min ,max = output_max ))

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
        #print("Before assignment:")
        #print("real_part:", real_part.min, real_part.max, real_part.val)
        #print("imag_part:", imag_part.min, imag_part.max, imag_part.val)

        '''
        for i in range(input_min+1,input_max,1000000):
            real_part.next = i
            imag_part.next = i
            yield delay(2)
            if( int(ssr.val)!= int(real_part.next)*int(real_part.next) + int(imag_part.next)*int(imag_part.next) ):
                print("error!")
                print("error i:",i)
                print("real_part:", real_part.min, real_part.max, int(real_part.next))
                print("imag_part:", imag_part.min, imag_part.max, int(imag_part.next))
                print("dut ssr:",int(ssr.val))
                print("ref ssr",int(real_part.next)*int(real_part.next) + int(imag_part.next)*int(imag_part.next) )
                break
        '''

        real_part.next = 100
        imag_part.next = 99
        yield delay(10)

        print("After first delay:")
        print("real_part:", real_part.min, real_part.max, real_part.next)
        print("imag_part:", imag_part.min, imag_part.max, imag_part.next)
        #print("ssr",int(ssr.val))
        print("dut ssr:",int(ssr.val))
        print("ref ssr",int(real_part.next)*int(real_part.next) + int(imag_part.next)*int(imag_part.next) )

        real_part.next = -9
        imag_part.next = -10
        yield delay(10)

        print("After second delay, before error:")
        print("real_part:", real_part.min, real_part.max, real_part.next)
        print("imag_part:", imag_part.min, imag_part.max, imag_part.next)
        #print("ssr",int(ssr.val))
        print("dut ssr:",int(ssr.val))
        print("ref ssr",int(real_part.next)*int(real_part.next) + int(imag_part.next)*int(imag_part.next) )

        raise StopSimulation
    
    return instances()

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()