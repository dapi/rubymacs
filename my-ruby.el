;; http://github.com/technomancy/emacs-starter-kit/blob/master/starter-kit-ruby.el
;; yasnippet
;; rcodetools (not used)
;; ruby-mode
;; rinari
;; ri (ruby information)
;; ruby-electric
;; imenu
;; idle-highlighting TURNED OFF
;; git
;; gtag ?
;; hideshow ?

;;
;;
;; rcodetools
;;
;;
;(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
;(require 'rcodetools)


;;
;;
;; ruby-mode
;;
;;
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")


     
;;;
;;;
;;; rinari
;;;
;;;


(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)
(setq rinari-tags-file-name "TAGS")
(define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
(define-key ruby-mode-map (kbd "C-c l") "lambda")

;;
;;
;; ri
;;
;;
;(autoload 'ri "/home/danil/.emacs.d/ri-emacs/ri-ruby.el" nil t)
(load-file "/home/danil/.emacs.d/ri-emacs/ri-ruby.el")
(setq ri-ruby-script "/home/danil/.emacs.d/ri-emacs/ri-emacs.rb")




;;
;;  You may want to bind the ri command to a key.
;;  For example to bind it to F1 in ruby-mode:
;;  Method/class completion is also available.
;;
 (add-hook 'ruby-mode-hook (lambda ()
                             (local-set-key [(f1)] 'ri)
                             (local-set-key [(control f1)] 'ri-ruby-complete-symbol)
                             (local-set-key [(control shift f1)] 'ri-ruby-show-args)
                             ))




;;;
;;;
;;; ruby-electric
;;;
;;;

(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode)))


; (require 'inf-ruby)
;; rinari подключает его автоматом

;;
;;
;; imenu
;;
;;

(require 'imenu)
(add-hook 'ruby-mode-hook '(lambda () 
                             (imenu-add-menubar-index)
                             ))

;; (require 'pabbrev)
;; (setq pabbrev-idle-timer-verbose nil)

; (require 'tabkey2)
; нужна для yasnippet и auto-complete, но работает и без нее

;;
;;
;; idle-highlighting
;;
;;
;; (require 'idle-highlight)

;; (defun my-coding-hook ()
;;   (make-local-variable 'column-number-mode)
;;   (column-number-mode t)
;;   (if window-system (hl-line-mode t))
;;   (idle-highlight))

;; (add-hook 'emacs-lisp-mode-hook 'my-coding-hook)
;; (add-hook 'ruby-mode-hook 'my-coding-hook)
;; (add-hook 'js2-mode-hook 'my-coding-hook)

