;(url-retrieve
; "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
; (lambda (s)
;   (end-of-buffer)
;   (eval-print-last-sexp)))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(el-get package browse-kill-ring
               ;; http://www.emacswiki.org/emacs/download/browse-kill-ring%2b.el
               ;; switch-window

               ;; (:name ruby-compilation :type elpa)

	       anything
               ;; anything-config anything-match-plugin
               ;; anything-gtags
               ;; desktop-menu sr-speedbar twittering-mode
               ; ruby-block
               (:name jekyll
                      :type git
                      :url "https://github.com/diasjorge/jekyll.el.git"
                      :features jekyll
                      )

               (:name haml-mode
                      :after (lambda()
                               (setq indent-tabs-mode nil)
                               (define-key haml-mode-map "\C-m" 'newline-and-indent)
                               ))

	       sass-mode
               (:name yasnippet
                      :after (lambda()
                               ;; (add-to-list 'yas/snippet-dirs (concat el-get-dir "yasnippet/snippets"))
                               (yas/load-directory "~/.emacs.d/yasnippets/jpablobr" )
                               (yas/load-directory "~/.emacs.d/yasnippets/rejeep" )
                               (yas/load-directory "~/.emacs.d/yasnippets/custom" )
                              )
                      )

               ;;	       (:name browse-kill-ring%2b
               ;;		      :after (lambda()
               ;;			       (require 'browse-kill-ring+)
               ;;			       )
               ;;		      )

               (:name mode-compile
                      :features mode-compile)

	       (:name rspec-mode
                      :after (lambda()
                               '(add-hook 'ruby-mode-hook
                                          (lambda ()
                                            (when (rspec-buffer-is-spec-p) (rspec-mode))

                                            (local-set-key (kbd "C-c ,v") 'rspec-verify)
                                            (local-set-key (kbd "C-c ,a") 'rspec-verify-all)
                                            (local-set-key (kbd "C-c ,t") 'rspec-toggle-spec-and-target)

                                            )
                                          )
                               )
                      )

               yari


               (:name rvm-el
                      :type http
                      :url "https://github.com/senny/rvm.el/raw/master/rvm.el"
                      :features rvm
                      :after (lambda ()
                               (rvm-use-default)
                               )
                      )

	       (:name tabbar
		      :type http
		      :url "http://www.emacswiki.org/emacs/download/tabbar.el"
		      :features tabbar
		      :after (lambda ()
                               (load "~/.emacs.d/my-tab.el")
                               )

		      )


               ;; Удаляет строку, если нет выделеного региона по M-w/C-w

               (:name whole-line-or-region
                      :features whole-line-or-region
                      :after (lambda ()
                               (whole-line-or-region-mode)
                               )
                      )

               (:name css-mode ; elpa?
                      :after (lambda ()
                               (setq auto-mode-alist (cons '("\\.scss$" . css-mode) auto-mode-alist))
                               (setq css-indent-level 2) ; 3 by default
                               ))
               (:name rhtml-mode
                      :after (lambda ()
                               (setq auto-mode-alist (cons '("\\.html\\.erb" . rhtml-mode) auto-mode-alist))
                               (setq auto-mode-alist (cons '("\\.erb$" . rhtml-mode) auto-mode-alist))
                               (setq auto-mode-alist (cons '("\\.rhtml$" . rhtml-mode) auto-mode-alist))
                               ))
               (:name yaml-mode
                      :after (lambda ()
                               (add-to-list 'auto-mode-alist '("\\.yaml"  . yaml-mode))
                               (add-to-list 'auto-mode-alist '("\\.yml"  . yaml-mode))

                               ))

               (:name js2-mode
                      :after (lambda ()
                               (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
                               (add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

                               (setq js2-basic-offset 2)
                               (setq js2-use-font-lock-faces t)

                               (add-hook 'js2-mode-hook
                                         '(lambda ()
                                            (setq tab-width 2)
                                            ;; (setq js2-basic-offset 2)
                                            ;; (setq js2-use-font-lock-faces t)
                                            )
                                         )
                               ))

               (:name auto-complete
                      :type git
                      :url "http://github.com/m2ym/auto-complete.git"
                      :after (lambda ()
                               ;; делается в post-init
                                (require 'auto-complete)
                                (add-to-list 'ac-dictionary-directories (expand-file-name "dict" pdir))
                                ;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/el-get/auto-complete/dict")
                                (require 'auto-complete-config)
                                (ac-config-default)

                               (add-to-list 'ac-modes 'sass-mode)
                               (add-to-list 'ac-modes 'yaml-mode)
                               (add-to-list 'ac-modes 'ruby-mode)
                                        ; (add-to-list 'ac-modes 'haml-mode)
                               (setq ac-ignore-case nil)
                               (setq ac-auto-show-menu t)

                               (add-hook 'ruby-mode-hook
                                         (lambda ()
                                           (setq ac-sources '(
                                                              ac-source-abbrev
                                                              ac-source-dictionary
                                                              ac-source-words-in-same-mode-buffers
                                                              ac-source-yasnippet
                                                              ;; 'ac-source-files-in-current-dir
                                                              ;; ac-source-gtags
                                                              ;; ac-source-rsense ; В принципе работает только для дополнения методов обычных классов
                                                              ))
                                           ))


                               )
                      )

               (:name magit
                      :features magit
                      :after (lambda ()
                               (global-set-key "\C-cm" 'magit-status)
			       ;; прикольная штука, чтобы видеть какие строки изменились
			       (require 'format-spec)
                               )
                      )
               ;; (:name flymake-ruby
               ;;        :after (lambda()
               ;;                 (require 'flymake-ruby)
               ;;                 (add-hook 'ruby-mode-hook 'flymake-ruby-load)
               ;;                 )
               ;;        )
	       )
      )
(el-get)
                                        ;(el-get 'sync)
;(el-get 'wait)
