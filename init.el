; http://stackoverflow.com/questions/92971/how-do-i-set-the-size-of-emacs-window
(setq default-frame-alist
      '((top . 0) (left . 0)
        (width . 112) (height . 45)
        ))
(setq initial-frame-alist
      '((top . 0) (left . 0)
        (width . 112) (height . 45)
        ))


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/code/chebytoday/doc/todo.org" "~/Dropbox/orgfiles/tasks.org")))
 '(org-cycle-include-plain-lists t)
 '(org-modules (quote (org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-mouse org-annotate-file org-toc)))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(truncate-lines t))

(require 'color-theme)
(color-theme-initialize)

(load "~/.emacs.d/color-themes/color-theme-dapi.el")
(load "~/.emacs.d/color-themes/color-theme-tangotango.el")
(load "~/.emacs.d/color-themes/color-theme-ingle-fingers.el")
(color-theme-dapi)

(load "~/.emacs.d/my-scroll.el")
(load "~/.emacs.d/my-backup.el")
(load "~/.emacs.d/my-desktop.el")

(load "~/.emacs.d/my-buffers.el")
(load "~/.emacs.d/my-ibuffer.el")
(load "~/.emacs.d/my-iswitch.el")

(load "~/.emacs.d/my-el-get.el")

(load "~/.emacs.d/my-perl.el")
(load "~/.emacs.d/my-ruby.el")
; (load "~/.emacs.d/my-tags.el")

(load "~/.emacs.d/my-anything.el")


;;
;;
; SCSS
; https://github.com/antonj/scss-mode

;  (setq exec-path (cons (expand-file-name "~/.gem/ruby/1.8/bin") exec-path))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/scss-mode"))
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq scss-compile-at-save nil)