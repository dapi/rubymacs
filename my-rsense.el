;;
;; Rsense
;;
; http://cx4a.org/software/rsense/
;(setq rsense-home "$RSENSE_HOME")

(setq rsense-home (expand-file-name "~/.emacs.d/rsense"))
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
(define-key ruby-mode-map (kbd "C-c , ,") 'rsense-complete)
(define-key ruby-mode-map (kbd "C-c .") 'ac-complete-rsense)
(define-key ruby-mode-map (kbd "C-=") 'rsense-jump-to-definition) ; You can jump to definition of a method or a constant you are pointing at
; rsense-where-is ; You can find which class/method you are editing
; rsense-type-help ; You can infer types of an expression at point
(rsense-version)
