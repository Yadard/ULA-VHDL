LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY multiplier IS
	generic(
		BITS_ARCH: integer
	);

    PORT (
		A, B : IN  std_logic_vector((BITS_ARCH/2)-1 DOWNTO 0);
		
		S    : OUT std_logic_vector(BITS_ARCH-1 DOWNTO 0)
	);
END ENTITY multiplier;

ARCHITECTURE Behavioral OF multiplier IS
	type operand_t is array(0 to 1) of std_logic_vector((BITS_ARCH/2)-1 DOWNTO 0);
	type operand_vector_t is array(0 to (BITS_ARCH/2)) of operand_t;
	type result_vector_t is array(0 to (BITS_ARCH/2)) of std_logic_vector((BITS_ARCH/2)-1 DOWNTO 0);
	
	SIGNAL aux          : operand_vector_t := (OTHERS => (OTHERS => (OTHERS => '0')));
	SIGNAL carry_chain  : std_logic_vector(0 to (BITS_ARCH/2)) := (OTHERS => '0');
	SIGNAL adder_result : result_vector_t;
BEGIN
	S(0) <= A(0) AND B(0);
	
	process(A,B)
	begin
	
		for i in 0 to (BITS_ARCH/2)-2 loop
			aux(0)(0)(i) <= A(0) and B(i+1);
		end loop;
			
		for l in 1 to (BITS_ARCH/2)-1 loop
			for i in 0 to (BITS_ARCH/2)-1 loop
				aux(l-1)(1)(i) <= A(l) and B(i);
			end loop;
		end loop;
	end process;
		
	gen_full_adders: for i in 1 to (BITS_ARCH/2) - 1 generate
        FA: WORK.adder_and_sub
				generic map(
					BITS_ARCH => (BITS_ARCH/2)
				)
            port map (
                A       => aux(i-1)(0),
                B       => aux(i-1)(1),
					 control => '0',
                S       => adder_result(i-1),
                carry   => carry_chain(i-1)
            );
				
				-- Assign the result of the adder to the output S
				S(i) <= adder_result(i-1)(0);

				
				aux(i)(0)((BITS_ARCH/2)-2 downto 0) <= adder_result(i-1)((BITS_ARCH/2)-1 downto 1);
				aux(i)(0)((BITS_ARCH/2)-1) <= carry_chain(i - 1);
    end generate gen_full_adders;
	 
	 process(carry_chain)
		begin
		  S(BITS_ARCH-1) <= carry_chain(BITS_ARCH/2 - 2); -- Getting the last_carry
		end process;
	
	process(adder_result((BITS_ARCH/2) - 2))
		begin
			S(BITS_ARCH - 2 downto BITS_ARCH - (BITS_ARCH/2)) <= adder_result((BITS_ARCH/2) - 2)((BITS_ARCH/2)-1 downto 1);
		end process;
	
END ARCHITECTURE Behavioral;
