-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul broji sekunde i prikazuje na LED diodama                                         
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_counter IS PORT (
                               clk_i     : IN STD_LOGIC; -- ulazni takt
                               rst_i     : IN STD_LOGIC; -- reset signal 
                               one_sec_i : IN STD_LOGIC; -- signal koji predstavlja proteklu jednu sekundu vremena 
                               cnt_en_i  : IN STD_LOGIC; -- signal dozvole brojanja                              
                               cnt_rst_i : IN STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               led_o     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka led diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS
SIGNAL counter_value_r : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_value_r_next : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	mux1_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	mux2_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	mux3_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	compare_signal : STD_LOGIC;
	
BEGIN

-- DODATI :
-- brojac koji na osnovu izbrojanih sekundi pravi izlaz na LE diode
process(clk_i,rst_i) begin
	if(rst_i='1') then
		counter_value_r<=(others =>'0');
	elsif(clk_i'event and clk_i='1') then
		counter_value_r<=counter_value_r_next;
	end if;
end process;

	counter_value_r_next<=counter_value_r when cnt_en_i='0' else mux2_signal;
	mux2_signal <= (others => '0') when cnt_rst_i = '1' else mux1_signal;--anuliraj ako je spolja resetpvan
	mux1_signal <= mux3_signal when one_sec_i = '1' else counter_value_r;--kada izbroji do kraja anuliraj
	mux3_signal <= counter_value_r + 1 when compare_signal = '0' else (others => '0');--kada izbroji do kraja anuliraj
	compare_signal <= '1' when counter_value_r = "00111011" else '0';
	
	led_o<=counter_value_r;
	--led_o<="10101011";
	
	
	


END rtl;