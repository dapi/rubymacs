(setq irbsh-continuing-prompt-pattern
      "^irb.*(.*)[0-9:]+\\* ")
(With-current-buffer "*irbsh*2"
  (looking-at irbsh-continuing-prompt-pattern))

(with-current-buffer "test"
  (goto-char 0)
  (re-search-forward irbsh-continuing-prompt-pattern nil t))


(with-current-buffer "*irbsh*2"
  (irbsh-search-command-line-string))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
        (irbsh-setup-multi-line-mode cmdline t t)
        (irbsh-multi-line-delete-output/prompt)
        ))
    (when (string-match irbsh-pwd-regexp str)
      (cd (match-string 1 str)))
    (when (string-match inferior-ruby-first-prompt-pattern str)
      (setq irbsh-prompt-self (match-string 1 str)))))
