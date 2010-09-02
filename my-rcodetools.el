;; (setq load-path (cons "/var/lib/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))

;; ; не пашет из-за fastri, а fastri не пашет из-за нового rdoc для нового ruby
;; (require 'rcodetools)
;; (require 'anything-rcodetools)

;; (setq rct-get-all-methods-command "PAGER=cat fri -l")
;; ;;       ;; See docs
;; (define-key anything-map "\C-z" 'anything-execute-persistent-action)

(defvar ac-source-rcodetools
  '((init . (lambda ()
              (condition-case x
                  (save-excursion
                    (rct-exec-and-eval rct-complete-command-name "--completion-emacs-icicles"))
                (error) (setq rct-method-completion-table nil))))
    (candidates . (lambda ()
                    (all-completions
                     ac-prefix
                     (mapcar
                      (lambda (completion)
                        (replace-regexp-in-string "\t.*$" "" (car completion)))
                      rct-method-completion-table))))))


;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-rcodetools)))



;; (add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-rcodetools)))
;; (setq ac-omni-completion-sources '(("\\.\\=" ac-source-rcodetools)))
