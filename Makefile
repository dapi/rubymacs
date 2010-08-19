byte-compile:
	emacs -batch -l init.el -f batch-byte-compile *.el lisp/*.el
	# emacs -Q -L . -batch -f batch-byte-compile *.el

clean:
	rm -f *.elc lisp/*.elc
