LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.types.all;

ENTITY or_gate IS
	generic (
		BITS_ARCH: integer
	);
	
	PORT( 
			A, B: in std_logic_vector(BITS_ARCH - 1 downto 0);
			
			S: out std_logic_vector(BITS_ARCH - 1 downto 0)
		);
END or_gate;

ARCHITECTURE arch_or_gate OF or_gate IS
	BEGIN
	
	process(A, B)
	begin
		for i in 0 to BITS_ARCH - 1 loop
			S(i) <= A(i) OR B(i);
		end loop;
	end process;
	
	
END arch_or_gate;