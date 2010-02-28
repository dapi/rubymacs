;(require 'site-gentoo)
; http://grapevine.net.au/~striggs/elisp/workspaces.el
; http://www.emacswiki.org/cgi-bin/wiki/NumberedWindows
; http://www.gnu.org/software/emacs/emacs-lisp-intro/html_node/etags.html
; http://www.emacswiki.org/emacs/DiredMode
; Some powerful tips http://www.xsteve.at/prg/emacs/power-user-tips.html

(setq load-path (cons "~/.emacs.d/lisp" load-path))

;; auto-install

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(setq load-path (cons "~/.emacs.d/auto-install" load-path))
;(auto-install-update-emacswiki-package-name t)


; Выключаем scrollbar и полосу прокрутки
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode t))


;(server-start)

; gpicker

; какой-то рекурсивный поиск файлов
;; (require 'find-recursive)

(load "~/.emacs.d/my-session.el")
(load "~/.emacs.d/my-scroll.el")
(load "~/.emacs.d/my-backup.el")
(load "~/.emacs.d/my-buffers.el")
(load "~/.emacs.d/my-scroll.el")
(load "~/.emacs.d/my-perl.el")
(load "~/.emacs.d/my-completion.el")
(load "~/.emacs.d/my-html.el")
;(load "~/.emacs.d/my-ruby.el")
(load "~/.emacs.d/my-rails.el")
(load "~/.emacs.d/my-anything.el")
; (load "~/.emacs.d/my-org.el")
(load "~/.emacs.d/my-tab.el")


(global-font-lock-mode 1)                     ; for all buffers
(transient-mark-mode 1)


;(setq display-time-interval 1)
;(setq display-time-format "%H:%M:%S")
;(display-time-mode)
(setq woman-show-log nil)
(setq woman-ignore t)

(global-set-key "\C-h" 'delete-backward-char)
(global-set-key [(meta backspace)] 'advertised-undo)
(global-set-key [f4] 'replace-string)
(global-set-key [(meta f3)] 'find-file-other-frame)

(global-set-key [(control r)] 'replace-string)
;(global-set-key [(control f8)] 'kill-this-buffer)
(global-set-key [(meta q)] 'comment-or-uncomment-region)
(global-set-key [?\C-,] 'previous-buffer)
(global-set-key [?\C-.] 'next-buffer)


(fset 'yes-or-no-p 'y-or-n-p) ;;не заставляйте меня печать yes целиком

(setq-default indent-tabs-mode nil) ; пробелы вместо табов
(setq
	default-tab-width 4 ;;подифолту
	tab-width 2
	delete-key-deletes-forward 't		
	kill-whole-line 't)
	
	
(auto-compression-mode 1) ; automatically uncompress files when visiting
;(setq sort-fold-case t) ; sorting functions should ignore case


; Ничего не работает, смотри http://www.enigmacurry.com/2009/01/14/extending-emacs-with-advice/
; и http://www.emacswiki.org/emacs/EasyPG
; Не спрашивать графически пароль11
(setenv "GPG_AGENT_INFO" nil)
; сохранять пароль GPG
(setq epa-file-cache-passphrase-for-symmetric-encryption t)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(current-language-environment "UTF-8")
 '(display-time-mode t)
 '(ecb-layout-window-sizes (quote (("left8" (0.2777777777777778 . 0.3269230769230769) (0.2777777777777778 . 0.21153846153846154) (0.2777777777777778 . 0.2692307692307692) (0.2777777777777778 . 0.17307692307692307)))))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("/home/danil/projects/github/dapi/" "/") ("/home/danil/projects/github/dapi/orionet.ru" "orionet.ru"))))
 '(ecb-vc-enable-support nil)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(icicle-command-abbrev-alist nil)
 '(icicle-reminder-prompt-flag 6)
 '(inhibit-startup-screen t)
 '(line-number-mode t)
 '(org-agenda-files (quote ("~/Dropbox/orgfiles/tasks.org")))
 '(org-cycle-include-plain-lists t)
 '(org-modules (quote (org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-mouse org-annotate-file org-toc)))
 '(ruby-electric-newline-before-closing-bracket t)
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(truncate-lines t))

; '(default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 132 :width normal :family "misc-fixed"))))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal))))
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
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "#202a2a"))))
 '(mode-line ((((class color) (min-colors 88)) (:background "red4" :foreground "gray90"))))
 '(mode-line-highlight ((((class color) (min-colors 88)) (:background "red"))))
 '(mode-line-inactive ((default (:inherit mode-line)) (((class color) (min-colors 88) (background dark)) (:background "grey40" :foreground "black"))))
 '(mouse ((t (:background "white"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) nil)))
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
