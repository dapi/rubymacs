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
(require 'auto-complete-etags)

(add-to-list 'ac-gtags-modes 'ruby-mode)


(global-auto-complete-mode t)
(setq ac-auto-start 1) ; 
(setq ac-dwim t)

;(define-key ac-completing-map "\r" 'ac-complete)
(define-key ac-completing-map "\M-/" 'ac-stop)
;(define-key ac-completing-map "\t" 'ac-complete)



(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-gtags)))

; Постоянно сбоит
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-etags)))

(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-words-in-same-mode-buffers)))
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-yasnippet)))
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-files-in-current-dir)))

;(add-hook 'ruby-mode-hook '(lambda () 
	;(pabbrev-mode t)
	;))

; дурацкая штука	
;(require 'predictive)

