;; http://gist.github.com/321268
;;


(require 'vc-git)
(when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))

(add-to-list 'load-path "/usr/share/doc/git/contrib/emacs")
(require 'git)
(autoload 'git-blame-mode "git-blame"
		    "Minor mode for incremental blame for Git." t)
(require 'format-spec)
;; прикольная штука, чтобы видеть какие строки зименились
;;

;; creates .gitignore file
;;
;;
 
 
(defun gitignore(dir)
  "create .gitignore file in a directory supplied
populating it with the patterns/files"
  (interactive "sDirectory name: ")
  (setq ignore-patterns
;; modify patterns/files below as per your need
'("*~"
"log/*.log"
"tmp/**/*"
"config/database.yml"
"db/*.sqlite3"))
  (switch-to-buffer
   (get-buffer-create
     (concat (file-name-as-directory dir) ".gitignore")))
  (while ignore-patterns
    (insert-string (concat (car ignore-patterns) "\n"))
    (setq ignore-patterns (cdr ignore-patterns))))
 
