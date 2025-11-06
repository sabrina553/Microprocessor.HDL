# ALU-HDL
For this project we were tasked with designing, testing, and simulating a microprocessor in VHDL. with 3 component parts: A Decoder, ROM, ALU. In doing so it could calculate a basic athematic equation of addition and subtraction, and store the results. 

VHDL is a description language used to describe hardware from the system level down to logic gates. We will not just be designing a working microprocessor but understanding the concepts of digital design and applying these in practice, highlighting digital logic, computer architecture and the language.

## Components
### ALU

The ALU, should have two 32-bit inputs, A and B, and a 32-bit output for the result. The result depends on a or b, as well as a 6-bit opcode to indicate the operation the ALU should perform. 
These opcodes are described below.


| Operand | Denary Representation | Binary Representation |
|--------|------|-------------|
|a + b| 4 |000100|
|a – b |8| 001000|
|\|a\| |11| 001011|
|-a |10 |001010|
|\|b\| |14 |001110|
|-b| 6| 000110|
|a or b |7 |000111|
|not a |9| 001001|
|not b |15 |001111|
|a and b| 2| 000010|
|a xor b |3| 000011|



### MEMORY

The memory takes 3 5-bit inputs, these reference the register number we are looking to take output from the ROM to the ALU, as-well as the register we wish to write our ALU result to. The output to the ALU takes a 32-bit value. Which is expressed in hexadecimal below. 

| Register Location | Denary Value | Hexadecimal Value |
|-------------------|--------------|-------------------|
| 0                 | 0            | 00000000          |
| 1                 | 70536        | 00011388          |
| 2                 | 42658        | 0000A6A2          |
| 3                 | 67141        | 00010645          |
| 4                 | 25998        | 0000658E          |
| 5                 | 86650        | 0001527A          |
| 6                 | 64211        | 0000FAD3          |
| 7                 | 56067        | 0000DB03          |
| 8                 | 40159        | 00009CDF          |
| 9                 | 69723        | 0001105B          |
| 10                | 28861        | 000070BD          |
| 11                | 59537        | 0000E891          |
| 12                | 33726        | 000083BE          |
| 13                | 23913        | 00005D69          |
| 14                | 35711        | 00008B7F          |
| 15                | 85087        | 00014C5F          |
| 16                | 22853        | 00005945          |
| 17                | 72191        | 000119FF          |
| 18                | 87837        | 0001571D          |
| 19                | 5042         | 000013B2          |
| 20                | 84884        | 00014B94          |
| 21                | 22842        | 0000593A          |
| 22                | 77156        | 00012D64          |
| 23                | 17363        | 000043D3          |
| 24                | 87296        | 00015500          |
| 25                | 45117        | 0000B03D          |
| 26                | 91034        | 0001639A          |
| 27                | 73021        | 00011D3D          |
| 28                | 56444        | 0000DC7C          |
| 29                | 53900        | 0000D28C          |
| 30                | 78916        | 00013444          |
| 31                | 0            | 00000000          |



### Decoder
The last component is the Decoder, this takes a 32-bit instruction and splits it into 4 useful numbers, the opcode, address 1, address 2, and address 3.

Simply this gives our microprocessor the task
-   A<sub>1</sub> “opcode” A<sub>2</sub>= A<sub>3</sub> 

Where addresses A<sub>1->3 </sub> are 5-bit numbers, referencing positions in the ROM to be operated in the manner the 6-bit opcode states in the ALU.
 The result is then stored in the ROM position A3.


## Task

The instructions are fed from a proprietary component, called Instruction Queue, the purpose of this component is to store the programme to run on the microprocessor. For this assignment this includes 30 instructions, fed one by one on each clock cycle. 

The task was to find the result when 

`R1+R2-R3-R4+R5+R6-.....+R29+R30`

My approach to this algorith was to first take all the additions of the overall equation and add them seperately. 
thus it starts 
- R<sub>0</sub> + R<sub>1 </sub> = R<sub>0</sub>
- R<sub>0</sub> + R<sub>2</sub> = R<sub>0</sub>

Doing this allows for the same process to be repeated with the subtraction values, where 

- R<sub>31</sub> + R<sub>3 </sub> = R<sub>31 </sub>
- R<sub>31</sub> + R<sub>4</sub> = R<sub>31 </sub>

