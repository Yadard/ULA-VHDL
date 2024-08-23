LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity or_gate is
	generic (
		BITS_ARCH: integer
	);
	
	port( 
		-- input ports
		A, B: in std_logic_vector(BITS_ARCH - 1 downto 0);
			
		-- output ports
		S: out std_logic_vector(BITS_ARCH - 1 downto 0)
	);
end or_gate;

architecture arch_or_gate of or_gate is
	begin
	
	process(A, B)
	begin
		for i in 0 to S'length - 1 loop
			S(i) <= A(i) OR B(i);
		end loop;
	end process;
	
	
end arch_or_gate;
