command-line support
processCommandLine: stdout
	| args scriptArgStart command commandArgs argIndex argsSize |
	args := System commandLineArguments.
	scriptArgStart := args indexOf: '--'.
	commandArgs := {}.
	command := nil.
	scriptArgStart = 0
		ifTrue: [ 
			^ self
				error:
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
					(#('create' 'filetree' 'tonel' '--debug') includes: arg)
						ifFalse: [ 
							^ self
								error:
									'UNKNOWN command ' , arg printString
										, '. Command should be one of [create | filetree | tonel ]'
								to: stdout ].
					arg = '--debug'
						ifTrue: [ self debug: true ]
						ifFalse: [ command := arg ] ]
				ifNotNil: [ commandArgs add: arg ] ].
	command = 'create'
		ifTrue: [ 
			commandArgs size ~= 4
				ifTrue: [ 
					^ self
						error:
							'expected 4 positional arguments for create command (project-root, t2f2t-data-dir, tonel-pkg-dir, and filetree-pkg-dir), got '
								, commandArgs size printString
						to: stdout ].
			^ self
				createForProject: (commandArgs at: 1)
				t2f2t: (commandArgs at: 2)
				tonel: (commandArgs at: 3)
				filetree: (commandArgs at: 4)
				stdout: stdout ].
	commandArgs size ~= 1
		ifTrue: [ 
			^ self
				error:
					'expected 1 positional arguments for ' , command
						, ' command (t2f2t-data-dir), got ' , commandArgs size printString
				to: stdout ].

	command = 'filetree'
		ifTrue: [ ^ self convertToFiletreePackagesUsing: (commandArgs at: 1) stdout: stdout ].
	command = 'tonel'
		ifTrue: [ ^ self convertToTonelPackagesUsing: (commandArgs at: 1) stdout: stdout ]