;;;
;;;
;;; Flymake syntax check on the fly
;;;
;;;

;; flymake ruby support

;; (require 'flymake nil t)

;; (defconst flymake-allowed-ruby-file-name-masks
;;   '(("\\.rb\\'"      flymake-ruby-init)
;;     ("\\.rxml\\'"    flymake-ruby-init)
;;     ("\\.builder\\'" flymake-ruby-init)
;;     ("\\.rjs\\'"     flymake-ruby-init))
;;   "Filename extensions that switch on flymake-ruby mode syntax checks.")

;; (defconst flymake-ruby-error-line-pattern-regexp
;;   '("^\\([^:]+\\):\\([0-9]+\\): *\\([\n]+\\)" 1 2 nil 3)
;;   "Regexp matching ruby error messages.")

;; (defun flymake-ruby-init ()
;;   (condition-case er
;;       (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                          'flymake-create-temp-inplace))
;;              (local-file  (file-relative-name
;;                            temp-file
;;                            (file-name-directory buffer-file-name))))
;;         (list rails-ruby-command (list "-c" local-file)))
;;     ('error ())))

;; (defun flymake-ruby-load ()
;;   (when (and (buffer-file-name)
;;              (string-match
;;               (format "\\(%s\\)"
;;                       (string-join
;;                        "\\|"
;;                        (mapcar 'car flymake-allowed-ruby-file-name-masks)))
;;               (buffer-file-name)))
;;     (setq flymake-allowed-file-name-masks
;;           (append flymake-allowed-file-name-masks flymake-allowed-ruby-file-name-masks))
;;     (setq flymake-err-line-patterns
;;           (cons flymake-ruby-error-line-pattern-regexp flymake-err-line-patterns))
;;     (flymake-mode t)
;;     (local-set-key (rails-key "d") 'flymake-display-err-menu-for-current-line)))

;; (when (featurep 'flymake)
;;   (add-hook 'ruby-mode-hook 'flymake-ruby-load))


(eval-after-load 'ruby-mode
  '(progn
     (require 'flymake)

     ;Invoke ruby with '-c' to get syntax checking
     (defun flymake-ruby-init ()
       (let* ((temp-file (flymake-init-create-temp-buffer-copy
                          'flymake-create-temp-inplace))
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

 (add-hook 'find-file-hook 'flymake-find-file-hook)
