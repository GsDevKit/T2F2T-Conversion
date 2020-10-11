command-line
executeCommandLine
	| stdout |
	stdout := GsFile stdout.
	self new processCommandLine: GsFile stdout