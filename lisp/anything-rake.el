
;;
;; rake tasks
;;	
(defvar anything-c-source-rake-task
  '((name . "Rake Task")
    (candidates
     . (lambda ()
         (when (string-match "^rake" anything-pattern)
           (cons '("rake" . "rake")
                 (mapcar (lambda (line)
                           (cons line (car (split-string line " +#"))))
                         (with-current-buffer anything-current-buffer
                           (split-string (shell-command-to-string "rake -T") "\n" t)))))))
    (action ("Compile" . compile)
            ("Compile with command-line edit"
             . (lambda (c) (let ((compile-command (concat c " ")))
                             (call-interactively 'compile)))))
    (requires-pattern . 4)))
	

(provide 'anything-rake)