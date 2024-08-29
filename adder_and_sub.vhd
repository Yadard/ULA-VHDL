LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.types.all;

ENTITY adder_and_sub IS
	generic(
		BITS_ARCH: integer
	);

	PORT( 
			A, B: in std_logic_vector(BITS_ARCH - 1 downto 0);
			control: in std_logic;
			
			S: out std_logic_vector(BITS_ARCH - 1 downto 0);
			carry: out std_logic
		);
END adder_and_sub;

ARCHITECTURE arch_adder_and_sub OF adder_and_sub IS

	SIGNAL c: std_logic_vector(BITS_ARCH downto 0);

	BEGIN

    gen_full_adders: for i in 0 to BITS_ARCH-1 generate
        FA: WORK.full_adder
            port map (
                A    => A(i),
                B    => B(i) XOR control,
                Cin  => c(i),
                S  => S(i),
                Cout => c(i+1)
            );
    end generate;

    -- Connect carry-in and carry-out
    c(0) <= control;
    carry <= (c(BITS_ARCH - 1) AND (control)) XOR c(BITS_ARCH);
	
END arch_adder_and_sub;