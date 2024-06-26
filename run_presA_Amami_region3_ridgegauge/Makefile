
# Makefile for Clawpack code in this directory.
# This version only sets the local files and frequently changed
# options, and then includes the standard makefile pointed to by CLAWMAKE.
CLAWMAKE = $(CLAW)/clawutil/src/Makefile.common

# See the above file for details and a list of make options, or type
#   make .help
# at the unix prompt.


# Adjust these variables if desired:
# ----------------------------------

CLAW_PKG = geoclaw                  # Clawpack package to use
EXE = xgeoclaw                 # Executable to create
SETRUN_FILE = setrun.py        # File containing function to make data
OUTDIR = _output               # Directory for output
SETPLOT_FILE = setplot.py      # File containing function to set plots
PLOTDIR = _plots               # Directory for plots

# NetCDF Fortran support
# set a fullpath of `nf-config` to NF_CONFIG or
# set `nf-config` in your PATH
NF_CONFIG := nf-config
NCFLAGS := $(shell $(NF_CONFIG) --cflags) -DNETCDF
NC_LINK_CMD := $(shell $(NF_CONFIG) --flibs)
#NC_CONFIG := nc-config
#NCFLAGS := $(shell $(NF_CONFIG) --cflags) $(shell $(NC_CONFIG) --cflags) -DNETCDF
#NC_LINK_CMD := $(shell $(NF_CONFIG) --flibs) $(shell $(NC_CONFIG) --libs)


# Compiler flags
MPFLAG = -fopenmp
# Debugging & profiling options
#DEBUG = 1# uncomment to debug
#PROFILE = 1# uncomment for profiling
#
ifeq ($(DEBUG),1)
    LDFLAGS = -g
    # Environment variable FC should be set to fortran compiler, e.g. gfortran
    ifeq ($(FC),gfortran)
	DFLAGS = -g -fbacktrace -fbounds-check -ffpe-trap=invalid,overflow,zero
    else ifeq ($(FC),ifort)
	#DEBUG = -g -C -fpe0 -traceback -ftrapuv -warn all
	DFLAGS = -g -CB -fpe0 -traceback -nogen-interface
    endif
else ifeq ($(PROFILE),1)
    LDFLAGS = -pg
    DFLAGS = -pg -O2 -profile-functions -profile-loops=all -profile-loops-report=2
    MPFLAG = 
else
    DFLAGS = -O2
    #DFLAGS = -O3
endif
FFLAGS += $(MPFLAG) $(DFLAGS) $(NCFLAGS)
LFLAGS += $(NC_LINK_CMD) $(MPFLAG) $(LDFLAGS)
FFLAGS += -fallow-argument-mismatch

# ---------------------------------
# package sources for this program:
# ---------------------------------

GEOLIB = $(CLAW)/geoclaw/src/2d/shallow
include $(GEOLIB)/Makefile.geoclaw

# ---------------------------------------
# package sources specifically to exclude
# (i.e. if a custom replacement source 
#  under a different name is provided)
# ---------------------------------------

EXCLUDE_MODULES = \
    $(GEOLIB)/surge/data_storm_module.f90 \
    $(GEOLIB)/surge/storm_module.f90 \
    $(GEOLIB)/gauges_module.f90 \
    $(GEOLIB)/multilayer/multilayer_module.f90 \

EXCLUDE_SOURCES = \
    $(AMRLIB)/outmsh.f \

# ----------------------------------------
# List of custom sources for this program:
# ----------------------------------------

RIEMANN = $(CLAW)/riemann/src

MODULES = \
  ./mod/data_storm_module_wrfclaw.f90 \
  ./mod/storm_module_wrfclaw.f90 \
  $(GEOLIB)/gauges_module.f90 \
  $(GEOLIB)/multilayer/multilayer_module.f90 \

SOURCES = \
  $(RIEMANN)/rpn2_geoclaw.f \
  $(RIEMANN)/rpt2_geoclaw.f \
  $(RIEMANN)/geoclaw_riemann_utils.f \
  ./src/outmsh.f \

#-------------------------------------------------------------------
# Include Makefile containing standard definitions and make options:
include $(CLAWMAKE)

# Plot and save using Julia 
.PHONY: juliaplots juliasave converttomat juliaall matlabplots

juliaplots:
	julia setplot.jl
juliasave:
	julia setsave.jl
converttomat:
	julia setconvert.jl
juliaall:
	julia -e 'include("./setsave.jl"); include("./setplot.jl"); include("./setconvert.jl");'
gmtplot:
	./sequential_mkgrd_fgout.sh; ./sequential_mkgrd_max.sh; ./sequential_plot_fgmax.sh

### DO NOT remove this line - make depends on it ###
