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
(add-to-list 'auto-mode-alist '("\\.irbrc$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
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


;(setq ruby-deep-arglist t)

; Когда параметры идут второй строкой делать малую идентацию, а не по их начало на предыдущей
; (setq ruby-deep-indent-paren nil)

;(setq ruby-deep-indent-paren-style nil)

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
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)
;; (setq rinari-tags-file-name "TAGS")

(define-key ruby-mode-map (kbd "C-c ]") 'rinari-find-file-in-project)


;; (define-key ruby-mode-map (kbd "C-c l") "lambda")


;; ruby-block

;; (require 'ruby-block)
;; (ruby-block-mode t)
;;
;; In addition, you can also add this line too.
;;
;; ;; do overlay
;; (setq ruby-block-highlight-toggle 'overlay)
;; ;; display to minibuffer
;; (setq ruby-block-highlight-toggle 'minibuffer)
;; ;; display to minibuffer and do overlay
;(setq ruby-block-highlight-toggle t)
;(setq ruby-block-delay 0.1) ; люблю побыстрее

;; (require 'ruby-hacks)

;; (define-key ruby-mode-map (kbd "C-:") 'ruby-toggle-string<>simbol)


;;
;;
;; ri
;;
;;
;(autoload 'ri "/home/danil/.emacs.d/ri-emacs/ri-ruby.el" nil t)

(setq ri-ruby-script "/home/danil/.emacs.d/ri-emacs/ri-emacs.rb")
(setq ri-ruby-program "/usr/bin/ruby1.8")


;; (setq ri-ruby-script "1.8.7 ruby /home/danil/.emacs.d/ri-emacs/ri-emacs.rb")
;; (setq ri-ruby-program "rvm")

(load-file "/home/danil/.emacs.d/ri-emacs/ri-ruby.el")

(define-key ruby-mode-map "\M-\C-i" 'ri-ruby-complete-symbol)
;           (local-set-key 'f4 'ri-ruby-show-args)
;; (define-key ruby-mode-map "\M-\C-o" 'rct-complete-symbol)


;;
;;  You may want to bind the ri command to a key.
;;  For example to bind it to F1 in ruby-mode:
;;  Method/class completion is also available.
;;
;; (add-hook 'ruby-mode-hook (lambda ()
 ;;                             (local-set-key [(f1)] 'ri)
 ;;                             (local-set-key [(control f1)] 'ri-ruby-complete-symbol)
 ;;                             (local-set-key [(control shift f1)] 'ri-ruby-show-args)
  ;;                           ))



;; irbsh
;; http://www.rubyist.net/~rubikitch/computer/irbsh/index.en.html#label:5
;; (add-to-list 'load-path "~/.emacs.d/irbsh/data/emacs/site-lisp")
;; (load "irbsh")
;; (load "irbsh-toggle")


;; yari
;; ;; You can use C-u M-x yari to reload all completion targets.

(require 'yari)
(define-key ruby-mode-map (kbd "C-h y") 'yari-anything)


;;; rails
(setq load-path (cons (expand-file-name "~/.emacs.d/emacs-rails-reloaded") load-path))

; Зачем он мне?
;(require 'rails-autoload)
 ; rails/bytecompile


;;;
;;;
;;; ruby-electric
;;;
;;;

(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode)))


(require 'inf-ruby)
;; rinari подключает его автоматом, убедиться что он этого не делает
; поэтому убедиться что он подключается с ruby а не с rinari/utils
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")

(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)
             (define-key ruby-mode-map "\C-c\C-a" 'ruby-eval-buffer)
             ))


; apidock search
(defun gaizka-search-apidock-rails ()
  "Search current word in apidock for rails"
  (interactive)
  (let* ((word-at-point (thing-at-point 'symbol))
		(word (read-string "Search apidock for? " word-at-point)))
	(browse-url (concat "http://apidock.com/rails/" word))))
 
;; (define-key ruby-mode-map (kbd "C-c d") 'gaizka-search-apidock-rails)
 
;(provide 'rails-apidock)
;;
;;
;; imenu
;;
;;

(require 'imenu)

;(add-hook 'ruby-mode-hook 'imenu-add-menubar-index)
(add-hook 'ruby-mode-hook '(lambda () 
                             (imenu-add-menubar-index)
                             ))

;; (require 'pabbrev)
;; (setq pabbrev-idle-timer-verbose nil)

; (require 'tabkey2)
; нужна для yasnippet и auto-complete, но работает и без нее

;;
;;
;; idle-highlighting
;;
;;
;; (require 'idle-highlight)

;; (defun my-coding-hook ()
;;   (make-local-variable 'column-number-mode)
;;   (column-number-mode t)
;;   (if window-system (hl-line-mode t))
;;   (idle-highlight))

;; (add-hook 'emacs-lisp-mode-hook 'my-coding-hook)
;; (add-hook 'ruby-mode-hook 'my-coding-hook)
;; (add-hook 'js2-mode-hook 'my-coding-hook)

;(require 'rdoc-mode)

(setq ruby-electric-newline-before-closing-bracket nil)
;(setq ruby-electric-newline-before-closing-bracket t)

(rvm-use-default)


;
; test-case-mode
; http://nschum.de/src/emacs/test-case-mode/
;

;(add-to-list 'load-path "/path/to/test-case-mode")
(autoload 'test-case-mode "test-case-mode" nil t)
(autoload 'enable-test-case-mode-if-test "test-case-mode")
(autoload 'test-case-find-all-tests "test-case-mode" nil t)
(autoload 'test-case-compilation-finish-run-all "test-case-mode")	

; To enable it automatically when opening test files:
(add-hook 'find-file-hook 'enable-test-case-mode-if-test)



;
; rspec
;

(require 'rspec-mode)

; Как его подключить не отключая ruby-mode?
;(add-to-list 'auto-mode-alist '("spec\\.rb$" . rspec-mode))

	
; If you want to run all visited tests after a compilation, add:
; (add-hook 'compilation-finish-functions 'test-case-compilation-finish-run-all)


(require 'rcov-overlay)
