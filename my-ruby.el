;; yasnippet
;; rcodetools (not used)
;; ruby-mode
;; rinari
;; ri (ruby information)
;; ruby-electric
;; imenu
;; git
;; gtag ?
;; hideshow ?

;;
;;
;; yasnippet
;;
;;
(require 'yasnippet)
(yas/initialize)
(yas/load-directory
    "~/.emacs.d/yasnippets-rails/rails-snippets/"
 	)

;;
;;
;; rcodetools
;;
;;
(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
;(require 'rcodetools)


;;
;;
;; ruby-mode
;;
;;
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)

(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
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
;; git
;;
;;
(require 'vc-git)
(when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))
(require 'git)
(autoload 'git-blame-mode "git-blame"
  "Minor mode for incremental blame for Git." t)
(require 'format-spec)
;; прикольная штука, чтобы видеть какие строки зименились

