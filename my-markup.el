(setq load-path (cons "~/.emacs.d/markdown" load-path))



(setq load-path (cons "~/.emacs.d/jekyll" load-path))
(require 'jekyll)

; http://jblevins.org/projects/markdown-mode/
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.text" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
   (cons '("\\.markdown" . markdown-mode) auto-mode-alist))


(require 'textile-mode)
(require 'textile-minor-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))
