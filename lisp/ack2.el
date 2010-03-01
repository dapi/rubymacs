;; ack.el
;; With credit to w32-find-dired.el
 
;; Copyright (C) 2008 Kim van Wyk and Johan Kohler
 
;; This file is not currently part of GNU Emacs.
 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.
 
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
 
(require 'compile)
(require 'thingatpt)
 
(defvar ack-command "ack" "The command run by the ack function.")
 
(defvar ack-mode-font-lock-keywords
  '(("^\\(Compilation\\|Ack\\) started.*"
     (0 '(face nil message nil help-echo nil mouse-face nil) t))))
 
(defvar ack-use-search-in-buffer-name t
  "If non-nil, use the search string in the ack buffer's name.")
 
(define-compilation-mode ack-mode "Ack"
  "Specialization of compilation-mode for use with ack."
  nil)
;;; ack.el --- Use ack where you might usually use grep.

;; Copyright (C) 2008 Philip Jackson

;; Author: Philip Jackson <phil@shellarchive.co.uk>
;; Version: 0.1

;; This file is not currently part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program ; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; ack.el provides a simple compilation mode for the perl grep-a-like
;; ack (http://petdance.com/ack/).

;; If `ack-guess-type' is non-nil and `ack-mode-type-map' has a
;; reasonable value then ack.el will try and guess what you would like
;; in the --type argument for ack.

;; To install/use put ack.el in your load-path and (require 'ack) in
;; your initialisation file. You can then M-x ack and you're off.

(require 'compile)

(defvar ack-guess-type t
  "Setting this value to `t' will have `ack' do its best to fill
in the --type argument to the ack command")

(defvar ack-mode-type-map
  '(((c++-mode) . "cpp")
    ((c-mode) . "cc")
    ((css-mode) . "css")
    ((emacs-lisp-mode) . "elisp")
    ((fortran-mode) . "fortran")
    ((html-mode) . "html")
    ((xml-mode nxml-mode) . "xml")
    ((java-mode) . "java")
    ((lisp-mode) . "lisp")
    ((perl-mode cperl-mode yaml-mode) . "perl"))
  "alist describing how to fill in the '--type=' argument to ack")

(defun ack-find-type-for-mode ()
  (catch 'found
    (dolist (mode-type ack-mode-type-map)
      (when (member major-mode (car mode-type))
        (throw 'found (cdr mode-type))))))

(defun ack-build-command ()
  (let ((type (ack-find-type-for-mode)))
    (concat ack-command
            (when (and ack-guess-type type)
              (concat "--type=" type)) " ")))

(defvar ack-command "ack --nocolor --nogroup "
  "The command to be run by the ack function.")

(define-compilation-mode ack-mode "Ack"
  "Ack compilation mode."
  nil)

;;;###autoload
(defun ack (command-args)
  (interactive
   (list (read-shell-command "Run ack (like this): "
                             (ack-build-command)
                             'ack-history
                             nil)))
  (compilation-start command-args 'ack-mode))

(provide 'ack)
