library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Genius is
port(
	BT1, BT2, BT3, BT4, Clk, Reset: in std_logic;
	L1,L2,L3,L4 : out std_logic;
	RNG : out bit_vector(1 downto 0);
	Temp : out integer;
	SCORE1, SCORE2, LUZ1, LUZ2 : out std_logic_vector(6 downto 0)
);
end entity;

architecture RTL of Genius is
	component XORShift is
		port(
			Clk : in std_logic;
			X : buffer bit_vector(7 downto 0);
			Y : out bit_vector(7 downto 0)
		);
	end component;
	
	type STATE_TYPE is (
		IDLE,
		DISPLAY,
		VERIFY,
		ERROR_STATE
	); 
	
	type L_ARRAY is array (0 to 127) of bit_vector(7 downto 0);
	type Matrix is array (0 to 9) of std_logic_vector(6 downto 0);
	
	constant D0 : std_logic_vector( 6 downto 0) := "0000001";
   constant D1 : std_logic_vector( 6 downto 0) := "1001111";
   constant D2 : std_logic_vector( 6 downto 0) := "0010010";
   constant D3 : std_logic_vector( 6 downto 0) := "0000110";
   constant D4 : std_logic_vector( 6 downto 0) := "1001100";
   constant D5 : std_logic_vector( 6 downto 0) := "0100100";
   constant D6 : std_logic_vector( 6 downto 0) := "0100000";
   constant D7 : std_logic_vector( 6 downto 0) := "0001111";
   constant D8 : std_logic_vector( 6 downto 0) := "0000000";
   constant D9 : std_logic_vector( 6 downto 0) := "0000100";
	
	constant DLimpo : std_logic_vector( 6 downto 0) := "1111111";
	constant DE : std_logic_vector( 6 downto 0) := "0110000";
	constant Dr : std_logic_vector( 6 downto 0) := "1111010";
	constant Do : std_logic_vector( 6 downto 0) := "1100010";
	
	constant Desq : std_logic_vector( 6 downto 0) := "0110001";
	constant Ddir : std_logic_vector( 6 downto 0) := "0000111";
	constant Dcima : std_logic_vector( 6 downto 0) := "0111111";
	constant Dbaixo : std_logic_vector( 6 downto 0) := "1110111";
	
	
	constant CDisplay : Matrix := (D0, D1, D2, D3, D4, D5, D6, D7, D8, D9); 
	
	signal Luzes : L_ARRAY;
	
	signal B1, B2, B3, B4: std_logic := '0'; -- 00, 01, 10, 11
	
	constant Esq : bit_vector(1 downto 0) := "00";
	constant Cima : bit_vector(1 downto 0) := "01";
	constant Dir : bit_vector(1 downto 0) := "10";
	constant Baixo : bit_vector(1 downto 0) := "11";
	
	constant Ciclos_por_ms : integer := 100000;
	signal frac : integer := 0; 
	signal tempo : integer := 0; -- ms
	
	signal Resultado :  bit_vector(7 downto 0);
	signal Y2: bit_vector(1 downto 0); 
	
	signal Exibir : std_logic := '0';
	
	signal SCORE : integer := 0;
	
	signal Num : bit_vector(1 downto 0) := "00";
	signal Erro : integer := 0;
	
	signal CURRENT_STATE : STATE_TYPE := IDLE;
	
