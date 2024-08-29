LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity divider is
	generic(
		BITS_ARCH: integer
	);

   port (
		  -- input ports
        A : IN  std_logic_vector(BITS_ARCH -1 DOWNTO 0);
		  B : IN  std_logic_vector((BITS_ARCH/2)-1 DOWNTO 0);
		  
		  -- output ports
        Q    : OUT std_logic_vector(BITS_ARCH-1 DOWNTO 0);
		  R    : OUT std_logic_vector(BITS_ARCH-1 DOWNTO 0)
    );
end entity divider;

architecture arch_divider OF divider IS
	type carry_chain_levels_t is array(0 to BITS_ARCH - 1) of std_logic_vector(BITS_ARCH / 2 + 1 downto 0);
	type result_levels_t is array(0 to BITS_ARCH - 1) of  std_logic_vector(BITS_ARCH / 2 downto 0);
	
	type operands_t is array(0 to BITS_ARCH / 2) of std_logic_vector(1 downto 0);
	type operands_levels_t is array(0 to BITS_ARCH - 1) of operands_t;
	
	type S_chain_levels_t is array(0 to BITS_ARCH - 1) of std_logic_vector(BITS_ARCH / 2 downto 0);
	
	signal carry_chain: carry_chain_levels_t := (OTHERS => (OTHERS => '1'));
	signal S_chain: S_chain_levels_t;
	signal operands: operands_levels_t := (OTHERS => (OTHERS => (OTHERS => '0')));
	
	constant extra_levels: integer := 2;
begin
	process(A, B)
	begin
		for l in 0 to Q'length - 1 loop
			for i in 0 to B'length - 1 loop
				operands(l)(i)(0) <= B(i);
			end loop;
			operands(l)(0)(1) <= A(A'length - 1 - l);
		end loop;
	end process;
	
	process(S_chain)
		variable ci_per_level: integer := (BITS_ARCH / 2);
	begin
		for l in 1 to Q'length - 1 loop
			
			-- last three levels
			if l /= 0 then
				for i in 1 to B'length loop
					operands(l)(i)(1) <= S_chain(l - 1)(i - 1);
				end loop;
			else
				for i in 1 to B'length - 1 loop
					operands(l)(i)(1) <= S_chain(l - 1)(i - 1);
				end loop;
			end if;
		end loop;
	end process;
	
	process(S_chain(S_chain'length - 1))
	begin
		for i in 0 to R'length - 1 loop
			if i < S_chain(BITS_ARCH - 1)'length then
				R(i) <= S_chain(BITS_ARCH - 1)(i);
			else
				R(i) <= '0';
			end if;
		end loop;
	end process;
	
	
	gen_division: for i in 0 to Q'length - 1 generate
	begin
		  -- generator for the last two levels
        gen_carry_chain: IF i /= 0 generate
				constant ci_per_level : integer := B'length + 1;
		  begin
            gen_carry: for j in 0 to ci_per_level - 1 generate
				begin
                DIVPU: entity work.div_pu
                port map(
                    A => operands(i)(j)(1),
                    B => operands(i)(j)(0),
                    Cin => carry_chain(i)(j),
                    Cout => carry_chain(i)(j + 1),
                    sel => carry_chain(i)(ci_per_level),
						  S => S_chain(i)(j)
                );
					 
					Q(Q'length - 1 - i) <= carry_chain(i)(ci_per_level);
            end generate gen_carry;
        end generate gen_carry_chain;

        -- generator for the other levels
        gen_normal_chain: if i = 0 generate
				CONSTANT ci_per_level : integer := B'length;
		  begin
            gen_carry: for j in 0 to ci_per_level - 1 generate
				begin
                DIVPU: entity work.div_pu
                port map(
                    A => operands(i)(j)(1),
                    B => operands(i)(j)(0),
                    Cin => carry_chain(i)(j),
                    Cout => carry_chain(i)(j + 1),
                    sel => carry_chain(i)(ci_per_level),
						  S => S_chain(i)(j)
                );
					 
					 Q(Q'length - 1 - i) <= carry_chain(i)(ci_per_level);
            end generate gen_carry;
        end generate gen_normal_chain;
    end generate gen_division;
	
end architecture arch_divider;