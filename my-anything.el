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



(require 'anything-gtags)

(require 'anything-etags)

(require 'anything-imenu)
;(require 'anything-git)
(require 'anything-rake)


(setq anything-sources
      (list anything-c-source-buffers+
			anything-c-source-imenu
 ;           anything-c-source-etags-select
            anything-c-source-rake-task
            anything-c-source-gtags-select
			anything-c-source-file-cache
;            anything-c-source-git-project-files
            anything-c-source-files-in-current-dir+
            anything-c-source-file-name-history
            anything-c-source-recentf
            anything-c-source-locate

            anything-c-source-buffers
            anything-c-source-info-pages
            anything-c-source-man-pages
            anything-c-source-emacs-commands
))


;; (defun anything-at-point ()
;;   "Start anything with the symbol at point"
;;   (interactive)
;;   (anything nil (thing-at-point 'symbol)))
;; (global-set-key [\S-f11] 'anything-at-point)


