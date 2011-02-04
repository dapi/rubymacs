(require 'pastie)

(require 'gist)
; (setq gist-view-gist 't)


;; gist-list - Lists your gists in a new buffer. Use arrow keys
;; to browse, RET to open one in the other buffer.

;; gist-region - Copies Gist URL into the kill ring.
;; With a prefix argument, makes a private gist.

;; gist-region-private - Explicitly create a private gist.

;; gist-buffer - Copies Gist URL into the kill ring.
;; With a prefix argument, makes a private gist.

;; gist-buffer-private - Explicitly create a private gist.

;; gist-region-or-buffer - Post either the current region, or if mark
;; is not set, the current buffer as a new paste at gist.github.com .
;; Copies the URL into the kill ring.
;; With a prefix argument, makes a private paste.

;; gist-region-or-buffer-private - Explicitly create a gist from the
;; region or buffer.