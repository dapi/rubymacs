;;
;; rake tasks
;;	

; http://www.emacswiki.org/emacs/anything-rcodetools.el

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


; не работает
;(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
;(setq load-path (cons "/var/lib/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
;(require 'anything-rcodetools)
;; ;;(setq rct-get-all-methods-command "PAGER=cat fri -l")
;; (setq rct-get-all-methods-command "fri -l")
;; ;;       ;; See docs
;; (define-key anything-map "\C-z" 'anything-execute-persistent-action)

