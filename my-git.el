;; http://gist.github.com/321268

;; creates .gitignore file
 
 
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
 