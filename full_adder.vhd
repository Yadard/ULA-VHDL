LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY full_adder IS
	PORT( 
			A, B: in std_logic;
			Cin: in std_logic;
			
			S: out std_logic;
			Cout: out std_logic
		);
END full_adder;

ARCHITECTURE arq_full_adder OF full_adder IS

BEGIN
	S <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (A AND Cin) OR (B AND Cin);
	
END arq_full_adder;