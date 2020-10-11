filetree/tonel commands
convertTo: targetFormat packagesUsing: t2f2tPath stdout: stdout
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