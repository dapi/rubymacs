;;
;;
;; gtags
;;
;;
;http://imaginateaqui.net/blog/2008/10/using-rtags-ang-gtags-for-coding-ruby/
;http://dsarkar.fhcrc.org/rtags/rtags.html
;http://code.google.com/p/google-gtags/wiki/GTagsEmacsClient
;http://emacs-fu.blogspot.com/2009/01/navigating-through-source-code-using.html

; use gem install http://rubyforge.org/frs/download.php/70625/rtags-0.98.gem to install this gem manually

;; Тут лежит мой gtags.el
(setq load-path (cons "/usr/share/emacs/site-lisp/global" load-path))

(autoload 'gtags-mode "gtags" "" t)

;;     (topdir (read-directory-name  
;;               "gtags: top of source tree:" (rinari-root))))

; http://emacs-fu.blogspot.com/2009/01/navigating-through-source-code-using.html
(defun djcb-gtags-create-or-update ()
  "create or update the gnu global tag file"
  (interactive)
  (if (not (= 0 (call-process "global" nil nil nil " -p"))) ; tagfile doesn't exist?
      (let ((olddir default-directory)
            (topdir (read-directory-name  
                     "gtags: top of source tree:" default-directory))) ; как бы сделать выход, если директория не найдена автоматом
        (cd topdir)
        (shell-command "gtags && echo 'created tagfile'")
        (cd olddir)) ; restore   
    ;;  tagfile already exists; update it
    (shell-command "global -u && echo 'updated tagfile'")))

;(shell-command "env > /tmp/env; global -uv 2> /tmp/global")))

; какбы исключить _flymake файлы из апдейта? 

(defun gtags-create-tags-file ()
  "create gnu global tag file"
  (interactive)
  (if (not (= 0 (call-process "global" nil nil nil " -p"))) ; tagfile doesn't exist?
      (let ((olddir default-directory)
            (topdir (read-directory-name  
                     "gtags: top of source tree:" default-directory))) ; как бы сделать выход, если директория не найдена автоматом
        (cd topdir)
        (shell-command "gtags && echo 'created tagfile'")
        (cd olddir)) ; restore   
    ;;  tagfile already exists; update it
    (shell-command "global -u && echo 'updated tagfile'")))

(defun gtags-update-tags-file ()
  "update gnu global tag file"
  (interactive)
  (if (not (= 0 (call-process "global" nil nil nil " -p")))
      (shell-command "echo 'no tagfile to update'") 
    (shell-command "global -u && echo 'updated tagfile'")))




; Пускать gtags -v чтобы создать GTAG-и
; Пускать global -u -v чтобы обновить
; global -x "^is_member" чтобы искать
; M-. чтобы искать определине тега
; M-* чтобы вернуться на прошлое место


(add-hook 'gtags-mode-hook 
  (lambda()
    (gtags-update-tags-file)
    )) 


(add-hook 'ruby-mode-hook (lambda () 
      (gtags-mode 1)
;      (rinari-gtags-create-or-update)
      (setq gtags-symbol-regexp "[A-Za-z_:][A-Za-z0-9_#.:?]*")
      (define-key ruby-mode-map "\e." 'gtags-find-tag)
;      (define-key ruby-mode-map "\e," 'gtags-find-with-grep)
      (define-key ruby-mode-map "\e:" 'gtags-find-symbol)
      (define-key ruby-mode-map "\e," 'gtags-find-rtag)
))



; Чтобы завести системные GTAG-и:
; cd 
; gtags -v
; exoprt GTAGSLIBPATH=/usr/src/lib:/usr/src/sy
