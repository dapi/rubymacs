

(require 'hideshow)


(add-hook 'ruby-mode-hook
  (lambda()
    (local-set-key (kbd "C-c <right>") 'hs-show-block)
    (local-set-key (kbd "C-c <left>")  'hs-hide-block)

    (local-set-key (kbd "C-/")  'hs-toggle-hiding)
    ;; (local-set-key [C-M-down]  'hs-hide-block)
    ;; (local-set-key [C-M-up] 'hs-show-block)

    ;; (local-set-key (kbd "C-c <up>")    'hs-hide-all)
    ;; (local-set-key (kbd "C-c <down>")  'hs-show-all)
    (hs-minor-mode t)))

;
; hide/show на основе уровня пробелов
;
; http://www.emacswiki.org/emacs/HideShow#toc5
;

(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))

(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))

(global-set-key (kbd "C-+") 'toggle-hiding)
(global-set-key (kbd "C-\\") 'toggle-selective-display)

(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'ruby-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
