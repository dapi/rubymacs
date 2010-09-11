
; Альтернатива  Icicles

; http://emacsblog.org/2008/05/19/giving-ido-mode-a-second-chance/

; Чтобы было везьде
(define-key minibuffer-local-map [tab] 'minibuffer-complete)

; Мне не нравится ido, так как в нем:
; FIXED через стрелки вверх нет истории
; FIXED C-w  не удаляет слово
; выбираются скрытые директории
(require 'tramp) ; Все равно его IDO грузит и тормозит
(require 'ido)
(ido-mode "file")
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

;(define-key map [remap find-file] 'ido-find-file)
;(global-set-key [remap find-file] 'ido-find-file)


(add-hook 'ido-setup-hook 'ido-my-keys)

(defun ido-my-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map [tab] 'ido-complete)
  

  ;; (let ((map (make-sparse-keymap)))
  ;;   ;; (define-key map "\C-k" 'ido-delete-file-at-head)
  ;;   ;; (define-key map "\C-o" 'ido-copy-current-word)
  ;;   (define-key map "\C-w" 'ido-delete-backward-updir)
  ;;   ;; (define-key map [(meta ?l)] 'ido-toggle-literal)
  ;;   ;; (define-key map "\C-v" 'ido-toggle-vc)
  ;;   (set-keymap-parent map ido-file-dir-completion-map)
  ;;   (setq ido-file-completion-map map))

   ;; (let ((map (make-sparse-keymap))
   ;;       ;; (define-key map "\C-w" 'ido-delete-backward-updir)
   ;;       ;; (define-key map "\C-q" 'ido-delete-backward-word-updir)
   ;;       (define-key map "\C-w" 'backward-delete-path)
   ;;        (set-keymap-parent map ido-file-dir-completion-map)
   ;;       ;; (set-keymap-parent map ido-file-completion-map)
   ;;       (setq ido-file-completion-map map)
   ;;       ;;    (setq ido-common-completion-map)
   ;;       )
   ;;   )
    
    (define-key ido-completion-map " " 'ido-next-match)
    (define-key ido-completion-map [up] 'ido-prev-work-file)
    (define-key ido-completion-map [down] 'ido-next-work-file)

  ;; (define-key ido-completion-map [remap backward-delete-word] 'ido-delete-backward-word-updir)  ; C-w

;   (define-key ido-completion-map "\C-w" 'ido-delete-backward-word-updir) ; "\C-w"
   (define-key ido-file-completion-map "\C-w" 'ido-delete-backward-word-updir) ; "\C-w"
;   (define-key ido-file-completion-map "\C-w" 'backward-delete-path) ; "\C-w"
;   (define-key ido-file-dir-completion-map "\C-w" 'ido-delete-backward-word-updir) ; "\C-w"

  ;; (define-key ido-completion-map "\C-q" 'ido-delete-backward-word-updir) ; "\C-w"
  ;; (define-key ido-file-completion-map "\C-q" 'ido-delete-backward-word-updir) ; "\C-w"
  ;; (define-key ido-file-dir-completion-map "\C-q" 'ido-delete-backward-word-updir) ; "\C-w"

;;  (define-key ido-completion-map "\C-h" 'backward-delete-path) ; "\C-w"
;;  (define-key ido-file-completion-map "\C-h" 'backward-delete-path) ; "\C-w"
;;  (define-key ido-file-dir-completion-map "\C-h" 'backward-delete-path) ; "\C-w"

    )


;; up 
;; down ido-next-work-file

;; To switch between buffers, press “C-x b”, then:

;;     * type some characters appearing in the buffer name, RET to visit the buffer in the front the list.
;;     * use C-s (next) or C-r (previous) to move through the list.
;;     * [Tab] display possible completion in a buffer (or visit the buffer if there is only one possible completion).
;;     * use C-f to fall back to find file (without ido-mode) or C-b to fall back to switch to buffer (without ido-mode).

;; To find a file, press “C-x C-f”.

;;     * type some characters appearing in the file name, RET to choose the file or directory in the front of the list.
;;     * C-s (next) or C-r (previous) to move through the list.
;;     * [Tab] - display possible completion in a buffer (or open the file or go down the directory if there is only one possible completion).
;;     * RET - type to go down inside the directory in front of the list.
;;     * [backspace] - go up to the parent directory.
;;     * // - go to the root directory.
;;     * ~/ - go to the home directory.
;;     * C-f - to go back temporarly to the normal find-file.
;;     * C-d - enter Dired for this directory (used to be C-x C-d in older versions)
;;     * C-j - create a new file named with the text you entered (note: this is needed if the text you entered matches an existing file, because RET would open the existing one)

;; To restrict the list after a first filtering:

;;     * type some characters appearing in the buffer/file name(say .cpp)
;;     * type C-SPC (C-@)
;;     * continue as normal with a list containing only the filtered names

;; Recently visited directories:

;;     * type M-p and M-n to change to previous/next directories from the history
;;     * M-s to search for a file matching your input
;;     * M-k to remove the current directory from the history
;;     * directories are added to the history by navigating inside them via RET 

;; The documentation for these keys is available via

;;     * M-x describe-function RET ido-find-file RET
;;     * C-h f ido-find-file RET