--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:01:04 07/28/2021
-- Design Name:   
-- Module Name:   C:/Users/Satish/async_fifo/fifo_test.vhd
-- Project Name:  async_fifo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: async_fifo
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY fifo_test IS
END fifo_test;
 
ARCHITECTURE behavior OF fifo_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT async_fifo
    PORT(
         reset : IN  std_logic;
         read_clk : IN  std_logic;
         write_clk : IN  std_logic;
         data_out : OUT  std_logic_vector(7 downto 0);
         write_full : OUT  std_logic;
         read_empty : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal read_clk : std_logic := '0';
   signal write_clk : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
   signal write_full : std_logic;
   signal read_empty : std_logic;

   -- Clock period definitions
   constant read_clk_period : time := 50 ns;
   constant write_clk_period : time := 5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: async_fifo PORT MAP (
          reset => reset,
          read_clk => read_clk,
          write_clk => write_clk,
          data_out => data_out,
          write_full => write_full,
          read_empty => read_empty
        );

   -- Clock process definitions
   read_clk_process :process
   begin
		read_clk <= '0';
		wait for read_clk_period/2;
		read_clk <= '1';
		wait for read_clk_period/2;
   end process;
 
   write_clk_process :process
   begin
		write_clk <= '0';
		wait for write_clk_period/2;
		write_clk <= '1';
		wait for write_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	--data_out<=(others=>'0');
	reset<='1','0' after 120 ns;
      -- hold reset state for 100 ns.
      wait for 100000000 ns;	

      

      -- insert stimulus here 

      wait;
   end process;

END;
