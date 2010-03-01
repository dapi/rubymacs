
;; no fucking rails-minor-mode, just rinari
 (add-to-list 'load-path (expand-file-name "~/.emacs.d/rails-minor-mode"))
(require 'rails)

;; (setq rails-indent-and-complete nil)
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


;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)

(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))



;;
;;
;; gtags
;;
;;

(autoload 'gtags-mode "gtags" "" t)

      ;;     (topdir (read-directory-name  
      ;;               "gtags: top of source tree:" (rinari-root))))
      ;; (cd topdir)

(defun djcb-gtags-create-or-update ()
  "create or update the gnu global tag file"
  (interactive)
  (if (not (= 0 (call-process "global" nil nil nil " -p"))) ; tagfile doesn't exist?
    (let ((olddir default-directory)
          (topdir (read-directory-name  
                    "gtags: top of source tree:" default-directory)))
      (cd topdir)
      (shell-command "gtags && echo 'created tagfile'")
      (cd olddir)) ; restore   
    ;;  tagfile already exists; update it
    (shell-command "global -u && echo 'updated tagfile'")))
 
(add-hook 'ruby-mode-hook (lambda () 
      (gtags-mode 1)
;      (rinari-gtags-create-or-update)
      (setq gtags-symbol-regexp "[A-Za-z_:][A-Za-z0-9_#.:?]*")
;      (define-key ruby-mode-map "\e." 'gtags-find-tag)
;      (define-key ruby-mode-map "\e," 'gtags-find-with-grep)
;      (define-key ruby-mode-map "\e:" 'gtags-find-symbol)
;      (define-key ruby-mode-map "\e_" 'gtags-find-rtag)
))


; Пускать gtags -v чтобы создать GTAG-и
; Пускать global -u -v чтобы обновить

(add-hook 'gtags-mode-hook 
  (lambda()
    (djcb-gtags-create-or-update)
    )) 






;; Interactively Do Things (highly recommended, but not strictly required)
;(require 'ido)
;(ido-mode t)


     
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
;(load-file "/home/danil/.emacs.d/ri-emacs/ri-ruby.el")
(autoload 'ri "/home/danil/.emacs.d/ri-emacs/ri-ruby.el" nil t)
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




;;
;;
;; git-blame
;;
;;

(require 'format-spec)
;; прикольная штука, чтобы видеть какие строки зименились

(require 'git)
(autoload 'git-blame-mode "git-blame"
  "Minor mode for incremental blame for Git." t)

