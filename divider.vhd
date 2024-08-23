LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY divider IS
	generic(
		BITS_ARCH: integer
	);

    PORT (
		  -- input ports
        A : IN  std_logic_vector(BITS_ARCH -1 DOWNTO 0);
		  B : IN  std_logic_vector((BITS_ARCH/2)-1 DOWNTO 0);
		  
		  -- output ports
        Q    : OUT std_logic_vector(BITS_ARCH-1 DOWNTO 0);
		  R    : OUT std_logic_vector(BITS_ARCH-1 DOWNTO 0)
    );
END ENTITY divider;

ARCHITECTURE Behavioral OF divider IS
	type carry_chain_levels_t is array(0 to BITS_ARCH - 1) of std_logic_vector(BITS_ARCH / 2 + 1 downto 0);
	type result_levels_t is array(0 to BITS_ARCH - 1) of  std_logic_vector(BITS_ARCH / 2 downto 0);
	
	type operands_t is array(0 to BITS_ARCH / 2) of std_logic_vector(1 downto 0);
	type operands_levels_t is array(0 to BITS_ARCH - 1) of operands_t;
	
	type S_chain_levels_t is array(0 to BITS_ARCH - 1) of std_logic_vector(BITS_ARCH / 2 downto 0);
	
	signal carry_chain: carry_chain_levels_t := (OTHERS => (OTHERS => '1'));
	signal S_chain: S_chain_levels_t;
	signal operands: operands_levels_t := (OTHERS => (OTHERS => (OTHERS => '0')));
	
BEGIN
	process(A, B)
	begin
		for l in 0 to BITS_ARCH - 1 loop
			for i in 0 to (BITS_ARCH / 2) - 1 loop
				operands(l)(i)(0) <= B(i);
			end loop;
			operands(l)(0)(1) <= A(BITS_ARCH - 1 - l);
		end loop;
	end process;
	
	process(S_chain)
		variable ci_per_level: integer := (BITS_ARCH / 2);
	begin
		for l in 1 to BITS_ARCH - 1 loop
			if l >= BITS_ARCH - 3 then
				for i in 1 to BITS_ARCH / 2 loop
					operands(l)(i)(1) <= S_chain(l - 1)(i - 1);
				end loop;
			else
				for i in 1 to (BITS_ARCH / 2) - 1 loop
					operands(l)(i)(1) <= S_chain(l - 1)(i - 1);
				end loop;
			end if;
		end loop;
	end process;
	
	process(S_chain(BITS_ARCH - 1))
	begin
		for i in 0 to R'length - 1 loop
			if i < S_chain(BITS_ARCH - 1)'length then
				R(i) <= S_chain(BITS_ARCH - 1)(i);
			else
				R(i) <= '0';
			end if;
		end loop;
	end process;
	
	
	gen_division: FOR i IN 0 TO BITS_ARCH - 1 GENERATE
	begin
        -- Generate block based on the condition
        gen_carry_chain: IF i > BITS_ARCH - 3 GENERATE
				CONSTANT ci_per_level : integer := (BITS_ARCH / 2) + 1;
		  begin
            gen_carry: FOR j IN 0 TO ci_per_level - 1 GENERATE
				begin
                DIVPU: ENTITY work.div_pu
                PORT MAP(
                    A => operands(i)(j)(1),
                    B => operands(i)(j)(0),
                    Cin => carry_chain(i)(j),
                    Cout => carry_chain(i)(j + 1),
                    sel => carry_chain(i)(ci_per_level),
						  S => S_chain(i)(j)
                );
					 
					Q(BITS_ARCH - 1 - i) <= carry_chain(i)(ci_per_level);
            END GENERATE gen_carry;
        END GENERATE gen_carry_chain;

        -- Alternate generate block for the other condition
        gen_normal_chain: IF i <= BITS_ARCH - 3 GENERATE
				CONSTANT ci_per_level : integer := BITS_ARCH / 2;
		  begin
            gen_carry: FOR j IN 0 TO ci_per_level - 1 GENERATE
				begin
                DIVPU: ENTITY work.div_pu
                PORT MAP(
                    A => operands(i)(j)(1),
                    B => operands(i)(j)(0),
                    Cin => carry_chain(i)(j),
                    Cout => carry_chain(i)(j + 1),
                    sel => carry_chain(i)(ci_per_level),
						  S => S_chain(i)(j)
                );
					 
					 Q(BITS_ARCH - 1 - i) <= carry_chain(i)(ci_per_level);
            END GENERATE gen_carry;
        END GENERATE gen_normal_chain;
    END GENERATE gen_division;
	
END ARCHITECTURE Behavioral;
