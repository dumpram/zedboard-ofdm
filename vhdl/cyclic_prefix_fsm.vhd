-- Dodati signal fifo_empty i provjeru stanja FIFO buffera
-- Izlaz prema vanjskom reset kontroleru

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity cyclic_prefix_fsm is
port (
  reset : in std_logic;
  clk : in std_logic;
  din : in std_logic_vector(31 downto 0);
  rd_en : out std_logic;
  fifo_rd_count : in std_logic_vector(9 downto 0);
  dout : out std_logic_vector(31 downto 0);
  fd_out : out std_logic;
  rffd : in std_logic;
  dft_data_valid : in std_logic
);
end cyclic_prefix_fsm;

architecture rtl of cyclic_prefix_fsm is

constant prefix_size : integer := 240;
constant data_size : integer := 960;
constant data_threshold : integer := 1024;

type fsm is (rst, cyclic_prefix_wait, fifo_dft_wait, dft_sample, dft_out_wait);
signal state : fsm := rst;

signal data_cnt : std_logic_vector(16 downto 0);
signal prefix_cnt : std_logic_vector(16 downto 0);  

begin

   dout <= din;

process(clk, reset)
begin
  if (clk'event and clk = '1') then
    
    case state is
        
        when rst =>
            rd_en <= '1';
            fd_out <= '0';
            prefix_cnt <= std_logic_vector(to_unsigned(prefix_size - 1, prefix_cnt'length));
            data_cnt <= std_logic_vector(to_unsigned(data_size - 1, data_cnt'length));
            
            state <= cyclic_prefix_wait;
            
        -- Cekamo minimalno prefix_size uzoraka i koliko god je jos potrebno do pojave peaka na izlazu FIFO-a    
        when cyclic_prefix_wait =>
            
            rd_en <= '1';
            fd_out <= '0';
            
            prefix_cnt <= prefix_cnt;
            
            if (prefix_cnt /= (prefix_cnt'range => '0')) then
               prefix_cnt <= prefix_cnt - '1';
               state <= cyclic_prefix_wait;
            elsif (to_integer(unsigned(din)) < data_threshold) then
               state <= cyclic_prefix_wait;
            else
               state <= fifo_dft_wait;
            end if;
            
        -- Cekamo popunjavanje FIFO buffera i spremnost DFT-a za prihvat uzoraka
        when fifo_dft_wait =>
        
            rd_en <= '0';
            fd_out <= '0';
            
            data_cnt <= std_logic_vector(to_unsigned(data_size - 1, data_cnt'length));
            
            if (to_integer(unsigned(fifo_rd_count)) < data_size) then
               state <= fifo_dft_wait;
            
            -- FIFO ima dovoljno uzoraka; Provjeravamo spremnost DFT-a
            elsif (rffd = '0') then
               state <= fifo_dft_wait;
            else
               fd_out <= '1';
               rd_en <= '1';
               
               state <= dft_sample;
            end if;
               
            
        -- Prosljedjujemo uzorke DFT-u
        when dft_sample =>
            
            fd_out <= '0';
            rd_en <= '1';
            
            prefix_cnt <= std_logic_vector(to_unsigned(prefix_size - 1, prefix_cnt'length));
            data_cnt <= data_cnt;
            
            if (data_cnt /= (data_cnt'range => '0')) then
               data_cnt <= data_cnt - '1';
               state <= dft_sample;
            else
			   rd_en <= '0';
               state <= dft_out_wait;
            end if;
			
		-- Cekamo dok DFT ne izbaci sve uzorke spektra
		when dft_out_wait =>
		
		    fd_out <= '0';
			rd_en <= '0';
			
            prefix_cnt <= std_logic_vector(to_unsigned(prefix_size - 1, prefix_cnt'length));
			
			if (dft_data_valid = '1') then
			   state <= dft_out_wait;
			else
			   rd_en <= '0';
			   state <= cyclic_prefix_wait;
			end if;            
            
        when others =>
            null;
        
    end case;
	
	if ( reset = '1') then
	   state <= rst;
	end if;
  
  end if;   
end process;

end rtl;
