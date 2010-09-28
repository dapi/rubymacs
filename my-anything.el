;;
;;
;; anything
;;
;;
;; TODO
;; прикрутить поиск файлок в проекте, project-root.el

;; Хорошие примеры по добавлению своих источников http://www.emacswiki.org/emacs/RubikitchAnythingConfiguration

(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)
;(require 'anything-complete)
;(anything-read-string-mode 1)
;(anything-complete-shell-history-setup-key "\C-o")

;;    *If non-nil, use separate source file by file.
;(setq anything-gtags-classify t)	

(setq anything-candidate-separator
      "------------------------------------------------------------------------------------")

(setq anything-c-adaptive-history-file "~/.emacs.tmp/anything-c-adaptive-history")

(global-set-key (kbd "M-X") 'anything)
(global-set-key (kbd "M-z") 'anything)



(require 'anything-gtags)

;(require 'anything-etags) я им не пользуюсь

(require 'anything-imenu)
;(require 'anything-git)
(require 'anything-rake)

(setq anything-sources
      (list anything-c-source-buffers+
                                        ; anything-c-source-imenu    ; набо бы тоже узнать клавишу :)
                                        ;           anything-c-source-etags-select
            ; anything-c-source-rake-task
            ; anything-c-source-gtags-select ; Use M-.
            anything-c-source-file-cache
                                        ;            anything-c-source-git-project-files
            anything-c-source-files-in-current-dir+
            anything-c-source-recentf
            ; anything-c-source-file-name-history ;тут больше чем в recentf но никогда не пользуюсь ими
            ;anything-c-source-locate  - как бы сделать отдельный поиск по locate

            ;anything-c-source-buffers
            ;anything-c-source-info-pages
            ;anything-c-source-man-pages
            ;anything-c-source-emacs-commands
))


;; (defun anything-at-point ()
;;   "Start anything with the symbol at point"
;;   (interactive)
;;   (anything nil (thing-at-point 'symbol)))

;; (global-set-key [\S-f11] 'anything-at-point)


;; (defvar anything-c-source-define-yasnippet-on-region
;;   '((name . "Create new YaSnippet on region")
;;     (dummy)
;;     (action . (lambda (c)
;;                 (with-stub
;;                   (let* ((mode-name (symbol-name anything-c-yas-cur-major-mode))
;;                          (root-dir (expand-file-name
;;                                     (if (listp yas/root-directory)
;;                                         (car yas/root-directory)
;;                                       yas/root-directory)))
;;                          (default-snippet-dir (anything-c-yas-find-recursively mode-name root-dir 'dir))
;;                          (filename (concat default-snippet-dir "/" anything-pattern)))
;;                     (stub read-file-name => filename)
;;                     (anything-c-yas-create-new-snippet
;;                      (with-current-buffer anything-current-buffer
;;                        (if mark-active (buffer-substring-no-properties (region-beginning) (region-end)) "")))))))))




