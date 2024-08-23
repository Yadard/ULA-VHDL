LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;

USE WORK.types.all;

entity div_pu is
    port (
        -- Input ports
		  A, B  : in  std_logic;
        sel   : in  std_logic;
		  Cin   : in std_logic;
	
        -- Output port
        Cout  : out std_logic;
		  S     : out std_logic
    );
end div_pu;


architecture arch_mux of div_pu is
	signal aux_S: std_logic;
	signal aux_mux: std_logic_vector_array(1 downto 0)(0 downto 0);
	 signal sel_vec: std_logic_vector(0 downto 0); 
    signal S_vec  : std_logic_vector(0 downto 0);
begin
	ADDER: work.full_adder
		port map(A => A, B => B, Cin => Cin, Cout => Cout, S => aux_S);
	MUX: work.my_mux
		generic map(SEL_ARCH => 1, BIT_ARCH => 1)
		port map(sel => sel_vec, input => aux_mux, O => S_vec);
		
	process(A)
	begin
		aux_mux(0)(0) <= A;
		aux_mux(1)(0) <= aux_S;
	end process;
	
	process(sel)
	begin
		sel_vec(0) <= sel;
	end process;
	
	process(S_vec)
	begin
		S <= S_vec(0);
	end process;

end arch_mux;