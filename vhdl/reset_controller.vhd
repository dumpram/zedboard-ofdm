library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity reset_controller is
port (
  clk : in std_logic;
  input_fsm_wd_reset : in std_logic;
  output_fsm_wd_reset : in std_logic;
  reset : out std_logic
);
end reset_controller;

architecture rtl of reset_controller is

-- Watchdog signals
signal watchdog_timer : std_logic_vector(7 downto 0) := x"ff";

-- Internal reset
signal reset_int : std_logic;

begin

process(clk)
begin
if rising_edge(clk) then

    watchdog_timer <= watchdog_timer;
    reset_int <= '0';

    -- WATCHDOG    
    -- Timer reset
    --     ... if input fifo is changing
    --     ... if output fifo is changing
    --     FSMs handle control signals
    if ( input_fsm_wd_reset = '1' ) or ( output_fsm_wd_reset = '1' ) then
       watchdog_timer <= x"ff";
    else
       watchdog_timer <= watchdog_timer - '1';
    end if;
    
    -- Watchdog reset signal
    if watchdog_timer = (watchdog_timer'range => '0') then
       reset_int <= '1';
    else
       reset_int <= '0';
    end if;

end if;
end process;

   reset <= reset_int;

end rtl;
