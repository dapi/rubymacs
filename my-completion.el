;;
;; yasnippet
;;
;;
;; (add-to-list 'load-path
;;              "~/.emacs.d/plugins/yasnippet")
;(require 'yasnippet)
;(yas/initialize) инициализируется где-то в рельсах

(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets/" )

; Тут слишком много всего
; (yas/load-directory "~/.emacs.d/yasnippets-jpablobr" )
(yas/load-directory "~/.emacs.d/yasnippets-rejeep" )


;;
;; Rsense
;;
; http://cx4a.org/software/rsense/

;(setq rsense-home "$RSENSE_HOME")
(setq rsense-home "~/.emacs.d/rsense")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
;; Complete by C-c .
;; (add-hook 'ruby-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-c .") 'rsense-complete)
;;             (local-set-key (kbd "C-c ,") 'ac-complete-rsense)))
(define-key ruby-mode-map (kbd "C-c .") 'rsence-complete)
(define-key ruby-mode-map (kbd "C-c ,") 'ac-complete-rsense)




;;;
;;;
;;; autocomplete
;;;
;;;

(setq load-path (cons "~/.emacs.d/auto-complete/" load-path))

(require 'auto-complete-config)


(ac-config-default)
(add-to-list 'ac-modes 'sass-mode)
(add-to-list 'ac-modes 'yaml-mode)
(add-to-list 'ac-modes 'haml-mode)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/dict")
(setq ac-ignore-case nil)
(setq ac-auto-show-menu t)



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


; default
; (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))

(add-hook 'ruby-mode-hook 
          (lambda () 
            (add-to-list 'ac-sources 'ac-source-yasnippet)
            (add-to-list 'ac-sources 'ac-source-gtags)
            (add-to-list 'ac-sources 'ac-source-rsense-method)
            (add-to-list 'ac-sources 'ac-source-rsense-constant)
          ))

;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-rcodetools)))



;; (add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-rcodetools)))
;; (setq ac-omni-completion-sources '(("\\.\\=" ac-source-rcodetools)))

; сбоит
;(require 'auto-complete-etags)

; было в предыдущей версии
;(add-to-list 'ac-gtags-modes 'ruby-mode)

; устанавливается автоматом
;(global-auto-complete-mode t)
;; (setq ac-auto-start 3)
;; (setq ac-dwim t)


;  'ac-source-words-in-same-mode-buffers - вроде как есть подефолту
; Постоянно сбоит
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-etags)))

;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-files-in-current-dir)))

;(add-hook 'ruby-mode-hook '(lambda () 
	;(pabbrev-mode t)
	;))


; дурацкая штука	
;(require 'predictive)

