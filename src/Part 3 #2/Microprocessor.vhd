library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity Microprocessor is
    port (
		Clock : in std_logic;	
	
        Instruction_Signal, Result_Signal, ResultPipe_Signal : out std_logic_vector(31 downto 0);
        Address1_Signal, Address2_Signal, Address3_Signal : out std_logic_vector(4 downto 0);
        Operation_Signal : out std_logic_vector(5 downto 0);
        RomRead1_Signal, RomRead2_Signal, RomRead3_Signal : out std_logic_vector(31 downto 0);
        CF_Signal, WE_Signal, RE_Signal, EX_Signal, FLA_Signal, FLB_Signal : out std_logic
    );
end entity Microprocessor;

architecture RTL of Microprocessor is
	signal InstructionPipe : std_logic_vector(31 downto 0);	 	 
    signal Address1, Address2, Address3 : std_logic_vector(4 downto 0);
    signal Operation, OperationPipe1 : std_logic_vector(5 downto 0);
    signal MEMtoALU1, MEMtoALU2, Result, ResultPipe, ReadAddress3 : std_logic_vector(31 downto 0);
    signal CF, WE, RE, EX, FLa, FLb : std_logic;

begin
    -- InstructionQueue: Assign the Clock, CF, and InstructionPipe
    g1: entity work.InstructionQueue(Behavioral)
        port map(Clock, CF, InstructionPipe);

    -- Decoder: Decode the instruction to get control signals
    g2: entity work.decoder3(simple)
        port map(Clock, InstructionPipe, Operation, Address1, Address2, Address3);

    -- Controller: Controller generates control signals
    g3: entity work.controller(dataflow)
        port map(Clock, InstructionPipe, Address1, Address2, Address3, Operation, OperationPipe1, CF, WE, RE, EX, FLa, FLb, result);

    -- ROM: Access ROM to get data
    g4: entity work.ROM3(write)
        port map(Clock, WE, RE, Address1, Address2, Address3, Result, MEMtoALU1, MEMtoALU2, ReadAddress3);

    -- ALU: Perform ALU operation
    g5: entity work.ALU3(dataflow)
        port map(Clock, MEMtoALU1, MEMtoALU2, OperationPipe1, Result, ResultPipe, FLa, FLb);

    -- Output data for testing purposes
    -- Assigning values to output signals
    Instruction_Signal <= InstructionPipe;
    Result_Signal <= Result;
    ResultPipe_Signal <= ResultPipe;
    Address1_Signal <= Address1;
    Address2_Signal <= Address2;
    Address3_Signal <= Address3;
    Operation_Signal <= Operation;
    RomRead1_Signal <= MEMtoALU1;
    RomRead2_Signal <= MEMtoALU2;
    RomRead3_Signal <= ReadAddress3;
    CF_Signal <= CF;
    WE_Signal <= WE;
    RE_Signal <= RE;
    EX_Signal <= EX;
    FLA_Signal <= FLa;
    FLB_Signal <= FLb;

end architecture;
