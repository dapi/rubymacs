
;;; rhtml mode
(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)


;; nxhtml
(load "~/.emacs.d/nxhtml/autostart.el")




(setq auto-mode-alist (cons '("\\.html\\.rb" . rhtml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb" . rhtml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.rhtml" . rhtml-mode) auto-mode-alist))



;; HAML
;(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/haml-edge-2.3.100/extra/" load-path))
(setq load-path (cons "/home/danil/.rvm/gems/ruby-1.8.7-p302/gems/haml-3.0.18/extra/" load-path))


(require 'haml-mode)
(require 'sass-mode)
; http://groups.google.com/group/haml/browse_thread/thread/173324407a78d290
; set indent-tabs-mode to nil

(setq auto-mode-alist (cons '("\\.haml" . haml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.sass" . sass-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.scss" . css-mode) auto-mode-alist))



;;; html-mode
;;
;;
(add-hook 'html-mode-hook
          '(lambda ()
             (setq tab-width 2)
             )
          )




;;;; yaml-mode
;
;
;

;(autoload 'yaml-mode "yaml-mode" nil t)
(require 'yaml-mode)
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



