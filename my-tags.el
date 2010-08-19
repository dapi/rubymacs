;;
;;
;; gtags
;;
;;
;http://imaginateaqui.net/blog/2008/10/using-rtags-ang-gtags-for-coding-ruby/

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
                    "gtags: top of source tree:" default-directory)))
      (cd topdir)
      (shell-command "gtags && echo 'created tagfile'")
      (cd olddir)) ; restore   
    ;;  tagfile already exists; update it
    (shell-command "global -u && echo 'updated tagfile'")))
;    (shell-command "env > /tmp/env; global -uv 2> /tmp/global")))

; какбы исключить _flymake файлы из апдейта? 



; Пускать gtags -v чтобы создать GTAG-и
; Пускать global -u -v чтобы обновить
; global -x "^is_member" чтобы искать
; M-. чтобы искать определине тега
; M-* чтобы вернуться на прошлое место


(add-hook 'gtags-mode-hook 
  (lambda()
    (djcb-gtags-create-or-update)
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
