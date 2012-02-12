.PHONY: all
all: ppp
ppp: ppp.o sha2.o rijndael.o

CFLAGS += -g
LDFLAGS += -lm

.PHONY: clean
clean:
	rm -f ppp ppp.o sha2.o rijndael.o

