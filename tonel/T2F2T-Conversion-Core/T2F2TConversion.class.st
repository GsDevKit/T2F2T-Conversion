Class {
	#name : 'T2F2TConversion',
	#superclass : 'Object',
	#category : 'T2F2T-Conversion-Core'
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
T2F2TConversion >> _manPagePath [
	^ 'docs/man.txt'
]

{ #category : 'private' }
T2F2TConversion >> _message: message to: stdout [
	stdout
		lf;
		nextPutAll: message;
		nextPutAll: '. See help (t2t2t.sh --help) for details';
		lf
]

{ #category : 'command-line support' }
T2F2TConversion >> processCommandLine: stdout [
	| args scriptArgStart command commandArgs argIndex argsSize |
	args := System commandLineArguments.
	scriptArgStart := args indexOf: '--'.
	commandArgs := {}.
	command := nil.
	scriptArgStart = 0
		ifTrue: [ 
			^ self
				_message:
					'topaz solo launched without '' -- '', so it is not possible to process command line arguments'
				to: stdout ].

	argIndex := scriptArgStart + 1.	"arg after initial --"
	argsSize := args size.
	[ argIndex <= argsSize ]
		whileTrue: [ 
			| arg |
			arg := args at: argIndex.
			argIndex := argIndex + 1.
			arg = '--help' | (arg = '-h')
				ifTrue: [ ^ self usageMessage: stdout ].
			command
				ifNil: [ 
					(#('create' 'filetree' 'tonel') includes: arg)
						ifFalse: [ 
							^ self
								_message:
									'UNKNOWN command ' , arg printString
										, '. Command should be one of [create | filetree | tonel ]'
								to: stdout ].
					command := arg ]
				ifNotNil: [ commandArgs add: arg ] ].
	command = 'create'
		ifTrue: [ 
			commandArgs size ~= 3
				ifTrue: [ 
					^ self
						_message:
							'expected 3 positional arguments for create command (t2f2t-data-dir, tonel-pkg-dir, and filetree-pkg-dir), got '
								, commandArgs size printString
						to: stdout ].
			^ self
				createUsing: (commandArgs at: 1)
				tonel: (commandArgs at: 2)
				filetree: (commandArgs at: 3) ].
	commandArgs size ~= 1
		ifTrue: [ 
			^ self
				_message:
					'expected 1 positional arguments for ' , command
						, ' command (t2f2t-data-dir), got ' , commandArgs size printString
				to: stdout ].

	command = 'filetree'
		ifTrue: [ ^ self convertToFiletreePackagesUsing: (commandArgs at: 1) ].
	command = 'tonel'
		ifTrue: [ ^ self convertToTonelPackagesUsing: (commandArgs at: 1) ]
]

{ #category : 'command-line support' }
T2F2TConversion >> usageMessage: stdout [
	| root read |
	root := (Rowan projectNamed: self class _projectName) repositoryRoot.
	read := ReadStreamPortable on: (root / self _manPagePath) contents.
	[ read atEnd ]
		whileFalse: [ 
			stdout
				nextPutAll: read nextLine;
				lf ]
]
