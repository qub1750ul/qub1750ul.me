# Main makefile
# Run `$ make help` for info on how to use this

include src/make/defaults
include src/make/rwildcard.make
include src/make/help/help.rules
include $(wildcard src/make/*.rules)
