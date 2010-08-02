;;
;;
;; yasnippet
;;
;;
;; (add-to-list 'load-path
;;              "~/.emacs.d/plugins/yasnippet")

;; (require 'yasnippet)
;; (yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets/" )
;; Перешел на yasnippet-bundle

;; (defvar anything-c-source-define-yasnippet-on-region
;;   '((name . "Create new YaSnippet on region")
;;     (dummy)
;;     (action . (lambda (c)
;;                 (with-stub
;;                   (let* ((mode-name (symbol-name anything-c-yas-cur-major-mode))
;;                          (root-dir (expand-file-name
;;                                     (if (listp yas/root-directory)
;;                                         (car yas/root-directory)
;;                                       yas/root-directory)))
;;                          (default-snippet-dir (anything-c-yas-find-recursively mode-name root-dir 'dir))
;;                          (filename (concat default-snippet-dir "/" anything-pattern)))
;;                     (stub read-file-name => filename)
;;                     (anything-c-yas-create-new-snippet
;;                      (with-current-buffer anything-current-buffer
;;                        (if mark-active (buffer-substring-no-properties (region-beginning) (region-end)) "")))))))))



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
(setq ac-auto-start 3)
(setq ac-dwim t)

;(define-key ac-completing-map "\r" 'ac-expand)
;(define-key ac-completing-map "\r" 'ac-complete)
(define-key ac-completing-map "\M-/" 'ac-stop)
;(define-key ac-completing-map "\t" 'ac-complete)
;(define-key map "\r" 'ac-complete)
;;  (define-key map "\t" 'ac-expand)
;;  (define-key map "\r" 'ac-complete)
;;  (define-key map (kbd "M-TAB") 'auto-complete)
;;  (define-key map "\C-s" 'ac-isearch)
;;  (define-key map "\M-n" 'ac-next)
;;  (define-key map "\M-r" 'ac-previous)
;;  (define-key map [down] 'ac-next)
;;  (define-key map [up] 'ac-previous)
;;  (define-key map [C-down] 'ac-quick-help-scroll-down)
;;  (define-key map [C-up] 'ac-quick-help-scroll-up)
;;  (define-key map "\C-\M-n" 'ac-quick-help-scroll-down)
;;  (define-key map "\C-\M-p" 'ac-quick-help-scroll-up)
;;      (define-key map (read-kbd-macro (format "M-%s" (1+ i))) symbol)))
;;  (define-key ac-mode-map (read-kbd-macro ac-trigger-key) nil))
;;  (define-key ac-mode-map (read-kbd-macro key) 'ac-trigger-key-command)))



(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-gtags)))

; Постоянно сбоит
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-etags)))

(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-words-in-same-mode-buffers)))
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-yasnippet)))
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-files-in-current-dir)))

;(add-hook 'ruby-mode-hook '(lambda () 
	;(pabbrev-mode t)
	;))

; дурацкая штука	
;(require 'predictive)

