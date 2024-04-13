library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Genius is
end entity;

architecture teste of tb_Genius is

	component Genius is
	port(
		BT1, BT2, BT3, BT4, Clk, Reset: in std_logic;
		L1,L2,L3,L4 : out std_logic;
		RNG : out bit_vector(1 downto 0);
		Temp : out integer;
		SCORE1, SCORE2, LUZ1, LUZ2 : out std_logic_vector(6 downto 0)
	);
	end component;

	signal Clock, Fim, Reset : std_logic := '0';
	signal A, B, C, D : std_logic := '1';
	signal R : bit_vector(1 downto 0);
	signal T : integer;

begin
	
	I : Genius port map (
		BT1 => A,
		BT2 => B,
		BT3 => C,
		BT4 => D,
		Clk => Clock,
		Reset => Reset,
		RNG => R,
		Temp => T
	);
	
	Clock <= not Clock after 120 ms when Fim /= '1' else '0';
	Fim <= '1' after 40 sec;
	
	A <= '1' after 3 sec, '0' after 3.2 sec;
	
end teste;