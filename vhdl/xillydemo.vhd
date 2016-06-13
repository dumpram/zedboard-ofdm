library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity xillydemo is
  port (
    -- For Vivado, delete the port declarations for PS_CLK, PS_PORB and
    -- PS_SRSTB, and uncomment their declarations as signals further below.

    --PS_CLK : IN std_logic;
    --PS_PORB : IN std_logic;
    --PS_SRSTB : IN std_logic;
    clk_100 : IN std_logic;
    otg_oc : IN std_logic;
    PS_GPIO : INOUT std_logic_vector(55 DOWNTO 0);
    GPIO_LED : OUT std_logic_vector(3 DOWNTO 0);
    vga4_blue : OUT std_logic_vector(3 DOWNTO 0);
    vga4_green : OUT std_logic_vector(3 DOWNTO 0);
    vga4_red : OUT std_logic_vector(3 DOWNTO 0);
    vga_hsync : OUT std_logic;
    vga_vsync : OUT std_logic;
    audio_mclk : OUT std_logic;
    audio_dac : OUT std_logic;
    audio_adc : IN std_logic;
    audio_bclk : IN std_logic;
    audio_lrclk : IN std_logic;
    smb_sclk : OUT std_logic;
    smb_sdata : INOUT std_logic;
    smbus_addr : OUT std_logic_vector(1 DOWNTO 0));
  end xillydemo;

