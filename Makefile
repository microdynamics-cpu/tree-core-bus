CC       = gcc
DEFS     =
INCDIRS  = -Isrc
LIBS     =
OPT      = -g
CCFLAGS  = $(DEFS) $(OPT)

BUILD_DIR = build
TARGET    = $(BUILD_DIR)/bus_generator
OBJ_DIR = $(BUILD_DIR)/obj
SRC =\
    main.c\
    arg_parser.c\
    gen_axi_amba.c\
    gen_axi_utils.c\
    gen_axi_mtos.c\
    gen_axi_stom.c\
    gen_axi_arbiter_mtos.c\
    gen_axi_arbiter_stom.c\
    gen_axi_default_slave.c\
    gen_axi_wid.c

OBJS = $(SRC:.c=.o)

H_DIR = src
C_DIR = src

vpath %.h $(H_DIR)
vpath %.c $(C_DIR)


$(OBJ_DIR)/%.o: %.c
	$(CC) -c $(CCFLAGS) $(INCDIRS) -o $@ $<

prev-build:
	@mkdir -p build
	@mkdir -p build/obj

all: prev-build $(TARGET)

$(TARGET): $(addprefix $(OBJ_DIR)/, $(OBJS))
	$(CC) -o $(TARGET) $^ $(LIBS)

run: $(TARGET)
	./$(TARGET) --master=2 --slave=3 --output=test/amba_axi_m2s3.v


DIRS = $(subst /,, $(dir $(wildcard */Makefile)))

clean:
	rm -rf $(BUILD_DIR)

.PHONY:
	prev-build all run clean
