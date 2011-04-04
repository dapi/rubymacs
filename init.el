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

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 128 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(anything-header ((t (:inherit header-line :foreground "grey30"))))
 '(border ((t (:background "red"))))
 '(buffer-menu-buffer ((t nil)))
 '(cperl-array-face ((((class color) (background dark)) (:foreground "yellow" :underline t))))
 '(cperl-hash-face ((((class color) (background dark)) (:foreground "yellow" :underline t))))
 '(cursor ((t (:background "red"))))
 '(custom-face-tag ((t (:inherit variable-pitch :height 0.8))))
 '(custom-group-tag ((((class color) (background dark)) (:foreground "light blue"))))
 '(custom-group-tag-1 ((((class color) (background dark)) (:inherit variable-pitch :foreground "pink"))))
 '(custom-variable-tag ((((class color) (background dark)) (:inherit variable-pitch :foreground "light blue" :weight bold :height 0.8))))
 '(erb-delim-face ((t (:inherit erb-face :foreground "cyan1"))))
 '(erb-exec-delim-face ((t (:inherit erb-delim-face))))
 '(erb-face ((t (:background "black"))))
 '(erb-out-delim-face ((t (:inherit erb-face :foreground "darkred"))))
 '(erb-out-face ((t (:inherit erb-face))))
 '(font-lock-comment-face ((((class color) (min-colors 88) (background dark)) (:foreground "chocolate1"))))
 '(header-line ((t (:inherit default :foreground "grey70" :slant oblique))))
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "#202a2a"))))
 '(mode-line ((((class color) (min-colors 88)) (:background "red4" :foreground "gray90"))))
 '(mode-line-highlight ((((class color) (min-colors 88)) (:background "red"))))
 '(mode-line-inactive ((default (:inherit mode-line)) (((class color) (min-colors 88) (background dark)) (:background "grey40" :foreground "black"))))
 '(mouse ((t (:background "white"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) nil)))
 '(mumamo-background-chunk-submode ((t (:background "dark"))))
 '(mumamo-background-chunk-submode1 ((((class color) (min-colors 88) (background dark)) nil)))
 '(mumamo-background-chunk-submode2 ((((class color) (min-colors 88) (background dark)) nil)))
 '(mumamo-background-chunk-submode3 ((((class color) (min-colors 88) (background dark)) nil)))
 '(mumamo-background-chunk-submode4 ((((class color) (min-colors 88) (background dark)) nil)))
 '(region ((((class color) (min-colors 88) (background dark)) (:background "gray40" :foreground "black"))))
 '(show-paren-match ((((class color) (background dark)) (:foreground "white" :weight bold))))
 '(tabbar-button ((t (:inherit tabbar-default :foreground "dark red"))))
 '(tabbar-default ((((class color grayscale) (background dark)) (:inherit variable-pitch :background "gray50" :foreground "grey10" :height 0.8))))
 '(tabbar-selected ((t (:inherit tabbar-default :background "black" :foreground "darkgray" :box (:line-width 3 :color "black")))))
 '(tabbar-separator ((t (:inherit tabbar-default :box (:line-width 2 :color "grey75") :height 0.1))))
 '(tabbar-unselected ((t (:inherit tabbar-default :background "gray50"))))
 '(widget-button ((t (:inherit default :foreground "gray80" :width condensed))))
 '(widget-button-pressed ((((min-colors 88) (class color)) (:inherit widget-button :foreground "red1")))))

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
