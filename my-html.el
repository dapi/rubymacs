
;;; rhtml mode
(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)




(setq auto-mode-alist (cons '("\\.html\\.rb" . rhtml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb" . rhtml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.rhtml" . rhtml-mode) auto-mode-alist))



;; HAML
(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/haml-edge-2.3.100/extra/" load-path))

(require 'haml-mode)
(require 'sass-mode)
; http://groups.google.com/group/haml/browse_thread/thread/173324407a78d290
; set indent-tabs-mode to nil

(setq auto-mode-alist (cons '("\\.haml" . haml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.sass" . sass-mode) auto-mode-alist))



;;; html-mode
;;
;;
(add-hook 'html-mode-hook
          '(lambda ()
             (setq tab-width 2)
             )
          )


; JS2
; in Emacs, M-x byte-compile-file RE js2.el RE
; http://code.google.com/p/js2-mode/
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
 
(setq js2-basic-offset 2)
(setq js2-use-font-lock-faces t)






;;;; yaml-mode
;
;
;

(autoload 'yaml-mode "yaml-mode" nil t)
;(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml"  . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml"  . yaml-mode))




;;; nxhtml
;(setq load-path (cons "~/.emacs.d/nxhtml/" load-path))
; (load "~/.emacs.d/nxhtml/autostart.el")

;; ;; MuMaMo-Mode for rhtml files
;; (add-to-list 'load-path "~/.emacs.d/nxhtml/util/")
;; (require 'mumamo-fun)
;; (setq mumamo-chunk-coloring 'submode-colored)
;; (add-to-list 'auto-mode-alist '("\\.rhtml\\'" . eruby-html-mumamo))
;; (add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . eruby-html-mumamo))

;; nxhtml stuff
;; (setq mumamo-chunk-coloring 'submode-colored
;;       nxhtml-skip-welcome t
;;       indent-region-mode t
;;       rng-nxml-auto-validate-flag nil)


;(setq
; nxhtml-global-minor-mode t
; mumamo-chunk-coloring 'submode-colored
; nxhtml-skip-welcome t
; indent-region-mode t
; rng-nxml-auto-validate-flag nil
; nxml-degraded )



