;;; perl-mode
;
;
;

(autoload 'cperl-mode "cperl-mode" nil t)
;(require 'cperl-mode)

(defalias 'perl-mode 'cperl-mode)
(setq cperl-auto-newline t)
(setq cperl-highlight-variables-indiscriminately t)
(setq cperl-font-lock t) 	;; to turn it on
(setq cperl-hairy t) ;; Turns on most of the CPerlMode options
(setq cperl-invalid-face nil) 
(setq cperl-electric-keywords t)
(add-hook 'cperl-mode-hook 'imenu-add-menubar-index)
(add-hook 'cperl-mode-hook
          '(lambda ()
             (abbrev-mode t)
             (auto-fill-mode t)
             (setq tab-width 2)
             (local-set-key [return] 'reindent-then-newline-and-indent)
             (global-set-key [C-x C-f] 'find-file)
             (cperl-define-key [(meta q)] 'cperl-comment-region)
             (cperl-define-key [(meta Q)] 'cperl-uncomment-region)
             )
          )


