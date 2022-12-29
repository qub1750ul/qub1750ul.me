# @brief Recursive version of `wildcard`
#
# @param $1 Initial set of root directories to recurse
# @param $2 Pattern matching expression
#
define rwildcard =
  $(foreach d,$(wildcard $1*),
    $(call rwildcard,$d/,$2)
    $(filter $(subst *,%,$2),$d)
  )
endef
