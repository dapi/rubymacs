;; http://github.com/technomancy/emacs-starter-kit/blob/master/starter-kit-ruby.el
;; yasnippet
;; rcodetools (not used)
;; ruby-mode
;; rinari
;; ri (ruby information)
;; ruby-electric
;; imenu
;; idle-highlighting TURNED OFF
;; git
;; gtag ?
;; hideshow ?


; ruby-debug-extra

;(add-to-list 'load-path "/home/danil/App//share/emacs/site-lisp/")
;(require 'rdebug)


;;
;;
;; rcodetools
;;
;;

;(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))

;; он все время пытается загрузить весь файл, с рельсовскими моделями и тп это не прокатывает

;; (setq load-path (cons "/home/danil/.rvm/gems/ruby-1.9.2-p0/gems/rcodetools-0.8.5.0/" load-path))
;; (require 'rcodetools)


;; (setq xmpfilter-command-name "rvm 1.8.7 ruby -S xmpfilter --dev --fork --detect-rbtest")
;; (setq rct-doc-command-name "rvm 1.8.7 ruby -S rct-doc --dev --fork --detect-rbtest")
;; (setq rct-complete-command-name "rvm 1.8.7 ruby -S rct-complete --dev --fork --detect-rbtest")
;; (setq ruby-toggle-file-command-name "rvm 1.8.7 ruby -S ruby-toggle-file")
;; (setq rct-fork-command-name "rvm 1.8.7 ruby -S rct-fork")
;/home/danil/.rvm/bin/ruby-1.8.7-p302

;; (setq xmpfilter-command-name "/home/danil/.rvm/bin/ruby-1.8.7-p302 -S xmpfilter --dev --fork --detect-rbtest")
;; (setq rct-doc-command-name "/home/danil/.rvm/bin/ruby-1.8.7-p302 -S rct-doc --dev --fork --detect-rbtest")
;; (setq rct-complete-command-name "/home/danil/.rvm/bin/ruby-1.8.7-p302 -S rct-complete --dev --fork --detect-rbtest")
;; (setq ruby-toggle-file-command-name "/home/danil/.rvm/bin/ruby-1.8.7-p302  -S ruby-toggle-file")
;; (setq rct-fork-command-name "/home/danil/.rvm/bin/ruby-1.8.7-p302 -S rct-fork")



;;
;;
;; ruby-mode
;;
;;
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.autotest$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.builder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.thor$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.irbrc$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.watchr$" . ruby-mode))
;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))


(define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
; (define-key ruby-mode-map (kbd "RET") 'ruby-newline-and-indent)

;; (define-key ruby-mode-map [M-up] 'backward-sentence)
;; (define-key ruby-mode-map [M-down] 'forward-sentence)

(define-key ruby-mode-map [M-up] 'ruby-backward-sexp)
(define-key ruby-mode-map [M-down] 'ruby-forward-sexp)



; Работает только со скобками!

; Глубина аргументов, который идут второй строкой.
; t -  "Deep indent lists in parenthesis when non-nil.
; Also ignores spaces after parenthesis when 'space."
;  глубина в ровень начала первого аргумента (конца нзвания метода)
; nil - глубина в 2 симаолв
;(setq ruby-deep-arglist t) ; default t
; работает только когда -style=space


; Может это на массивы? Некоторые ставят nil
;(defcustom ruby-deep-indent-paren '(?\( ?\[ ?\] t)

; Когда параметры идут второй строкой делать малую идентацию, а не по их начало на предыдущей
; не понятно когда и где эта переменная срабатывает
; Default deep indent style."
;  :options '(t nil space) :group 'ruby)

; Если ruby-deep-arglist nil или t (default):
; 't - делает indent на 2 символа дальше скобки
; nil - делает indent на 2 символа от начала вызова и в ровень от начала методв
(setq ruby-deep-indent-paren-style nil)


; Не вставлять coding: utf-8
; (setq ruby-insert-encoding-magic-comment nil)


;(setq ruby-indent-beg-re (concat "\\(\\s *" (regexp-opt '("class"
;      "module" "def" "belongs_to") t) "\\)\\|" (regexp-opt '("if"
;      "unless" "case" "while" "until" "for" "begin"))) "Regexp to
;      match where the indentation gets deeper.")


;;;
;;;
;;; rinari
;;;
;;;


;; временно отключил в пользу emacs rails reloaded
;(add-to-list 'load-path "~/.emacs.d/rinari")
;(require 'rinari)

;(define-key ruby-mode-map (kbd "C-c ]") 'rinari-find-file-in-project)


;; (define-key ruby-mode-map (kbd "C-c l") "lambda")


;; ruby-block

;; (require 'ruby-block)
;; (ruby-block-mode t)
;; (setq ruby-block-highlight-toggle t)
;; (setq ruby-block-delay 0.1) ; люблю побыстрее



(add-hook 'ruby-mode-hook '(lambda ()
;                             (add-hook 'before-save-hook
;                                       'delete-trailing-whitespace nil t)
                             (setq show-trailing-whitespace t)
                             (setq-default indicate-empty-lines t)
                             (setq indicate-empty-lines t)

                             (add-to-list 'hs-special-modes-alist
                                          '(ruby-mode
                                            "\\(def\\|do\\)" "end" "#"
                                            (lambda (arg) (ruby-end-of-block)) nil))
                             (hs-minor-mode t)
                             ))

;;;
;;;
;;; ruby-electric
;;;
;;;

;(require 'ruby-electric)
;(defun my-ruby-newline ()
;  (newline-and-indent))

;(add-hook 'ruby-mode-hook '(lambda ()
;                             (ruby-electric-mode)
;                             (define-key ruby-mode-map "\r" 'newline-and-indent)
;                             ))
;(setq ruby-electric-newline-before-closing-bracket nil)

(require 'imenu)

(add-hook 'ruby-mode-hook '(lambda ()
                             (imenu-add-menubar-index)
                             ))


; hide/show block support
(add-to-list 'hs-special-modes-alist
	     '(ruby-mode
	       "\\(def\\|do\\|{\\)" "\\(end\\|end\\|}\\)" "#"
	       (lambda (arg) (ruby-end-of-block)) nil))



