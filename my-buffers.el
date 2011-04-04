
; (require 'switch-window)


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



(autoload 'kill-ring-search "kill-ring-search"
  "Search the kill ring in the minibuffer."
  (interactive))

(global-set-key "\M-\C-y" 'kill-ring-search)


; Типографика

(defun typopunct-mode-init ()
  (require 'typopunct)
  (typopunct-change-language 'russian)
  (typopunct-mode t))

(add-hook 'markdown-mode-hook 'typopunct-mode-init)



;; Register

(global-set-key (kbd "C-,") 'point-to-register)
(global-set-key (kbd "C-.") 'jump-to-register)



;;
;; window-numbers
;;
;; Switch buffers by M-[1,2,3,4..]
;(require 'window-number)
;(window-number-mode)
;(window-number-meta-mode)

;; (require 'window-numbering)
;; (window-numbering-mode 1)
;; (setq window-numbering-assign-func
;;       (lambda () (when (equal (buffer-name) "*Calculator*") 9))) ALWAYS NUMBER 9


; el-get problem

; M-y
(global-set-key "\C-cy" '(lambda ()
                           (interactive)
                           (popup-menu 'yank-menu)))



(global-font-lock-mode 1)                     ; for all buffers
(transient-mark-mode 1) ; Отображать selection через C-SPC
(delete-selection-mode 1) ; Нажатие на клавишу удаляет selection(delete-selection-mode 1) ; Нажатие на клавишу удаляет selection


;; Copy Past
;;;; делаем чтоб можно было копировать из емакса во вне
;;;l http://www.emacswiki.org/emacs/CopyAndPaste
(setq x-select-enable-clipboard t)

; You can customize the variable x-select-enable-clipboard to make the Emacs yank functions consult the clipboard before the primary selection, and to make the kill functions to store in the clipboard as well as the primary selection. Otherwise, these commands do not access the clipboard at all. Using the clipboard is the default on MS-Windows and Mac OS, but not on other systems.

;  (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))




;;
;; Слово нужно delete, а не kill (не постить в буффер)
;;

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

; If you use CUA mode, you might want to register these functions as movements, so that shift-<key> works properly:

(dolist (cmd '(delete-word backward-delete-word)) (put cmd 'CUA 'move))

;(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-w" 'backward-delete-word) ; В крайнем случае применять это для только для минибуфера



; Надо вернуть в минибуфер
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key [(shift insert)] 'yank)
;(global-set-key [(shift delete)] 'copy-region-as-kill)
(global-set-key [(shift delete)] 'kill-region)




;;
;; Минибуфер
; Удаляем директорию целеком, со всякими . и -

;; (defun backward-delete-path ()
;;   (interactive)
;;   (backward-delete-char 1)
;;   (while (not (eq (preceding-char) ?/))
;;     (backward-delete-char 1)))

 (defun backward-delete-path ()
   (interactive)
   (save-match-data
     (let ((pos (point)))
       (if (search-backward-regexp "/." (line-beginning-position) t)
           (progn
            (delete-region (match-beginning 0) pos)
            (insert "/")
            )
         (delete-region (line-beginning-position) pos))
       )))


;; Если что можно заменить на ido-delete-backward-updir
(define-key minibuffer-local-completion-map "\C-w" 'backward-delete-path)
(define-key minibuffer-local-map "\C-w" 'backward-delete-path)
(define-key minibuffer-local-must-match-map "\C-w" 'backward-delete-path)


;; Надо узнавать не в идошном ли мы режиме и тогда его удалялку ставить
;; (add-hook 'minibuffer-setup-hook (lambda ()
;;                                    (local-set-key "\C-w" 'backward-delete-path)
;;                                    ))




(defun my-kill-emacs ()
  (interactive)
;  (y-or-n-p "Quit editor? ")
  (save-some-buffers)
; Надо сделать что-то типа if desktop-mode
;  (desktop-save-in-desktop-dir)
  (kill-emacs))

(global-set-key (kbd "C-x c") 'my-kill-emacs)



; добавить убиваемые файлы в file-cache
(defun file-cache-add-this-file ()
  (and buffer-file-name
       (file-exists-p buffer-file-name)
       (file-cache-add-file buffer-file-name)))
(add-hook 'kill-buffer-hook 'file-cache-add-this-file)





; уникальные названия буферов http://emacs-fu.blogspot.com/2009/11/making-buffer-names-unique.html
(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":")
;(setq uniquify-buffer-name-style 'reverse)
;(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers


;;
;;
;; bubble-buffer
;;
;;
;; (require 'bubble-buffer)
;; (when (require 'bubble-buffer nil t)
;;   (global-set-key [f11] 'bubble-buffer-next)
;;   (global-set-key [(shift f11)] 'bubble-buffer-previous))
;; (setq bubble-buffer-omit-regexp "\\(^ .+$\\|\\*Messages\\*\\|*compilation\\*\\|\\*.+output\\*$\\|\\*TeX Help\\*$\\|\\*vc-diff\\*\\|\\*Occur\\*\\|\\*grep\\*\\|\\*cvs-diff\\*\\)")


;;;



(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
(setq indicate-empty-lines t)

(global-set-key [(meta backspace)] 'advertised-undo)
(global-set-key [f4] 'replace-string)
(global-set-key [(meta q)] 'comment-or-uncomment-region)
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
(epa-file-enable)
(setq epa-file-cache-passphrase-for-symmetric-encryption t) ; уже давно не работает
