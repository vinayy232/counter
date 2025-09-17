
#
# DEFINE THE NAME OF THE TOPLEVEL DESIGN
# AND variables specific to this run
#
set design(TOPLEVEL) "sm"

#
# Variables
#
# set mmc_or_simple "mmc"    # "simple" - using "read_libs"
#                        # "mmc" - using "read_mmc"
set runtype "synthesis"
set phys_synth_type "lef" ; # "lef" - only read lef and qrcTech files
                        # "floorplan" - read in a def of the floorplan

#
# Load basic settings
#
#
# Load general procedures
#
source ../scripts/procedures.tcl -quiet

enics_start_stage "start"

set debug_file "debug.txt"

# Load the specific definitions for this project
source ../inputs/$design(TOPLEVEL).defines -quiet

# Load general settings
source ../scripts/settings.tcl -quiet

# Load the library paths and definitions for this technology
source ../libraries/$TECH.tcl -quiet
source ../libraries/libraries.$SOC_TECHNOLOGY.tcl -quiet
source ../libraries/libraries.$SRAM_TECHNOLOGY.tcl -quiet