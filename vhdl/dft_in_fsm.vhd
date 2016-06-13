library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity dft_in_fsm is
port (
  reset : in std_logic;
  clk : in std_logic;
  fifo_data : in std_logic_vector(31 downto 0);
  fifo_rd_en : out std_logic;
  fifo_rd_count : in std_logic_vector(9 downto 0);
  dft_data : out std_logic_vector(31 downto 0);
  dft_fd_in : out std_logic;
  dft_rffd : in std_logic;
  dft_data_valid : in std_logic;
  fifo_watchdog_reset : out std_logic
);
end dft_in_fsm;

architecture rtl of dft_in_fsm is

constant data_size : integer := 960;

type fsm is (rst, fifo_dft_wait, dft_sample, dft_out_wait);
signal state : fsm := rst;

signal data_cnt : std_logic_vector(16 downto 0);

signal fifo_cnt_prev : std_logic_vector(9 downto 0);

begin

   dft_data <= fifo_data;

process(clk)
begin
  if (clk'event and clk = '1') then
    
    case state is
        
        when rst =>
            fifo_rd_en <= '1';
            dft_fd_in <= '0';
            
            data_cnt <= std_logic_vector(to_unsigned(data_size - 1, data_cnt'length));
            
            state <= fifo_dft_wait;
            
        -- Cekamo popunjavanje FIFO buffera i spremnost DFT-a za prihvat uzoraka
        when fifo_dft_wait =>
        
            fifo_rd_en <= '0';
            dft_fd_in <= '0';
            
            data_cnt <= std_logic_vector(to_unsigned(data_size - 1, data_cnt'length));
            
            if (to_integer(unsigned(fifo_rd_count)) < data_size) then
               state <= fifo_dft_wait;
            
            -- FIFO ima dovoljno uzoraka; Provjeravamo spremnost DFT-a
            elsif (dft_rffd = '0') then
               state <= fifo_dft_wait;
            else
               dft_fd_in <= '1';
               fifo_rd_en <= '1';
               
               state <= dft_sample;
            end if;
               
            
        -- Prosljedjujemo uzorke DFT-u
        when dft_sample =>
            
            dft_fd_in <= '0';
            fifo_rd_en <= '1';
            
            data_cnt <= data_cnt;
            
            if (data_cnt /= (data_cnt'range => '0')) then
               data_cnt <= data_cnt - '1';
               state <= dft_sample;
            else
			   fifo_rd_en <= '0';
               state <= dft_out_wait;
            end if;
			
		-- Cekamo dok DFT ne izbaci sve uzorke spektra
		when dft_out_wait =>
		
		    dft_fd_in <= '0';
	        fifo_rd_en <= '0';
			
            if (dft_data_valid = '1') then
			   state <= dft_out_wait;
			else
			   state <= fifo_dft_wait;
			end if;            
            
        when others =>
            null;
        
    end case;
	
	if ( reset = '1') then
	   state <= rst;
	end if;
	
    -- Watchdog control signal
    if (fifo_rd_count /= fifo_cnt_prev) then
       fifo_watchdog_reset <= '1';
       fifo_cnt_prev <= fifo_rd_count;
    else
       fifo_watchdog_reset <= '0';
       fifo_cnt_prev <= fifo_cnt_prev;
    end if;
  
  end if;   
end process;

end rtl;
