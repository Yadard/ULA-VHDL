LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.types.all;

ENTITY and_gate IS
	generic(
		BITS_ARCH: integer
	);

	PORT( 
			A, B: in std_logic_vector(BITS_ARCH - 1 downto 0);
			
			S: out std_logic_vector(BITS_ARCH - 1 downto 0)
		);
END and_gate;

ARCHITECTURE arch_and_gate OF and_gate IS
	BEGIN
	
	process(A, B)
	begin
		for i in 0 to S'length - 1 loop
			S(i) <= A(i) AND B(i);
		end loop;
	end process;
	
	
END arch_and_gate;