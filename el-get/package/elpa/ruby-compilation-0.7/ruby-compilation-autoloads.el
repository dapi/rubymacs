;;; ruby-compilation-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (ruby-compilation-this-buffer ruby-compilation-cap
;;;;;;  ruby-compilation-rake ruby-compilation-run pcomplete/cap
;;;;;;  pcomplete/rake) "ruby-compilation" "ruby-compilation.el"
;;;;;;  (19979 33381))
;;; Generated autoloads from ruby-compilation.el

(autoload 'pcomplete/rake "ruby-compilation" "\
Not documented

\(fn)" nil nil)

(autoload 'pcomplete/cap "ruby-compilation" "\
Not documented

\(fn)" nil nil)

(autoload 'ruby-compilation-run "ruby-compilation" "\
Run a ruby process dumping output to a ruby compilation buffer.

\(fn CMD)" t nil)

(autoload 'ruby-compilation-rake "ruby-compilation" "\
Run a rake process dumping output to a ruby compilation buffer.

\(fn &optional EDIT TASK ENV-VARS)" t nil)

(autoload 'ruby-compilation-cap "ruby-compilation" "\
Run a capistrano process dumping output to a ruby compilation buffer.

\(fn &optional EDIT TASK ENV-VARS)" t nil)

(autoload 'ruby-compilation-this-buffer "ruby-compilation" "\
Run the current buffer through Ruby compilation.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("ruby-compilation-pkg.el") (19979 33381
;;;;;;  444317))

;;;***

(provide 'ruby-compilation-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ruby-compilation-autoloads.el ends here
