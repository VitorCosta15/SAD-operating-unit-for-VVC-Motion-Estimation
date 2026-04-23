Library IEEE;
USE IEEE.std_logic_1164.all;

ENTITY somador_1_bit IS
PORT(
	A0, B0: IN STD_LOGIC;
	c_in: IN STD_LOGIC;
	S0 : OUT STD_LOGIC;
	c_out : out STD_LOGIC
);

END somador_1_bit;

ARCHITECTURE arch_somador_1_bit OF somador_1_bit IS
BEGIN 
	S0 <= A0 xor B0 xor c_in;
	c_out <= (A0 and B0) or (c_in and A0) or (c_in and B0); --isso aqui ESTAVA errado e tava fazendo com que tudo referente ao circuito desse errado.
END arch_somador_1_bit;
