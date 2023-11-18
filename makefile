# Main makefile
# Run `$ make help` for info on how to use this

# Load local environment file.
# Since we want to not surprise the user, generate equivalent Make code that
# sets each variable only if not already set via CLI
envfile = build/make/env_from_file.make
$(shell mkdir -p $(dir $(envfile)) && <.local/environment sed -nEe 's!^([^= ]+)=(.*)$$!export \1 ?= \2!p' > build/make/env_from_file.make)
include $(envfile)

include src/make/defaults
include src/make/rwildcard.make
include src/make/help/help.rules
include $(wildcard src/make/*.rules)
