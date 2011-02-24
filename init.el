;(require 'site-gentoo)
; http://grapevine.net.au/~striggs/elisp/workspaces.el
; http://www.emacswiki.org/cgi-bin/wiki/NumberedWindows
; http://www.gnu.org/software/emacs/emacs-lisp-intro/html_node/etags.html
; http://www.emacswiki.org/emacs/DiredMode
; Some powerful tips http://www.xsteve.at/prg/emacs/power-user-tips.html

; ubuntu
; http://stackoverflow.com/questions/189291/emacs-ubuntu-initialization
;(load-file "/usr/share/emacs/site-lisp/debian-startup.el")
;(debian-startup 'emacs23)

; byte compile files
; find .emacs.d -name "*.el" | awk '{print "(byte-compile-file \"" $1 "\")";}' > runme.el
; emacs -batch -l runme.el -kill 
; emacs -batch -f batch-byte-compile files...

; /home/danil/bin/myemacs
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
 '(ecb-layout-window-sizes (quote (("left8" (0.2777777777777778 . 0.3269230769230769) (0.2777777777777778 . 0.21153846153846154) (0.2777777777777778 . 0.2692307692307692) (0.2777777777777778 . 0.17307692307692307)))))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("/home/danil/projects/github/dapi/" "/") ("/home/danil/projects/github/dapi/orionet.ru" "orionet.ru"))))
 '(ecb-vc-enable-support nil)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/code/chebytoday/doc/todo.org" "~/Dropbox/orgfiles/tasks.org")))
 '(org-cycle-include-plain-lists t)
 '(org-modules (quote (org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-mouse org-annotate-file org-toc)))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(truncate-lines t))

; '(default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 132 :width normal :family "misc-fixed"))))

;; (setq initial-frame-alist (append '((width . 263) (height . 112) (top . -5) (left . 5) (font . "4.System VIO")) initial-frame-alist))
;; (setq default-frame-alist (append '((width . 263) (height . 112) (top . -5) (left . 5) (font . "4.System VIO")) default-frame-alist))

;(setq initial-frame-alist (append '((width . 110) (height . 44) (top . -5) (left . 5))
;(setq default-frame-alist (append '((width . 110) (height . 44) (top . -5) (left . 5))



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


(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)



(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq load-path (cons "~/.emacs.d/elpa" load-path))
;; (setq load-path (cons "~/.emacs.d/color-theme" load-path))
;; (require 'color-theme)
;(require 'byte-code-cache) неработает с elpa или с package.el, не загружает yasnippet


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(when (load (expand-file-name "~/.emacs.d/lisp/package.el"))
    (package-initialize))
;(load "~/.emacs.d/starter-kit-elpa.el")
;; package-list-packages


;; (setq load-path (cons "/usr/share/emacs/site-lisp/" load-path))
;; (setq load-path (cons "/usr/share/emacs/site-lisp/emacs-goodies-el" load-path))



;; auto-install
;; для anything, в elpa его почемуто нет
;; (require 'auto-install)
;; (setq auto-install-directory "~/.emacs.d/auto-install/")
(setq load-path (cons "~/.emacs.d/auto-install" load-path))
; (auto-install-update-emacswiki-package-name t)

; Выключаем scrollbar и полосу прокрутки
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'fringe-mode) (fringe-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))


; twitter
(setq load-path (cons "~/.emacs.d/twittering-mode" load-path))
(require 'twittering-mode)
; http://www.emacswiki.org/emacs/TwitteringMode


;(server-start)

; gpicker

; какой-то рекурсивный поиск файлов
;; (require 'find-recursive)

(load "~/.emacs.d/my-desktop.el")
(load "~/.emacs.d/my-scroll.el")
(load "~/.emacs.d/my-backup.el")
(load "~/.emacs.d/my-buffers.el")
(load "~/.emacs.d/my-perl.el")

(load "~/.emacs.d/my-js.el")            ; Нужно запускать до completion
(load "~/.emacs.d/my-html.el")

; (load "~/.emacs.d/my-hide-show.el")

(load "~/.emacs.d/my-ruby.el")

(load "~/.emacs.d/my-php.el")
(load "~/.emacs.d/my-tab.el")
(load "~/.emacs.d/my-git.el")
; (load "~/.emacs.d/my-flymake.el")
(load "~/.emacs.d/my-tags.el")

;(load "~/.emacs.d/my-rails.el") все ушло в ruby
(load "~/.emacs.d/my-anything.el")
;(load "~/.emacs.d/my-ido.el")
;(load "~/.emacs.d/my-icicles.el")

(load "~/.emacs.d/my-org.el")
(load "~/.emacs.d/my-tab.el")
(load "~/.emacs.d/my-gist.el")
(load "~/.emacs.d/my-cucumber.el")

(load "~/.emacs.d/my-completion.el")
(load "~/.emacs.d/my-markup.el")

;(autoload 'cheat "cheat")
(require 'cheat)

;(setq display-time-interval 1)
;(setq display-time-format "%H:%M:%S")
;(display-time-mode)
;; (setq woman-show-log nil)
;; (setq woman-ignore t)

;(global-set-key "\C-h" 'delete-backward-char)
(global-set-key [(meta backspace)] 'advertised-undo)
(global-set-key [f4] 'replace-string)
;(global-set-key [(meta f3)] 'find-file-other-frame)
;(global-set-key [(control r)] 'replace-string)
;(global-set-key [(control f8)] 'kill-this-buffer)
(global-set-key [(meta q)] 'comment-or-uncomment-region)
;; (global-set-key [?\C-,] 'previous-buffer)
;; (global-set-key [?\C-.] 'next-buffer)
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)
;  
; Not to say this is right for you, but when I had this problem I taught myself to press Ctrl-g instead, which is also bound to keyboard-escape-quit by default. For me, this has the advantage of keeping my left hand pretty close to the home position, as well as leaving my Esc prefix intact.

(global-set-key [(super =)] 'text-scale-increase)
(global-set-key [(super -)] 'text-scale-decrease)

(fset 'yes-or-no-p 'y-or-n-p) ;;не заставляйте меня печать yes целиком

(setq-default indent-tabs-mode nil) ; пробелы вместо табов
(setq
 tab-width 2                                        ; delete-key-deletes-forward 't		давно нет такой переменной
 kill-whole-line 't)
	
	
(auto-compression-mode 1) ; automatically uncompress files when visiting
;(setq sort-fold-case t) ; sorting functions should ignore case


; Ничего не работает, смотри http://www.enigmacurry.com/2009/01/14/extending-emacs-with-advice/
; и http://www.emacswiki.org/emacs/EasyPG
; Не спрашивать графически пароль11
;(require 'epa)
;(setenv "GPG_AGENT_INFO" nil)
; сохранять пароль GPG
(epa-file-enable)
(setq epa-file-cache-passphrase-for-symmetric-encryption t) ; уже давно не работает

; Чтобы не жать на выход три раза ESC

