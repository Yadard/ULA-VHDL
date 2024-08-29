LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;

USE WORK.types.all;

ENTITY display_flags IS
	generic (
		SEG7_AMOUNT: integer := 3
	);

	port( 
			overflow: in std_logic;
			negative: in std_logic;
			zero: in std_logic;

			out_codes : out seg7_code_vector_t(SEG7_AMOUNT - 1 downto 0)
		);
END display_flags;

ARCHITECTURE arq_display_flags OF display_flags IS
BEGIN
	-- Default é tudo desligado.
	out_codes(0) <=  "0001110" when overflow else "1111111";
	out_codes(1) <=  "0111111" when negative else "1111111";
	out_codes(2) <=  "1000000" when zero  else "1111111";
END arq_display_flags;