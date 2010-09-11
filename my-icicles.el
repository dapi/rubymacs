;;     (it defaults to "~/icicles") by running `customize-variable' on
;;     the `icicle-download-dir' variable. If you do this, be sure to
;;     also add the value of `icicle-download-dir' to variable
;;     `load-path'.


(require 'linkd)
(linkd-mode)
(require 'fuzzy-match)
(require 'el-swank-fuzzy)

(setq load-path (cons "~/.emacs.d/icicles" load-path))
(require 'icicles)
(icicle-mode 1)

(define-key icicle-mode-map [up] 'previous-history-element)
(define-key icicle-mode-map [down] 'next-history-element)
