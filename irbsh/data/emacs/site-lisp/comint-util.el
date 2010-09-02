;;; comint-util.el --- comint.el little add-on

;; Copyright (C) 2001 rubikitch

;; $Id: comint-util.el 372 2002-09-05 20:52:13Z rubikitch $
;; Author:  rubikitch <rubikitch@ruby-lang.org>
;; Created: [2001/11/18]
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



(defun comint-ctrl-p ()
  (interactive)
  (call-interactively (if (= (point) (point-max))
                          'comint-previous-input
                        'previous-line)))

(defun comint-ctrl-n ()
  (interactive)
  (call-interactively (if (= (point) (point-max))
                          'comint-next-input
                        'next-line)))


(defun comint-delete-output/prompt ()
  "Delete all output and prompt from interpreter since last input."
  (interactive)
  (let (beg)
    (save-excursion
    (comint-previous-prompt 1)
    (move-to-column 0)
    (setq beg (point))
    (comint-next-prompt 2)
    (move-to-column 0)
    (delete-region beg (point))
    (comint-show-maximum-output))))

  
(defun comint-bol-2 ()
  "Goto beginning of prompt/line."
  (interactive)
  (forward-line 0)
  (if (and (looking-at comint-prompt-regexp)
           (not (eq last-command 'comint-bol-2)))
      (comint-goto-process-mark)))


(defun comint-next-prompt-2 (n)
  "A better `comint-next-prompt'."
  (interactive "p")
  (let ((col (current-column)))
    (cond ((eq col 0)
           (forward-line (/ n (abs n)))
           (comint-next-prompt n)
           (forward-line 0))
          (t
           (comint-next-prompt n)))))

(defun comint-previous-prompt-2 (n)
  "A better `comint-previous-prompt'."
  (interactive "p")
  (comint-next-prompt-2 (- n)))

(provide 'comint-util)
