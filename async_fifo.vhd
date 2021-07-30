------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date:    22:03:55 07/27/2021 
---- Design Name: 
---- Module Name:    async_fifo - Behavioral 
---- Project Name: 
---- Target Devices: 
---- Tool versions: 
---- Description: 
----
---- Dependencies: 
----
---- Revision: 
---- Revision 0.01 - File Created
---- Additional Comments: 
----
------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;








entity async_fifo is
port(reset,read_clk,write_clk:in std_logic;data_out:out std_logic_vector(7 downto 0);write_full,read_empty:out std_logic);
--here width is 8 and depth is 16 of fifo

end async_fifo;

architecture Behavioral of async_fifo is
component send_data is port(write_ptr:in std_logic_vector(7 downto 0);data_out:out std_logic_vector(7 downto 0)); end component;

signal write_pointer, write_sync_1, write_sync_2, read_sync_1, read_sync_2:std_logic_vector(4 downto 0);--:=(others => '0');
signal read_pointer:std_logic_vector(4 downto 0);--:=(others => '0');
type t_Data is array (0 to 15) of std_logic_vector(7 downto 0);
signal memory:t_Data;--:=(others => (others => '0'));
signal temporary_pointer:std_logic_vector(7 downto 0);--:=(others => '0');
signal full,empty:std_logic;
signal data_in:std_logic_vector(7 downto 0);

signal write_pointer_sync,read_pointer_sync,read_pointer_g,write_pointer_g:std_logic_vector(4 downto 0);--:=(others => '0');
begin


data_out<=memory(to_integer(unsigned(read_pointer(3 downto 0))));

process(reset,write_clk)

begin
if rising_edge(write_clk) then
if (reset='1') then
write_pointer <= "00000";
temporary_pointer<="00000000";
elsif (full ='0') then
write_pointer <= write_pointer+'1';
temporary_pointer<=temporary_pointer+'1';
memory(to_integer(unsigned(write_pointer(3 downto 0)))) <= data_in;
end if;
end if;
end process;

process(write_clk)


begin
if rising_edge(write_clk) then
read_sync_1 <= read_pointer_g;
read_sync_2 <= read_sync_1;
end if;
end process;

process(reset,read_clk)
begin
if rising_edge(read_clk) then
if reset='1' then
read_pointer <= "00000";
elsif ( empty ='0') then
read_pointer <= read_pointer + '1';

end if;
end if;
end process;

process(read_clk) 

begin
if rising_edge(read_clk) then
write_sync_1 <= write_pointer_g;
write_sync_2 <= write_sync_1;
end if;end process;

process(write_pointer_sync,read_pointer_sync,read_pointer_g,write_pointer_g,data_in,reset,read_clk,write_clk,write_pointer, write_sync_1, write_sync_2,read_pointer, read_sync_1, read_sync_2,memory,temporary_pointer,full,empty)

 begin
if (not(write_pointer(4)) & write_pointer(3 downto 0)=read_pointer_sync) then
full<='1';
else
full<='0';
end if;end process;



process(write_pointer_sync,read_pointer_sync,read_pointer_g,write_pointer_g,data_in,reset,read_clk,write_clk,write_pointer, write_sync_1, write_sync_2,read_pointer, read_sync_1, read_sync_2,memory,temporary_pointer,full,empty) 

begin
if (write_pointer_sync=read_pointer) then
empty<='1';
else
empty<='0';
end if;end process;


u1: send_data port map(temporary_pointer,data_in);

write_pointer_g <= write_pointer xor ('0' & write_pointer(4 downto 1));
read_pointer_g <= read_pointer xor ('0' & read_pointer(4 downto 1));


write_pointer_sync(4)<=write_sync_2(4);
write_pointer_sync(3)<=write_sync_2(3) xor write_pointer_sync(4);
write_pointer_sync(2)<=write_sync_2(2) xor write_pointer_sync(3);
write_pointer_sync(1)<=write_sync_2(1) xor write_pointer_sync(2);
write_pointer_sync(0)<=write_sync_2(0) xor write_pointer_sync(1);

read_pointer_sync(4)<=read_sync_2(4);
read_pointer_sync(3)<=read_sync_2(3) xor read_pointer_sync(4);
read_pointer_sync(2)<=read_sync_2(2) xor read_pointer_sync(3);
read_pointer_sync(1)<=read_sync_2(1) xor read_pointer_sync(2);
read_pointer_sync(0)<=read_sync_2(0) xor read_pointer_sync(1);

write_full <= full;
read_empty <= empty;
end architecture;



library IEEE;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_1164.ALL;
entity send_data is port(write_ptr:in std_logic_vector(7 downto 0);data_out:out std_logic_vector(7 downto 0)); end entity;
architecture send of send_data is
type t_D is array (0 to 255) of std_logic_vector(7 downto 0);
signal input_rom:t_D;
signal write_ptr_sig:std_logic_vector(7 downto 0);
begin
write_ptr_sig<=write_ptr;
process(write_ptr_sig) 


begin
for i in 0 to 255 loop
input_rom(i) <= std_logic_vector(to_unsigned(i, 8));
end loop;

end process;

data_out <= input_rom(to_integer(unsigned(write_ptr_sig(7 downto 0))));

end architecture;






