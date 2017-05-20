
TOOLCHAIN :=
CC=$(TOOLCHAIN)gcc
AR=$(TOOLCHAIN)ar

CFLAGS  += -Wall -Wextra -Wno-unused-parameter -pipe
CFLAGS  += -D_GNU_SOURCE -Ilibfdt -DANDROID -Ilibz
CFLAGS  += -Iinclude -fPIC -O2 -DUSE_MMAP -I./
LDFLAGS := -Llibfdt/ -Llibs -Llibmincrypt
FDTLDFLAGS += -Ilibfdt -Llibfdt/libcrypt.a

BINDIR := bin
LIBDIR := libs

TARGETS := \
	dtbtool 

	
LIBFDT_VERSION = version.lds

LIBFDT_soname = libfdt.$(SHAREDLIB_EXT).1

LIBFDT_SRCS := \
	libfdt/fdt.c \
	libfdt/fdt_ro.c \
	libfdt/fdt_wip.c \
	libfdt/fdt_sw.c \
	libfdt/fdt_rw.c \
	libfdt/fdt_strerror.c \
	libfdt/fdt_empty_tree.c 
	
LCRYPYO_SRCS := libmincrypt/sha.c libmincrypt/rsa.c libmincrypt/sha256.c

LIBFDT_INCLUDES := \
		libfdt/fdt.h \
		libfdt/libfdt.h \
		libfdt/libfdt_env.h

CRYPTOBJ_FILES := $(LCRYPYO_SRCS:%.c=%.o)
LIBFDT_OBJS := $(LIBFDT_SRCS:%.c=%.o)
 
all: libcrypt libfdt dtbtool
$(install)
	
libcrypt: $(CRYPTOBJ_FILES)
	$(AR) rs $(LIBDIR)/libcrypt.a $^

libfdt: $(LIBFDT_OBJS)
	$(AR) rs $(LIBDIR)/libfdt.a $^

dtbtool: $(LIBFDT_OBJS) $(CRYPTOBJ_FILES) dtbtool.o
	$(CC) -o $(BINDIR)/$@ $^ $(FDTLDFLAGS) $(CFLAGS)

libs: $(STATIC_LIBS)
	for file in $(STATIC_LIBS) ; do \
			mv $$file $(LIBDIR)/; done

install: $(TARGETS)
	for file in `find ./ -name "$(TARGETS)" `; do \
			mv $$file $(BINDIR)/; done

clean:
	rm -f $(LIBDIR)/* $(BINDIR)/* **/*.o *.o **/*.a 

.PHONY: clean

