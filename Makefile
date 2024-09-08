# Target specific macros
TARGET = movement_OSEK
TARGET_SOURCES = \
	movement.c
TOPPERS_OSEK_OIL_SOURCE = ./movement.oil
ROOT=$(nxtOSEK)

# Don't modify below part
O_PATH ?= build
include $(nxtOSEK)/ecrobot/ecrobot.mak
