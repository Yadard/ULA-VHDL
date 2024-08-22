LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.types.all;

ENTITY not_gate IS
	generic(
		BITS_ARCH: integer
	);

	PORT( 
			A: in std_logic_vector(BITS_ARCH - 1 downto 0);
			
			S: out std_logic_vector(BITS_ARCH - 1 downto 0)
		);
END not_gate;

ARCHITECTURE arch_not_gate OF not_gate IS
	BEGIN
	
	process(A)
	begin
		for i in 0 to BITS_ARCH - 1 loop
			S(i) <= NOT A(i);
		end loop;
	end process;
	
	
END arch_not_gate;