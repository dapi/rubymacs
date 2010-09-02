#######
#
# E-scripts about irbsh
#
#######

# (eeindex)
## INDEX
## (to "test-invoke")
## (to "test-eval-list")
## (to "test-gnuclient")

;;
;; (eeb-eval)
(defun eech-M-x (&rest args)
  (eech (concat "\ex" (mapconcat 'identity args "\n") "\n")))
(defun eech-comint-send-input (input)
  (eech (concat input "\excomint-send-input\r"))
  )
(defun eech-kill-emacs ()
  (eech-M-x "kill-emacs"))
;;

emacs=emacs21-nw
emacs=emacs-nw

# test-invoke
 (eevnow-at ".test-invoke")
 (eech-comint-send-input " echo a")
 (eech-comint-send-input " el (setq x 1)")
:x
 (eech-comint-send-input " el (setq x \"100\")")
:x
 (eech-kill-emacs)

# test-eval-list
 (eevnow-at ".test-invoke")
 (eech "\C-c\ee")
 (eech "Objec\t")

 (eech "'aaaaa'.leng\t")
:(progn (switch-to-buffer " *irbsh tmp*") (delete-other-windows))
 (eech "\C-xb\n")

 (eech "\C-a\C-k\t")
 (eech-kill-emacs)

# test-gnuclient
# I do not know why eech w/ gnuserv does not work
emacs=emacs21-nw
 (gnuserv-shutdown)
 (eevnow-at ".test-invoke")
:(load "gnuserv-compat")
:(load "gnuserv")
 (eech-M-x "gnuserv-start")
1.edit
 (eech "\C-e00\C-c\C-c")
 (eech-kill-emacs)
 (gnuserv-start)
emacs=emacs22-nw

#
# .test-invoke
<<'%%%' > $EERUBY
el_load 'irbsh'
irbsh "irb --inf-ruby-mode"
%%%
el4r -r ~/src/el4r -I ~/emacs/lisp/ --emacs=$emacs $EERUBY
#
