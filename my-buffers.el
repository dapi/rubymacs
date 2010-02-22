;;kill-orphan-buffers
;; Kills all orphan buffers - buffers that are visiting a file that no longer exists. Useful if you've just done an svn up and various files were moved or removed.

(defun kill-orphan-buffers ()
  (interactive)
  (dolist (buffer (buffer-list))
    (let ((fname (buffer-file-name buffer)))
      (when (and fname (not (file-exists-p fname)) (not (buffer-modified-p buffer)))
        (message (concat "Killing " fname))
        (kill-buffer buffer)))))

(defun kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k") 'kill-current-buffer)


;;; Copy Past
;;;; делаем чтоб можно было копировать из емакса во вне
;;;l http://www.emacswiki.org/emacs/CopyAndPaste
(setq x-select-enable-clipboard t)
;  (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

; Недавно вставил
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key [(shift insert)] 'yank)
;(global-set-key [(shift delete)] 'copy-region-as-kill)
(global-set-key [(shift delete)] 'kill-region)
(global-set-key "\C-x \C-b" 'ibuffer) ;; более удобный переключатель буферов


(defun my-kill-emacs ()
  (interactive)
;  (y-or-n-p "Quit editor? ")
  (save-some-buffers)
  (desktop-save-in-desktop-dir)
  (kill-emacs))

(global-set-key (kbd "C-x c") 'my-kill-emacs)
