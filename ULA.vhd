LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL; -- or use a library with `or_reduce`

USE WORK.types.all;

entity ULA is
	generic(
        BITS_ARCH   : integer := 8;
        SEL_ARCH    : integer := 4;
        SEG7_AMOUNT : integer := 3;
		  SEG7_AMOUNT_OP : integer := 2;
		  SEG7_AMOUNT_FLAG : integer := 3
    );

	port
	(
		-- Input ports
		A, B	            : in std_logic_vector(BITS_ARCH - 1 downto 0);
		op_code_buttons	: in std_logic_vector(SEL_ARCH - 1 downto 0);
		

		-- Output ports
		R	         : out std_logic_vector(BITS_ARCH - 1 downto 0);
		seg_code    : out seg7_code_vector_t(SEG7_AMOUNT - 1 downto 0);
		
		-- This port only purpose in life is allowing to see the opcode
		-- behaviour through the modelsim, because I just can't for the sake
		-- of god make it simulate the signal op_code properly, might be just a
		-- skill issue :\
		op_code_out    : out std_logic_vector(SEL_ARCH - 1 downto 0);
		seg_code_op    : out seg7_code_vector_t(SEG7_AMOUNT_OP - 1 downto 0);
		seg_code_flags : out seg7_code_vector_t(SEG7_AMOUNT_FLAG - 1 downto 0);
		
		overflow    : out std_logic;
		zero        : out std_logic;
		negative    : out std_logic
	);
end ULA;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture arch_ULA of ULA is
    -- Signal declaration
    signal aux_mux : std_logic_vector_array(2 ** SEL_ARCH - 1 downto 0)(BITS_ARCH - 1 downto 0) := (OTHERS => (OTHERS => '0'));
	 signal aux_R   : std_logic_vector(BITS_ARCH - 1 downto 0) := (OTHERS => '0');
	 signal op_code : std_logic_vector(SEL_ARCH - 1 downto 0) := (OTHERS => '0');
	 
	 signal aux_Neg : std_logic;
	 signal aux_Zero: std_logic;
	 signal aux_Over: std_logic;
	 signal auxx_Over: std_logic;
begin

		op_code_out <= op_code;
	
		GEN_FF_OPCODE: for i in 0 to SEL_ARCH-1 generate
		  FLIPFLOPB: WORK.tflipflop
				port map (
					 CLK => op_code_buttons(i),
					 T   => '1',
					 Q   => op_code(i)
				);
		end generate GEN_FF_OPCODE;

		DISPLAY: work.display
			generic map(BITS_ARCH => BITS_ARCH, SEG7_AMOUNT => SEG7_AMOUNT)
			port map(in_value => aux_R, out_codes => seg_code);
			
		DISPLAYOP: work.display
			generic map(BITS_ARCH => SEL_ARCH, SEG7_AMOUNT => SEG7_AMOUNT_OP)
			port map(in_value => op_code, out_codes => seg_code_op);
		
		DISPLAY_FLAG: work.display_flags
			generic map(SEG7_AMOUNT => SEG7_AMOUNT_FLAG)
			port map(overflow => aux_Over, negative => aux_Neg, zero => aux_Zero, out_codes => seg_code_flags);
			
		MUX: work.my_mux
			generic map(SEL_ARCH => SEL_ARCH, BITS_ARCH => BITS_ARCH)
			port map(input => aux_mux, sel => op_code, o => aux_R);
		
		ADDER: work.adder_and_sub
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, B => B, control => '0', carry => auxx_Over, S => aux_mux(0));
			
		SUB: work.adder_and_sub
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, B => B, control => '1', S => aux_mux(1));
		
		OR_GATE: work.or_gate
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, B => B, S => aux_mux(2));
			       
		AND_GATE: work.and_gate
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, B => B, S => aux_mux(3));
			
		NOT_GATE: work.not_gate
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, S => aux_mux(4));
		
		SHIFTL: work.shifter
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, control => '0', S => aux_mux(5));
			
		SHIFTR: work.shifter
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, control => '1', S => aux_mux(6));
			
		MULT: work.multiplier
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A(BITS_ARCH/2 - 1 downto 0), B => B(BITS_ARCH/2 - 1 downto 0), S => aux_mux(7));
		
		DIV: work.divider
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, B => B(BITS_ARCH/2 - 1 downto 0), Q => aux_mux(8));
		
		MODULUS: work.divider
			generic map(BITS_ARCH => BITS_ARCH)
			port map(A => A, B => B(BITS_ARCH/2 - 1 downto 0), R => aux_mux(9));
		
		process(auxx_Over, op_code)
			variable foo: std_logic;
		begin
			foo := NOT(op_code(0));
			for i in 1 to SEL_ARCH - 1 loop
				foo := foo AND NOT(op_code(i));
			end loop;
			aux_Over <= auxx_Over and foo;
		end process;
		
		overflow <= aux_Over;
		aux_Neg <= aux_R(BITS_ARCH - 1);
		negative <= aux_Neg;
		R <= aux_R;

		process (aux_R)
			variable foo: std_logic := '0';
		begin
			foo := NOT(aux_R(0));
			for i in 1 to BITS_ARCH - 1 loop
				foo := foo AND NOT(aux_R(i));
			end loop;
			aux_Zero <= foo;
		end process;
		zero <= aux_Zero;
end arch_ULA;
