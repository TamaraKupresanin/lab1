-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                          
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul odogvaran za indikaciju o proteku sekunde
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk_counter IS GENERIC(
                              -- maksimalna vrednost broja do kojeg brojac broji
                              max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "10111110101111000010000000" -- 50 000 000
                             );
                      PORT   (
                               clk_i     : IN  STD_LOGIC; -- ulazni takt
                               rst_i     : IN  STD_LOGIC; -- reset signal
                               cnt_en_i  : IN  STD_LOGIC; -- signal dozvole brojanja
                               cnt_rst_i : IN  STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               one_sec_o : OUT STD_LOGIC  -- izlaz koji predstavlja proteklu jednu sekundu vremena
                             );
END clk_counter;

ARCHITECTURE rtl OF clk_counter IS
	SIGNAL   counter_r : STD_LOGIC_VECTOR(25 DOWNTO 0);
	SIGNAL   counter_r_next : STD_LOGIC_VECTOR(25 DOWNTO 0);
	SIGNAL	compare_signal : STD_LOGIC;
	SIGNAL	add_signal : STD_LOGIC_VECTOR(25 DOWNTO 0);
	SIGNAL	mux1_signal : STD_LOGIC_VECTOR(25 DOWNTO 0);
	SIGNAL	mux2_signal : STD_LOGIC_VECTOR(25 DOWNTO 0);


BEGIN

-- DODATI:
-- brojac koji kada izbroji dovoljan broj taktova generise SIGNAL one_sec_o koji
-- predstavlja jednu proteklu sekundu, brojac se nulira nakon toga
process(clk_i,rst_i) begin
	if(rst_i='1') then
		counter_r<=(others =>'0');
	elsif(clk_i'event and clk_i='1') then
		counter_r<=counter_r_next;
	end if;
end process;
	
	counter_r_next<=counter_r when cnt_en_i='0' else mux2_signal;
	mux2_signal <= (others => '0') when cnt_rst_i = '1' else mux1_signal;--anuliraj ako je spolja resetpvan
	mux1_signal <= counter_r + 1 when compare_signal = '0' else (others => '0');--kada izbroji do kraja anuliraj
	compare_signal <= '1' when counter_r = max_cnt else '0';
	
	one_sec_o<=compare_signal;
	


END rtl;