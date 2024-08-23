LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.types.all;

entity not_gate is
	generic(
		BITS_ARCH: integer
	);

	port( 
		-- input ports
		A: in std_logic_vector(BITS_ARCH - 1 downto 0);
			
		-- output ports
		S: out std_logic_vector(BITS_ARCH - 1 downto 0)
	);
end not_gate;

architecture arch_not_gate of not_gate is
begin
	
	process(A)
	begin
		for i in 0 to S'length - 1 loop
			S(i) <= not A(i);
		end loop;
	end process;
	
end arch_not_gate;
