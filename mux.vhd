LIBRARY IEEE;

USE IEEE.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;

USE WORK.types.all;

entity my_mux is
    generic (
			SEL_ARCH : integer;
			BITS_ARCH: integer
    );

    port (
			-- Input ports
			sel   : in  std_logic_vector(SEL_ARCH - 1 downto 0);
			input : in  std_logic_vector_array(2 ** SEL_ARCH - 1 downto 0)(BITS_ARCH - 1 downto 0);

			-- Output port
			O     : out std_logic_vector(BITS_ARCH - 1 downto 0)
	 );
end my_mux;


architecture arch_mux of my_mux is
begin

    process(input, sel)
        variable index: integer;
    begin
		index := to_integer(unsigned(sel));
		
		O <= input(index);
    end process;

end arch_mux;