begin

	
	Instance : XORShift port map(
		Clk => Clk,
		Y => Resultado
	);
	
	
	Y2 <= Resultado(1 downto 0);
	RNG <= Num;
	--RNG <= Y2;
	
	process(Clk, Reset, Resultado, Luzes(0 to 127), Y2)
		variable J, I: integer := 0;
		variable teste : L_ARRAY;
		variable T : integer := 126;
	begin
		
		L1 <= BT1;
		L2 <= BT2;
		L3 <= BT3;
		L4 <= BT4;
		
		SCORE <= I;
		
		if rising_edge(Clk) then
		
			if(Reset = '1') then
				CURRENT_STATE <= IDLE;
			end if;
		
			frac <= frac + 1;
			
			if(Frac >= ciclos_por_ms) then
				Tempo <= Tempo + 1;
				Frac <= 0;
			end if;
				
			case CURRENT_STATE is
				
				when IDLE =>	
					Erro <= 0;
					I := 0; 
					J := 0;
					
					Temp <= T;
					--teste(0) := "11111111";
					T := (T + 1);
					if(T > 127) then 
						T := 0;
					end if;
					
					Luzes(T) <= Resultado;				
					--RNG <= Luzes(T);
					
					
					
					if((BT1 = '0' and B1 = '0')or(BT2 = '0' and B2 = '0')or(BT3 = '0' and B3 = '0')or(BT4 = '0' and B4 = '0')) then
						Tempo <= 0;
						Frac <= 0;
						CURRENT_STATE <= DISPLAY;
					end if;
				
				when DISPLAY =>
					
					
					Num <= Luzes(J)(1 downto 0);
					
					if Tempo < 600 then
						Exibir <= '1';
					elsif Tempo < 800 then
						Exibir <= '0';
					else
						Tempo <= 0;
						Frac <= 0;
						J := J + 1;
					end if;
					
					
					if J > I then
						J := 0;
						Tempo <= 0;
						Frac <= 0;
						CURRENT_STATE <= VERIFY;
					end if;
					
					
				when VERIFY =>
				
					Num <= Luzes(J)(1 downto 0);
					
					if(BT1 = '0' and B1 = '0') then
						B1 <= '0';
						
						if NUM /= Esq then
							Erro <= 1;
						else
							J := J + 1;
						end if;
					elsif(BT2 = '0' and B2 = '0') then
						B2 <= '0';
						
						if NUM /= Cima then
							Erro <= 1;
						else
							J := J + 1;
						end if;
					elsif(BT3 = '0' and B3 = '0') then
						B3 <= '0';
						
						if NUM /= Dir then
							Erro <= 1;
						else
							J := J + 1;
						end if;
					elsif(BT4 = '0' and B4 = '0') then
						B4 <= '0';
						
						if NUM /= Baixo then
							Erro <= 1;
						else
							J := J + 1;
						end if;
					end if;
					
					if(J > I and Erro = 0) then
						I := I + 1;
						Tempo <= 0;
						J := 0;
						CURRENT_STATE <= DISPLAY;
					elsif Erro = 1 then
						Tempo <= 0;
						Frac <= 0;
						CURRENT_STATE <= ERROR_STATE;
					end if;
					
					
				when ERROR_STATE =>
					if Tempo > 2000 then
						CURRENT_STATE <= IDLE;
					end if;
					
				when OTHERS => null;
				
			end case;
			
			B1 <= not BT1;
			B2 <= not BT2;
			B3 <= not BT3;
			B4 <= not BT4;
			
		end if;
		
		
	end process;
	
	process(Exibir, Num, SCORE, CURRENT_STATE)
	begin
		if (CURRENT_STATE /= IDLE and CURRENT_STATE /= ERROR_STATE) then
				
			SCORE1 <= CDISPLAY(SCORE/10);
			SCORE2 <= CDISPLAY(SCORE mod 10);
			
			if(Exibir = '1') then
				case Num is
					when Esq =>
						LUZ1 <= Desq;
						LUZ2 <= Dr;
					
					when Cima =>
						LUZ1 <= Dcima;
						LUZ2 <= Dcima;
						
					when Dir =>
						LUZ1 <= DLimpo;
						LUz2 <= Ddir;
					
					when Baixo =>
						Luz1 <= Dbaixo;
						Luz2 <= Dbaixo;
						
					when others => null;
						
				end case;
			else
				LUZ1 <= DLimpo;
				LUZ2 <= DLimpo;
			end if;
		elsif CURRENT_STATE = ERROR_STATE then	
			SCORE1 <= DE;
			SCORE2 <= Dr;
			LUZ1 <= Dr;
			LUZ2 <= Do;		
		else
			SCORE1 <= DLimpo;
			SCORE2 <= DLimpo;
			LUZ1 <= DLimpo;
			LUZ2 <= DLimpo;
		end if;
	end process;

end architecture;