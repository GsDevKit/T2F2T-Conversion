private
_message: message to: stdout
	stdout
		lf;
		nextPutAll: message;
		nextPutAll: '. See help (t2t2t.sh --help) for details';
		lf