R<sub>x</sub> represents the register locations referenced in each instruction, all these operations are performed using addition, until the final where
-  R31 – R0 = R0. 

Subtraction can be computationally expensive, so this is an express way to save time by choosing how we write out the programme.

 We take advantage of the only two registers that do not have a stored value necessary for the actual computation.

 The program is stored in array and on each clock cycle it is iterated and outputs the 32-bit instruction to the decoder.

## The Microprocessor

![example](assets/images/image.png)

Combining all these components together we get the basics of a microprocessor, as a unit the first step is to fetch instructions from memory, the ‘Instruction Queue’ fetches this and outputs to the ‘InstructionPipe,’ this represents the one and only input to the decoder, where it is split into its constituent opcode, Address1, Address2, Address3. The addresses are then passed to the rom, within there is one pipeline stage for addresses one and two. Meaning one extra clock cycle is taken to output to the ALU, and for address three there are 3 pipelines, this delays the writing mechanic until the result is ready to be taken from the ALU, two clock cycles after the other values have been passed to the ALU. Operations on these values are then performed by the ALU, and the result outputted be written back to the rom. In summary the microprocessor Fetches the next instruction, feeds the relevant information to the memory and ALU, the memory passes the correct stored values to the ALU, to be operated on, then written back to memory.


## Challenges
One component thus far has been omitted, the controller. Due to the nature of our programme, where address 0 or address 31 are being sequentially written to for the vast majority of runtime. We end up running into a read before write error. 

Notice from the memory description, there is a two-clock cycle gap between numbers being passed to the ALU
and being written back to ROM, in this time two more instructions could run, and would be reading an outdated value from the respective register. 

To account for this, the controller adds an additional function, tapping into the aforementioned ‘Instruction Pipe’, like the decoder it splits the instruction into its relevant addresses, and for two instruction cycles it compares the address three, with one and two, if it is found that either address is used sequentially, it will trigger forward logic in the ALU. In which case, the value of a or b of the alu, is replaced with the previous result produced. Meaning the rom will continue to
take updated results at a two-clock cycle delay, but the previous result is always ready for the ALU, avoiding this error.

Further for this to work, the opcode is fed from the controller rather than the decoder directly to the ALU, as this allows it to be pipelined. Much like Address one and two is in the memory. 

In doing so this solved the equation in the way stated previously, it also worked to solve the equation as it was written in documentation, i.e. alternating between addition and subtraction, every two instruction cycles. Which adds a layer of versatility to the microporcessor, however I elected to continue using the originally stated altered algorithm, as subtraction is computationally expensive compared to addition. 


However, it would not work for alternating each cycle between addition and subtraction or using the two free write addresses alternatively. This is one limitation of our design that thought needs to be put into the how intstruction set  is designed. Rather than being logic to compile an ideal instruction set to reduce overhead. 

That being said Successfully getting the result for two of the three tested algorithms was a big achievement in this project, implementing forward logic and dirty lists made this possible, and were a big challenge to overcome in the design process. Being able to neglect the need for no-ops in this solution vastly improves throughput and the computational speed of the microprocessor. Saving an estimated third of the run time. Meeting the requirments of the task, in an efficient manner.

If this project were to be improved, I believe problems with the dirty list being too small could
be easily implemented, and not require much overhead in getting there. Further alternatives
like a functional no-op or smart re-ordering, would certainly take more time and thorough
testing, admittedly the design process could have been vastly improved, one important lesson
was to have signals reading values at any given time in the circuit, implemented from the
testbench, allowing for faster debugging, too much time was wasted before finally
implementing this.


## Performance 

As for the overall performance of the microprocessor, it takes 71ns for the result to be written to memory with a clock frequency of 500 MHz - Equivalently one clock cycle is 2 ns, meaning it takes 35 clock cycles (the first nano second, the system is in an undefined state) to complete 30 instructions altogether. 

For an individual computation or instruction cycle it takes 10ns, or a latency of 5 clock cycles. After which results are written each clock cycle to the memory. This is the minimal time we could achieve this.

adding no ops would increase time by almost 3x as this method pipelines instructions and utilises forward logic, using no ops, would replace these pipelines instead delaying all but few instructions by an additional two cycles or approximately 60 clock cycles in total or 120ns. The initial time to output the first result is certainly delayed, but thereafter everything is sequential with no expectation regardless of the instruction.








