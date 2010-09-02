;;; cmdline-stack.el --- zsh like command-line stack

;; Copyright (C) 2001 rubikitch

;; $Id: cmdline-stack.el 264 2001-11-20 02:23:42Z rubikitch $
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



(require 'comint)
(defvar cmdline-stack-stack nil)
(make-variable-buffer-local 'cmdline-stack-stack)

(defun cmdline-stack-push ()
  (interactive)
  (setq cmdline-stack-stack
        (cons (let* ((pt (point))
                     (bol (comint-bol-or-process-mark))
                     (str (buffer-substring bol (point-max)))
                     (diff (- (point-max) pt)))
                (delete-region bol (point-max))
                (cons str diff))
              cmdline-stack-stack)))

(defun cmdline-stack-pop ()
  (interactive)
  (comint-send-input)
  (cmdline-stack-pop0))

(defun cmdline-stack-pop0 ()
  (let* ((top (car cmdline-stack-stack))
         (str (car top))
         (diff (cdr top)))
    (and top (progn
               (insert str)
               (backward-char diff)
               (setq cmdline-stack-stack (cdr cmdline-stack-stack))))))

(provide 'cmdline-stack)
