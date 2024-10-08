LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity tflipflop is
	port
	(
		CLK : in  std_logic;
		T   : in  std_logic;
		Q   : out std_logic;
		NQ  : out std_logic
	);
end tflipflop;

architecture arch_tflipflop of tflipflop is
	signal tmp: std_logic;
begin
	process (CLK)
	begin
		if rising_edge(CLK) then
			if T='0' then
				tmp <= tmp;
			elsif T='1' then
				tmp <= NOT(tmp);
			end if;
		end if;
	end process;
	
	Q <= tmp;
	NQ <= NOT(tmp);
end arch_tflipflop;
