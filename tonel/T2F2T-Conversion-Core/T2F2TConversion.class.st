"
Rowan-based scripts for converting package repositories from Tonel to Filetree and Filetree to Tonel format .

See project readme (https://github.com/GsDevKit/T2F2T-Conversion#t2f2t-conversion) and shell script man page (https://github.com/GsDevKit/T2F2T-Conversion/blob/master/docs/man.txt) for additional details.

test ""quoted strings"" in a comment
"
Class {
	#name : 'T2F2TConversion',
	#superclass : 'Object',
	#instVars : [
		'debug'
	],
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

{ #category : 'filetree/tonel commands' }
T2F2TConversion >> _copyPackagesFrom: sourceProject to: targetProject [
	sourceProject
		readPackageNamesBlock: [ :packageName | 
			"read all of the packages"
			true ].
	targetProject packagesRoot ensureCreateDirectory.
	targetProject packages: sourceProject packages.
	targetProject exportPackages
]

{ #category : 'create command' }
T2F2TConversion >> _createProject: projectName packageConvention: packageConvention root: root t2f2tDir: t2f2tDir packageDir: packageDir componentName: componentName format: format [
	| project resolvedProject |
	project := (Rowan newProjectNamed: projectName)
		packageConvention: packageConvention;
		packageFormat: format;
		diskUrl: 'file://' , root pathString;
		projectSpecFile: t2f2tDir , '/' , format , '.ston';
		specName: format;
		componentsPath: t2f2tDir , '/components';
		packagesPath: packageDir;
		projectsPath: t2f2tDir , '/projects';
		specsPath: t2f2tDir , '/specs';
		projectSpecPath: t2f2tDir;
		projectSpecName: format;
		yourself.

	project addTopLevelComponentNamed: componentName.

	resolvedProject := project resolve.
	Rowan projectTools createV2
		createResolvedProjectRepository: resolvedProject repository.
	resolvedProject
		exportProjectSpecification;
		exportProjects;
		exportComponents;
		exportLoadSpecification
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

{ #category : 'filetree/tonel commands' }
T2F2TConversion >> convertTo: targetFormat packagesUsing: t2f2tPath stdout: stdout [
	| t2f2tRoot tonelProject filetreeProject targetProject sourceProject |
	t2f2tRoot := t2f2tPath asFileReference.
	t2f2tRoot exists
		ifFalse: [ 
			^ self
				error:
					'The t2f2t metadata directory ' , t2f2tRoot printString , ' does not exist.'
				to: stdout ].
	tonelProject := Rowan
		projectFromUrl: 'file://' , (t2f2tRoot / 'specs' / 'tonel.ston') pathString.
	filetreeProject := Rowan
		projectFromUrl: 'file://' , (t2f2tRoot / 'specs' / 'filetree.ston') pathString.
	targetFormat = 'tonel'
		ifTrue: [ 
			targetProject := tonelProject.
			sourceProject := filetreeProject ]
		ifFalse: [ 
			targetFormat = 'filetree'
				ifTrue: [ 
					targetProject := filetreeProject.
					sourceProject := tonelProject ]
				ifFalse: [ 
					self
						error:
							'unknown format ' , targetFormat printString , '. Should be [ tonel | filetree]'
						to: stdout ] ].
	self _copyPackagesFrom: sourceProject to: targetProject
]

{ #category : 'filetree/tonel commands' }
T2F2TConversion >> convertToFiletreePackagesUsing: t2f2tPath stdout: stdout [
	^ self convertTo: 'filetree' packagesUsing: t2f2tPath stdout: stdout
]

{ #category : 'filetree/tonel commands' }
T2F2TConversion >> convertToTonelPackagesUsing: t2f2tPath stdout: stdout [
	^ self convertTo: 'tonel' packagesUsing: t2f2tPath stdout: stdout
]

{ #category : 'create command' }
T2F2TConversion >> createForProject: projectRootPath t2f2t: t2f2tDir tonel: tonelPackageDir filetree: filetreePackageDir projectName: projectName componentName: componentName packageConvention: packageConvention stdout: stdout [
	| projectRoot t2f2tRoot |
	projectRoot := projectRootPath asFileReference.
	projectRoot exists
		ifFalse: [ 
			^ self
				error:
					'The project directory ' , projectRootPath printString , ' does not exist.'
				to: stdout ].
	t2f2tRoot := projectRoot.

	(projectRoot / tonelPackageDir) ensureCreateDirectory.
	self
		_createProject: projectName
		packageConvention: packageConvention
		root: t2f2tRoot
		t2f2tDir: t2f2tDir
		packageDir: tonelPackageDir
		componentName: componentName
		format: 'tonel'.

	(projectRoot / filetreePackageDir) ensureCreateDirectory.
	self
		_createProject: projectName
		packageConvention: packageConvention
		root: t2f2tRoot
		t2f2tDir: t2f2tDir
		packageDir: filetreePackageDir
		componentName: componentName
		format: 'filetree'
]

{ #category : 'create command' }
T2F2TConversion >> createForProject: projectRootPath t2f2t: t2f2tDir tonel: tonelPackageDir filetree: filePackageDir stdout: stdout [
	^ self
		createForProject: projectRootPath
		t2f2t: t2f2tDir
		tonel: tonelPackageDir
		filetree: filePackageDir
		projectName: 't2f2tMeta'
		componentName: 'Core'
		packageConvention: 'Monticello'
		stdout: stdout
]

{ #category : 'accessing' }
T2F2TConversion >> debug [
	^ debug ifNil: [ false ]
]

{ #category : 'accessing' }
T2F2TConversion >> debug: object [
	debug := object
]

{ #category : 'error handling' }
T2F2TConversion >> error: errorMessage to: stdout [
	self debug
		ifTrue: [ ^ super error: errorMessage ].
	self _message: errorMessage to: stdout
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
