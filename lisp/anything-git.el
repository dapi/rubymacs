
;; (add-to-list 'load-path "~/.emacs.d/magit")
;; (require 'magit)
;; ;;
;; ;; anything for git projects
;; ;;

;; (defvar anything-c-source-git-project-files-cache nil "(path signature cached-buffer)")
;; (defvar anything-c-source-git-project-files
;;       '((name . "Files from Current GIT Project")
;; 	(init . (lambda ()
;; 		  (let* ((top-dir (file-truename (magit-get-top-dir (if (buffer-file-name)
;; 									(file-name-directory (buffer-file-name))
;; 								      default-directory))))
;; 			 (default-directory top-dir)
;; 			 (signature (magit-shell (magit-format-git-command "rev-parse --verify HEAD" nil))))

;; 		    (unless (and anything-c-source-git-project-files-cache
;; 				 (third anything-c-source-git-project-files-cache)
;; 				 (equal (first anything-c-source-git-project-files-cache) top-dir)
;; 				 (equal (second anything-c-source-git-project-files-cache) signature))
;; 		      (if (third anything-c-source-git-project-files-cache)
;; 			  (kill-buffer (third anything-c-source-git-project-files-cache)))
;; 		      (setq anything-c-source-git-project-files-cache
;; 			    (list top-dir
;; 				  signature
;; 				  (anything-candidate-buffer 'global)))
;; 		      (with-current-buffer (third anything-c-source-git-project-files-cache)
;; 			(dolist (filename (mapcar (lambda (file) (concat default-directory file))
;; 						  (magit-shell-lines (magit-format-git-command "ls-files" nil))))
;; 			  (insert filename)
;; 			  (newline))))
;; 		    (anything-candidate-buffer (third anything-c-source-git-project-files-cache)))))

;;         (type . file)
;; 	(candidates-in-buffer)))

(provide 'anything-git)