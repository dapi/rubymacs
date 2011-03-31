;(url-retrieve
; "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
; (lambda (s)
;   (end-of-buffer)
;   (eval-print-last-sexp)))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(el-get package

               browse-kill-ring switch-window

               ;; (:name ruby-compilation :type elpa)

               anything anything-config anything-match-plugin anything-gtags
               desktop-menu twittering-mode

               ruby-block

               (:name haml-mode
                      :after (lambda()
                               (setq indent-tabs-mode nil)
                               (define-key haml-mode-map "\C-m" 'newline-and-indent)
                              ))

	       sass-mode
					; sr-speedbar

              (:name browse-kill-ring%2b
                                        ;		      :after (lambda()
                                        ;			       (require 'browse-kill-ring+)
                                        ;			       )
                     )

               (:name yasnippet
                      :after (lambda()
                               (require 'yasnippet)
                               (yas/initialize) ; инициализируется где-то в рельсах
                               (yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets/")
                               (yas/load-directory "~/.emacs.d/yasnippets-rspec/rspec-snippets/") ;(load-library "~/.emacs.d/yasnippets-rspec/setup.el")
                               (yas/load-directory "~/.emacs.d/yasnippets-rspec/rspec-snippets/text-mode/" )
                               (yas/load-directory "~/.emacs.d/yasnippets-rejeep" )
                                        ; Тут слишком много всего
                                        ; (yas/load-directory "~/.emacs.d/yasnippets-jpablobr" )
                               )
                      )

	       (:name rspec-mode
                      :after (lambda()
                               (require 'rspec-mode)
                               (add-hook 'rspec-mode-hook
                                         '(lambda ()
                                            (setq yas/mode-symbol 'rspec-mode)))
                               )
                      )
               (:name rvm-el
                      :after (lambda ()
                               (rvm-use-default)
                              ))

               (:name tabbar
		      :after (lambda () (load "~/.emacs.d/my-tab.el"))
                      )

                                        ; Удаляет строку, если нет выделеного региона по M-w/C-w

               (:name whole-line-or-region
                      :after (lambda ()
                               (require 'whole-line-or-region)
                               (whole-line-or-region-mode)
                               )
                      )

               (:name css-mode
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
                                           (setq js2-basic-offset 2)
                                           (setq js2-use-font-lock-faces t)

                                           )
                                        )
                              ))

               (:name auto-complete
                      :after (lambda ()

                               (require 'auto-complete-config)
                               (ac-config-default)

                               (add-to-list 'ac-modes 'sass-mode)
                               (add-to-list 'ac-modes 'yaml-mode)
                                        ; (add-to-list 'ac-modes 'haml-mode)

                               (add-to-list 'ac-dictionary-directories "~/.emacs.d/el-get/auto-complete/dict")
                               (setq ac-ignore-case nil)
                               (setq ac-auto-show-menu t)

                               (add-hook 'ruby-mode-hook
                                         (lambda ()
                                           (setq ac-sources '(
                                                              ac-source-abbrev
                                                              ac-source-dictionary
                                                              ac-source-words-in-same-mode-buffers
                                                              ac-source-yasnippet
                                        ; 'ac-source-files-in-current-dir
                                                              ac-source-gtags
                                                              ac-source-rsense ; В принципе работает только для дополнения методов обычных классов
                                                              ))
                                           ))


                              ))

               (:name magit
                      :after (lambda ()
                               (global-set-key "\C-cm" 'magit-status)
                               ))
	       ))

(el-get)
;(el-get 'wait)
;(el-get)
