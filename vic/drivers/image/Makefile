 ##############################################################################
 # @section DESCRIPTION
 #
 # VIC Image Driver Makefile
 ##############################################################################

# -----------------------------------------------------------------------
# SET ENVIRONMENT-SPECIFIC OPTIONS HERE
# -----------------------------------------------------------------------

# VIC DRIVER PATH (include and src are subdirs of this)
DRIVERPATH = .

# VIC RUN PATH
SHAREDPATH = ../shared_all
SHAREDIMAGEPATH = ../shared_image

# VIC RUN PATH
VICPATH = ../../vic_run

# VIC EXTENTIONS PATH
EXTPATH = ../../extensions

# Set the routing model extension
# | Level      | Value                              |
# |----------  |---------------------------------   |
# | rout_stub  | Stub routing model (no routing)    |
# | rout_rvic  | Use RVIC routing scheme            |
ROUT=rout_stub

include ${EXTPATH}/${ROUT}/rout.mk

ifndef NC_LIBS
NC_LIBS = $(shell nc-config --libs)
endif
$(info $$NC_LIBS is [${NC_LIBS}])

ifndef NC_CFLAGS
NC_CFLAGS = $(shell nc-config --cflags)
endif
$(info $$NC_CFLAGS is [${NC_CFLAGS}])

ifndef MPICC
MPICC = mpicc
endif
$(info $$MPICC is [${MPICC}])

GIT_VERSION := $(shell git describe --abbrev=4 --dirty --always --tags)
UNAME_S := $(shell uname -s)
HOSTNAME := $(shell uname -n)

# Set the log level
# To turn off warning statements, set LOG_LVL >= 30
# | Level     | Numeric value    |
# |---------  |---------------   |
# | ERROR     | Always Active    |
# | WARNING   | < 30             |
# | INFO      | < 20             |
# | DEBUG     | < 10             |
LOG_LVL = 5

# set includes
INCLUDES = -I ${DRIVERPATH}/include \
		   -I ${VICPATH}/include \
		   -I ${SHAREDPATH}/include \
		   -I ${SHAREDIMAGEPATH}/include \
		   -I ${EXTPATH}/${ROUT}/include \
			 -I /usr/lib/x86_64-linux-gnu/openmpi/include \
			 -L /usr/lib/x86_64-linux-gnu/openmpi/lib
#  -I /usr/include/x86_64-linux-gnu/mpich \

# Uncomment to include debugging information
CFLAGS  =  ${INCLUDES} ${NC_CFLAGS} -ggdb -O3 -Wall -Wextra -std=c99 \
					 -fopenmp -fcommon \
					 -DLOG_LVL=$(LOG_LVL) \
					 -DGIT_VERSION=\"$(GIT_VERSION)\" \
					 -DUSERNAME=\"$(USER)\" \
					 -DHOSTNAME=\"$(HOSTNAME)\"

ifeq (true, ${TRAVIS})
# Add extra debugging for builds on travis
CFLAGS += -rdynamic -Wl,-export-dynamic
endif

LIBRARY = -lm ${NC_LIBS}


dlext ?= so
prefix ?= /usr/local

target = libvic5_image.${dlext}
exe    = vic_image.exe

# -----------------------------------------------------------------------
# MOST USERS DO NOT NEED TO MODIFY BELOW THIS LINE
# -----------------------------------------------------------------------

HDRS = \
	$(wildcard ${VICPATH}/include/*.h) \
	$(wildcard ${DRIVERPATH}/include/*.h) \
	$(wildcard ${SHAREDPATH}/include/*.h) \
	$(wildcard ${SHAREDIMAGEPATH}/include/*.h) \
	$(wildcard ${EXTPATH}/${ROUT}/include/*.h)

SRCS = \
	$(wildcard ${VICPATH}/src/*.c) \
	$(wildcard ${DRIVERPATH}/src/*.c) \
	$(wildcard ${SHAREDPATH}/src/*.c) \
	$(wildcard ${SHAREDIMAGEPATH}/src/*.c) \
	$(wildcard ${EXTPATH}/${ROUT}/src/*.c)

OBJS = $(SRCS:%.c=%.o)


all:
	make model
	make dll

model: $(OBJS)
	$(MPICC) -o ${exe} $(OBJS) $(CFLAGS) $(LIBRARY)


dll: $(OBJS)
	$(MPICC) -o ${target} $(OBJS) $(CFLAGS) -shared $(LIBRARY)

%.o: %.c
	$(CC) -c $(CFLAGS) -fPIC $< -o $@

install:
	install -Dvm 755 ${exe} ${prefix}/bin
	install -Dv ${target} ${prefix}/lib


clean::
	rm -f ${SHAREDPATH}/src/*.o
	rm -f ${SHAREDIMAGEPATH}/src/*.o
	rm -f ${VICPATH}/src/*.o
	rm -f ${EXTPATH}/${ROUT}/src/*.o
	rm -f src/*.o
	rm -f *.so *.dll *.exe
	\rm -f core log
	\rm -rf ${COMPEXE}${EXT} ${COMPEXE}${EXT}.dSYM *.dll *.so