architecture sample_arch of xillydemo is
  component xillybus
    port (
      PS_CLK : IN std_logic;
      PS_PORB : IN std_logic;
      PS_SRSTB : IN std_logic;
      clk_100 : IN std_logic;
      otg_oc : IN std_logic;
      DDR_Addr : INOUT std_logic_vector(14 DOWNTO 0);
      DDR_BankAddr : INOUT std_logic_vector(2 DOWNTO 0);
      DDR_CAS_n : INOUT std_logic;
      DDR_CKE : INOUT std_logic;
      DDR_CS_n : INOUT std_logic;
      DDR_Clk : INOUT std_logic;
      DDR_Clk_n : INOUT std_logic;
      DDR_DM : INOUT std_logic_vector(3 DOWNTO 0);
      DDR_DQ : INOUT std_logic_vector(31 DOWNTO 0);
      DDR_DQS : INOUT std_logic_vector(3 DOWNTO 0);
      DDR_DQS_n : INOUT std_logic_vector(3 DOWNTO 0);
      DDR_DRSTB : INOUT std_logic;
      DDR_ODT : INOUT std_logic;
      DDR_RAS_n : INOUT std_logic;
      DDR_VRN : INOUT std_logic;
      DDR_VRP : INOUT std_logic;
      MIO : INOUT std_logic_vector(53 DOWNTO 0);
      PS_GPIO : INOUT std_logic_vector(55 DOWNTO 0);
      DDR_WEB : OUT std_logic;
      GPIO_LED : OUT std_logic_vector(3 DOWNTO 0);
      bus_clk : OUT std_logic;
      quiesce : OUT std_logic;
      vga4_blue : OUT std_logic_vector(3 DOWNTO 0);
      vga4_green : OUT std_logic_vector(3 DOWNTO 0);
      vga4_red : OUT std_logic_vector(3 DOWNTO 0);
      vga_hsync : OUT std_logic;
      vga_vsync : OUT std_logic;
      user_r_mem_8_rden : OUT std_logic;
      user_r_mem_8_empty : IN std_logic;
      user_r_mem_8_data : IN std_logic_vector(7 DOWNTO 0);
      user_r_mem_8_eof : IN std_logic;
      user_r_mem_8_open : OUT std_logic;
      user_w_mem_8_wren : OUT std_logic;
      user_w_mem_8_full : IN std_logic;
      user_w_mem_8_data : OUT std_logic_vector(7 DOWNTO 0);
      user_w_mem_8_open : OUT std_logic;
      user_mem_8_addr : OUT std_logic_vector(4 DOWNTO 0);
      user_mem_8_addr_update : OUT std_logic;
      user_r_read_32_rden : OUT std_logic;
      user_r_read_32_empty : IN std_logic;
      user_r_read_32_data : IN std_logic_vector(31 DOWNTO 0);
      user_r_read_32_eof : IN std_logic;
      user_r_read_32_open : OUT std_logic;
      user_r_read_8_rden : OUT std_logic;
      user_r_read_8_empty : IN std_logic;
      user_r_read_8_data : IN std_logic_vector(7 DOWNTO 0);
      user_r_read_8_eof : IN std_logic;
      user_r_read_8_open : OUT std_logic;
      user_w_write_32_wren : OUT std_logic;
      user_w_write_32_full : IN std_logic;
      user_w_write_32_data : OUT std_logic_vector(31 DOWNTO 0);
      user_w_write_32_open : OUT std_logic;
      user_w_write_8_wren : OUT std_logic;
      user_w_write_8_full : IN std_logic;
      user_w_write_8_data : OUT std_logic_vector(7 DOWNTO 0);
      user_w_write_8_open : OUT std_logic;
      user_r_audio_rden : OUT std_logic;
      user_r_audio_empty : IN std_logic;
      user_r_audio_data : IN std_logic_vector(31 DOWNTO 0);
      user_r_audio_eof : IN std_logic;
      user_r_audio_open : OUT std_logic;
      user_w_audio_wren : OUT std_logic;
      user_w_audio_full : IN std_logic;
      user_w_audio_data : OUT std_logic_vector(31 DOWNTO 0);
      user_w_audio_open : OUT std_logic;
      user_r_smb_rden : OUT std_logic;
      user_r_smb_empty : IN std_logic;
      user_r_smb_data : IN std_logic_vector(7 DOWNTO 0);
      user_r_smb_eof : IN std_logic;
      user_r_smb_open : OUT std_logic;
      user_w_smb_wren : OUT std_logic;
      user_w_smb_full : IN std_logic;
      user_w_smb_data : OUT std_logic_vector(7 DOWNTO 0);
      user_w_smb_open : OUT std_logic;
      user_clk : OUT std_logic;
      user_wren : OUT std_logic;
      user_wstrb : OUT std_logic_vector(3 DOWNTO 0);
      user_rden : OUT std_logic;
      user_rd_data : IN std_logic_vector(31 DOWNTO 0);
      user_wr_data : OUT std_logic_vector(31 DOWNTO 0);
      user_addr : OUT std_logic_vector(31 DOWNTO 0);
      user_irq : IN std_logic);
  end component;

    component cyclic_prefix_fsm
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
    end component;
    
    component dft_in_fsm
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
    end component;
    
    component dft_out_fsm
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
    end component;
    
    COMPONENT dft_16
      PORT (
        CLK : IN STD_LOGIC;
        CE : IN STD_LOGIC;
        SCLR : IN STD_LOGIC;
        XN_RE : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        XN_IM : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        FD_IN : IN STD_LOGIC;
        FWD_INV : IN STD_LOGIC;
        SIZE : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        RFFD : OUT STD_LOGIC;
        XK_RE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        XK_IM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        BLK_EXP : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        FD_OUT : OUT STD_LOGIC;
        DATA_VALID : OUT STD_LOGIC
      );
    END COMPONENT;
    
    component reset_controller
    port (
      clk : in std_logic;
      input_fsm_wd_reset : in std_logic;
      output_fsm_wd_reset : in std_logic;
      reset : out std_logic
    );
    end component;

  component fifo_8x2048
    port (
      clk: IN std_logic;
      srst: IN std_logic;
      din: IN std_logic_VECTOR(7 downto 0);
      wr_en: IN std_logic;
      rd_en: IN std_logic;
      dout: OUT std_logic_VECTOR(7 downto 0);
      full: OUT std_logic;
      empty: OUT std_logic);
  end component;

  component fifo_32x512
    port (
      clk: IN std_logic;
      srst: IN std_logic;
      din: IN std_logic_VECTOR(31 downto 0);
      wr_en: IN std_logic;
      rd_en: IN std_logic;
      dout: OUT std_logic_VECTOR(31 downto 0);
      full: OUT std_logic;
      empty: OUT std_logic);
  end component;
  
  COMPONENT fifo_32x1024
    PORT (
      clk : IN STD_LOGIC;
      srst : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC;
      data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
  END COMPONENT;

  component i2s_audio
    port (
      bus_clk : IN std_logic;
      clk_100 : IN std_logic;
      quiesce : IN std_logic;
      audio_mclk : OUT std_logic;
      audio_dac : OUT std_logic;
      audio_adc : IN std_logic;
      audio_bclk : IN std_logic;
      audio_lrclk : IN std_logic;
      user_r_audio_rden : IN std_logic;
      user_r_audio_empty : OUT std_logic;
      user_r_audio_data : OUT std_logic_vector(31 DOWNTO 0);
      user_r_audio_eof : OUT std_logic;
      user_r_audio_open : IN std_logic;
      user_w_audio_wren : IN std_logic;
      user_w_audio_full : OUT std_logic;
      user_w_audio_data : IN std_logic_vector(31 DOWNTO 0);
      user_w_audio_open : IN std_logic);
  end component;

  component smbus
    port (
      bus_clk : IN std_logic;
      quiesce : IN std_logic;
      smb_sclk : OUT std_logic;
      smb_sdata : INOUT std_logic;
      smbus_addr : OUT std_logic_vector(1 DOWNTO 0);
      user_r_smb_rden : IN std_logic;
      user_r_smb_empty : OUT std_logic;
      user_r_smb_data : OUT std_logic_vector(7 DOWNTO 0);
      user_r_smb_eof : OUT std_logic;
      user_r_smb_open : IN std_logic;
      user_w_smb_wren : IN std_logic;
      user_w_smb_full : OUT std_logic;
      user_w_smb_data : IN std_logic_vector(7 DOWNTO 0);
      user_w_smb_open : IN std_logic);
  end component;

-- Synplicity black box declaration
  attribute syn_black_box : boolean;
  attribute syn_black_box of fifo_32x512: component is true;
  attribute syn_black_box of fifo_8x2048: component is true;

  type demo_mem is array(0 TO 31) of std_logic_vector(7 DOWNTO 0);
  signal demoarray : demo_mem;
  signal litearray0 : demo_mem;
  signal litearray1 : demo_mem;
  signal litearray2 : demo_mem;
  signal litearray3 : demo_mem;
  
  signal bus_clk :  std_logic;
  signal quiesce : std_logic;

  signal reset_8 : std_logic;
  signal reset_32 : std_logic;

  signal ram_addr : integer range 0 to 31;
  signal lite_addr : integer range 0 to 31;
    
  signal user_r_mem_8_rden :  std_logic;
  signal user_r_mem_8_empty :  std_logic;
  signal user_r_mem_8_data :  std_logic_vector(7 DOWNTO 0);
  signal user_r_mem_8_eof :  std_logic;
  signal user_r_mem_8_open :  std_logic;
  signal user_w_mem_8_wren :  std_logic;
  signal user_w_mem_8_full :  std_logic;
  signal user_w_mem_8_data :  std_logic_vector(7 DOWNTO 0);
  signal user_w_mem_8_open :  std_logic;
  signal user_mem_8_addr :  std_logic_vector(4 DOWNTO 0);
  signal user_mem_8_addr_update :  std_logic;
  signal user_r_read_32_rden :  std_logic;
  signal user_r_read_32_empty :  std_logic;
  signal user_r_read_32_data :  std_logic_vector(31 DOWNTO 0);
  signal user_r_read_32_eof :  std_logic;
  signal user_r_read_32_open :  std_logic;
  signal user_r_read_8_rden :  std_logic;
  signal user_r_read_8_empty :  std_logic;
  signal user_r_read_8_data :  std_logic_vector(7 DOWNTO 0);
  signal user_r_read_8_eof :  std_logic;
  signal user_r_read_8_open :  std_logic;
  signal user_w_write_32_wren :  std_logic;
  signal user_w_write_32_full :  std_logic;
  signal user_w_write_32_data :  std_logic_vector(31 DOWNTO 0);
  signal user_w_write_32_open :  std_logic;
  signal user_w_write_8_wren :  std_logic;
  signal user_w_write_8_full :  std_logic;
  signal user_w_write_8_data :  std_logic_vector(7 DOWNTO 0);
  signal user_w_write_8_open :  std_logic;
  signal user_r_audio_rden :  std_logic;
  signal user_r_audio_empty :  std_logic;
  signal user_r_audio_data :  std_logic_vector(31 DOWNTO 0);
  signal user_r_audio_eof :  std_logic;
  signal user_r_audio_open :  std_logic;
  signal user_w_audio_wren :  std_logic;
  signal user_w_audio_full :  std_logic;
  signal user_w_audio_data :  std_logic_vector(31 DOWNTO 0);
  signal user_w_audio_open :  std_logic;
  signal user_r_smb_rden :  std_logic;
  signal user_r_smb_empty :  std_logic;
  signal user_r_smb_data :  std_logic_vector(7 DOWNTO 0);
  signal user_r_smb_eof :  std_logic;
  signal user_r_smb_open :  std_logic;
  signal user_w_smb_wren :  std_logic;
  signal user_w_smb_full :  std_logic;
  signal user_w_smb_data :  std_logic_vector(7 DOWNTO 0);
  signal user_w_smb_open :  std_logic;
  signal user_clk :  std_logic;
  signal user_wren :  std_logic;
  signal user_wstrb :  std_logic_vector(3 DOWNTO 0);
  signal user_rden :  std_logic;
  signal user_rd_data :  std_logic_vector(31 DOWNTO 0);
  signal user_wr_data :  std_logic_vector(31 DOWNTO 0);
  signal user_addr :  std_logic_vector(31 DOWNTO 0);
  signal user_irq :  std_logic;

  -- Note that none of the ARM processor's direct connections to pads is
  -- defined as I/O on this module. Normally, they should be connected
  -- as toplevel ports here, but that confuses Vivado 2013.4 to think that
  -- some of these ports are real I/Os, causing an implementation failure.
  -- This detachment results in a lot of warnings during synthesis and
  -- implementation, but has no practical significance, as these pads are
  -- completely unrelated to the FPGA bitstream.

  signal PS_CLK :  std_logic;
  signal PS_PORB :  std_logic;
  signal PS_SRSTB :  std_logic;
  signal DDR_Addr : std_logic_vector(14 DOWNTO 0);
  signal DDR_BankAddr : std_logic_vector(2 DOWNTO 0);
  signal DDR_CAS_n : std_logic;
  signal DDR_CKE : std_logic;
  signal DDR_CS_n : std_logic;
  signal DDR_Clk : std_logic;
  signal DDR_Clk_n : std_logic;
  signal DDR_DM : std_logic_vector(3 DOWNTO 0);
  signal DDR_DQ : std_logic_vector(31 DOWNTO 0);
  signal DDR_DQS : std_logic_vector(3 DOWNTO 0);
  signal DDR_DQS_n : std_logic_vector(3 DOWNTO 0);
  signal DDR_DRSTB : std_logic;
  signal DDR_ODT : std_logic;
  signal DDR_RAS_n : std_logic;
  signal DDR_VRN : std_logic;
  signal DDR_VRP : std_logic;
  signal MIO : std_logic_vector(53 DOWNTO 0);
  signal DDR_WEB : std_logic;
  
  
  -- Signali za input FSM 
  signal input_fsm_reset : std_logic;
  
  -- Signali za output FSM
  signal output_fsm_reset : std_logic;
  signal output_fsm_dft_ce : std_logic;
  
  
  -- Signali za ulazni FIFO
  signal fifo_read_data : std_logic_vector(31 downto 0);
  signal fifo_read_rd_en : std_logic;
  signal fifo_in_reset : std_logic;
  signal fifo_in_empty : std_logic;
  signal fifo_read_count : std_logic_vector(9 downto 0);
  
  
  -- Signali za izlazni FIFO
  signal fifo_write_data : std_logic_vector(31 downto 0);
  signal fifo_write_wr_en : std_logic;
  signal fifo_out_reset : std_logic;
  signal fifo_out_full : std_logic;
  signal fifo_write_count : std_logic_vector(9 downto 0);
  
  
  -- Signali za DFT IP core
  -- DFT-960 => size_const = 29 = 0x1d = 0b011101
  constant dft_size_const : std_logic_vector(5 downto 0) := "011101";
  signal dft_data_in : std_logic_vector(31 downto 0);
  signal dft_out_I : std_logic_vector(15 downto 0);
  signal dft_out_Q : std_logic_vector(15 downto 0);
  signal dft_out_blk_exp : std_logic_vector(3 downto 0);
  signal dft_fd_in : std_logic;
  signal dft_fd_out : std_logic;
  signal dft_data_valid : std_logic;
  signal dft_rffd : std_logic;
  signal dft_sclr : std_logic;
  
  signal dft_out : std_logic_vector(31 downto 0);
  
  -- Reset controller signals
  signal controller_reset : std_logic;
  signal input_fsm_wd_reset : std_logic;
  signal output_fsm_wd_reset : std_logic;
  
  -- DEBUG
  signal led_sig : std_logic;
  signal led_cnt : std_logic_vector(7 downto 0);
  signal dft_fd_out_prev : std_logic := dft_fd_out;
  signal PS_GPIO_xillybus : std_logic_vector(55 downto 0);
  signal heartbeat_led_cnt : std_logic_vector(23 downto 0);
  signal led_heartbeat : std_logic;
  
begin
  xillybus_ins : xillybus
    port map (
      -- Ports related to /dev/xillybus_mem_8
      -- FPGA to CPU signals:
      user_r_mem_8_rden => user_r_mem_8_rden,
      user_r_mem_8_empty => user_r_mem_8_empty,
      user_r_mem_8_data => user_r_mem_8_data,
      user_r_mem_8_eof => user_r_mem_8_eof,
      user_r_mem_8_open => user_r_mem_8_open,
      -- CPU to FPGA signals:
      user_w_mem_8_wren => user_w_mem_8_wren,
      user_w_mem_8_full => user_w_mem_8_full,
      user_w_mem_8_data => user_w_mem_8_data,
      user_w_mem_8_open => user_w_mem_8_open,
      -- Address signals:
      user_mem_8_addr => user_mem_8_addr,
      user_mem_8_addr_update => user_mem_8_addr_update,

      -- Ports related to /dev/xillybus_read_32
      -- FPGA to CPU signals:
      user_r_read_32_rden => user_r_read_32_rden,
      user_r_read_32_empty => user_r_read_32_empty,
      user_r_read_32_data => user_r_read_32_data,
      user_r_read_32_eof => user_r_read_32_eof,
      user_r_read_32_open => user_r_read_32_open,

      -- Ports related to /dev/xillybus_read_8
      -- FPGA to CPU signals:
      user_r_read_8_rden => user_r_read_8_rden,
      user_r_read_8_empty => user_r_read_8_empty,
      user_r_read_8_data => user_r_read_8_data,
      user_r_read_8_eof => user_r_read_8_eof,
      user_r_read_8_open => user_r_read_8_open,

      -- Ports related to /dev/xillybus_write_32
      -- CPU to FPGA signals:
      user_w_write_32_wren => user_w_write_32_wren,
      user_w_write_32_full => user_w_write_32_full,
      user_w_write_32_data => user_w_write_32_data,
      user_w_write_32_open => user_w_write_32_open,

      -- Ports related to /dev/xillybus_write_8
      -- CPU to FPGA signals:
      user_w_write_8_wren => user_w_write_8_wren,
      user_w_write_8_full => user_w_write_8_full,
      user_w_write_8_data => user_w_write_8_data,
      user_w_write_8_open => user_w_write_8_open,

      -- Ports related to Xillybus Lite
      user_clk => user_clk,
      user_wren => user_wren,
      user_wstrb => user_wstrb,
      user_rden => user_rden,
      user_rd_data => user_rd_data,
      user_wr_data => user_wr_data,
      user_addr => user_addr,
      user_irq => user_irq,

      -- Ports related to /dev/xillybus_audio
      -- FPGA to CPU signals:
      user_r_audio_rden => user_r_audio_rden,
      user_r_audio_empty => user_r_audio_empty,
      user_r_audio_data => user_r_audio_data,
      user_r_audio_eof => user_r_audio_eof,
      user_r_audio_open => user_r_audio_open,
      -- CPU to FPGA signals:
      user_w_audio_wren => user_w_audio_wren,
      user_w_audio_full => user_w_audio_full,
      user_w_audio_data => user_w_audio_data,
      user_w_audio_open => user_w_audio_open,

      -- Ports related to /dev/xillybus_smb
      -- FPGA to CPU signals:
      user_r_smb_rden => user_r_smb_rden,
      user_r_smb_empty => user_r_smb_empty,
      user_r_smb_data => user_r_smb_data,
      user_r_smb_eof => user_r_smb_eof,
      user_r_smb_open => user_r_smb_open,
      -- CPU to FPGA signals:
      user_w_smb_wren => user_w_smb_wren,
      user_w_smb_full => user_w_smb_full,
      user_w_smb_data => user_w_smb_data,
      user_w_smb_open => user_w_smb_open,

      -- General signals
      PS_CLK => PS_CLK,
      PS_PORB => PS_PORB,
      PS_SRSTB => PS_SRSTB,
      clk_100 => clk_100,
      otg_oc => otg_oc,
      DDR_Addr => DDR_Addr,
      DDR_BankAddr => DDR_BankAddr,
      DDR_CAS_n => DDR_CAS_n,
      DDR_CKE => DDR_CKE,
      DDR_CS_n => DDR_CS_n,
      DDR_Clk => DDR_Clk,
      DDR_Clk_n => DDR_Clk_n,
      DDR_DM => DDR_DM,
      DDR_DQ => DDR_DQ,
      DDR_DQS => DDR_DQS,
      DDR_DQS_n => DDR_DQS_n,
      DDR_DRSTB => DDR_DRSTB,
      DDR_ODT => DDR_ODT,
      DDR_RAS_n => DDR_RAS_n,
      DDR_VRN => DDR_VRN,
      DDR_VRP => DDR_VRP,
      MIO => MIO,
      PS_GPIO => PS_GPIO_xillybus,
      DDR_WEB => DDR_WEB,
      GPIO_LED => GPIO_LED,
      bus_clk => bus_clk,
      quiesce => quiesce,
      vga4_blue => vga4_blue,
      vga4_green => vga4_green,
      vga4_red => vga4_red,
      vga_hsync => vga_hsync,
      vga_vsync => vga_vsync
  );

  -- Xillybus Lite
  
  user_irq <= '0'; -- No interrupts for now

  lite_addr <= conv_integer(user_addr(6 DOWNTO 2));

  process (user_clk)
  begin
    if (user_clk'event and user_clk = '1') then
      if (user_wstrb(0) = '1') then 
        litearray0(lite_addr) <= user_wr_data(7 DOWNTO 0);
      end if;

      if (user_wstrb(1) = '1') then 
        litearray1(lite_addr) <= user_wr_data(15 DOWNTO 8);
      end if;

      if (user_wstrb(2) = '1') then 
        litearray2(lite_addr) <= user_wr_data(23 DOWNTO 16);
      end if;

      if (user_wstrb(3) = '1') then 
        litearray3(lite_addr) <= user_wr_data(31 DOWNTO 24);
      end if;

      if (user_rden = '1') then
        user_rd_data <= litearray3(lite_addr) & litearray2(lite_addr) &
                        litearray1(lite_addr) & litearray0(lite_addr);
      end if;
    end if;
  end process;
  
--  A simple inferred RAM

  ram_addr <= conv_integer(user_mem_8_addr);
  
  process (bus_clk)
  begin
    if (bus_clk'event and bus_clk = '1') then
      if (user_w_mem_8_wren = '1') then 
        demoarray(ram_addr) <= user_w_mem_8_data;
      end if;
      if (user_r_mem_8_rden = '1') then
        user_r_mem_8_data <= demoarray(ram_addr);
      end if;
    end if;
  end process;

  user_r_mem_8_empty <= '0';
  user_r_mem_8_eof <= '0';
  user_w_mem_8_full <= '0';

----  32-bit loopback

--  fifo_32 : fifo_32x512
--    port map(
--      clk        => bus_clk,
--      srst       => reset_32,
--      din        => user_w_write_32_data,
--      wr_en      => user_w_write_32_wren,
--      rd_en      => user_r_read_32_rden,
--      dout       => user_r_read_32_data,
--      full       => user_w_write_32_full,
--      empty      => user_r_read_32_empty
--      );

--  reset_32 <= not (user_w_write_32_open or user_r_read_32_open);

--  user_r_read_32_eof <= '0';
  
  -- INPUT FIFO
  fifo_in : fifo_32x1024
  port map(
     clk        => bus_clk,
     srst       => fifo_in_reset,
     din        => user_w_write_32_data,
     wr_en      => user_w_write_32_wren,
     rd_en      => fifo_read_rd_en,
     dout       => fifo_read_data,
     full       => user_w_write_32_full,
     empty      => fifo_in_empty,
     data_count => fifo_read_count
  );
  
  fifo_in_reset <= controller_reset;
  
  -- OUTPUT FIFO
  fifo_out : fifo_32x1024
  port map(
     clk        => bus_clk,
     srst       => fifo_out_reset,
     din        => fifo_write_data,
     wr_en      => fifo_write_wr_en,
     rd_en      => user_r_read_32_rden,
     dout       => user_r_read_32_data,
     full       => fifo_out_full,
     empty      => user_r_read_32_empty,
     data_count => fifo_write_count
  );
  
  fifo_out_reset <= controller_reset;
  
  
  input_fsm : dft_in_fsm
  port map (
    reset          => input_fsm_reset,
    clk            => bus_clk,
    fifo_data      => fifo_read_data,
    fifo_rd_en     => fifo_read_rd_en,
    fifo_rd_count  => fifo_read_count,
    dft_data       => dft_data_in,
    dft_fd_in      => dft_fd_in,
    dft_rffd       => dft_rffd,
    dft_data_valid => dft_data_valid,
    fifo_watchdog_reset => input_fsm_wd_reset
  );
  
  input_fsm_reset <= controller_reset;
  
  
  output_fsm : dft_out_fsm
  port map (
    reset          => output_fsm_reset,
    clk            => bus_clk,
    dft_ce         => output_fsm_dft_ce,
    dft_dout       => dft_out, 
    dft_fd_out     => dft_fd_out,
    fifo_data      => fifo_write_data,
    fifo_wr_en     => fifo_write_wr_en,
    fifo_wr_count  => fifo_write_count,
    fifo_watchdog_reset => output_fsm_wd_reset
  );
  
  output_fsm_reset <= controller_reset;
  dft_out_I <= dft_out(31 downto 16);
  dft_out_Q <= dft_out(15 downto 0);
  
  dft_16_I : dft_16
    PORT MAP (
      CLK         => bus_clk,
      SCLR        => dft_sclr,
      CE          => output_fsm_dft_ce,
      SIZE        => dft_size_const,
      FWD_INV     => '1',
      -- Vremenska domena
      XN_RE       => dft_data_in(31 downto 16),
      XN_IM       => dft_data_in(15 downto 0),
      FD_IN       => dft_fd_in,
      RFFD        => dft_rffd,
      -- Frekvencijska domena
      XK_RE       => dft_out_I,
      XK_IM       => dft_out_Q,
      BLK_EXP     => dft_out_blk_exp,
      FD_OUT      => dft_fd_out,
      DATA_VALID  => dft_data_valid
    );
    
    dft_sclr <= controller_reset;
    
    -- Reset controller
    
    reset_controller_I : reset_controller
        port map (
          clk                 => bus_clk,
          input_fsm_wd_reset  => input_fsm_wd_reset,
          output_fsm_wd_reset => output_fsm_wd_reset,
          reset               => controller_reset
        );
    
    PS_GPIO <= PS_GPIO_xillybus(55 downto 11) & led_sig & led_heartbeat & PS_GPIO_xillybus(8 downto 0);
    process(bus_clk)
      begin
        if rising_edge(bus_clk) then
        if (dft_fd_out /= dft_fd_out_prev) then
          dft_fd_out_prev <= dft_fd_out;
          
          if led_cnt /= (led_cnt'range => '0') then 
            led_cnt <= x"ff";
            led_sig <= not led_sig;
          else
            led_cnt <= led_cnt - '1';
            led_sig <= led_sig;
          end if;
        end if;
        end if;
      end process;
      
      process(bus_clk)
      begin
        if rising_edge(bus_clk) then
           if heartbeat_led_cnt /= (heartbeat_led_cnt'range => '0') then
             heartbeat_led_cnt <= x"ffffff";
             led_heartbeat <= not led_heartbeat;
           else
             heartbeat_led_cnt <= heartbeat_led_cnt - '1';
             led_heartbeat <= led_heartbeat;
           end if;
        end if;
      end process;
  
--  8-bit loopback

  fifo_8 : fifo_8x2048
    port map(
      clk        => bus_clk,
      srst       => reset_8,
      din        => user_w_write_8_data,
      wr_en      => user_w_write_8_wren,
      rd_en      => user_r_read_8_rden,
      dout       => user_r_read_8_data,
      full       => user_w_write_8_full,
      empty      => user_r_read_8_empty
      );

    reset_8 <= not (user_w_write_8_open or user_r_read_8_open);

    user_r_read_8_eof <= '0';

  audio_ins : i2s_audio
    port map(
      bus_clk => bus_clk,
      clk_100 => clk_100,
      quiesce => quiesce,
      audio_mclk => audio_mclk,
      audio_dac => audio_dac,
      audio_adc => audio_adc,
      audio_bclk => audio_bclk,
      audio_lrclk => audio_lrclk,
      user_r_audio_rden => user_r_audio_rden,
      user_r_audio_empty => user_r_audio_empty,
      user_r_audio_data => user_r_audio_data,
      user_r_audio_eof => user_r_audio_eof,
      user_r_audio_open => user_r_audio_open,
      user_w_audio_wren => user_w_audio_wren,
      user_w_audio_full => user_w_audio_full,
      user_w_audio_data => user_w_audio_data,
      user_w_audio_open => user_w_audio_open
      );

  smbus_ins : smbus
    port map(
      bus_clk => bus_clk,
      quiesce => quiesce,
      smb_sclk => smb_sclk,
      smb_sdata => smb_sdata,
      smbus_addr => smbus_addr,
      user_r_smb_rden => user_r_smb_rden,
      user_r_smb_empty => user_r_smb_empty,
      user_r_smb_data => user_r_smb_data,
      user_r_smb_eof => user_r_smb_eof,
      user_r_smb_open => user_r_smb_open,
      user_w_smb_wren => user_w_smb_wren,
      user_w_smb_full => user_w_smb_full,
      user_w_smb_data => user_w_smb_data,
      user_w_smb_open => user_w_smb_open
      );
  
end sample_arch;
