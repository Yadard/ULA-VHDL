LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;

USE WORK.types.all;

ENTITY display IS
	generic (
		BITS_ARCH: integer;
		SEG7_AMOUNT: integer;
		RADIX: integer := 10
	);

	port( 
			in_value: in std_logic_vector(BITS_ARCH - 1 downto 0);

			out_codes : out seg7_code_vector_t(SEG7_AMOUNT - 1 downto 0)		
		);
END display;

ARCHITECTURE arq_display OF display IS
BEGIN
	process(in_value)
		constant chars_code: seg7_code_vector_t(0 to 9) := (
			  0 => "1000000",
			  1 => "1111001",
			  2 => "0100100",
			  3 => "0110000",
			  4 => "0011001",
			  5 => "0010010",
			  6 => "0000010",
			  7 => "1111000",
			  8 => "0000000",
			  9 => "0010000"
		);
		variable num: integer;
		variable i: integer := 0;
	begin
		
		-- Default é tudo desligado.
		out_codes <= (OTHERS => (OTHERS => '1'));
		
		num := to_integer(unsigned(in_value));

		for i in 0 to SEG7_AMOUNT - 1 loop
			out_codes(i) <= chars_code(num MOD RADIX);
			num := num / RADIX;
		end loop;	
	end process;
END arq_display;