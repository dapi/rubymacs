
;; no fucking rails-minor-mode, just rinari
 (add-to-list 'load-path (expand-file-name "~/.emacs.d/rails-minor-mode"))
(require 'rails)

;; (setq rails-indent-and-complete nil)
 (setq rails-features:list
   '(
     ;rails-snippets-feature
     rails-speedbar-feature
     rails-rspec-feature)
   )


