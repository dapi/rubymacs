;;
;;
;; yasnippet
;;
;;
;; (add-to-list 'load-path
;;              "~/.emacs.d/plugins/yasnippet")

;(require 'yasnippet)
;(yas/initialize)


(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets/" )


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

;(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
;(require 'rcodetools)


;;;
;;;
;;; autocomplete
;;;
;;;


(setq load-path (cons "~/.emacs.d/auto-complete/" load-path))

(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/dict")
(setq ac-ignore-case nil)
(setq ac-auto-show-menu t)
; сбоит
;(require 'auto-complete-etags)

; было в предыдущей версии
;(add-to-list 'ac-gtags-modes 'ruby-mode)

; устанавливается автоматом
;(global-auto-complete-mode t)
;; (setq ac-auto-start 3)
;; (setq ac-dwim t)


(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-gtags)))

;  'ac-source-words-in-same-mode-buffers - вроде как есть подефолту
; Постоянно сбоит
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-etags)))
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-yasnippet)))
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-files-in-current-dir)))

;(add-hook 'ruby-mode-hook '(lambda () 
	;(pabbrev-mode t)
	;))





; дурацкая штука	
;(require 'predictive)

