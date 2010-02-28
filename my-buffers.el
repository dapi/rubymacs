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



(defun my-kill-emacs ()
  (interactive)
;  (y-or-n-p "Quit editor? ")
  (save-some-buffers)
; Надо сделать что-то типа if desktop-mode
;  (desktop-save-in-desktop-dir)
  (kill-emacs))

(global-set-key (kbd "C-x c") 'my-kill-emacs)



;;
;;
;;
;; iswitchb-mode
;;
;; интерактивная фигня для быстрого переключения ‘C-x b’ 
(iswitchb-mode 1)

(defun iswitchb-local-keys ()
  (mapc (lambda (K) 
	      (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
	    '(("<right>" . iswitchb-next-match)
	      ("<left>"  . iswitchb-prev-match)
	      ("<up>"    . ignore             )
	      ("<down>"  . ignore             ))))

(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)
;(setq iswitchb-buffer-ignore '("^ " "*"))
(add-to-list 'iswitchb-buffer-ignore "^ ")
(add-to-list 'iswitchb-buffer-ignore "*Messages*")
(add-to-list 'iswitchb-buffer-ignore "*ECB")
(add-to-list 'iswitchb-buffer-ignore "*Buffer")
(add-to-list 'iswitchb-buffer-ignore "*WoMan")
(add-to-list 'iswitchb-buffer-ignore "*Completions")
(add-to-list 'iswitchb-buffer-ignore "*ftp ")
(add-to-list 'iswitchb-buffer-ignore "*bsh")
(add-to-list 'iswitchb-buffer-ignore "*jde-log")
(add-to-list 'iswitchb-buffer-ignore "*file")
(add-to-list 'iswitchb-buffer-ignore "^[tT][aA][gG][sS]$")



;;============================================================
;; iswitchb-fc
;;============================================================
(require 'filecache)
(defun file-cache-iswitchb-file ()
  "Using iswitchb, interactively open file from file cache'.
First select a file, matched using iswitchb against the contents
in `file-cache-alist'. If the file exist in more than one
directory, select directory. Lastly the file is opened."
  (interactive)
  (let* ((file (file-cache-iswitchb-read "File: "
                                   (mapcar
                                    (lambda (x)
                                      (car x))
                                    file-cache-alist)))
         (record (assoc file file-cache-alist)))
    (find-file
     (concat
      (if (= (length record) 2)
          (car (cdr record))
        (file-cache-iswitchb-read 
         (format "Find %s in dir: " file) (cdr record))) file))))

(defun file-cache-iswitchb-read (prompt choices)
  (let ((iswitchb-make-buflist-hook
	 (lambda ()
	   (setq iswitchb-temp-buflist choices))))
    (iswitchb-read-buffer prompt)))

;I bound C-c f to it:

(global-set-key "\C-cf" 'file-cache-iswitchb-file)

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

(when (require 'bubble-buffer nil t)
  (global-set-key [f11] 'bubble-buffer-next)
  (global-set-key [(shift f11)] 'bubble-buffer-previous))
(setq bubble-buffer-omit-regexp "\\(^ .+$\\|\\*Messages\\*\\|*compilation\\*\\|\\*.+output\\*$\\|\\*TeX Help\\*$\\|\\*vc-diff\\*\\|\\*Occur\\*\\|\\*grep\\*\\|\\*cvs-diff\\*\\)")

;;
;;
;; ibuffer
;;
;;
(global-set-key "\C-x \C-b" 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)
;(add-to-list 'ibuffer-never-show-regexps "^\\*")
(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-shrink-to-minimum-size t)
(setq ibuffer-always-show-last-buffer nil)
(setq ibuffer-sorting-mode 'recency)
(setq ibuffer-use-header-line t)


(setq ibuffer-saved-filter-groups
      '(("home"
         ("emacs-config" (or (filename . ".emacs.d")
                             (filename . ".emacs")))
         ("lubpytno" (filename . "lubopytno"))
         ("orionet" (filename . "orionet"))
         ("chebit" (filename . "chebit"))
         ("chebytoday" (filename . "chebytoday"))
         ("Org" (or (mode . org-mode)
                    (filename . "OrgMode")))
         ("code" (filename . "code"))
         ("Web Dev" (or (mode . html-mode)
                        (mode . haml-mode)
                        (mode . sass-mode)
                        (mode . ruby-mode)
                        (mode . css-mode)))
         ("Subversion" (name . "\*svn"))
         ("Magit" (name . "\*magit"))
;         ("ERC" (mode . erc-mode))
         ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*"))))))

(add-hook 'ibuffer-mode-hook 
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "home")))