 ;;;
  ;;;
  ;;; autocomplete
  ;;;
  ;;;
;(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
;(require 'rcodetools)

(setq load-path (cons "~/.emacs.d/auto-complete/" load-path))

(require 'auto-complete)
(require 'auto-complete-config)

(add-to-list 'ac-gtags-modes 'ruby-mode)


(global-auto-complete-mode t)
(setq ac-auto-start 1) ; 
(setq ac-dwim t)
;(setq-default ac-sources '(ac-source-gtags
;							ac-source-imenu))
;(setq-default ac-sources '(ac-source-words-in-same-mode-buffers)
;			)
;(add-hook 'ruby-mode-hook
 ;         (lambda ()
  ;          (setq ac-omni-completion-sources '(("\\.\\=" ac-source-rcodetools)))))
			   
;(set-default 'ac-sources '(
			   ;ac-source-yasnippet 
			   ;ac-source-gtags
			   ;ac-source-rcodetools
;			   ac-source-abbrev 
			   ;ac-source-words-in-buffer
			   ; ac-source-words-in-all-buffer
			   ;ac-source-imenu
			   ;ac-source-symbols
			   ;ac-source-files-in-current-dir
			   ;ac-source-semantic    
                                        ;this source need file `auto-complete-semantic.el'   
;			   ))

(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-gtags)))
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-yasnippet)))
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-files-in-current-dir)))

;(add-hook 'ruby-mode-hook '(lambda () 
	;(pabbrev-mode t)
	;))

; дурацкая штука	
;(require 'predictive)




;;
;;
;; auto-complete
;;
;;


;(add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))
;(global-auto-complete-mode t)
;(setq ac-sources (append (list 'ac-source-filename) ac-sources))
;(setq ac-sources (append (list 'ac-source-yasnippet) ac-sources))
;(setq ac-sources (append (list 'ac-source-gtags) ac-sources))
;(setq-default ac-sources 
;              'ac-source-words-in-same-mode-buffers
;	      )
;              '(ac-source-yasnippet)
;              '(ac-source-filename)
;              '(ac-source-imenu))

;(ac-rcodetools-initialize) ;; инициализация для Ruby

;; (add-hook 'auto-complete-mode-hook (lambda () (add-to-list 
;;                                                 'ac-sources 
;;                                                 )))

;;                                                'ac-source-filename

;;                                                'ac-source-words-in-buffer
;;                                                'ac-source-words-in-all-buffer
;;                                                'ac-source-imenu
;;                                                )))

; (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
;