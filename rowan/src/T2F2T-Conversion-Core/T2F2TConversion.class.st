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

{ #category : 'private' }
T2F2TConversion >> _helpFileName [
	^ 't2f2t-help.txt'
]

{ #category : 'private' }
T2F2TConversion >> _message: message to: stdout [
	stdout
		lf;
		nextPutAll: message;
		lf;
		tab;
		nextPutAll: 'See help (t2t2t.sh --help) for details';
		lf
]

{ #category : 'command-line support' }
T2F2TConversion >> processCommandLine: stdout [
	| args scriptArgStart directoryArgsList command createArgsList |
	args := System commandLineArguments.
	scriptArgStart := args indexOf: '--'.
	directoryArgsList := {}.
	createArgsList := {}.
	command := nil.
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
						ifTrue: [ command := arg ]
						ifFalse: [ 
							(#('--tonel' '--filetree' '--t2f2t')
								detect: [ :each | arg beginsWith: each ]
								ifNone: [  ]) notNil
								ifTrue: [ 
									command := 'create'.
									createArgsList add: arg ]
								ifFalse: [ 
									(arg beginsWith: '-')
										ifTrue: [ ^ self _message: 'UNKNOWN argument ' , arg printString to: stdout ]
										ifFalse: [ directoryArgsList add: arg ] ] ] ].
			command ~~ 'create'
				ifTrue: [ 
					"doing conversion"
					directoryArgsList size ~= 2
						ifTrue: [ 
							^ self
								_message:
									'missing positional arguments (source and destination directories)'
								to: stdout ].
					command = '--t2f'
						ifTrue: [ 
							^ self
								convertTonelPackagesIn: (directoryArgsList at: 1)
								toFiletreePackagesIn: (directoryArgsList at: 2) ].
					command = '--f2t'
						ifTrue: [ 
							^ self
								convertFiletreePackagesIn: (directoryArgsList at: 1)
								toTonelPackagesIn: (directoryArgsList at: 2) ].
					^ self _message: 'missing required argument [ --t2f | --f2t ]' to: stdout ]
				ifFalse: [ 
					"creating metadata"
					createArgsList size ~= 3
						ifTrue: [ 
							self
								_message: 'missing required arguments [--tonel --filetree --t2f2t ]'
								to: stdout ].
					^ self processCreateMetadataArgs: createArgsList ] ]
		ifFalse: [ 
			^ self
				_message:
					'topaz solo launched without '' -- '', so it is not possible to process command line arguments'
				to: stdout ]
]

{ #category : 'command-line support' }
T2F2TConversion >> usageMessage: stdout [
	| root read |
	root := (Rowan projectNamed: self class _projectName) repositoryRoot.
	read := ReadStreamPortable on: (root / 'bin' / self _helpFileName) contents.
	[ read atEnd ]
		whileFalse: [ 
			stdout
				nextPutAll: read nextLine;
				lf ]
]
