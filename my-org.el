;;; org-mode
; Using the C-c C-x C-c key binding.
; (require 'mercurial)
; http://habrahabr.ru/blogs/emacs/28098/
; http://www.newartisans.com/2007/08/using-org-mode-as-a-day-planner.html
; http://members.optusnet.com.au/~charles57/GTD/orgmode.html
; http://members.optusnet.com.au/~charles57/GTD/gtd_workflow.html#sec-8
; http://jaderholm.com/screencasts/org-mode/
; http://www.youtube.com/watch?v=oJTwQvgfgMM
; http://doc.norang.ca/org-mode.html - the best

;(autoload 'org-mode "org-install" nil t)
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))


;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;; (setq org-directory "~/Dropbox/orgfiles/")
;; ; Для remember
;; (setq org-default-notes-file "~/Dropbox/orgfiles/notes.org")
(setq org-hide-leading-stars 0)

(setq org-todo-keywords '((sequence "TODO" "STARTED" "WAITING" "DONE")))

;(setq org-todo-keywords (quote ((sequence "TODO(t)" "STARTED(s)"  "DONE")
;; (setq org-todo-keywords (quote ((sequence "TODO(t)" "STARTED(s)"  "WAITING(w@/!)"  "|" "DONE(d!/!)")
;;  (sequence "WAITING(w@/!)" "SOMEDAY(S!)" "PROJECT(P@)" "OPEN(O@)" "|" "CANCELLED(c@/!)")
;;  (sequence "QUOTE(q!)" "QUOTED(Q!)" "|" "APPROVED(A@)" "EXPIRED(E@)" "REJECTED(R@)"))))

(setq org-todo-keyword-faces (quote (
                                     ;("TODO" :foreground "red" :weight bold)
                                     ("STARTED" :foreground "white" :weight bold)
                                     ("WAITING" :foreground "gray" :weight bold)
                                     ;("DONE" :foreground "forest green" :weight bold)
                                     )))

;;                                      ;; ("WAITING" :foreground "orange" :weight bold)
;;                                      ;; ("SOMEDAY" :foreground "magenta" :weight bold)
;;                                      ;; ("CANCELLED" :foreground "forest green" :weight bold)
;;                                      ;; ("QUOTE" :foreground "red" :weight bold)
;;                                      ;; ("QUOTED" :foreground "magenta" :weight bold)
;;                                      ;; ("APPROVED" :foreground "forest green" :weight bold)
;;                                      ;; ("EXPIRED" :foreground "forest green" :weight bold)
;;                                      ;; ("REJECTED" :foreground "forest green" :weight bold)
;;                                      ;; ("OPEN" :foreground "blue" :weight bold)
;;                                      ;; ("PROJECT" :foreground "red" :weight bold)
;;                                      )
;;                                     ))

;; (setq org-todo-state-tags-triggers
;;       (quote (("CANCELLED" ("CANCELLED" . t))
;;               ("WAITING" ("WAITING" . t) ("NEXT"))
;;               ("SOMEDAY" ("WAITING" . t))
;;               (done ("NEXT") ("WAITING"))
;;               ("TODO" ("WAITING") ("CANCELLED"))
;;               ("STARTED" ("WAITING"))
;;               ("PROJECT" ("CANCELLED") ("PROJECT" . t)))))

;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")

(add-hook 'org-mode-hook
	  (lambda () 
	    (imenu-add-to-menubar "Imenu")
		(abbrev-mode t)
		(auto-fill-mode t)
		(setq tab-width 2)
		(turn-on-font-lock)
;		(local-set-key [(control tab)] 'shk-tabbar-next)

		;; yasnippet
;		(make-variable-buffer-local 'yas/trigger-key)
;		(setq yas/trigger-key [tab])
;		(define-key yas/keymap [tab] 'yas/next-field-group)
		;; flyspell mode to spell check everywhere
;		(flyspell-mode 1)
;		(message "org-mode-hook")
;		(local-set-key "[(tab)]" 'org-cycle)
;		(rails-minor-mode 0)
					; turn off rails-minor-mode
		
	    ))

;; (global-set-key "\C-cl" 'org-store-link)
;; (global-set-key "\C-ca" 'org-agenda)
;; (global-set-key "\C-cb" 'org-iswitchb)


;;; remember
; http://members.optusnet.com.au/~charles57/GTD/remember.html#sec-3
; http://sachachua.com/wp/2007/10/05/remembering-to-org-and-planner/
; http://www.emacswiki.org/cgi-bin/wiki/RememberMode

; (require 'remember)
; (global-set-key (kbd "C-c r") 'remember)    ;; (1)

; (add-hook 'remember-mode-hook 'org-remember-apply-template) ;; (2)
; (setq org-remember-templates
;      '((?n "* %U %?\n\n  %i\n  %a" "~/notes.org")))  ;; (3)
; (setq remember-annotation-functions '(org-remember-annotation)) ;; (4)
; (setq remember-handler-functions '(org-remember-handler)) ;; (5)

;;
;;;  Load Org Remember Stuff
;; (require 'remember)
;; (org-remember-insinuate)

;; ;; Start clock if a remember buffer includes :CLOCK-IN:
;; (add-hook 'remember-mode-hook 'my-start-clock-if-needed 'append)

;; (defun my-start-clock-if-needed ()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (when (re-search-forward " *:CLOCK-IN: *" nil t)
;;       (replace-match "")
;;       (org-clock-in))))

;; ;; I use C-M-r to start org-remember
;; (global-set-key (kbd "C-M-r") 'org-remember)

;; ;; Keep clocks running
;; (setq org-remember-clock-out-on-exit nil)

;; ;; C-c C-c stores the note immediately
;; (setq org-remember-store-without-prompt t)

;; I don't use this -- but set it in case I forget to specify a location in a future template
;(setq org-remember-default-headline "Tasks")

;; 3 remember templates for TODO tasks, Notes, and Phone calls
;; (setq org-remember-templates (quote (("todo" ?t "* TODO %?
;;   %u
;;   %a" "~/Dropbox/orgfiles/tasks.org" bottom nil)
;;                                      ("note" ?n "* %?                                        :NOTE:
;;   %u
;;   %a" nil bottom nil)
;;                                      ("phone" ?p "* PHONE %:name - %:company -                :PHONE:
;;   Contact Info: %a
;;   %u
;;   :CLOCK-IN:
;;   %?" "~/Dropbox/orgfiles/phone.org" bottom nil))))

