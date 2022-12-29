# This program takes as input raw docstrings
#

function printLineWarn( msg )
{
	print "WARN: " msg
	print "\tin file " FILENAME
	print "\tat line " ( NR - 1 )
}

BEGIN {
	# ANSI color escapes
	NO_FMT="\033[0m"
	TARGET_COLOR="\033[36m"
}

# Match a dockblock start token
/^##$/ {

	# Clean attribute buffers
	target="" ; brief=""

	# parse lines until block end
	while ( $0 ~ /^#/ ) {

		if ( $0 ~ /^# @brief/ ) {
				gsub( "^# @brief ","" )
				brief=$0
		}

		if ( $0 ~ /^# @target / ) {
				gsub( "^# @target ", TARGET_COLOR )
				gsub( "$", NO_FMT )
				target=$0
		}

		getline
	}

	# When docblock ends print help info
	if ( target == "" ) {
		printLineWarn( "docattr 'target' not defined, dropping docblock" )
		next
	}

	printf "%-20s : %s\n", target, brief
}
