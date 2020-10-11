error handling
error: errorMessage to: stdout
	self debug
		ifTrue: [ ^ super error: errorMessage ].
	self _message: errorMessage to: stdout