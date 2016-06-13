# VHDL implementation
VHDL sources provided in this tree are intended to be used with the Xillybus example project for ZedBoard.

### Prerequisites

Download the boot partition kit for ZedBoard platform on the [official site](http://xillybus.com/xillinux). ([Direct link](http://xillybus.com/downloads/xillinux-eval-zedboard-1.3c.zip)) Extract the archive to the working directory. Run Vivado and without any project open go to Tools > Run Tcl script ... and navigate to Tcl script vhdl/xillydemo-vivado.tcl. Vivado will create a project and open it.


### Usage

Replace the sample scripts with the ones from this repository. From the IP catalog create new customizations of the following IP cores:

* dft_16 - DFT core with 16 bit word length and the following optional signals:
    * CE
    * SCLR

* fifo_32x1024 - FIFO generator with 32 bit word length, 1024 depth and the following optional signals:
    * DATA_COUNT (10 bit) - both read and write
