;;;
;;;
;;; Flymake syntax check on the fly
;;;
;;;

;; Feature request: have flymake create its temp files in the system temp file directory instead of in the same directory as the file. When using it with Ruby on Rails and autotest, autotest sees the temp file and tries to do something with it and dies, forcing me to restart it, thus killing the magic of autotest. Putting flymake’s temp files elsewhere seems like the easiest way to dodge this.
;;
;; I second the above request. I know there are workarounds for autotest, but it seems like we don’t want to find work arounds for every new web framework, we want to get flymake working in a way that won’t conflict with any other tools.
;;
;; It is easy to patch your autotest to ignore flymake files. I have submitted a patch which hopefully will be included in future releases. For more info see: Emacs, flymake and autotest: the fix
;;
;; Here is a suggestion for a solution (100% untested). Replace flymake-create-temp-inplace above with

(defun flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking FILE-NAME.
This is a replacement for `flymake-create-temp-inplace'. The
difference is that it gives a file name in
`temporary-file-directory' instead of the same directory as
FILE-NAME.

For the use of PREFIX see that function.

Note that not making the temporary file in another directory
\(like here) will not if the file you are checking depends on
relative paths to other files \(for the type of checks flymake
makes)."
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))


;; Not provided by flymake itself, curiously
; Другая альтернатива flymake-create-temp-inplace
(defun flymake-create-temp-in-system-tempdir (filename prefix)
  (make-temp-file (or prefix "flymake-ruby")))

(require 'flymake)

;; I don't like the default colors :)
(set-face-background 'flymake-errline "red4 white")
(set-face-background 'flymake-warnline "dark slate blue")


(defvar flymake-ruby-err-line-patterns '(("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3)))
(defvar flymake-ruby-allowed-file-name-masks '((".+\\.\\(rb\\|rake\\)$" flymake-ruby-init)
                                               ("Rakefile$" flymake-ruby-init)))

;; (defun flymake-ruby-load ()
;;   (interactive)
;;   (set (make-local-variable 'flymake-allowed-file-name-masks) flymake-ruby-allowed-file-name-masks)
;;   (set (make-local-variable 'flymake-err-line-patterns) flymake-ruby-err-line-patterns)
;;   (flymake-mode t))

(eval-after-load 'ruby-mode
  '(progn
     (require 'flymake)

     ;Invoke ruby with '-c' to get syntax checking
     (defun flymake-ruby-init ()
       (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                            'flymake-create-temp-intemp))
              (local-file (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
         (list "ruby" (list "-c" local-file))))

     (push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
     (push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

     (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3)
           flymake-err-line-patterns)

     (add-hook 'ruby-mode-hook
               (lambda ()
                 (when (and buffer-file-name
                            (file-writable-p
                             (file-name-directory buffer-file-name))
                            (file-writable-p buffer-file-name))
                   (local-set-key (kbd "C-c d")
                                  'flymake-display-err-menu-for-current-line)
                   (flymake-mode t))))))

; Start syntax check on file open
(add-hook 'find-file-hook 'flymake-find-file-hook)
