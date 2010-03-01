;;
;;
;; gtags
;;
;;

(autoload 'gtags-mode "gtags" "" t)

      ;;     (topdir (read-directory-name  
      ;;               "gtags: top of source tree:" (rinari-root))))
      ;; (cd topdir)

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
 
(add-hook 'ruby-mode-hook (lambda () 
      (gtags-mode 1)
;      (rinari-gtags-create-or-update)
      (setq gtags-symbol-regexp "[A-Za-z_:][A-Za-z0-9_#.:?]*")
;      (define-key ruby-mode-map "\e." 'gtags-find-tag)
;      (define-key ruby-mode-map "\e," 'gtags-find-with-grep)
;      (define-key ruby-mode-map "\e:" 'gtags-find-symbol)
;      (define-key ruby-mode-map "\e_" 'gtags-find-rtag)
))


; Пускать gtags -v чтобы создать GTAG-и
; Пускать global -u -v чтобы обновить

(add-hook 'gtags-mode-hook 
  (lambda()
    (djcb-gtags-create-or-update)
    )) 



