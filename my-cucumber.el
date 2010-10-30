;; http://www.least-significant-bit.com/past/2009/4/17/emacs_cucumber_mode/

(setq load-path (cons "~/.emacs.d/cucumber" load-path))

(require 'feature-mode)

(require 'cucumber-mode-compilation)

;; cucumber-compilation-this-buffer (C-x t)
;; cucumber-compilation-this-scenario (C-x C-t)

;; ;; default language if .feature doesn't have "# language: fi"

(setq feature-default-language "en")

;; ;; point to cucumber languages.yml or gherkin i18n.yml to use
;; ;; exactly the same localization your cucumber uses
;; ;(setq feature-default-i18n-file "/path/to/gherkin/gem/i18n.yml")

;; ;; and load feature-mode
;; (require 'feature-mode)

(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

(add-hook 'feature-mode-hook
          (lambda ()
            
            (local-set-key (kbd "C-c ,f") 'feature-verify-all-scenarios-in-project)
            (local-set-key (kbd "C-c ,s") 'feature-verify-scenario-at-pos)
            (local-set-key (kbd "C-c ,v") 'feature-verify-all-scenarios-in-buffer)
            (local-set-key (kbd "C-c ,g") 'feature-goto-step-definition)
            
            ))


;; Key Bindings
;; ------------
;;
;;  \C-c ,v
;;  :   Verify all scenarios in the current buffer file.
;;
;;  \C-c ,s 
;;  :   Verify the scenario under the point in the current buffer.
;;
;;  \C-c ,f 
;;  :   Verify all features in project. (Available in feature and 
;;      ruby files)
;;
;;  \C-c ,r 
;;  :   Repeat the last verification process.

