;;; sessions and desktops
;

(require 'saveplace)
(setq-default save-place t)

;(setq-default save-visited-files-location "~/.emacs.tmp/emacs-visited-files")
;(turn-on-save-visited-files-mode)


(require 'desktop-menu)
(setq desktop-menu-clear 'yes)


; сохраняет places и глобальные переменные
;(require 'session)
;(setq-default session-initialize t)
;(session-initialize)
;(add-hook 'after-init-hook 'session-initialize)
;; (when (require 'session nil t)
;;   (add-hook 'after-init-hook 'session-initialize)
;;   (add-to-list 'session-globals-exclude 'org-mark-ring))


(desktop-save-mode t)
;; (setq history-length 250)
;; (add-to-list 'desktop-globals-to-save 'file-name-history)

(setq-default desktop-save 'if-exists)
(setq-default desktop-load-locked-desktop t)

;; (setq desktop-path (list "." user-emacs-directory "~") - default
(setq desktop-path (list "~"))


; periodically auto-save desktop
(add-hook 'auto-save-hook (lambda () (desktop-save-in-desktop-dir)))

;(desktop-load-default)
;(desktop-read)
;; (global-set-key (kbd "C-c d") 'desktop-change-dir)
;; (global-set-key (kbd "C-c C-d") 'desktop-change-dir)


(require 'bookmark+)



; http://stackoverflow.com/questions/1229142/how-can-i-save-my-mini-buffer-history-in-emacs
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(savehist-mode 1)

;; Save a list of recent files visited.
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 60)
(global-set-key [(f12)] 'recentf-open-files)



; устанавливать при установке рута проекта gtags-visit-rootdir

;;
;;
;; mk-project
;;
;;

;; (require 'mk-project)
;; (project-def "lubo"
;;       '((basedir          "/home/danil/projects/github/dapi/lubopytno.ru/")
;;         (src-patterns     ("*.rb" "*.rake"))
;; ;        (ignore-patterns  ("*.class" "*.wsdl"))
;;         (tags-file        "/home/danil/projects/github/dapi/lubopytno.ru/TAGS")
;;         (file-list-cache  "/home/danil/projects/github/dapi/lubopytno.ru/.files")
;;         (open-files-cache "/home/danil/projects/github/dapi/lubopytno.ru/.open-files")
;;         (vcs              git)
;; ;        (compile-cmd      "ant")
;;         (ack-args         "")
;; ;        (startup-hook     my-java-project-startup)
;;         (shutdown-hook    nil)))

;; (project-def "emacs"
;;       '((basedir          "/home/danil/.emacs.d/")
;;         (src-patterns     ("*.rb" "*.rake"))
;; ;        (ignore-patterns  ("*.class" "*.wsdl"))
;; ;        (tags-file        "/home/danil/projects/github/dapi/lubopytno.ru/TAGS")
;;         (file-list-cache  "/home/danil/.emacs.tmp/.emacs-files")
;;         (open-files-cache "/home/danil/.emacs.tmp/.emacs-open-files")
;;         (vcs              git)
;; ;        (compile-cmd      "ant")
;; ;        (ack-args         "--java")
;; ;        (startup-hook     my-java-project-startup)
;;         (shutdown-hook    nil)))

;; (project-def "zhazhda"
;;       '((basedir          "/home/danil/projects/web/nz/")
;;         (src-patterns     ("*.pl" "*.html"))
;; ;        (ignore-patterns  ("*.class" "*.wsdl"))
;; ;        (tags-file        "/home/danil/projects/github/dapi/lubopytno.ru/TAGS")
;; ;        (file-list-cache  "/home/danil/.emads.d.tmp/.files")
;; ;        (open-files-cache "/home/danil/.emacs.d.tmp/.open-files")
;; ;        (vcs              git)
;; ;        (compile-cmd      "ant")
;; ;        (ack-args         "--java")
;; ;        (startup-hook     my-java-project-startup)
;;         (shutdown-hook    nil)))

;; (project-def "chebytoday"
;;       '((basedir          "/home/danil/projects/github/dapi/chebytoday/")
;;         (src-patterns     ("*.rb" "*.rake"))
;;         (tags-file        "/home/danil/projects/github/dapi/chebytoday/TAGS")
;;         (file-list-cache  "/home/danil/projects/github/dapi/chebytoday/.files")
;;         (open-files-cache "/home/danil/projects/github/dapi/chebytoday/.open-files")
;; ;        (ignore-patterns  ("*.class" "*.wsdl"))
;; ;        (tags-file        "/home/danil/projects/github/dapi/lubopytno.ru/TAGS")
;; ;        (file-list-cache  "/home/danil/.emads.d.tmp/.files")
;; ;        (open-files-cache "/home/danil/.emacs.d.tmp/.open-files")
;;         (vcs              git)
;; ;        (compile-cmd      "ant")
;; ;        (ack-args         "--java")
;; ;        (startup-hook     my-java-project-startup)
;;         (shutdown-hook    nil)))



;; (global-set-key (kbd "C-c p c") 'project-compile)
;; (global-set-key (kbd "C-c p g") 'project-grep)
;; (global-set-key (kbd "C-c p a") 'project-ack)
;; (global-set-key (kbd "C-c p l") 'project-load)
;; (global-set-key (kbd "C-c p u") 'project-unload)
;; (global-set-key (kbd "C-c p f") 'project-find-file) ; or project-find-file-ido
;; (global-set-key (kbd "C-c p i") 'project-index)
;; (global-set-key (kbd "C-c p s") 'project-status)
;; (global-set-key (kbd "C-c p h") 'project-home)
;; (global-set-key (kbd "C-c p d") 'project-dired)
;; (global-set-key (kbd "C-c p t") 'project-tags)


