;;; irbsh.el --- irb shell - extended inf-ruby-mode

;; Copyright (C) 2001,2002,2003,2004,2005,2006 rubikitch

;; $Id: irbsh.el 1543 2010-04-07 20:43:48Z rubikitch $
;; Author:  rubikitch <rubikitch@ruby-lang.org>
;; Created: [2001/11/14]
;; Revised: [2001/11/20]

;; This file is part of irbsh

;; Irbsh is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; Irbsh is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with irbsh; see the file COPYING.

(defvar comint-last-input-start)
(defvar comint-last-input-end)
(defvar comint-last-output-start)

(require 'cmdline-stack)
(require 'comint-util)
(require 'inf-ruby)
(require 'shell)
(require 'cl)                           ; cl-seq
(or (fboundp 'comint-redirect-send-command-to-process)
    (load "comint-redirect"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar irbsh-startup-hook nil
  "Hook for irbsh startup.")
(defvar irbsh-pwd-regexp "^\\[pwd:\\(.+\\)\\].*$"
  "Regexp of irbsh current directory.")
;;irb prompt
(setq inferior-ruby-first-prompt-pattern "^irb.*(\\(.*\\))[0-9:]+0> "
      inferior-ruby-prompt-pattern "^\\(irb.*(.*)[0-9:]+[>*\"'] \\)+")

(defvar irbsh-pwd-prompt-regexp
  (concat (substring irbsh-pwd-regexp 0 -1) "\n" (substring inferior-ruby-prompt-pattern 1))
  "Regexp of pwd and prompt.")

(defvar irbsh-continuing-prompt-pattern
      "\\`irb.*(.*)[0-9:]+\\* \\|\\`irb.*(\\(.*\\))[0-9:]+1> ")

(defvar irbsh-history-file "~/.irbsh_history"
  "History file of irbsh.")

(defvar irbsh-dynamic-complete-functions
  '(irbsh-dynamic-complete-bufname
    irbsh-dynamic-complete-dirname
    irbsh-dynamic-complete-command
    irbsh-dynamic-complete-filename
    irbsh-dynamic-complete-method
    
    )
  "List of functions called to perform completion.
This variable is used to initialise `comint-dynamic-complete-functions' in the
irbsh buffer.

This is a fine thing to set in your `.emacs' file.")

(defvar irbsh-display-redirect-output-buffer-flag nil
  "[User Option] Whether redirection buffer displays or not.")

(defvar irbsh-font-lock-keywords
  '(
    ("^irbsh(.*)[0-9:]+0>  +.+$" 0 font-lock-comment-face))
  "[User Option] Additional expressions to highlight in irbsh mode.")

(defvar irbsh-use-sigle-key-extension-flag t
  "[User Option] If non-nil, C-d, C-w, and C-u is extended for irbsh.")

(defvar irbsh-use-cd-without-quote-flag nil
  "[User Option] If non-nil, you can use CD command without ''")

(defvar irbsh-strip-last-comma-flag t
  "[User Option] If non-nil, the last ',' at command line is stripped")

(defvar irbsh-directory-completion-command-regexp "cd\\|chdir\\|entries\\|mkdir\\|rmdir"
  "[User Option] These commands are applyed to directory completion")

(defvar irbsh-display-context-at-prompt-flag t
  "[User Option] If non-nil, irbsh-prompt shows Shell/Ruby context.")

(defvar irbsh-hm-keys "asdfghjklzxcvbnmqwertyuiop"
  "[User Option] History menu select keys")

(defvar irbsh-nth-buffer-key-function
  (lambda (i) (concat "\C-c" (int-to-string i)))
  "[User Option] Keybind of switch to n-th *irbsh* buffer.")

(defvar irbsh-use-screen nil
  "[User Option] Use GNU Screen instead of background-shell")
(defvar irbsh-screen-command "screen"
  "[User Option] The filename of GNU Screen")

(defvar irbsh-tmp-buffer-name " *irbsh tmp*"
  "temporary buffer.")

(defvar irbsh-redirect-output-buffer "*irbsh output*"
  "Redirection output buffer.")

(defvar irbsh-redirect-flag nil
  "[internal] Whether redirect or not.")

(defvar irbsh-major-mode 'inferior-ruby-mode
  "[internal] major mode of irbsh.")

(defvar irbsh-hm-menu-buffer "*irbsh history*"
  "[internal] history menu buffer")

(add-hook 'inferior-ruby-mode-hook 'irbsh-startup)

(add-hook 'ruby-mode-hook 'ruby-irbsh-eval-list-setup)

(defvar irbsh-real-input nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; basic functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(or (fboundp 'comint-bol-or-process-mark)
    (defun comint-bol-or-process-mark ()
      (interactive)
      (if (not (eq last-command 'comint-bol-or-process-mark))
          (comint-bol nil)
        (comint-goto-process-mark))))

(or (fboundp 'make-temp-file)
    (defun make-temp-file (prefix &optional dir-flag)
      "Create a temporary file.
The returned file name (created by appending some random characters at the end
of PREFIX, and expanding against `temporary-file-directory' if necessary,
is guaranteed to point to a newly created empty file.
You can then use `write-region' to write new data into the file.

If DIR-FLAG is non-nil, create a new empty directory instead of a file."
      (let (file)
        (while (condition-case ()
                   (progn
                     (setq file
                           (make-temp-name
                            (expand-file-name prefix temporary-file-directory)))
                     (if dir-flag
                         (make-directory file)
                       (write-region "" nil file nil 'silent nil 'excl))
                     nil)
                 (file-already-exists t))
          ;; the file was somehow created by someone else between
          ;; `make-temp-name' and `write-region', let's try again.
          nil)
        file)))


(defun irbsh-in-string-extention-p ()
  "Return t if (point) is between `#{' and `}'"
  (let* ((pt (point))
         (bol (save-excursion (beginning-of-line 0) (point)))
         (beg (save-excursion (search-backward "#{" bol t)))
         (end (save-excursion (search-forward "}" nil t))))
    (and beg end (< beg pt) (< pt end))))


(defun irbsh-command-line-as-shell-p ()
  "Return t if the command-line is treated as shell command-line"
  (save-excursion
    (let ((pos (point)))
      (move-to-column 0)
      (looking-at (concat inferior-ruby-first-prompt-pattern " +")))))

(defun irbsh-in-shell-command-line-p ()
  "Return t if (point) is in shell command line."
  (save-excursion
    (let ((pos (point))
          min max)
      (and (not (irbsh-in-string-extention-p))
           (or (progn
                 (move-to-column 0)
                 (looking-at (concat inferior-ruby-first-prompt-pattern " +")))
               (progn
                 (search-forward "irbsh_system %Q" nil t)
                 (setq min (point))
                 (condition-case nil
                     (forward-sexp)
                   (error nil))
                 (setq max (point))
                 (and (< min pos) (< pos max)))
               (and irbsh-in-oneliner
                    (save-excursion
                      (goto-char (point-min))
                      (search-forward "]: " nil t)
                      (eq (char-after (point)) ? ))))))))


(defun irbsh-in-command-line-p ()
  "Return t if (point) is in command line."
  (or irbsh-in-oneliner
      (save-excursion
        (move-to-column 0)
        (looking-at inferior-ruby-prompt-pattern))))

(defun irbsh-in-first-command-line-p ()
  "Return t if (point) is in first command line."
  (or irbsh-in-oneliner
      (save-excursion                   ; first-prompt
        (move-to-column 0)
        (looking-at inferior-ruby-first-prompt-pattern))))

(defun irbsh-command-line-string ()
  "Return command-line string."
  (save-excursion
    (comint-goto-process-mark)
    (buffer-substring (point) (point-max))))
         
(defun irbsh-search-command-line-string ()
  "Search and return previous command-line string."
  (let ((pos (point)))
    (re-search-backward (concat inferior-ruby-first-prompt-pattern "\\(.+\\)$") nil t)
    (if (not (eq pos (point)))
        (match-string 2))))


(defun irbsh-ready-p (buf)
  "Return t if BUF is ready to execute next command."
  (save-excursion
    (set-buffer buf)
    ;(comint-bol-or-process-mark)
    (goto-char (point-max))
    (and (eq (point) (point-max))
         (irbsh-in-first-command-line-p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun irbsh-system ()
  "Insert 'irbsh_system' in order to execute shell commands."
  (interactive)
  (insert "irbsh_system %Q(")
  (save-excursion (insert ")")))

(defun irbsh-insert-load (file)
  "Insert 'load' in order to load script."
  (interactive "fLoad file: ")
  (insert "load '" (expand-file-name file) "'"))


(defun irbsh-find-ready-buffer ()
  "Return the first buffer which can execute next command."
  (find-if (lambda (buf)
             (and (string-match "^\\*irbsh\\*" (buffer-name buf))
                  (irbsh-ready-p buf)))
           (buffer-list)))

(defun irbsh-buffer ()
  (if (eq major-mode irbsh-major-mode)
      (current-buffer)
    (irbsh-find-ready-buffer)))

(defun irbsh-prepare-quotation (str back)
  (insert str)
  (backward-char back))

(defun irbsh-prepare-sharp-braces ()
  "Prepare #{}."
  (interactive)
  (irbsh-prepare-quotation "#{}" 1))

(defun irbsh-prepare-parenthesis ()
  "Prepare ()."
  (interactive)
  (irbsh-prepare-quotation "()" 1))

(defun irbsh-prepare-braces ()
  "Prepare {}."
  (interactive)
  (irbsh-prepare-quotation "{}" 1))

(defun irbsh-prepare-brackets ()
  "Prepare []."
  (interactive)
  (irbsh-prepare-quotation "[]" 1))
  
(defun irbsh-prepare-single-quote ()
  "Prepare ''."
  (interactive)
  (irbsh-prepare-quotation "''" 1))
  
(defun irbsh-prepare-double-quote ()
  "Prepare \"\"."
  (interactive)
  (irbsh-prepare-quotation "\"\"" 1))

(defun irbsh-insert-buffer-object ()
  (interactive)
  (require 'iswitchb)
  (insert "---"
          (iswitchb-read-buffer "Buffer object: " nil t)
          "---."))
  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; sigle-key command extension
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun irbsh-position-is-in-this-line-p (pos)
  "Whether the POS is in this line or not."
  (save-excursion
    (let ((beg (progn
                 (beginning-of-line)
                 (point)))
          (end (progn
                 (end-of-line)
                 (point))))
      (and (<= beg pos) (<= pos end)))))

(defun irbsh-delete-previous-word ()
  "Delete previous word. C-w by default."
  (interactive)
  (let ((pos (point)))
    (cond ((irbsh-in-shell-command-line-p)
           (if (re-search-backward "[ /][^ ]+ *" nil t)
               (forward-char 1))
           (delete-region (point) pos)
           t)
          ((irbsh-in-command-line-p)
           (beginning-of-line)
           (if (re-search-forward "[\]}) ]+?$" nil t)
               (goto-char (setq pos (match-beginning 0)))
             (goto-char pos))
           (re-search-backward "\\b\\w+ *" nil t)
           (delete-region (point) pos)
           t))))

(defun irbsh-ctrl-w (arg)
  "delete word(in command-line) / kill-region(otherwise)"
  (interactive "P")
  (if arg
      (call-interactively 'kill-region)
    (or (irbsh-delete-previous-word)
        (call-interactively 'kill-region))))

(defun irbsh-delete-command-line ()
  "Delete command-line. C-u by default."
  (interactive)
  (cond ((irbsh-in-command-line-p)
         (let ((pos (point)))
           (comint-goto-process-mark)
           (delete-region (point) pos))
         t)))

(defun irbsh-ctrl-u ()
  "delete command-line(in command-line) / universal-argument(otherwise)"
  (interactive)
  (or (irbsh-delete-command-line)
      (call-interactively 'universal-argument)))
         
(defun irbsh-prepare-quotation-when-eof ()
  "Prepare '',   C-d by default."
  (interactive)
  (cond ((and (irbsh-in-command-line-p)
              (eq (point) (point-max)))
         (irbsh-prepare-quotation "\"\"," 2)
         t)))

(defun irbsh-prepare-sharp-braces-when-eof ()
  "Prepare #{},   C-e by default."
  (interactive)
  (cond ((and (irbsh-in-command-line-p)
              (eq (point) (point-max)))
         (irbsh-prepare-quotation "#{}" 1)
         t)))

(defun irbsh-ctrl-d ()
  "prepare quotation(in command-line and point == point-max) / delete-char(otherwise)"
  (interactive)
  (or (irbsh-prepare-quotation-when-eof)
      (call-interactively 'delete-char)))

(defun irbsh-ctrl-e ()
  "prepare #{}(in command-line and point == point-max) / delete-char(otherwise)"
  (interactive)
  (or (irbsh-prepare-sharp-braces-when-eof)
      (call-interactively 'end-of-line)))




(defun irbsh-toggle-command-line-context ()
  "Toggle shell/ruby cmdline.  C-k by default."
  (interactive)
  (cond ((and (irbsh-command-line-as-shell-p)
              (eq (point) (point-max)))
         (save-excursion
           (comint-goto-process-mark)
           (while (eq (char-after) ? )
             (delete-char 1)))
         (message "Switched to Ruby context.")
         t)
         
        ;;ruby
        ((and (eq (point) (point-max)))
         (if (string= (irbsh-command-line-string) "")
             (insert " ")
           (save-excursion
             (comint-goto-process-mark)
             (insert " ")))
         (message "Switched to Shell context.")
         t)))

(defun irbsh-ctrl-k ()
  "toggle shell/ruby cmdline(in command-line and point == point-max) / kill-line(otherwise)"
  (interactive)
  (or (irbsh-toggle-command-line-context)
      (call-interactively 'kill-line)))
         
(defun irbsh-previous-input-delete-previous-word ()
  "M-p C-w. C-o by default."
  (interactive)
  (cond ((irbsh-in-command-line-p)
         (comint-previous-input 1)
         (irbsh-ctrl-w nil)
         t)))

(defun irbsh-ctrl-o ()
  "M-p C-w."
  (interactive)
  (or (irbsh-previous-input-delete-previous-word)
      (call-interactively 'open-line)))

(defun irbsh-ctrl-v ()
  "history menu/C-v"
  (interactive)
  (or (and (save-excursion
             (end-of-line)
             (eq (point) (point-max)))
           (irbsh-history-menu))
      (call-interactively 'scroll-up)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun irbsh-delete-line ()
  (let ((bol (progn (beginning-of-line)(point))))
    (forward-line 1)
    (delete-region bol (point))))  

(defun irbsh-delete-needless-lines ()
  (save-excursion
    (when (progn (forward-line -1)
                 (looking-at irbsh-pwd-regexp))
      (irbsh-delete-line)))
  (save-excursion
    (when (progn (forward-line -1)
                 (looking-at "EvalList(\\(.+\\)):[0-9]+:[0-9]+> \\(nil\\)+"))
      (irbsh-delete-line))))

(defun irbsh-strip-last-comma ()
  (save-excursion
    (and irbsh-strip-last-comma-flag
         (eq ?, (char-before (progn
                               (end-of-line)
                               (point))))
         (delete-char -1))))

(defun irbsh-send-input ()
  "Send input to irb"
  (interactive)
  (let* ((proc (get-buffer-process (current-buffer)))
         (pmark (process-mark proc))
         (input (buffer-substring pmark (point)))
         (hm (or (get-buffer-window irbsh-hm-menu-buffer)
                 (get-buffer-window "*Completions*")))
         buf)
    (when hm
      (setq buf (window-buffer hm))
      (delete-window hm)
      (kill-buffer buf))
    (if (and (string-match "^ *$" input)
             (irbsh-in-command-line-p))
        (delete-region pmark (point))
      (and irbsh-strip-last-comma-flag
           (irbsh-strip-last-comma))
      (irbsh-delete-needless-lines)
      (when irbsh-history-file
        (let ((real-input (buffer-substring pmark (point-at-eol))))
          (with-temp-buffer
            (insert real-input "\n")
            (write-region 1 (point) irbsh-history-file t 'nodisp))))
      (setq input (buffer-substring pmark (point-at-eol)))
      (irbsh-debug-message "irbsh-send-input:input=" input)
      (comint-send-input)
      (if (get-buffer-window (get-buffer-create "*Completions*"))
          (progn
            (delete-window (get-buffer-window (get-buffer "*Completions*")))
            ))
      (cmdline-stack-pop0)
      (when irbsh-redirect-flag
        (message "Output is in %s too!" irbsh-redirect-output-buffer)
        (if irbsh-display-redirect-output-buffer-flag
            (display-buffer irbsh-redirect-output-buffer))
        (setq irbsh-redirect-flag nil))
      input
      )))

(defun irbsh-redirect-output-setup (output-buffer)
  "Prepare redirection."
  (let* ((echo t)
         ;; The process buffer
	 (process-buffer (current-buffer))
	 (proc (get-buffer-process process-buffer)))
    (setq irbsh-redirect-flag t)

    ;; Change to the process buffer
    (set-buffer process-buffer)

    ;; Make sure there's a prompt in the current process buffer
    (and comint-redirect-perform-sanity-check
	 (save-excursion
	   (goto-char (point-max))
	   (or (re-search-backward comint-prompt-regexp nil t)
	       (error "No prompt found or `comint-prompt-regexp' not set properly"))))

    ;;;;;;;;;;;;;;;;;;;;;
    ;; Set up for redirection
    ;;;;;;;;;;;;;;;;;;;;;
    (get-buffer-create output-buffer)
    (comint-redirect-setup
     ;; Output Buffer
     output-buffer
     ;; Comint Buffer
     (current-buffer)
     ;; Finished Regexp
     irbsh-pwd-prompt-regexp
     ;; Echo input
     echo)

    (save-excursion
      (set-buffer output-buffer)
      (erase-buffer))

    ;;;;;;;;;;;;;;;;;;;;;
    ;; Set the filter
    ;;;;;;;;;;;;;;;;;;;;;
    ;; Save the old filter
    (setq comint-redirect-original-filter-function
	  (process-filter proc))
    (set-process-filter proc 'comint-redirect-filter)))

(defun irbsh-input-filter (str)
  "Parse the input as shell command when input =~ /^ +/"
  (setq irbsh-real-input
        (irbsh-chomp (if (save-excursion
                           (forward-line -1)
                           (or (irbsh-in-first-command-line-p)
                              ; (progn
                              ;   (comint-goto-process-mark)
                              ;   (eq ?\n (char-after (point))))
                               ))
                         (irbsh-input-filter0 str)
                       str)))
  )

(defun irbsh-chomp (str)
  (if (and (not (string= str ""))
           (string= (substring str -1) "\n"))
      (substring str 0 -1)
    str))

(defun irbsh-input-sender (proc input)
  (comint-simple-send proc irbsh-real-input))

(defun irbsh-replace-meta-variables(str)
  (with-temp-buffer
    (insert str)
    (goto-char (point-min))
    (while (re-search-forward "\\(---\\(.+?\\)---\\)" nil t) ;buffer file
      (let ((buf (match-string 2)))
        (when (get-buffer buf)
          (irbsh-buffer-file-replace nil buf))))
    (goto-char (point-min))
    (while (re-search-forward "^\\(.*\\(__region__\\).*\\)$" nil t) ; region
      (irbsh-region-file-replace nil))
    (buffer-string)))
; test
; (irbsh-replace-meta-variables "---non-exist-buffer--- and --non-exist-buffer2--- and ---*scratch*--- and __region__")
; (irbsh-replace-meta-variables "---*scratch*---")


(defun irbsh-input-filter0 (str)
  (irbsh-debug-message "irbsh-input-filter0:-------\n" "str0=" str)
  (setq str (mapconcat 'identity (split-string (irbsh-chomp str) "\n") ";"))
  (let ((header "")
        ret)
    (setq str (irbsh-replace-meta-variables str))
    (irbsh-debug-message "str=" str)
    (setq ret (cond ;; cd/pushd
               ((and irbsh-use-cd-without-quote-flag
                     (string-match "^cd +\\([^ \"'\n]+\\) *$" str))
                (concat header "irbsh_cd" " %q[" (match-string 1 str) "]"))
               ((string-match "^\\(.+\\) *|$" str)
                (irbsh-oneliner (match-string 1 str))
                (format "'output is at #<buffer %s>'.ni" irbsh-redirect-output-buffer))
               ((string-match "^\\(.+\\)$" str) ; other
                (concat header (match-string 1 str)))
               (t                       ; not reached
                (error "[bug]irbsh-input-filter"))))
    (irbsh-debug-message "ret=" ret)
    ret
    ))

(defvar bg-command nil)
(defvar irbsh-background-kill-key "q")

(define-derived-mode irbsh-background-shell-mode shell-mode
  ""
  (make-local-variable 'bg-command)
  (setq mode-name "BgSh")
  (setq irbsh-background-kill-key "q")
  (define-key irbsh-background-shell-mode-map "\C-m" 'irbsh-background-send-input-or-resurrect)
  (define-key irbsh-background-shell-mode-map irbsh-background-kill-key 'irbsh-background-insert-or-kill-buffer)
  )

(defun irbsh-bg (cmd)
  (cond (irbsh-use-screen
         (irbsh-screen-start cmd))
        (t
         (irbsh-background-shell-command cmd))))

(defun irbsh-screen-start (cmd)
  (call-process irbsh-screen-command nil nil nil "-X" "screen" "-t"
                (car (split-string cmd))
                "sh" "-c"
                (format "cd '%s'; %s" default-directory cmd))
  (format "New screen created."))

(defun irbsh-background-shell-command (cmd)
  "Exuecute background process at another buffer, return the buffer-name."
  (let* ((bufname (generate-new-buffer-name (format "*%s*" cmd)))
         (buf (get-buffer-create bufname))
         proc)
    (irbsh-background-start cmd buf)
    (format "background process at #<buffer %s>" bufname)))

(defvar proc nil)
(defvar start-pos nil)

(defun irbsh-background-start (cmd buf)
  (with-current-buffer buf
    (let ((pt (point)))
      (setq proc (start-process-shell-command "irbsh-sub" buf cmd))
      (irbsh-background-shell-mode)
      (setq bg-command cmd)                ;buffer-local
      (set (make-local-variable 'start-pos) pt)
      (set (make-local-variable 'comint-use-prompt-regexp-instead-of-fields) t)
      (set-process-sentinel proc 'irbsh-background-sentinel))))
  
(defun irbsh-background-sentinel (process signal)
  (when (memq (process-status process) '(exit signal))
    (with-current-buffer (process-buffer process)

      (message (substitute-command-keys "%s: %s. Press \\[irbsh-background-insert-or-kill-buffer] to destroy or \\[irbsh-background-send-input-or-resurrect] to resurrect process in %s.")
               (car (cdr (cdr (process-command process))))
               (substring signal 0 -1)
               (current-buffer))
      (set-marker comint-last-input-end start-pos))
    ))

(defun irbsh-background-super ()
  (call-interactively
   (or (and (keymap-parent (current-local-map))
            (lookup-key (keymap-parent (current-local-map)) (this-single-command-keys)))
       (lookup-key  global-map irbsh-background-kill-key))))

(defun irbsh-background-send-input-or-resurrect ()
  ""
  (interactive)
  (let* ((proc (get-buffer-process (current-buffer))))
    (if proc
        (irbsh-background-super)
      (goto-char (point-max))
      (irbsh-background-start bg-command (current-buffer)))))

(defun irbsh-background-insert-or-kill-buffer ()
  ""
  (interactive)
  (let* ((proc (get-buffer-process (current-buffer))))
    (if proc
        (irbsh-background-super)
      (kill-buffer (current-buffer)))))


(defun irbsh-buffer-file-replace (cmd bufname)
  "Replace '---BUFNAME---' to 'open(BUF_TMPFILE)'."
  (let ((buf (get-buffer bufname))
        tmpfile)
    (cond (buf                          ;buffer exists
           (save-match-data
             (setq tmpfile (make-temp-file
                            (expand-file-name "irbshtmp"
                                              temporary-file-directory)))
             (save-excursion
               (set-buffer buf)
               (write-region (point-min)(point-max) tmpfile)))
           (replace-match (concat "open( '" tmpfile "' )") nil t cmd 1))
          (t
           cmd))))

(defun irbsh-region-file-replace (cmd)
  "Replace '__region__' to 'open(REGION_TEMPFILE)'. "
  (let ((tmpbuf (get-buffer-create irbsh-tmp-buffer-name))
        tmpfile)
    (save-match-data
      (setq tmpfile (make-temp-file
                     (expand-file-name "irbshtmp"
                                       temporary-file-directory)))
      (save-excursion
        (set-buffer tmpbuf)
        (erase-buffer)
        (yank)
        (write-region (point-min) (point-max) tmpfile)))
    (replace-match (concat "open( '" tmpfile "' )") nil t cmd 2)))


(defun irbsh-toggle-prompt-line ()
  (condition-case nil
      (and (eq major-mode irbsh-major-mode)
           irbsh-display-context-at-prompt-flag
           (cond ((irbsh-command-line-as-shell-p)
                  (progn
                    (or (string= (match-string 1) "*SHELL*")
                        (setq irbsh-prompt-self (match-string 1)))
                    (save-excursion
                      (replace-match "*SHELL*" t nil nil 1))))
                 ((irbsh-in-first-command-line-p)
                  (progn
                    (save-excursion
                      (replace-match irbsh-prompt-self t nil nil 1))))))
    (error nil)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar irbsh-elisp-start "\001\001\002")
(defvar irbsh-elisp-end "\001\001\003")
(defvar irbsh-elisp-start-point nil)
(defvar irbsh-elisp-end-point nil)

(defun irbsh-format-and-eval (formatstr &rest rest)
  "Apply `format' to FORMATSTR and REST and evaluate the result."
  (eval (read (apply 'format (concat "(progn " formatstr ")") rest))))

(defun irbsh-output-filter (str)
  "This function is called after output is completed.
* Track pwd
* get self"
  (unless (and (string-match inferior-ruby-prompt-pattern str)
               (string= (substring str 0 3) "^C\n"))
    (when (string-match irbsh-continuing-prompt-pattern str)
      (let ((cmdline (save-excursion(irbsh-search-command-line-string)))
            (pt (point)))
        (move-to-column 0)
        (delete-region (point) pt)
        (comint-interrupt-subjob)
        (irbsh-setup-multi-line-mode cmdline nil t)
        (irbsh-multi-line-delete-output/prompt)
        ))
    (let ((elisp-buf (get-buffer-create "*irbsh elisp*"))
          elisp-eval-point)
      ;; borrowed from comint-strip-ctrl-m
      (let* ((proc (get-buffer-process (current-buffer)))
             pmark)
        (when proc
          (setq pmark (process-mark proc))
          (save-excursion
            ;; for eval_list
            (goto-char comint-last-output-start)
            (while (re-search-forward "set_eval_list_prompt;\\|;Irbsh::DisableOutput" pmark t)
              (replace-match "" t t))

            ;; for irbsh-elisp
            (goto-char comint-last-output-start)
            (let (exit)
              (while (and (not exit)
                          (or (and irbsh-elisp-start-point
                                   (goto-char (+ irbsh-elisp-start-point 3)))
                              (search-forward irbsh-elisp-start pmark t)))
                ;; now (point) is "^A^A^Bx"
                ;;                       ^-here
                (setq irbsh-elisp-start-point (- (point) 3))
                (cond ((search-forward irbsh-elisp-end pmark t)
                       (setq irbsh-elisp-end-point (point))
                       (let ((lisp (buffer-substring (+ irbsh-elisp-start-point 3) (- irbsh-elisp-end-point 3)))
                             (dir default-directory))
                         (with-current-buffer elisp-buf
                           (buffer-disable-undo)
                           (cd dir)
                           (insert lisp)))
                       (setq elisp-eval-point irbsh-elisp-start-point)
                       (delete-region (+ 3 irbsh-elisp-start-point) irbsh-elisp-end-point)
                       (setq irbsh-elisp-start-point nil))
                      (t
                       (setq exit t)))))))
        (when (string-match irbsh-pwd-regexp str)
          (cd (match-string 1 str)))
        (when (string-match inferior-ruby-first-prompt-pattern str)
          (setq irbsh-prompt-self (match-string 1 str)))
        (unless (zerop (buffer-size elisp-buf))
          (if elisp-eval-point
              (save-excursion
                (goto-char (point-max))
                (when (search-backward irbsh-elisp-start comint-last-output-start t)
                  (let ((buf (current-buffer))
                        (repl (concat 
                               (prin1-to-string
                                (irbsh-format-and-eval "%s" (with-current-buffer elisp-buf
                                                              (prog1
                                                                  (buffer-substring-no-properties (point-min) (point-max))
                                                                (erase-buffer)))))
                               "\n")))
                    (set-buffer buf)
                    (replace-match repl))))))))))


(defun irbsh-result-to-kill-ring ()
  "Save the result to kill ring."
  (interactive)
  (let ((beg (marker-position comint-last-input-end)))
    (when beg
      (save-excursion
        (goto-char (1- beg))
        (while (not (re-search-forward inferior-ruby-first-prompt-pattern nil t))
          (irbsh-accept-process-output))
        (goto-char beg)
        (beginning-of-line 0)
        (re-search-forward irbsh-pwd-regexp)
        (goto-char (1- (match-beginning 0)))
        (copy-region-as-kill beg (point))
        (message "Result is in kill ring.")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar irbsh-debug nil)

(defun irbsh-debug-message (&rest msg)
  (when irbsh-debug
    (with-current-buffer (get-buffer-create " *irbsh debug*")
      (goto-char (point-max))
      (apply 'insert (append msg (list "\n"))))))

(defun irbsh-dynamic-complete ()
  "Dynamically complete function for irbsh."
  (interactive)
  (or (irbsh-dynamic-complete-directory-part)
      (irbsh-expand-tilde)
      (irbsh-expand-glob)
      (let ((pop-up-windows t))
        (comint-dynamic-complete))))


(defun irbsh-expand-tilde ()
  "Expand home directory."
  (interactive)
  (irbsh-debug-message "irbsh-expand-tilde")
  (cond ((string= "~/" (buffer-substring (- (point) 2) (point)))
         (delete-region (- (point) 2) (point))
         (insert (expand-file-name "~/"))
         t)
        ((string= "~" (buffer-substring (- (point) 1) (point)))
         (delete-region (- (point) 1) (point))
         (insert (expand-file-name "~"))
         t)))
        

(defun irbsh-expand-glob ()
  "Expand glob."
  (irbsh-debug-message "irbsh-expand-glob")
  (let* ((comint-file-name-chars "^ ")
         (pt (point))
         glob beg
         )
    (when (save-excursion
            (and (irbsh-in-shell-command-line-p)
                 (search-backward " " nil t)
                 (progn
                   (forward-char 1)
                   (setq beg (point))
                   (setq glob (buffer-substring beg pt))
                   (string-match "[][}{*?]" glob))))
      (goto-char beg)
      (delete-region (point) pt)
      (irbsh-redirect-output
       (concat "Irbsh.no_output; Irbsh.irbsh_expand_glob "
               (irbsh-string-to-ruby-string glob)
               "")
       t)
      (insert (with-current-buffer irbsh-tmp-buffer-name
                (buffer-substring (point-min) (1- (point-max))))
              " ")
      t)))

(defun irbsh-dynamic-complete-bufname ()
  "Dynamically complete buffer name for irbsh."
  (interactive)
  (irbsh-debug-message "irbsh-dynamic-complete-bufname")
  (let ((pos (point))
        (comint-completion-addsuffix '("" . "---"))
        beg)

    (when (save-excursion
            (beginning-of-line)
            (setq beg (search-forward "---" nil t)))
      (message "Completing buffer name...")
      (goto-char pos)
      (comint-dynamic-simple-complete (buffer-substring beg pos)
                                      (mapcar 'buffer-name (buffer-list))))))

(defun irbsh-dynamic-complete-dirname ()
  "Dynamically complete directory name if the previous word is 'cd'."
  (interactive)
  (irbsh-debug-message "irbsh-dynamic-complete-dirname")
  ;;previous word =~ irbsh-directory-completion-command-regexp
  (when (save-excursion
          (search-backward " " nil t)
          (forward-word -1)
          (looking-at (concat "\\(" irbsh-directory-completion-command-regexp "\\)[( ]")))
    ;;do directory-name completion
    (irbsh-dynamic-complete-as-dirname)))

(defun irbsh-dynamic-complete-as-dirname ()
  "Directory completion."
  (irbsh-debug-message "irbsh-dynamic-complete-as-dirname")
  (message "Completing directory name...")
  (let* ((pos (point))
         (filename (or (comint-match-partial-filename) ""))
         (pathdir (file-name-directory filename))
         (pathnondir (file-name-nondirectory filename))
         (directory (if pathdir (comint-directory pathdir)
                      default-directory))
         (directories
          (delq nil
                (mapcar
                 (lambda (full)
                   (and (file-accessible-directory-p full)
                        (file-name-nondirectory full)))
                 (directory-files directory t))))
         (comint-completion-addsuffix '("/" . "/")))
    (comint-dynamic-simple-complete pathnondir directories)))

(defun irbsh-directory-completion (dir predicate flag)
  "Completion function for directory"
  (irbsh-debug-message "irbsh-directory-completion")
  (if (eq flag 'lambda)
      (and (string= "/" (substring dir -1))
	   (file-directory-p dir))
    (let (alist)
      ;;(setq dir (expand-file-name dir))
      (mapcar (lambda (f)
		(and (not (string-match "/\\.\\.?$" f))
		     (file-directory-p f)
		     (setq alist (cons (cons (concat f "/") 0) alist))))
	      (directory-files (file-name-directory dir) t))
      (cond
       ((eq flag nil) (try-completion dir alist predicate))
       ((eq flag t) (all-completions dir alist predicate)))
      )))

(defun irbsh-dynamic-complete-command ()
  "Dynamically complete the command at point for irbsh.
imported from shell.el"
  (interactive)
  (irbsh-debug-message "irbsh-dynamic-complete-command")
  (let (filename eqpt eqstr (buf (current-buffer)))
    (if (and (irbsh-in-shell-command-line-p)
             (setq filename (comint-match-partial-filename)) ;*1
             (save-match-data (not (string-match "[~/]" filename)))
             (or (save-match-data
                   (save-excursion
                     (let ((limit (save-excursion (comint-bol nil) (point))))
                       (when (> limit (point))
                         (setq limit (line-beginning-position)))
                       (when (re-search-backward (concat "=" shell-command-regexp)
                                                 limit t)
                         (forward-char 1)
                         (setq eqpt (point))
                         (save-excursion
                           (comint-goto-process-mark)
                           (setq eqstr (buffer-substring (point) eqpt))
                           (delete-region (point) eqpt)
                           (insert " ")
                           (setq eqpt (point)))
                         t))))
                 (eq (match-beginning 0) ; match-data of *1
                     (save-excursion (irbsh-backward-command 1)
                                     (forward-char -1)
                                     (point)))
                 ))
        (prog2 t (message "Completing command name...")
            (shell-dynamic-complete-as-command)
          (with-current-buffer buf
            (when eqpt
              (save-excursion
                (comint-goto-process-mark)
                (delete-char 1)
                (insert eqstr))))
          ))))

(defun irbsh-backward-command (&optional arg)
  "Move backward across ARG shell command(s).  Does not cross lines.
imported from shell.el"
  (interactive "p")
  (let ((limit (save-excursion (comint-bol nil) (point))))
    (when (> limit (point))
      (setq limit (line-beginning-position)))
    (skip-syntax-backward " " limit)
    (if (re-search-backward
	 (format "\\(irbsh_system %%Q(\\|[;&|]+[\t ]*\\)\\(%s\\)" shell-command-regexp) limit 'move arg)
	(progn (goto-char (match-beginning 2))
	       (skip-chars-forward ";&|")))
    (re-search-forward "[^ ]" nil t)))

(defun irbsh-dynamic-complete-filename ()
  "Dynamically complete filename."
  (interactive)
  (irbsh-debug-message "irbsh-dynamic-complete-filename")
  (let ((beg (point))
        (end (make-marker))
        comint-completion-addsuffix comint-file-name-quote-list)
    (cond ((irbsh-in-shell-command-line-p)
           (setq comint-completion-addsuffix (cons "/" " ")
                 comint-file-name-quote-list shell-file-name-quote-list)
           (setq beg (point))
           (comint-dynamic-complete-filename)
           ;;must be DOUBLE-ESCAPED
           (set-marker end (point))
           (narrow-to-region beg (point))
           (goto-char beg)
           (irbsh-replace-string-internal "\\" "\\\\")
           (widen)
           (goto-char (marker-position end))
           (set-marker end nil)) 
          (t
           (setq comint-completion-addsuffix (cons "/" "")
                 comint-file-name-quote-list nil)
           (comint-dynamic-complete-filename)))
    ))

(defun irbsh-dynamic-complete-directory-part ()
  "Complete the directory part of the last word."
  (interactive)
  (irbsh-debug-message "irbsh-dynamic-complete-directory-part")
  (cond ((and (irbsh-in-shell-command-line-p)
              (eq ?  (char-before (point))))
         (let ((pos (point))
               (dirname
                (save-excursion
                  (when (re-search-backward " \\([^ ]+\\) +" nil t)
                    (file-name-directory (match-string 1))))))
           (when dirname
             (goto-char pos)
             (insert dirname)
             t)))
        ((and (irbsh-in-command-line-p)
              (eq (point) (point-max)))
         (cond ((save-excursion
                  (beginning-of-line)
                  (looking-at ".+'\\([^']+\\)', *$"))
                (insert "'" (file-name-directory (match-string 1)) "',")
                (forward-char -2)
                t)
               ((save-excursion
                  (beginning-of-line)
                  (looking-at ".+\"\\([^\"]+\\)\", *$"))
                (insert "\"" (file-name-directory (match-string 1)) "\",")
                (forward-char -2)
                t)
               (t
                nil)))
        (t
         nil)))

(defun irbsh-accept-process-output ()
  "Wait for output."
  (with-current-buffer (irbsh-buffer)
    (condition-case nil
        (accept-process-output proc nil 100)
      (error 1))))
      

;; (progn (display-buffer "aaa")(irbsh-redirect-output "Time.now" t "aaa"))
(defun irbsh-redirect-output (string &optional wait buf)
  "Send STRING to irbsh and the output is written in `irbsh-tmp-buffer-name'."
  (setq buf (or buf (get-buffer-create irbsh-tmp-buffer-name)))
  (save-excursion
    (set-buffer buf)
    (erase-buffer))
  (save-current-buffer
    (let ((irbsh (irbsh-buffer)))
      (comint-redirect-send-command-to-process
       string
       buf
       (get-buffer-process irbsh) nil t)
      (if wait
          (while (null (with-current-buffer irbsh comint-redirect-completed))
            (irbsh-accept-process-output))))))

(defun irbsh-replace-string-internal (from to)
  (while (search-forward from nil t)
    (replace-match to nil t)))

(defun irbsh-string-to-ruby-string (string)
  "Convert elisp string to ruby String."
  (save-excursion
    (set-buffer (get-buffer-create irbsh-tmp-buffer-name))
    (erase-buffer)
    (insert string)
    (goto-char 0) (irbsh-replace-string-internal "\\" "\\\\")
    (goto-char 0) (irbsh-replace-string-internal "'" "\\'")
    (goto-char 0) (insert "'")
    (goto-char (point-max)) (insert "'")
    (buffer-string)))

(defvar irbsh-tmp-cands nil)

(defun irbsh-dynamic-complete-method ()
  "Dynamically complete method/variable name."
  (interactive)
  (irbsh-debug-message "irbsh-dynamic-complete-method")
  (unless (irbsh-in-shell-command-line-p)
    (let* ((pt (point))
           (string (save-excursion
                     (comint-bol-or-process-mark)
                     (buffer-substring (point) pt)))
           (comint-completion-addsuffix '("" . ""))
           string-r)
      (message "Completing method/variable name...")
      (setq string-r (irbsh-string-to-ruby-string string))
      (irbsh-redirect-output (concat "Irbsh.no_output; Irbsh.make_completion_elisp " string-r) t)
      (save-excursion
        (set-buffer irbsh-tmp-buffer-name)
        (eval-buffer))
      (comint-dynamic-simple-complete string irbsh-tmp-cands))))
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; history menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun irbsh-make-history-menu (&optional query)
  "Make history menu. If the history menu is displayed, then do nothing."
  (interactive)
  (let ((pop-up-windows t)
        (window (get-buffer-window irbsh-hm-menu-buffer)))
    (or window
        (save-excursion
          (get-buffer-create irbsh-hm-menu-buffer)
          (with-current-buffer irbsh-hm-menu-buffer
            (erase-buffer))
          (save-selected-window 
            (with-output-to-temp-buffer irbsh-hm-menu-buffer
              (let ((pos (point))
                    (i 0)
                    key beg history cmd)
                (while (and (setq key (condition-case nil
                                          (substring irbsh-hm-keys i (1+ i))
                                        (error nil)))
                            (setq cmd (irbsh-search-command-line-string)))
                  (unless (member cmd history)
                    (when (or (null query) (string-match (regexp-quote query) cmd))
                      (add-to-list 'history cmd)
                      (princ (concat key ": " cmd "\n"))
                      (setq i (1+ i))))
                  )))
            ;; for emacs22
            (with-current-buffer irbsh-hm-menu-buffer
              (when (eq ?\C-j (char-before (point-max)))
                (goto-char (point-max))
                (let (buffer-read-only)
                  (delete-backward-char 1))))
            (irbsh-arrange-tmp-buffer-window irbsh-hm-menu-buffer))))
    window))

(defun irbsh-arrange-tmp-buffer-window (buf)
  "Resize tmp-buffer. Use with `save-selected-window'"
  (let ((window (get-buffer-window buf)))
    (when window
      (select-window window)
      (enlarge-window
       (- (min (1+ (length irbsh-hm-keys)) (- (frame-height) 4))
          (window-height)))
      (shrink-window-if-larger-than-buffer))))
  
(defun irbsh-history-menu (&optional query)
  "History menu select mode."
  (interactive)
  (let ((flag t)
        (winconf (current-window-configuration)))
    (while flag
      (let* ((hm-win (irbsh-make-history-menu query))
             (key (progn
                    (message "Select history: ")
                    (char-to-string (read-char))))
             (downcase (downcase key))
             case-fold-search
             )
        (cond ((string-match key "0\C-v")
               (setq flag nil)
               (delete-window hm-win))
              ((string= key "\C-s")
;               (setq flag nil)
               (setq query (read-string "History search: "))
               (select-window (irbsh-find-irbsh-window))
               (delete-other-windows)
               (irbsh-make-history-menu query)
               )
              ((string-match key irbsh-hm-keys)
               (setq flag nil)
               (irbsh-hm-select-and-paste key t))
              ((string-match downcase irbsh-hm-keys)
               (irbsh-hm-select-and-paste downcase)))
        t                               ;for C-v
        ))
    (set-window-configuration winconf)))

(defvar shellp nil)

(defun irbsh-hm-select-and-paste (key &optional nosemicolon)
  (let (pos cmd)
    (with-current-buffer irbsh-hm-menu-buffer
      (goto-char (point-min))
      (when (re-search-forward (concat "^" key ": ") nil t)
        (setq shellp (eq (char-after) ? ))
        (setq pos (point))
        (end-of-line)
        (setq cmd (buffer-substring pos (point)))))
    (when cmd
      (insert cmd (if nosemicolon "" "; ")))))
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; multi-line mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'derived)

(defvar irbsh-multi-line-buffer "*irbsh multi line*")
(defvar irbsh-tmp-filename nil)
(defvar irbsh-multi-line-save-winconf nil)
(defvar irbsh-multi-line-dynamic-complete-functions
  '(irbsh-dynamic-complete-bufname
    irbsh-dynamic-complete-filename
    irbsh-dynamic-complete-method
    
    ))


(defun irbsh-setup-multi-line-mode (&optional cmdline no-newline no-delete)
  "irbsh-mode -> irbsh-multi-line-mode."
  (interactive)
  (let ((irbsh-buf (current-buffer)))
    (setq cmdline (or cmdline (irbsh-command-line-string)))
    (unless no-delete
      (save-excursion
        (comint-goto-process-mark)
        (delete-region (point) (point-max))))
    (setq irbsh-multi-line-save-winconf (current-window-configuration))
    (switch-to-buffer-other-window irbsh-multi-line-buffer)
    (irbsh-multi-line-mode)
    (insert cmdline)
    (unless (or (string= cmdline "") no-newline)
      (newline-and-indent))
    (setq irbsh-buffer irbsh-buf)))

(defvar irbsh-multi-line-insert-end-point nil)

(define-derived-mode irbsh-multi-line-mode ruby-mode "irbsh[M]"
  "Major mode for input multi-line to irbsh."
  (make-local-variable 'irbsh-multi-line-irbsh-buffer)
  (make-local-variable 'comint-input-ring)
  (make-local-variable 'irbsh-buf)
  (make-local-variable 'irbsh-multi-line-insert-end-point)
  (make-local-variable 'comint-dynamic-complete-functions)
  (setq irbsh-multi-line-insert-end-point nil)
  (setq comint-dynamic-complete-functions irbsh-multi-line-dynamic-complete-functions)

  (define-key irbsh-multi-line-mode-map "\C-c\C-c" 'irbsh-multi-line-send-input)
  (define-key irbsh-multi-line-mode-map "\M-p" 'irbsh-multi-line-insert-previous-input)
  (define-key irbsh-multi-line-mode-map "\M-n" 'irbsh-multi-line-insert-next-input)
  ;(define-key irbsh-multi-line-mode-map "\C-c\C-v" 'irbsh-multi-line-history-menu)
  (define-key irbsh-multi-line-mode-map "\C-c\C-e" 'erase-buffer)
  (define-key irbsh-multi-line-mode-map "\C-c\C-u" 'irbsh-multi-line-uninsert-history)
  (define-key irbsh-multi-line-mode-map "\C-c\C-q" 'irbsh-multi-line-delete-output/prompt)
  (define-key irbsh-multi-line-mode-map "\C-c\C-x" 'irbsh-multi-line-eval-buffer)
  (define-key irbsh-multi-line-mode-map "\C-i" 'irbsh-dynamic-complete)
  (define-key irbsh-multi-line-mode-map [TAB] 'irbsh-dynamic-complete)
  (irbsh-install-input-helper irbsh-multi-line-mode-map)
  )

(defvar irbsh-multi-line-start-regexp "^#### MULTI-LINE BEGIN ####\n")
(defvar irbsh-multi-line-end-regexp "^#### MULTI-LINE END ####\n")

(defun irbsh-prompt-to-top-of-window (&optional window)
  "Adjust window. "
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (move-to-column 0)
    (set-window-start (or window (selected-window)) (point))))

(defun irbsh-search-previous-multi-line-input ()
  "Return previous multi-line input."
  (let (pos)
    (and (re-search-backward irbsh-multi-line-end-regexp nil t)
         (setq pos (point))
         (re-search-backward irbsh-multi-line-start-regexp nil t)
         (buffer-substring pos (match-end 0)))))

(defun irbsh-search-next-multi-line-input ()
  "Return next multi-line input."
  (let (pos)
    (and (re-search-forward irbsh-multi-line-start-regexp nil t)
         (setq pos (point))
         (re-search-forward irbsh-multi-line-end-regexp nil t)
         (buffer-substring pos (match-beginning 0)))))


(defun irbsh-multi-line-insert-input (input errmsg)
  "Insert past multi-line-input in irbsh-multi-line-buffer."
  (interactive "*p")
  (let ((s (with-current-buffer irbsh-buffer (funcall input))))
    (cond (s
           (when (or (eq this-command 'irbsh-multi-line-insert-previous-input)
                     (eq this-command 'irbsh-multi-line-insert-next-input))
             (condition-case nil
                 (delete-region (point) irbsh-multi-line-insert-end-point)
               (error nil)))
           (save-excursion
             (insert s)
             (setq irbsh-multi-line-insert-end-point (point))))
          (t
           (error errmsg)))))


(defun irbsh-multi-line-insert-previous-input (arg)
  (interactive "*p")
  (irbsh-multi-line-insert-input 'irbsh-search-previous-multi-line-input "No previous input"))


(defun irbsh-multi-line-insert-next-input (arg)
  (interactive "*p")
  (irbsh-multi-line-insert-input 'irbsh-search-next-multi-line-input "No next input"))

(defun irbsh-save-to-tmp-file ()
  (write-region (point-min) (point-max) irbsh-tmp-filename))

(defun irbsh-eval-tmp-file ()
  (comint-send-string irbsh-buffer
                      (concat "Irbsh.eval_and_cat_multi_line_file '" irbsh-tmp-filename "', binding\n")))

(defun irbsh-multi-line-send-input ()
  (interactive)
  (irbsh-save-to-tmp-file)
  (erase-buffer)
  (set-buffer irbsh-buffer)
  (goto-char (point-max))
  (irbsh-prompt-to-top-of-window)
  (irbsh-eval-tmp-file)
  (set-window-configuration irbsh-multi-line-save-winconf))

(defun irbsh-multi-line-select-irbsh-window ()
  (if (window-live-p (get-buffer-window irbsh-buffer))
      (select-window (get-buffer-window irbsh-buffer))
    (switch-to-buffer-other-window irbsh-buffer)))
  

(defun irbsh-multi-line-delete-output/prompt ()
  "Delete all output and prompt from interpreter since last input from irbsh-multi-line buffer."
  (interactive)
  (save-selected-window
    (irbsh-multi-line-select-irbsh-window)
    (goto-char (point-max))
    (comint-delete-output/prompt)))

(defun irbsh-multi-line-eval-buffer ()
  "Eval this buffer."
  (interactive)
  (irbsh-save-to-tmp-file)
  (save-selected-window
    (irbsh-multi-line-select-irbsh-window)
    (goto-char (point-max))
    (irbsh-prompt-to-top-of-window)
    (irbsh-eval-tmp-file)))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; invoke irbsh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun irbsh (cmd)
  "Invoke irbsh"
  (interactive (list (if current-prefix-arg
			 (read-string "Run irbsh: " ruby-program-name)
                       ruby-program-name)))
  (save-some-buffers)

  (unless (buffer-live-p "*ruby scratch*")
    (with-current-buffer (get-buffer-create "*ruby scratch*")
      (ruby-mode)))

  (let ((rubybuf (get-buffer "*ruby*"))
        i bufname)
    (when rubybuf
      (set-buffer rubybuf)
      (rename-uniquely))

    ;;find first empty *irbsh*n buffer
    (setq i 1)
    (while (and (get-buffer (setq bufname (concat "*irbsh*" (int-to-string i))))
                (get-buffer-process bufname))
      (setq i (1+ i)))
    (when (get-buffer bufname)
      (kill-buffer bufname))
    (run-ruby cmd)
    (rename-buffer bufname)
    (when rubybuf
      (save-excursion
        (set-buffer rubybuf)
        (rename-buffer "*ruby*")))
    (goto-char (point-max))
    (current-buffer)))

(defun irbsh-restart (cmd)
  "Restart irbsh."
  (interactive (list (if current-prefix-arg
			 (read-string "Run irbsh: " ruby-program-name)
                       ruby-program-name)))
  (let (buf)
    (save-window-excursion
      (save-some-buffers)
      (kill-buffer (current-buffer))
      (irbsh cmd)
      (setq buf (current-buffer))
      (goto-char (point-max)))
    (switch-to-buffer buf)))



(defun irbsh-startup ()
  "Initialize irbsh"
  (interactive)

  (setq mode-name "irbsh")
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '((irbsh-font-lock-keywords) t nil))
  (make-local-variable 'font-lock-keywords)
  (setq font-lock-keywords irbsh-font-lock-keywords)
  (make-local-variable 'comint-completion-addsuffix)
  (setq irbsh-prompt-self nil)
  (make-local-variable 'irbsh-prompt-self)
  ;(setq comint-completion-addsuffix (cons "/" ""))
  (make-local-variable 'comint-prompt-read-only)
  (setq comint-prompt-read-only nil)

  (make-local-variable 'comint-use-prompt-regexp-instead-of-fields)
  (setq comint-use-prompt-regexp-instead-of-fields t)
  (when irbsh-display-context-at-prompt-flag
    (make-local-hook 'post-command-hook)
    (add-hook 'post-command-hook 'irbsh-toggle-prompt-line nil t))

  (or irbsh-tmp-filename
      (setq irbsh-tmp-filename
            (make-temp-file (expand-file-name "irbshtmp" temporary-file-directory))))
  (font-lock-mode 1)

  (buffer-disable-undo (get-buffer-create irbsh-tmp-buffer-name))

  (setq comint-input-filter-functions 'irbsh-input-filter)
  (setq comint-output-filter-functions '( irbsh-output-filter ))
  (setq comint-input-sender 'irbsh-input-sender)
  (setq comint-dynamic-complete-functions irbsh-dynamic-complete-functions)
  (when irbsh-use-sigle-key-extension-flag
    (define-key inferior-ruby-mode-map "\C-w" 'irbsh-ctrl-w)
    ;(define-key inferior-ruby-mode-map "\C-u" 'irbsh-ctrl-u)
    (define-key inferior-ruby-mode-map "\C-k" 'irbsh-ctrl-k)
    (define-key inferior-ruby-mode-map "\C-o" 'irbsh-ctrl-o)
    (define-key inferior-ruby-mode-map "\C-p" 'comint-ctrl-p)
    (define-key inferior-ruby-mode-map "\C-n" 'comint-ctrl-n)
    (define-key inferior-ruby-mode-map "\C-v" 'irbsh-ctrl-v)
    )
  (define-key inferior-ruby-mode-map "\C-a" 'comint-bol-2)
  (define-key inferior-ruby-mode-map "\C-c\C-b" 'irbsh-insert-buffer-object)
  (define-key inferior-ruby-mode-map "\C-c\C-f" 'irbsh-insert-load)
  (define-key inferior-ruby-mode-map "\C-c\C-l" 'irbsh-insert-load)
  (define-key inferior-ruby-mode-map "\C-c\C-p" 'comint-previous-prompt-2)
  (define-key inferior-ruby-mode-map "\C-c\C-n" 'comint-next-prompt-2)
  (define-key inferior-ruby-mode-map "\C-c\C-q" 'comint-delete-output/prompt)
  (define-key inferior-ruby-mode-map "\C-c\C-s" 'irbsh)
  (define-key inferior-ruby-mode-map "\C-c\C-k" 'irbsh-result-to-kill-ring)
  (define-key inferior-ruby-mode-map "\C-c " 'irbsh-setup-multi-line-mode)
  (define-key inferior-ruby-mode-map "\M-q" 'cmdline-stack-push)
  (define-key inferior-ruby-mode-map "\C-m" 'irbsh-send-input)
  (define-key inferior-ruby-mode-map "\C-i" 'irbsh-dynamic-complete)
  (define-key inferior-ruby-mode-map ruby-visit-irbsh-eval-list-key 'irbsh-visit-eval-list)
  (define-key inferior-ruby-mode-map ruby-irbsh-eval-list-load-and-eval-key 'ruby-irbsh-eval-list-load-and-eval)
  (irbsh-install-input-helper inferior-ruby-mode-map)

  (define-key inferior-ruby-mode-map "\C-\M-v" 'irbsh-scroll-other-window-script-buffer)
  (define-key inferior-ruby-mode-map "\C-\M-y" 'irbsh-scroll-other-window-script-buffer-down)
  ;; C-c 1 .. C-c 9: switch-to *irbsh*n buffer
  (when irbsh-nth-buffer-key-function
    (let ((i 1)
          (ed 9))
      (while (<= i ed)
        (define-key inferior-ruby-mode-map (funcall irbsh-nth-buffer-key-function i)
          `(lambda () (interactive) (irbsh-goto-nth ,i)))
        (setq i (1+ i)))))

  (run-hooks 'irbsh-startup-hook))

(defun irbsh-install-input-helper (map)
  (when irbsh-use-sigle-key-extension-flag
    (define-key map "\C-d" 'irbsh-ctrl-d)
    (define-key map "\C-e" 'irbsh-ctrl-e)
    )
  (define-key map "\C-c(" 'irbsh-prepare-parenthesis)
  (define-key map "\C-c{" 'irbsh-prepare-braces)
  (define-key map "\C-c[" 'irbsh-prepare-brackets)
  (define-key map "\C-c'" 'irbsh-prepare-single-quote)
  (define-key map "\C-c\"" 'irbsh-prepare-double-quote)
  (define-key map "\C-c\C-m" 'irbsh-system)
  (define-key map "\C-c\C-v" 'irbsh-prepare-sharp-braces)
)

(defun goto-irbsh ()
  "Switch to *irbsh* buffer"
  (interactive)
  (let ((fn (buffer-file-name)) irbsh-buf)
    (if (setq irbsh-buf (irbsh-find-ready-buffer))
        (switch-to-buffer irbsh-buf)
      (irbsh ruby-program-name))
    (comint-send-string (get-buffer-process (current-buffer))
                        (concat "def l; load '" fn "'; end;"
                                "'l:" fn "'\n"))))

(defun irbsh-goto-nth (n)
  (let ((bn (concat "*irbsh*" (int-to-string n))))
    (when (get-buffer bn)
      (switch-to-buffer bn))))

(defvar irbsh-eval-tmp-file "~/.irbsh_eval_tmp")

(defun irbsh-eval-buffer ()
  (interactive)
  (write-region (point-min) (point-max) irbsh-eval-tmp-file)
  (pop-to-buffer (irbsh-find-ready-buffer))
  (let ((s (concat "load '" irbsh-eval-tmp-file "'")))
    (message s)
    (irbsh-redirect-output s)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; eval list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar irbsh-eval-list-tmp-file "~/.irbsh_eval_list_tmp")

(defun irbsh-visit-eval-list ()
  (interactive)
  (let* ((script-win (irbsh-find-script-window))
         (script-buf (if script-win
                         (window-buffer script-win)
                       (get-buffer-create "*ruby scratch*"))))
    (irbsh-visit-eval-list-sub script-buf)))

(defvar irbsh-default-eval-list-buffer "*irbsh eval list*")

(defun irbsh-visit-eval-list-sub (script-buf)
  (let (eval-list-buf irbsh-buf)
    (unless (irbsh-find-ready-buffer)
      (irbsh-invoke-background))
    (setq irbsh-buf (irbsh-find-ready-buffer))
    (setq eval-list-buf (get-buffer irbsh-default-eval-list-buffer))
    (unless eval-list-buf
      (with-current-buffer (get-buffer-create irbsh-default-eval-list-buffer)
        (irbsh-eval-list-mode)
        (setq eval-list-buf (current-buffer))))
    (funcall irbsh-eval-list-arrange-window-function script-buf eval-list-buf irbsh-buf)
    (message (substitute-command-keys "type \\[ruby-irbsh-eval-list-load-and-eval] to eval eval-list."))))
    
(defvar irbsh-eval-list-arrange-window-function 'irbsh-eval-list-arrange-window:default)
; (setq irbsh-eval-list-arrange-window-function 'irbsh-eval-list-arrange-window:simple)
(defvar eval-list-win nil)

(defun irbsh-eval-list-arrange-window:default (script-buf eval-list-buf irbsh-buf)
  (if (and (get-buffer-window eval-list-buf)
           (get-buffer-window irbsh-buf))
      (select-window (get-buffer-window eval-list-buf))
    (delete-other-windows)
    (let ((win (split-window)) evali-list-win)
      (switch-to-buffer script-buf)
      (select-window win)
      (switch-to-buffer irbsh-buf)
      (setq eval-list-win (split-window-horizontally (- (window-width) ruby-irbsh-eval-list-width)))
      (select-window eval-list-win)
      (switch-to-buffer eval-list-buf))))

(defun irbsh-eval-list-arrange-window:simple (script-buf eval-list-buf irbsh-buf)
  (delete-other-windows)
  (let ((lower-window (split-window)))
    (switch-to-buffer eval-list-buf)
    (select-window lower-window)
    (switch-to-buffer irbsh-buf)
    (other-window 1)))

(defvar irbsh-eval-list-dynamic-complete-functions
  '(irbsh-dynamic-complete-bufname
    irbsh-dynamic-complete-filename
    irbsh-dynamic-complete-method
    
    ))

(define-derived-mode irbsh-eval-list-mode ruby-mode "irbsh[eval]"
  "Major mode for irbsh eval-list."
  (define-key irbsh-eval-list-mode-map "\C-c\C-c" 'irbsh-eval-list-exit)
  (define-key irbsh-eval-list-mode-map "\C-c\C-x" 'irbsh-eval-list-exit-and-eval)
  (define-key irbsh-eval-list-mode-map "\C-i" 'irbsh-dynamic-complete)
  (define-key irbsh-eval-list-mode-map [TAB] 'irbsh-dynamic-complete)
  (define-key irbsh-eval-list-mode-map "\C-c\C-m" 'irbsh-system)
  (define-key irbsh-eval-list-mode-map "\M-\C-v" 'irbsh-scroll-other-window-irbsh-buffer)
  (define-key irbsh-eval-list-mode-map "\M-\C-y" 'irbsh-scroll-other-window-irbsh-buffer-down)
  
  (irbsh-install-input-helper irbsh-eval-list-mode-map)
  (make-local-variable 'other-window-scroll-buffer)
  (make-local-variable 'comint-dynamic-complete-functions)
  (setq comint-dynamic-complete-functions irbsh-eval-list-dynamic-complete-functions)
  (setq other-window-scroll-buffer (window-buffer (irbsh-find-irbsh-window)))
  )

(defun irbsh-scroll-other-window-0 (buf func lines)
  (let ((other-window-scroll-buffer buf))
    (funcall func lines)))

(defun irbsh-scroll-other-window-script-buffer (lines)
  (interactive "P")
  (irbsh-scroll-other-window-0 (window-buffer (irbsh-find-script-window)) 'scroll-other-window lines))

(defun irbsh-scroll-other-window-script-buffer-down (lines)
  (interactive "P")
  (irbsh-scroll-other-window-0 (window-buffer (irbsh-find-script-window)) 'scroll-other-window-down lines))

(defun irbsh-scroll-other-window-irbsh-buffer (lines)
  (interactive "P")
  (irbsh-scroll-other-window-0 (window-buffer (irbsh-find-irbsh-window)) 'scroll-other-window lines))

(defun irbsh-scroll-other-window-irbsh-buffer-down (lines)
  (interactive "P")
  (irbsh-scroll-other-window-0 (window-buffer (irbsh-find-irbsh-window)) 'scroll-other-window-down lines))



(defun irbsh-eval-list-exit ()
  (interactive)
  (switch-to-buffer (cadr (buffer-list))))

(defun irbsh-eval-list-exit-and-eval ()
  (interactive)
  (write-region (point-min) (point-max) irbsh-eval-list-tmp-file)
  (irbsh-eval-list-exit)
  (let ((s (concat "irbsh_eval_eval_list '" irbsh-eval-list-tmp-file "'\n")))
    (comint-send-string (current-buffer) s)))
 
(defun irbsh-find-window-from-major-mode (mode)
  (let (x buf)
    (save-excursion
      (walk-windows (lambda (win)
                      (setq buf (window-buffer win))
                      (set-buffer buf)
                      (when (eq major-mode mode)
                        (setq x win)))))
    x))

(defun irbsh-find-script-window ()
  (irbsh-find-window-from-major-mode 'ruby-mode))

(defun irbsh-find-eval-list-window ()
  (irbsh-find-window-from-major-mode 'irbsh-eval-list-mode))

(defun irbsh-invoke-background ()
  (save-window-excursion
    (call-interactively 'irbsh))
  (message "Starting irbsh, wait for seconds....")
  (while (not (irbsh-find-ready-buffer))(sit-for 1))
  (message ""))

(defun irbsh-find-irbsh-window (&optional force)
  (let ((irbsh-win (irbsh-find-window-from-major-mode irbsh-major-mode))
        script-win irbsh-buf)
    (if (or irbsh-win (not force))
        irbsh-win
      (when (setq script-win (irbsh-find-script-window))
        (save-selected-window
          (select-window script-win)
          (if (setq irbsh-buf (irbsh-find-ready-buffer))
              (get-buffer-window (switch-to-buffer-other-window irbsh-buf))
            (if (one-window-p)
                (split-window))
            (irbsh-invoke-background)
            (display-buffer (irbsh-buffer))
            (irbsh-find-irbsh-window)))))))


(defvar irbsh-eval-list-beginning-position nil)

(defun ruby-irbsh-eval-list-load-and-eval (no-eval)
  (interactive "P")
  (let* ((script-win (irbsh-find-script-window))
         (script-buffer (and script-win (window-buffer script-win)))
         (load-arg "nil"))
    (save-excursion
      (when script-buffer
        (set-buffer script-buffer)
        (write-region (point-min) (point-max) irbsh-eval-tmp-file)
        (setq load-arg (concat "'" irbsh-eval-tmp-file "'")))
      (unless no-eval
        (set-buffer (get-buffer-create irbsh-default-eval-list-buffer))
        (if (zerop (buffer-size))
            (write-region (point) (point) irbsh-eval-list-tmp-file)
          (let ((content (buffer-string)))
            (with-temp-buffer
              (insert (irbsh-replace-meta-variables content))
              (unless (eq (char-before (point-max)) ?\n)
                (goto-char (point-max))
                (insert "\n"))
              (write-region (point-min) (point-max) irbsh-eval-list-tmp-file))))))
    (let* ((eval-arg (if no-eval "nil"
                       (concat "'" irbsh-eval-list-tmp-file "'")))
           (s (concat "irbsh_load_script_and_eval_eval_list " load-arg ", " eval-arg "\n"))
           (window (irbsh-find-irbsh-window t))
           (irbsh-buf (window-buffer window)))
      (set-buffer irbsh-buf)
      (setq irbsh-current-error-position nil)
      (setq irbsh-eval-list-beginning-position (point-max))
      (set-marker comint-last-input-end (point-max))
      (irbsh-delete-needless-lines)
      (comint-send-string irbsh-buf s)
      (irbsh-prompt-to-top-of-window window)
      (when script-buffer
        (message "loaded contents of %s" (buffer-name script-buffer))))))

;;;; ruby-mode -> eval-list
(defvar ruby-irbsh-eval-list-width 30)

(defun ruby-visit-irbsh-eval-list ()
  (interactive)
  (irbsh-visit-eval-list-sub (current-buffer)))


(defvar ruby-visit-irbsh-eval-list-key "\C-c\M-e")
(defvar ruby-irbsh-eval-list-load-and-eval-key "\C-c\C-z")
(defvar irbsh-next-error-key "\C-c`")

(defun ruby-irbsh-eval-list-setup ()
  (interactive)
  (define-key ruby-mode-map ruby-visit-irbsh-eval-list-key 'ruby-visit-irbsh-eval-list)
  (define-key ruby-mode-map ruby-irbsh-eval-list-load-and-eval-key 'ruby-irbsh-eval-list-load-and-eval)
  (define-key ruby-mode-map "\C-c\C-e" 'ruby-irbsh-eval-list-load-and-eval)
  (define-key ruby-mode-map irbsh-next-error-key 'irbsh-next-error)
  (define-key ruby-mode-map "\C-c\C-r" 'irbsh-show-output)
  )


; set-window-start
(defun irbsh-next-error (&optional argp)
  ""
  (interactive "P")
  (irbsh-goto-locus (irbsh-next-error-locus
                     ;; We want to pass a number here only if
                     ;; we got a numeric prefix arg, not just C-u.
                     (and (not (consp argp))
                          (prefix-numeric-value argp))
                     (consp argp))))



(defvar irbsh-current-error-position nil)
(defvar irbsh-next-error-locus-move-old 1) ;static variables

(defun irbsh-next-error-locus (&optional move restart)
  ""
  (when (or restart (null irbsh-current-error-position))
    (setq irbsh-current-error-position irbsh-eval-list-beginning-position))
  (setq move (or move 1))
  (when (< (* move irbsh-next-error-locus-move-old) 0)
    (setq move (if (< move 0) (1- move) (1+ move))))
  (setq irbsh-next-error-locus-move-old move)
  (save-excursion
    (set-buffer (window-buffer (irbsh-find-irbsh-window)))
    (goto-char irbsh-current-error-position)
    (cond ((re-search-forward
            (concat "^\\(\\|.+ \\)\\([^ :\n]*"
                    (regexp-quote (file-name-nondirectory irbsh-eval-tmp-file))
                    "\\):\\([0-9]*\\)")
            nil t move)
           (when (< (point) irbsh-eval-list-beginning-position)
             (goto-char irbsh-current-error-position)
             (error "No more errors"))
           (setq irbsh-current-error-position (point))
           (beginning-of-line)
           (set-window-start (irbsh-find-irbsh-window) (point))
           (string-to-int (match-string 3)))
          (t
           (error "No more errors")))))


(defun irbsh-goto-locus (err)
  ""
  (let* ((script-win (irbsh-find-script-window)))
    (select-window script-win)
    (goto-line err)))


(defun irbsh-show-output ()
  ""
  (interactive)
  (save-selected-window
    (select-window (irbsh-find-irbsh-window))
    (comint-show-output)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; oneliner
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar irbsh-oneliner-dynamic-complete-functions
  '(irbsh-dynamic-complete-bufname
    irbsh-dynamic-complete-dirname
    irbsh-dynamic-complete-command
    irbsh-dynamic-complete-filename
    irbsh-dynamic-complete-method
    
    ))

(defvar irbsh-in-oneliner nil)

(defun irbsh-oneliner (command &optional output-buffer)
  (interactive (list (read-from-minibuffer "Irbsh command: "
					   nil nil nil 'irbsh-command-history)
		     current-prefix-arg))
  (let ((input command)
        (irbsh-use-cd-without-quote-flag nil)
        (c0 (char-to-string 0))
        irbsh-in-oneliner irbsh-buf
        )
    (unless (irbsh-find-ready-buffer)
      (irbsh-invoke-background))
    (setq irbsh-in-oneliner  t
          irbsh-buf (irbsh-buffer))
    (setq input (irbsh-input-filter0 input))            ; input
    (setq command (concat "Irbsh.nopwd_output; begin; Irbsh.irbsh_cd(\"" default-directory  "\"){eval %q" c0 input c0 "}; ensure; Irbsh.enable_output; end"))
    (if (and output-buffer
             (not (or (bufferp output-buffer)  (stringp output-buffer))))
        (progn
          (setq output-buffer irbsh-tmp-buffer-name)
          (barf-if-buffer-read-only)
          (push-mark nil t)
          (goto-char (prog1 (mark t)
                       (set-marker (mark-marker) (point)
                                   (current-buffer))))
          (irbsh-redirect-output command t output-buffer)
          (insert-buffer-substring output-buffer))
      (unless output-buffer
        (setq output-buffer "*irbsh output*"))
      (get-buffer-create output-buffer)
      (with-current-buffer output-buffer
        (erase-buffer))
      (irbsh-redirect-output command t output-buffer)
      (irbsh-oneliner-display output-buffer))))

;; borrowed from shell-command-on-region in simple.el
(defun irbsh-oneliner-display (buffer)
  (let ((lines (save-excursion
                 (set-buffer buffer)
                 (goto-char (point-max))
                 (when (eq (char-before) ?\n) (delete-backward-char 1))
                 (if (= (buffer-size) 0)
                     0
                   (count-lines (point-min) (point-max))))))
    (cond ((= lines 0)
           (message "(Irbsh evaluation finished with no output)")
           (kill-buffer buffer))
          ((= lines 1)
           (message "%s"
                    (save-excursion
                      (set-buffer buffer)
                      (goto-char (point-min))
                      (buffer-substring (point)
                                        (progn (end-of-line) (point))))))
          (t 
           (save-excursion
             (set-buffer buffer)
             (goto-char (point-min)))
           (display-buffer buffer)))))  

(define-key esc-map "\"" 'irbsh-oneliner-with-completion)

(defun read-irbsh-command (prompt &optional init hist)
  ""
  (let ((keymap (copy-keymap minibuffer-local-map))
        (irbsh-in-oneliner t))
    (unwind-protect
        (progn
          (define-key minibuffer-local-map "\t"
            '(lambda ()
               (interactive)
               (irbsh-no-message-in-minibuffer
                (lambda ()
                  (run-hook-with-args-until-success 'irbsh-oneliner-dynamic-complete-functions)))))
          (define-key minibuffer-local-map "\C-m"
            (lambda ()
              (interactive)
              (and irbsh-strip-last-comma-flag (irbsh-strip-last-comma))
              (exit-minibuffer)))
          (irbsh-install-input-helper minibuffer-local-map)
          (read-from-minibuffer prompt
                                init nil nil
                                (or hist 'irbsh-command-history)))
      (setq minibuffer-local-map keymap))))
  
(defun irbsh-oneliner-with-completion (command &optional output-buffer)
  ""
  (interactive
   (let* ((keymap (copy-keymap minibuffer-local-map))
	  (string (read-irbsh-command
                   (format "Irbsh command [%s]: " (substring default-directory 0 -1)))))
     (list string
           current-prefix-arg)))
  (irbsh-oneliner command output-buffer))

(defadvice message (around no-message-in-minibuffer)
  ""
  (unless (window-minibuffer-p (selected-window))
    ad-do-it))

(defun irbsh-no-message-in-minibuffer (func)
  (ad-enable-advice 'message 'around 'no-message-in-minibuffer)
  (ad-activate 'message)
  (funcall func)
  (ad-disable-advice 'message 'around 'no-message-in-minibuffer)
  (ad-activate 'message))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; edit with yaml
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar irbsh-buffer nil)

(defvar irbsh-edit-yaml-file nil)
(defun irbsh-edit-object (yaml-filename)
  (let ((buf (get-buffer-create "*irbsh edit object*"))
        (map (make-sparse-keymap))
        (irbsh (irbsh-buffer)))
    (switch-to-buffer buf)
    (set (make-local-variable 'irbsh-buffer) irbsh)
    (setq irbsh-edit-yaml-file yaml-filename)
    (erase-buffer)
    (insert-file-contents yaml-filename)
    (define-key map "\C-c\C-c" 'irbsh-edit-finish)
    (use-local-map map)
    )
  "editing object..."
  )

(defun irbsh-edit-finish ()
  (interactive)
  (write-region (point-min) (point-max) irbsh-edit-yaml-file)
  (message "")
  (bury-buffer (current-buffer))
  (irbsh-input-sender irbsh-buffer "")
  (switch-to-buffer irbsh-buffer))

(provide 'irbsh)
