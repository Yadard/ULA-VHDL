LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.types.all;

ENTITY shifter IS
	generic(
		BITS_ARCH: integer
	);

	PORT( 
			A: in std_logic_vector(BITS_ARCH - 1 downto 0);
			control: in std_logic;
			
			S: out std_logic_vector(BITS_ARCH - 1 downto 0)
		);
END shifter;

ARCHITECTURE arch_shifter OF shifter IS	
	type word_array_t is array (1 downto 0) of std_logic_vector_array(BITS_ARCH + 1 downto 0)(0 downto 0);
	signal aux_mux : word_array_t :=  (OTHERS => (OTHERS => (OTHERS => '0')));

BEGIN
	PROCESS(control, A)
	BEGIN
		for i in 0 to BITS_ARCH/2 loop
			aux_mux(1)(i)(0) <= A(i + 1);
		end loop;
		for i in 1 to BITS_ARCH/2 + 1 loop
			aux_mux(0)(i)(0) <= A(i - 1);
		end loop;
	END PROCESS;
		
    gen_full_adders: for i in 0 to BITS_ARCH-1 generate
        MUX: WORK.my_mux
				generic map (
					SEL_ARCH => 1,
					BIT_ARCH => 1
				)
            port map (
                input(0) => aux_mux(0)(i),
					 input(1) => aux_mux(1)(i),
					 sel(0) => control,
					 o(0) => S(i)
            );
    end generate;
	
END arch_shifter;