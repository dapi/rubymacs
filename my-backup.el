;; Backups
;
; Резонно еще ползоваться auto-save http://snarfed.org/space/gnu%20emacs%20backup%20files

;; Enable backup files.

(setq make-backup-files t)
;(setq make-backup-files nil)


;; Enable versioning with default values (keep five last versions, I think!)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)
;(setq version-control t)

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.backups/"))))

(setq backup-by-copying t)


; save temps somewhere else and don't affect the git repository
(defvar user-temporary-file-directory
;(concat (file-name-directory (or load-file-name buffer-file-name)) 
	"~/.emacs.tmp/")
(make-directory user-temporary-file-directory t)
;(setq backup-directory-alist
;      `(("." . ,user-temporary-file-directory)
;        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))
