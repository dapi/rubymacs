
(add-to-list 'load-path (expand-file-name "~/.emacs.d/rails-minor-mode"))
(require 'rails)
(setq rails-indent-and-complete nil)
(setq rails-features:list
  '(
    ;rails-snippets-feature
    rails-speedbar-feature
    rails-rspec-feature)
  )


;; yasnippet
(require 'yasnippet)
(yas/initialize)
(yas/load-directory
    "~/.emacs.d/yasnippets-rails/rails-snippets/"
 	)



;; rcodetools
(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
(require 'rcodetools)



;;
;;
;; gtags
;;
;;

(autoload 'gtags-mode "gtags" "" t)
 
(add-hook 'ruby-mode-hook (lambda () 
      (gtags-mode 1)
      (setq gtags-symbol-regexp "[A-Za-z_:][A-Za-z0-9_#.:?]*")
      (define-key ruby-mode-map "\e." 'gtags-find-tag)
      (define-key ruby-mode-map "\e," 'gtags-find-with-grep)
      (define-key ruby-mode-map "\e:" 'gtags-find-symbol)
      (define-key ruby-mode-map "\e_" 'gtags-find-rtag)))


; Пускать gtags -v чтобы создать GTAG-и
; Пускать global -u -v чтобы обновить репо




;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)


     
;;;
;;;
;;; rinari
;;;
;;;


(add-to-list 'load-path "~/.emacs.d/rinari")
;(require 'rinari)
(setq rinari-tags-file-name "TAGS")

; вроде emacs-rails делает это автоматом
;(define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)




 ;;
 ;;
 ;; ri
 ;;
 ;;
(load-file "/home/danil/.emacs.d/ri-emacs/ri-ruby.el")
(setq ri-ruby-script "/home/danil/.emacs.d/ri-emacs/ri-emacs.rb")
;;
;;  You may want to bind the ri command to a key.
;;  For example to bind it to F1 in ruby-mode:
;;  Method/class completion is also available.
;;
(add-hook 'ruby-mode-hook (lambda ()
;                               (local-set-key 'f1 'ri)
                               (local-set-key "\M-\C-i" 'ri-ruby-complete-symbol)
                               (local-set-key "\M-\C-I" 'ri-ruby-show-args)
 ))




;;
;;
;; git-blame
;;
;;

(require 'format-spec)
;; прикольная штука, чтобы видеть какие строки зименились
(autoload 'git-blame-mode "git-blame"
  "Minor mode for incremental blame for Git." t)

