;;; sessions and desktops
;
; If you want to save minibuffer history from one session to another, use the savehist library.
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(when (require 'session nil t)
  (add-hook 'after-init-hook 'session-initialize)
  (add-to-list 'session-globals-exclude 'org-mark-ring))


(desktop-save-mode t)
;(desktop-load-default)
;(desktop-read)

(global-set-key (kbd "C-c d") 'desktop-change-dir)
(global-set-key (kbd "C-c C-d") 'desktop-change-dir)

;; Save a list of recent files visited.
(recentf-mode 1)

