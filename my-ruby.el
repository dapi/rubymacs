;;; Ïðîâåðêà ñèíòàêñèñà - flymake
;;; rinari - ruby on rails minor mode
;;; ido
;;; ruby-electric - çàêðûòèå ñêîáîê è ïðî÷àÿ àâòîìàòèçàöèÿ
;;; vc-git
;;; autocomplete



(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)


;;;
;;;
;;; rinari
;;;
;;;

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
     
;; Rinari
;(add-to-list 'load-path "~/.emacs.d/rinari")
;(require 'rinari)
;(setq rinari-tags-file-name "TAGS")

(define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)

;; Rake files are ruby, too, as are gemspecs.
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))

;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")



;;
;;
;; rails-minor-mode - альтернатива Rinari
;;
;;



(add-to-list 'load-path (expand-file-name "~/.emacs.d/rails-minor-mode"))
(require 'rails)
(setq rails-indent-and-complete nil)


;;;
;;;
;;; Flymake syntax check on the fly
;;;
;;;


(eval-after-load 'ruby-mode
  '(progn
     (require 'flymake)

     ;; Invoke ruby with '-c' to get syntax checking
     (defun flymake-ruby-init ()
       (let* ((temp-file (flymake-init-create-temp-buffer-copy
                          'flymake-create-temp-inplace))
              (local-file (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
         (list "ruby" (list "-c" local-file))))

     (push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
     (push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

     (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3)
           flymake-err-line-patterns)

     (add-hook 'ruby-mode-hook
               (lambda ()
                 (when (and buffer-file-name
                            (file-writable-p
                             (file-name-directory buffer-file-name))
                            (file-writable-p buffer-file-name))
                   (local-set-key (kbd "C-c d")
                                  'flymake-display-err-menu-for-current-line)
                   (flymake-mode t))))))

 (add-hook 'find-file-hook 'flymake-find-file-hook)
 ;;;
 ;;;
 ;;; ruby-electric
 ;;;
 ;;;
;; (require 'inf-ruby)
;; (require 'ruby-electric)
;; (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode)))
;; (autoload 'inf-ruby-keys "inf-ruby"
;;   "Set local key defs for inf-ruby in ruby-mode")
;; (add-hook 'ruby-mode-hook
;; 	  '(lambda ()
;; 	     (inf-ruby-keys)
;; 	     ))
;; подключит автоматом rails-minor-mode

		 
;; added linum
;(global-linum-mode t)

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





;; yasnippet
;; (require 'yasnippet)
;; (yas/initialize)
;; (yas/load-directory
;;    "~/.emacs.d/yasnippets-rails/rails-snippets/"
;; 	)
;; rails-minor-mode автоматом включает snippets

   
;; load yas on ruby-mode
;(add-to-list 'yas/extra-mode-hooks
 ;            'ruby-mode-hook)

	
;; (require 'imenu)
;; (add-hook 'ruby-mode-hook '(lambda () 
;; 	(imenu-add-menubar-index)
;; 	))
; rails-minor-mode вставит автоматом

(require 'pabbrev)
(setq pabbrev-idle-timer-verbose nil)

; øòóêà ÷òîáû ðàáîòàë è àâòîêîìïëèò è snippets
(require 'tabkey2)
; нужна для yasnippet и auto-complete

;;
;;
;; git
;;
(require 'vc-git)
(when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))
(require 'git)
