Class {
	#name : 'T2F2TConversion',
	#superclass : 'Object',
	#category : 'T2F2T-Conversion'
}

{ #category : 'private' }
T2F2TConversion class >> _projectName [
	^ 'T2F2T-Conversion'
]

{ #category : 'command-line support' }
T2F2TConversion class >> helpText [
	((Rowan projectNamed: self _projectName) repositoryRoot / 'bin'
		/ 't2f2t-help.txt') contents
]
