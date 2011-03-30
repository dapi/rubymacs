(setq load-path (cons "~/.emacs.d/markdown" load-path))

; требует nxhtml, а он глючит
; (require 'mumamo-fun)


;; ; http://metajack.im/2009/01/02/manage-jekyll-from-emacs/
;; (setq load-path (cons "~/.emacs.d/jekyll" load-path))
;; (require 'jekyll)

;; (add-to-list 'jekyll-modes-list '("yaml" 'yaml-mode))
;; (add-to-list 'jekyll-modes-list '("html" 'html-mode))


;; (setq jekyll-directory  "/home/danil/blog/")

;; (global-set-key (kbd "C-c b n") 'jekyll-draft-post)
;; (global-set-key (kbd "C-c b P") 'jekyll-publish-post)
;; (global-set-key (kbd "C-c b p") (lambda ()
;;                                   (interactive)
;;                                   (find-file (concat jekyll-directory jekyll-posts-dir))))
;; (global-set-key (kbd "C-c b d") (lambda ()
;;                                   (interactive)
;;                                   (find-file (concat jekyll-directory jekyll-drafts-dir))))


; http://ru.wikipedia.org/wiki/Markdown
; http://jblevins.org/projects/markdown-mode/

(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
;; (setq auto-mode-alist
;;    (cons '("\\.text" . markdown-mode) auto-mode-alist)
;;    (cons '("\\.md" . markdown-mode) auto-mode-alist)
;;    (cons '("\\.markdown" . markdown-mode) auto-mode-alist)
;;    )
;; (setq auto-mode-alist
;;    (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
;; (add-to-list 'auto-mode-alist '("\\.mdwn" . markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))

 (defun ska-untabify ()
   "My untabify function as discussed and described at
 http://www.jwz.org/doc/tabs-vs-spaces.html
 and improved by Claus Brunzema:
 - return nil to get `write-contents-hooks' to work correctly
   (see documentation there)
 - `make-local-hook' instead of `make-local-variable'
 - when instead of if
 Use some lines along the following for getting this to work in the
 modes you want it to:
 
 \(add-hook 'some-mode-hook  
           '(lambda () 
               (make-local-hook 'write-contents-hooks) 
                (add-hook 'write-contents-hooks 'ska-untabify nil t)))"
   (save-excursion
     (goto-char (point-min))
     (when (search-forward "\t" nil t)
       (untabify (1- (point)) (point-max)))
     nil))

;; (add-hook 'markdown-mode-hook  
;;            '(lambda () 
;;                (make-local-hook 'write-contents-hooks) 
;;                 (add-hook 'write-contents-hooks 'ska-untabify nil t)))
;; (defun markdown-custom ()
;;   "markdown-mode-hook"
;;   ; rdiscount
;;   (setq markdown-command "markdown | SmartyPants.pl"))
;; (add-hook 'markdown-mode-hook '(lambda() (markdown-custom)))

(require 'textile-mode)
(require 'textile-minor-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))



(custom-set-faces
 '(mumamo-background-chunk-major ((t (:background "dark"))))
 '(mumamo-background-chunk-submode ((t (:background "dark"))))
 '(mumamo-background-chunk-submode1 ((t (:background "dark"))))
 '(mumamo-background-chunk-submode2 ((t (:background "dark"))))
 '(mumamo-background-chunk-submode3 ((t (:background "dark"))))
 '(mumamo-background-chunk-submode4 ((t (:background "dark"))))
 )



; README markdown
;; for lisp files

;; (require 'md-readme)
;; (dir-locals-set-class-variables
;;  'generate-README-with-md-readme
;;  '((emacs-lisp-mode . ((mdr-generate-readme . t)))))
;; (dolist (dir '("~/code/gem/loop_dance"))
;;   (dir-locals-set-directory-class
;;    dir 'generate-README-with-md-readme))
;; (add-hook 'after-save-hook 
;;           '(lambda () (if (boundp 'mdr-generate-readme) (mdr-generate))))
