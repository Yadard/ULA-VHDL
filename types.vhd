LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE types IS
  TYPE seg7_code_t IS ARRAY (6 DOWNTO 0) OF std_logic;
  TYPE seg7_code_vector_t IS ARRAY (natural range <>) OF seg7_code_t;
  type std_logic_vector_array is array (natural range <>) of std_logic_vector(natural range <>);
END PACKAGE types;

