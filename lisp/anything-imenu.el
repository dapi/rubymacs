	
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


(provide 'anything-imenu)