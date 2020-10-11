command-line support
usageMessage: stdout
	| root read |
	root := (Rowan projectNamed: self class _projectName) repositoryRoot.
	read := ReadStreamPortable on: (root / self _manPagePath) contents.
	[ read atEnd ]
		whileFalse: [ 
			stdout
				nextPutAll: read nextLine;
				lf ]