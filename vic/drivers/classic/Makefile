 ##############################################################################
 # @section DESCRIPTION
 #
 # VIC Classic Driver Makefile
 ##############################################################################

# -----------------------------------------------------------------------
# SET ENVIRONMENT-SPECIFIC OPTIONS HERE
# -----------------------------------------------------------------------

# VIC DRIVER PATH (include and src are subdirs of this)
DRIVERPATH = .

# VIC RUN PATH
SHAREDPATH = ../shared_all

# VIC RUN PATH
VICPATH = ../../vic_run

# Set SHELL = your shell here
# SHELL = /bin/bash
# SHELL = powershell

# Set CC = your compiler here
# ifndef CC
# CC=gcc
# endif
CC=gcc

GIT_VERSION := $(git describe --abbrev=4 --dirty --always --tags)
# HOSTNAME := $(shell uname -n)

# Set the log level
# To turn off warning statements, set LOG_LVL >= 30
# | Level     | Numeric value    |
# |---------  |---------------   |
# | ERROR     | Always Active    |
# | WARNING   | < 30             |
# | INFO      | < 20             |
# | DEBUG     | < 10             |
LOG_LVL = 5

# set include
INCLUDES = -I ${DRIVERPATH}/include -I $(SHAREDPATH)/include -I ${VICPATH}/include

# Uncomment for normal optimized code flags (fastest run option)
#CFLAGS  = -O3 -Wall -Wno-unused
# LIBRARY = -lm

# Uncomment to include debugging information
# gcc10, -fcommon: https://stackoverflow.com/questions/69908418/multiple-definition-of-first-defined-here-on-gcc-10-2-1-but-not-gcc-8-3-0
CFLAGS  =  ${INCLUDES} -g -O3 -Wall -Wextra -std=c99 -fcommon \
					 -DLOG_LVL=$(LOG_LVL) \
					 -DGIT_VERSION=\"$(GIT_VERSION)\" \
					 -DUSERNAME=\"$(USER)\" \
					 -DHOSTNAME=\"$(HOSTNAME)\"
LIBRARY = -lm

# Uncomment to include execution profiling information
#CFLAGS  = ${INCLUDES} -O3 -pg -Wall -Wno-unused -DLOG_LVL=$(LOG_LVL)
#LIBRARY = -lm

# Uncomment to debug memory problems using electric fence (man efence)
#CFLAGS  = ${INCLUDES} -g -Wall -Wno-unused -DLOG_LVL=$(LOG_LVL)
#LIBRARY = -lm -lefence -L/usr/local/lib

ifeq ($(target),)
	target := libvic5_classic.dll
endif

exe    = vic_classic.exe

# -----------------------------------------------------------------------
# MOST USERS DO NOT NEED TO MODIFY BELOW THIS LINE
# -----------------------------------------------------------------------
HDRS = \
	$(wildcard ${VICPATH}/include/*.h) \
	$(wildcard ${DRIVERPATH}/include/*.h) \
	$(wildcard ${SHAREDPATH}/include/*.h)

SRCS = \
	$(wildcard ${VICPATH}/src/*.c) \
	$(wildcard ${DRIVERPATH}/src/*.c) \
	$(wildcard ${SHAREDPATH}/src/*.c)

OBJS = $(SRCS:%.c=%.o)

default: 
	make exe
	make dll

exe: $(exe)
dll: $(target)

$(target): $(OBJS)
	$(CC) -o ${target} $(OBJS) $(CFLAGS) -shared $(LIBRARY)

$(exe): $(OBJS)
	$(CC) -o $(exe) $(OBJS) $(CFLAGS) $(LIBRARY)

%.o: %.c
	$(CC) -c $(CFLAGS) -fPIC $< -o $@

install:
	install -m 755 $(exe) $bindir
	install $(target) $libdir

clean::
	rm -f core log
	rm -f ${SHAREDPATH}/src/*.o
	rm -f ${VICPATH}/src/*.o
	rm -f src/*.o
	rm -rf ${COMPEXE}${EXT} ${COMPEXE}${EXT}.dSYM
