library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity dft_out_fsm is
port (
  reset : in std_logic;
  clk : in std_logic;
  dft_ce : out std_logic;
  dft_dout : in std_logic_vector(31 downto 0);
  dft_fd_out : in std_logic;
  fifo_data : out std_logic_vector(31 downto 0);
  fifo_wr_en : out std_logic;
  fifo_wr_count : in std_logic_vector(9 downto 0);
  fifo_watchdog_reset : out std_logic
);
end dft_out_fsm;

architecture rtl of dft_out_fsm is

constant data_size : integer := 960;
constant fifo_size : integer := 1024;

type fsm is (rst, idle, fifo_wait, dft_out);
signal state : fsm := rst;

signal data_cnt : std_logic_vector(15 downto 0);

signal fifo_cnt_prev : std_logic_vector(9 downto 0);

begin

    fifo_data <= dft_dout;

process(clk)
begin
if (clk'event and clk = '1') then

   case state is
   
   when rst =>
      dft_ce <= '1';
      fifo_wr_en <= '0';
      data_cnt <= std_logic_vector(to_unsigned(data_size - 1, data_cnt'length));
      
      state <= idle;
      
   when idle =>
      dft_ce <= '1';
      fifo_wr_en <= '0';
      data_cnt <= std_logic_vector(to_unsigned(data_size - 1, data_cnt'length));

      if (dft_fd_out = '1') then
         if (fifo_wr_count /= (fifo_wr_count'range => '0')) then
            dft_ce <= '0';
            state <= fifo_wait;
         else
            dft_ce <= '0';
            fifo_wr_en <= '1';
            state <= dft_out;
         end if;
      else
         state <= idle;
      end if;
      
      
   when fifo_wait =>
      dft_ce <= '0';
      fifo_wr_en <= '0';
      data_cnt <= std_logic_vector(to_unsigned(data_size - 1, data_cnt'length));
      
      if (to_integer(unsigned(fifo_wr_count)) > (fifo_size - data_size)) then
         state <= fifo_wait;
      else
         fifo_wr_en <= '1';
         dft_ce <= '1';
         state <= dft_out;
      end if;
      
   
   when dft_out =>
      dft_ce <= '1';
      fifo_wr_en <= '1';
      
      data_cnt <= data_cnt;
      
      if (data_cnt /= (data_cnt'range => '0')) then
         data_cnt <= data_cnt - '1';
         state <= dft_out;
      else
         fifo_wr_en <= '0';
         state <= idle;
      end if;
      
   when others =>
      null;
   
   end case;
   
   if (reset = '1') then
      state <= rst;
   end if;
   
   -- Watchdog control signal
   if (fifo_wr_count /= fifo_cnt_prev) then
      fifo_watchdog_reset <= '1';
      fifo_cnt_prev <= fifo_wr_count;
   else
      fifo_watchdog_reset <= '0';
      fifo_cnt_prev <= fifo_cnt_prev;
   end if;

end if;
end process;


end rtl;