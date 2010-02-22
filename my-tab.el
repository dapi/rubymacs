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
	((string-equal "*" (substring (buffer-name) 0 1))
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

;; Smart Tab
; http://www.emacswiki.org/cgi-bin/wiki/TabCompletion

