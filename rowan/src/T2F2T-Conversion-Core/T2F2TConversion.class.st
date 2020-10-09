Class {
	#name : 'T2F2TConversion',
	#superclass : 'Object',
	#category : 'T2F2T-Conversion'
}

{ #category : 'private' }
T2F2TConversion class >> _projectName [
	^ 'T2F2T-Conversion'
]

{ #category : 'command-line' }
T2F2TConversion class >> executeCommandLine [
	| stdout |
	stdout := GsFile stdout.
	self new processCommandLine: GsFile stdout
]

{ #category : 'command-line support' }
T2F2TConversion class >> helpText [
	((Rowan projectNamed: self _projectName) repositoryRoot / 'bin'
		/ 't2f2t-help.txt') contents
]

{ #category : 'command-line support' }
T2F2TConversion >> processCommandLine: stdout [
	| args scriptArgStart directoryArgsList polarity |
	args := System commandLineArguments.
	scriptArgStart := args indexOf: '--'.
	directoryArgsList := {}.
	scriptArgStart > 0
		ifTrue: [ 
			| argIndex argsSize |
			argIndex := scriptArgStart + 1.	"arg after initial --"
			argsSize := args size.
			[ argIndex <= argsSize ]
				whileTrue: [ 
					| arg |
					arg := args at: argIndex.
					argIndex := argIndex + 1.
					arg = '--help' | (arg = '-h')
						ifTrue: [ ^ self usageMessage: stdout ].
					arg = '--t2f' | (arg = '--f2t')
						ifTrue: [ polarity := arg ]
						ifFalse: [ 
							(arg beginsWith: '-')
								ifTrue: [ 
									stdout
										lf;
										nextPutAll: 'UNKNOWN argument ' , arg printString;
										lf;
										lf.
									^ self usageMessage: stdout ]
								ifFalse: [ directoryArgsList add: arg ] ] ].
			directoryArgsList size = 2
				ifFalse: [ 
					stdout
						lf;
						nextPutAll:
								'missing positional arguments (source and destination directories)';
						lf;
						lf.
					^ self usageMessage: stdout ].
			polarity == '--t2f'
				ifTrue: [ 
					self
						convertTonelPackagesIn: (directoryArgsList at: 1)
						toFiletreePackagesIn: (directoryArgsList at: 2) ].
			polarity == '--f2t'
				ifTrue: [ 
					self
						convertFiletreePackagesIn: (directoryArgsList at: 1)
						toTonelPackagesIn: (directoryArgsList at: 2) ].
			stdout
				lf;
				nextPutAll: 'missing required argument [ --t2f | --f2t ]';
				lf;
				lf.
			^ self usageMessage: stdout ]
		ifFalse: [ 
			stdout
				lf;
				nextPutAll:
						'topaz solo launched without '' -- '', so it is not possible to process command line arguments';
				lf;
				lf.
			^ self usageMessage: stdout ]
]

{ #category : 'command-line support' }
T2F2TConversion >> usageMessage: stdout [
	stdout
		lf;
		nextPutAll: 'SYNOPSIS:';
		lf;
		lf;
		nextPutAll: '	t2f2t.sh [-h | --help]';
		lf;
		nextPutAll:
				'	t2f2t.sh --t2f <source-package-directory> <destination-package-directory';
		lf;
		nextPutAll:
				'	t2f2t.sh --f2t <source-package-directory> <destination-package-directory';
		lf;
		lf;
		nextPutAll: 'DESCRIPTION';
		lf;
		lf;
		nextPutAll: 'EXAMPLES:';
		lf;
		nextPutAll:
				'	t2f2t.sh';
		lf;
		lf
]
