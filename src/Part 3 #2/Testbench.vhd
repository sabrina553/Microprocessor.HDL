library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench is
end entity Testbench;

architecture Run of Testbench is
    constant ClockFreq : integer := 500e6;
    constant ClockPeriod : time := 1000 ms / ClockFreq;     

    signal Clock : std_logic := '0';  

    signal 
        InstructionSignal,
        ResultSignal,
        ResultPipeSignal,
        RomLoad1Signal,
        RomLoad2Signal,
        RomLoad3Signal : std_logic_vector(31 downto 0);
        
    signal 
        Address1Signal,
        Address2Signal,
        Address3Signal : std_logic_vector(4 downto 0);  
    
    signal OperationSignal : std_logic_vector(5 downto 0);
    signal CFSignal, WESignal, RESignal, EXSignal, FLASignal, FLBSignal : std_logic;

begin
    -- Generate a clock signal 
    Clock <= not Clock after ClockPeriod / 2;  
    
    -- port => signal
    g1: entity work.Microprocessor(RTL)
        port map (
            Clock             => Clock,
            Instruction_Signal => InstructionSignal,
            Result_Signal      => ResultSignal,
            ResultPipe_Signal  => ResultPipeSignal,
            Address1_Signal    => Address1Signal,
            Address2_Signal    => Address2Signal,
            Address3_Signal    => Address3Signal,
            Operation_Signal   => OperationSignal,
            RomRead1_Signal    => RomLoad1Signal,
            RomRead2_Signal    => RomLoad2Signal,
            RomRead3_Signal    => RomLoad3Signal,
            CF_Signal          => CFSignal,
            WE_Signal          => WESignal,
            RE_Signal          => RESignal,
            EX_Signal          => EXSignal,
            FLA_Signal         => FLASignal,
            FLB_Signal         => FLBSignal
        );   
end architecture;
