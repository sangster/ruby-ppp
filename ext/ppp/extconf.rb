require 'mkmf'

$warnflags.slice! '-Wdeclaration-after-statement' # this warning is dumb

create_makefile 'Cppp'
