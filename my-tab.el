;;;; tabbar
;;
;;
;;

; http://www.emacswiki.org/cgi-bin/wiki/TabBarMode
(require 'tabbar)

(tabbar-mode 1)

;(define-key global-map [(alt j)] 'tabbar-backward)
;(define-key global-map [(alt k)] 'tabbar-forward)

(defun tabbar-buffer-groups ()
  "Return the list of group names the current buffer belongs to.
 This function is a custom function for tabbar-mode's tabbar-buffer-groups.
 This function group all buffers into 3 groups:
 Those Dired, those user buffer, and those emacs buffer.
 Emacs buffer are those starting with “*”."
  (list
   (cond
	((or 
      (string-equal "*" (substring (buffer-name) 0 1))
      (string-equal "TAGS" (buffer-name))
      )
	 "Emacs Buffer"
	 )
	((eq major-mode 'dired-mode)
	 "Dired"
	 )
	(t
	 "User Buffer"
	 )
	))) ;; from Xah Lee

(setq tabbar-buffer-groups-function 'tabbar-buffer-groups)

; Here is a example where all tabs is just one group
;; (setq tabbar-buffer-groups-function
;;       (lambda (b) (list "All Buffers")))

;; All tabs in one
;; (setq tabbar-buffer-list-function
;;      	(lambda ()
;;      	  (remove-if
;;      	   (lambda(buffer)
;;      	     (find (aref (buffer-name buffer) 0) " *"))
;;      	   (buffer-list))))


(dolist (func '(tabbar-mode tabbar-forward-tab tabbar-forward-group tabbar-backward-tab tabbar-backward-group))
  (autoload func "tabbar" "Tabs at the top of buffers and easy control-tab navigation"))
     

(defmacro defun-prefix-alt (name on-no-prefix on-prefix &optional do-always)
  `(defun ,name (arg)
     (interactive "P")
     ,do-always
     (if (equal nil arg)
         ,on-no-prefix
       ,on-prefix)))
     
(defun-prefix-alt shk-tabbar-next (tabbar-forward-tab) (tabbar-forward-group) (tabbar-mode 1))
(defun-prefix-alt shk-tabbar-prev (tabbar-backward-tab) (tabbar-backward-group) (tabbar-mode 1))
     
(global-set-key [(control tab)] 'shk-tabbar-next)
(global-set-key [(control shift iso-lefttab)] 'shk-tabbar-prev)
(global-set-key [(control meta tab)] 'tabbar-forward-group)



;; 1- if remove-if is not found, add here (require 'cl)
;; 2- in my emacs 23, I had to remove the "b" from "lambda (b)"

;; (when (require 'tabbar nil t)
;;   (setq tabbar-buffer-groups-function
;;     	(lambda (b) (list "All Buffers")))
;;   (setq tabbar-buffer-list-function
;;     	(lambda ()
;;     	  (remove-if
;;     	   (lambda(buffer)
;;     	     (find (aref (buffer-name buffer) 0) " *"))
;;     	   (buffer-list))))
;;   (tabbar-mode))


;Add a buffer modification state indicator in the label

 ;; add a buffer modification state indicator in the tab label,
 ;; and place a space around the label to make it looks less crowd
 (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
   (setq ad-return-value
		(if (and (buffer-modified-p (tabbar-tab-value tab))
				 (buffer-file-name (tabbar-tab-value tab)))
			(concat " + " (concat ad-return-value " "))
			(concat " " (concat ad-return-value " ")))))

 ;; called each time the modification state of the buffer changed
 (defun ztl-modification-state-change ()
   (tabbar-set-template tabbar-current-tabset nil)
   (tabbar-display-update))
 ;; first-change-hook is called BEFORE the change is made
 (defun ztl-on-buffer-modification ()
   (set-buffer-modified-p t)
   (ztl-modification-state-change))
 (add-hook 'after-save-hook 'ztl-modification-state-change)
 ;; this doesn't work for revert, I don't know
 ;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
 (add-hook 'first-change-hook 'ztl-on-buffer-modification)