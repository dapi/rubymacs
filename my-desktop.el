
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)


;(setq load-path (cons "~/.emacs.d/lisp" load-path))

; Выключаем scrollbar и полосу прокрутки
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'fringe-mode) (fringe-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;; sessions and desktops
;

(require 'saveplace)
(setq-default save-place t)

;(setq-default save-visited-files-location "~/.emacs.tmp/emacs-visited-files")
;(turn-on-save-visited-files-mode)


;(require 'desktop-menu)
;(setq desktop-menu-clear 'yes)


; сохраняет places и глобальные переменные
;(require 'session)
;(setq-default session-initialize t)
;(session-initialize)
;(add-hook 'after-init-hook 'session-initialize)
;; (when (require 'session nil t)
;;   (add-hook 'after-init-hook 'session-initialize)
;;   (add-to-list 'session-globals-exclude 'org-mark-ring))


(desktop-save-mode t)
;; (setq history-length 250)
;; (add-to-list 'desktop-globals-to-save 'file-name-history)

(setq-default desktop-save 'if-exists)
(setq-default desktop-load-locked-desktop t)

;; (setq desktop-path (list "." user-emacs-directory "~") - default
(setq desktop-path (list "~"))


; periodically auto-save desktop
(add-hook 'auto-save-hook (lambda () (desktop-save-in-desktop-dir)))

;(desktop-load-default)
;(desktop-read)
;; (global-set-key (kbd "C-c d") 'desktop-change-dir)
;; (global-set-key (kbd "C-c C-d") 'desktop-change-dir)


;(require 'bookmark+)



; http://stackoverflow.com/questions/1229142/how-can-i-save-my-mini-buffer-history-in-emacs
(setq savehist-file "~/.emacs-history")
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(savehist-mode 1)

;; Save a list of recent files visited.
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 60)
;(global-set-key [(f12)] 'recentf-open-files)



; устанавливать при установке рута проекта gtags-visit-rootdir


