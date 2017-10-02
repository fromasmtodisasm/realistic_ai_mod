INCLUDE_FLAGS	= -I../CryCommon -I../Win32APIWrapper
LIBS  				= -lWin32APIWrapper

FILES =	$(wildcard *.cpp) 
#these files need to remain unoptimized in release mode
DEBUG_FILES =	XVehicle.cpp XVehicleProxy.cpp XVehicleSystem.cpp

OUTPUT		= crygame
all: 		release

CXX = g++
CXXFLAGS_OPT_LEVEL = -O3

include ../Makefile.include