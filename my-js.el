;(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
;; (add-hook 'js2-mode-hook 'my-coding-hook)

; JS2
; in Emacs, M-x byte-compile-file RE js2.el RE
; http://code.google.com/p/js2-mode/
;(autoload 'js2-mode "js2-mode" nil t)
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
;; (add-to-list 'auto-mode-alist '("\\.js.erb$" . js2-mode))

;(setq c-basic-offset 2)
 
(setq js2-basic-offset 2)
(setq js2-use-font-lock-faces t)

(add-hook 'js2-mode-hook
          '(lambda ()
             (setq tab-width 2)
             (setq js2-basic-offset 2)
             (setq js2-use-font-lock-faces t)

             )
          )
(add-hook 'js-mode-hook
          '(lambda ()
             (setq tab-width 2)
             )
          )



