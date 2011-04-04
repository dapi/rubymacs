;;
;; yasnippet
;;
;;
;; (add-to-list 'load-path
;;              "~/.emacs.d/plugins/yasnippet")
;(require 'yasnippet)
;(yas/initialize) инициализируется где-то в рельсах

(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets/" )
(load-library "~/.emacs.d/yasnippets-rspec/setup.el")
(yas/load-directory "~/.emacs.d/yasnippets-rspec/rspec-snippets/text-mode/" )
(yas/load-directory "~/.emacs.d/yasnippets-rejeep" )
(yas/load-directory "~/.emacs.d/yasnippets-custom" )

; Тут слишком много всего
; (yas/load-directory "~/.emacs.d/yasnippets-jpablobr" )


;;
;; Rsense
;;
; http://cx4a.org/software/rsense/
;(setq rsense-home "$RSENSE_HOME")

(setq rsense-home (expand-file-name "~/.emacs.d/rsense"))
;(setq rsense-home "/home/danil/.emacs.d/rsense")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
(define-key ruby-mode-map (kbd "C-c , ,") 'rsense-complete)
(define-key ruby-mode-map (kbd "C-c .") 'ac-complete-rsense)
(define-key ruby-mode-map (kbd "C-=") 'rsense-jump-to-definition) ; You can jump to definition of a method or a constant you are pointing at
; rsense-where-is ; You can find which class/method you are editing
; rsense-type-help ; You can infer types of an expression at point
(rsense-version)


;;;
;;;
;;; autocomplete
;;;
;;;

(setq load-path (cons "~/.emacs.d/auto-complete/" load-path))

(require 'auto-complete-config)
(ac-config-default)

(add-to-list 'ac-modes 'sass-mode)
(add-to-list 'ac-modes 'yaml-mode)
; (add-to-list 'ac-modes 'haml-mode)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/dict")
(setq ac-ignore-case nil)
(setq ac-auto-show-menu t)

; default
; (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
(add-hook 'ruby-mode-hook
          (lambda ()
            (setq ac-sources '(
                               ac-source-abbrev
                               ac-source-dictionary
                               ac-source-words-in-same-mode-buffers
                               ac-source-yasnippet
                               ac-source-gtags
                               ac-source-rsense ; В принципе работает только для дополнения методов обычных классов
                               ))
            ))

;;  (setq ac-sources (append '(ac-source-yasnippet ac-source-gtags) ac-sources)))

; В случае добавлений источников не работает rsense
;; (add-hook 'ruby-mode-hook
;;            (lambda ()
;;              (add-to-list 'ac-sources 'ac-source-yasnippet)
;;              (add-to-list 'ac-sources 'ac-source-gtags)
;;              (add-to-list 'ac-sources 'ac-source-rsense)
;; ;;             ;; (add-to-list 'ac-sources 'ac-source-rsense-constant)
;;            ))

; сбоит
;(require 'auto-complete-etags)

; было в предыдущей версии
;(add-to-list 'ac-gtags-modes 'ruby-mode)

;  'ac-source-words-in-same-mode-buffers - вроде как есть подефолту
;(add-hook 'ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-files-in-current-dir)))

;(add-hook 'ruby-mode-hook '(lambda ()
	;(pabbrev-mode t)
	;))

; дурацкая штука
;(require 'predictive)

