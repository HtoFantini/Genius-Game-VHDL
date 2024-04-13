library ieee;
use ieee.std_logic_1164.all;

entity XORShift is
port(
	Clk : in std_logic;
	X : buffer bit_vector(7 downto 0) := "00000001";
	Y : out bit_vector(7 downto 0)
);
end XorShift;

architecture RTL of XORShift is
begin

	process(Clk)
		variable T : std_logic;
		variable Temp : std_logic_vector(7 downto 0);
	begin
		if rising_edge(Clk) then
			
			Temp := to_stdlogicvector(X);
			T := Temp(6) xor (Temp(5) xor (Temp(1) xor Temp(0))); -- Xor
			X <= to_bitvector(Temp);
			
			X(6 downto 0) <= X(7 downto 1); -- Shift
			X(7) <= to_bit(T);
			
			Y <= X; -- Output
		end if;
		
	end process;

end RTL;