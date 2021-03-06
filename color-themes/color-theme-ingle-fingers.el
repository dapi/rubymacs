;; Port of idleFingers Textmate Theme for Emacs. http://idlefingers.co.uk/
;; Based on Emacs Twilight theme http://github.com/crafterm/twilight-emacs
;;
;; Still needs a lot of work though, feel free to improve!
;;
;; (require 'color-theme)
;; (color-theme-initialize)
;; (load-file "~/.emacs.d/idle-fingers-emacs/color-theme-idle-fingers.el")
;;
;; And then (color-theme-idle-fingers) to activate it.
;;
;; MIT License Copyright (c) 2010 Koen Van der Auwera (koen@atog.be)
;; Credits due to the excellent Emacs Twilight theme and Textmate idleFingers theme
;;

(defun color-theme-idle-fingers ()
  "Color theme by Koen Van der Auwera, based off the Emacs Twilight theme and TextMate idleFingers theme"
  (interactive)
  (color-theme-install
	'(color-theme-idle-fingers
	  ((background-color . "#282828")
		(background-mode . dark)
		(border-color . "#282828")
		(cursor-color . "#91FF00")
		(foreground-color . "#C2C2C2")
		(mouse-color . "sienna1"))
	  (default ((t (:background "#282828" :foreground "#C2C2C2"))))
	  (blue ((t (:foreground "blue"))))
	  (border-glyph ((t (nil))))
	  (buffers-tab ((t (:background "#282828" :foreground "#C2C2C2"))))
	  (font-lock-builtin-face ((t (:foreground "#C2C2C2"))))
	  (font-lock-comment-face ((t (:italic t :foreground "#BC9458"))))
	  (font-lock-constant-face ((t (:foreground "#6C99BB"))))
	  (font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
	  (font-lock-function-name-face ((t (:foreground "#FFF980"))))
	  (font-lock-keyword-face ((t (:foreground "#CC7833"))))
	  (font-lock-preprocessor-face ((t (:foreground "#D0D0FF"))))
	  (font-lock-reference-face ((t (:foreground "LightSteelBlue"))))
	  (font-lock-string-face ((t (:foreground "#A5C261"))))
	  (font-lock-type-face ((t (:foreground "#CCCC33"))))
	  (font-lock-variable-name-face ((t (:foreground "#B7DFF8"))))
	  (font-lock-warning-face ((t (:background "#EE799F" :foreground "red"))))
	  (font-lock-regexp-grouping-backslash ((t (:foreground "#CCCC33"))))
	  (font-lock-regexp-grouping-construct ((t (:foreground "red"))))

	  (minibuffer-prompt ((t (:foreground "#C2C2C2"))))
	  (ido-subdir ((t (:foreground "#CF6A4C"))))
	  (ido-first-match ((t (:bold t :foreground "#FFF980"))))
	  (ido-only-match ((t (:bold t :foreground "#FFF980"))))

    (dired-face-boring ((t (nil))))
    (dired-face-directory ((t (nil))))
    (dired-face-executable ((t (nil))))
    (dired-face-flagged ((t (nil))))
    (dired-face-marked ((t (nil))))
    (dired-face-permissions ((t (nil))))
    (dired-face-setuid ((t (nil))))
    (dired-face-socket ((t (nil))))
    (dired-face-symlink ((t (nil))))

    (diredp-display-msg ((t (nil))))
    (diredp-dir-heading ((t (:background "#91FF00" :foreground "#00000"))))
    (diredp-deletion ((t (nil))))
    (diredp-deletion-file-name ((t (nil))))
    (diredp-flag-mark ((t (nil))))
    (diredp-flag-mark-line ((t (nil))))
    (diredp-file-suffix ((t (:foreground "#A5C261"))))
    (diredp-symlink ((t (nil))))
    (diredp-date-time ((t (nil))))
    (diredp-file-name ((t (:foreground "#A5C261"))))
    (diredp-ignored-file-name ((t (nil))))
    (diredp-compressed-file-suffix ((t (nil))))
    (diredp-executable-tag ((t (nil))))
    (diredp-dir-priv ((t (nil))))
    (diredp-exec-priv ((t (nil))))
    (diredp-other-priv ((t (nil))))
    (diredp-write-priv ((t (nil))))
    (diredp-read-priv ((t (nil))))
    (diredp-no-priv ((t (nil))))
    (diredp-rare-priv ((t (nil))))
    (diredp-link-priv ((t (nil))))

	  (gui-element ((t (:background "#D4D0C8" :foreground "black"))))
	  (region ((t (:background "#5A647E"))))
    (modeline ((t (:background "#91FF00" :foreground "#00000"))))
	  (mode-line ((t (:background "#91FF00" :foreground "#00000"))))
    (modeline-mousable ((t (:background "#91FF00" :foreground "#00000"))))
    (modeline-mousable-minor-mode ((t (:background "#91FF00" :foreground "#00000"))))
    (fringe ((t (:background "#282828"))))
	  (highlight ((t (:background "#353637"))))
	  (left-margin ((t (nil))))
	  (text-cursor ((t (:background "yellow" :foreground "black"))))
	  (toolbar ((t (nil))))
	  (underline ((nil (:underline nil))))
	  (zmacs-region ((t (:background "snow" :foreground "blue")))))))
