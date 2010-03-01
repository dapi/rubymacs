;;
;;
;; anything
;;
;;
(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)
;(require 'anything-complete)
;(anything-read-string-mode 1)
;(anything-complete-shell-history-setup-key "\C-o")
;
(setq anything-c-adaptive-history-file "~/.emacs.tmp/anything-c-adaptive-history")


(global-set-key (kbd "M-X") 'anything)


; не работает
(setq load-path (cons "/usr/lib/ruby/gems/1.8/gems/rcodetools-0.8.5.0/" load-path))
(require 'anything-rcodetools)
;; ;;(setq rct-get-all-methods-command "PAGER=cat fri -l")
;; (setq rct-get-all-methods-command "fri -l")
;; ;;       ;; See docs
;; (define-key anything-map "\C-z" 'anything-execute-persistent-action)

(require 'anything-gtags)
;(setq anything-gtags-classify t)

(require 'anything-etags)

;; прикрутить imenu
;; прикрутить поиск файлок в проекте, project-root.el


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
	
	
	
;; imenu
(defvar anything-c-imenu-delimiter " / ")
(defvar anything-c-imenu-index-filter nil)
(defvar anything-c-cached-imenu-alist nil)
(defvar anything-c-cached-imenu-candidates nil)
(defvar anything-c-cached-imenu-tick nil)
(make-variable-buffer-local 'anything-c-imenu-index-filter)
(make-variable-buffer-local 'anything-c-cached-imenu-alist)
(make-variable-buffer-local 'anything-c-cached-imenu-candidates)
(make-variable-buffer-local 'anything-c-cached-imenu-tick)
(defun anything-imenu-create-candidates (entry)
  (if (listp (cdr entry))
      (mapcan (lambda (sub)
                (if (consp (cdr sub))
                    (mapcar
                     (lambda (subentry)
                       (concat (car entry) anything-c-imenu-delimiter subentry))
                     (anything-imenu-create-candidates sub))
                  (list (concat (car entry) anything-c-imenu-delimiter (car sub)))))
              (cdr entry))
    (list entry)))
(setq anything-c-source-imenu
      '((name . "Imenu")
        (init . (lambda ()
                  (setq anything-c-imenu-current-buffer
                        (current-buffer))))
        (candidates
         . (lambda ()
             (with-current-buffer anything-c-imenu-current-buffer
               (let ((tick (buffer-modified-tick)))
                 (if (eq anything-c-cached-imenu-tick tick)
                     anything-c-cached-imenu-candidates
                   (setq anything-c-cached-imenu-tick tick
                         anything-c-cached-imenu-candidates
                         (condition-case nil
                             (mapcan
                              'anything-imenu-create-candidates
                              (setq anything-c-cached-imenu-alist
                                    (let ((index (imenu--make-index-alist)))
                                      (if anything-c-imenu-index-filter
                                          (funcall anything-c-imenu-index-filter index)
                                        index))))
                           (error nil))))))))
        (volatile)
        (action
         . (lambda (entry)
             (let ((path (split-string entry anything-c-imenu-delimiter))
                   (alist anything-c-cached-imenu-alist))
               (imenu
                (progn
                  (while path
                    (setq alist (assoc (car path) alist)
                          path (cdr path)))
                  alist)))))))

(setq anything-sources
      (list anything-c-source-buffers+
			anything-c-source-imenu
            anything-c-source-etags-select
            anything-c-source-gtags-select
			anything-c-source-file-cache
;            anything-c-source-git-project-files
            anything-c-source-files-in-current-dir+
            anything-c-source-file-name-history
            anything-c-source-recentf
            anything-c-source-locate
;            anything-c-source-buffers
;;            anything-c-source-info-pages
;;            anything-c-source-man-pages
;;            anything-c-source-emacs-commands
))


;; (defun anything-at-point ()
;;   "Start anything with the symbol at point"
;;   (interactive)
;;   (anything nil (thing-at-point 'symbol)))
;; (global-set-key [\S-f11] 'anything-at-point)


