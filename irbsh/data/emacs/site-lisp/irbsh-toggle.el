;;; irbsh-toggle.el --- Toggle to and from the *irbsh*1 buffer
;;; Version 1.2 - 98-11-19
;;; Copyright (C) 1997, 1998 Mikael Sjödin (mic@docs.uu.se)
;;;
;;;  Author: Mikael Sjödin  --  mic@docs.uu.se
;;; Revised: rubikitch  --  rubikitch@ruby-lang.org
;;;
;;; This file is NOT part of GNU Emacs.
;;; You may however redistribute it and/or modify it under the terms of the GNU
;;; General Public License as published by the Free Software Foundation; either
;;; version 2, or (at your option) any later version.
;;;
;;; The file is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; ----------------------------------------------------------------------
;;; Description:
;;;
;;; Provides the command irbsh-toggle which toggles between the
;;; *irbsh*1 buffer and whatever buffer you are editing.
;;;
;;; This is done in an "intelligent" way.  Features are:
;;; o Starts a irbsh if non is existing.
;;; o Minimum distortion of your window configuration.
;;; o When done in the irbsh-buffer you are returned to the same window
;;;   configuration you had before you toggled to the irbsh.
;;; o If you desire, you automagically get a "cd" command in the irbsh to the
;;;   directory where your current buffers file exists; just call
;;;   irbsh-toggle-cd instead of irbsh-toggle.
;;; o You can convinently choose if you want to have the irbsh in another
;;;   window or in the whole frame.  Just invoke irbsh-toggle again to get the
;;;   irbsh in the whole frame.
;;;
;;; This file has been tested under Emacs 20.2.
;;;
;;; This file can be obtained from http://www.docs.uu.se/~mic/emacs.html
;;; (Rubikitch only replaced `shell' with `irbsh')

;;; ----------------------------------------------------------------------
;;; Installation:
;;;
;;; o Place this file in a directory in your 'load-path.
;;; o Put the following in your .emacs file:
;;;   (autoload 'irbsh-toggle "irbsh-toggle" 
;;;    "Toggles between the *irbsh*1 buffer and whatever buffer you are editing."
;;;    t)
;;;   (autoload 'irbsh-toggle-cd "irbsh-toggle" 
;;;    "Pops up a irbsh-buffer and insert a \"cd <file-dir>\" command." t)
;;;   (global-set-key [M-f1] 'irbsh-toggle)
;;;   (global-set-key [C-f1] 'irbsh-toggle-cd)
;;; o Restart your Emacs.  To use irbsh-toggle just hit M-f1 or C-f1
;;;
;;; For a list of user options look in code below.
;;;

;;; ----------------------------------------------------------------------
;;; BUGS:
;;;  No reported bugs as of today

;;; ----------------------------------------------------------------------
;;; Thanks to:
;;;   Christian Stern <Christian.Stern@physik.uni-regensburg.de> for helpful
;;;   sugestions.

;;; ======================================================================
;;; User Options:

(defvar irbsh-toggle-goto-eob t
  "*If non-nil `irbsh-toggle' will move point to the end of the irbsh-buffer
whenever the `irbsh-toggle' switched to the irbsh-buffer.

When `irbsh-toggle-cd' is called the point is allways moved to the end of the
irbsh-buffer")

(defvar irbsh-toggle-automatic-cd t
  "*If non-nil `irbsh-toggle-cd' will send the \"cd\" command to the irbsh.
If nil `irbsh-toggle-cd' will only insert the \"cd\" command in the 
irbsh-buffer.  Leaving it to the user to press RET to send the command to 
the irbsh.")

;;; ======================================================================
;;; Commands:

(defun irbsh-toggle-cd ()
  "Calls `irbsh-toggle' with a prefix argument.  Se command `irbsh-toggle'"
  (interactive)
  (irbsh-toggle t))

(defun irbsh-toggle (make-cd)
  "Toggles between the *irbsh*1 buffer and whatever buffer you are editing.
With a prefix ARG also insert a \"cd DIR\" command into the irbsh, where DIR is
the directory of the current buffer.

Call twice in a row to get a full screen window for the *irbsh*1 buffer.

When called in the *irbsh*1 buffer returns you to the buffer you were editing
before caling the first time.

Options: `irbsh-toggle-goto-eob'"
  (interactive "P")
  ;; Try to descide on one of three possibilities:
  ;; If not in irbsh-buffer, switch to it.
  ;; If in irbsh-buffer and called twice in a row, delete other windows
  ;; If in irbsh-buffer and not called twice in a row, return to state before
  ;;  going to the irbsh-buffer 
  (if (eq major-mode irbsh-major-mode)
      (if (and (or (eq last-command 'irbsh-toggle)
		   (eq last-command 'irbsh-toggle-cd))
	       (not (eq (count-windows) 1)))
	  (delete-other-windows)
	(irbsh-toggle-buffer-return-from-irbsh))
    (irbsh-toggle-buffer-goto-irbsh make-cd)))

;;; ======================================================================
;;; Internal functions and declarations

(defvar irbsh-toggle-pre-irbsh-win-conf nil
  "Contains the window configuration before the *irbsh*1 buffer was selected")



(defun irbsh-toggle-buffer-return-from-irbsh ()
  "Restores the window configuration used before switching the *irbsh*1 buffer.
If no configuration has been stored, just burry the *irbsh*1 buffer."
  (if (window-configuration-p irbsh-toggle-pre-irbsh-win-conf)
      (progn
	(set-window-configuration irbsh-toggle-pre-irbsh-win-conf)
	(setq irbsh-toggle-pre-irbsh-win-conf nil)
	(bury-buffer (get-buffer "*irbsh*1")))
    (bury-buffer))
  )


(defvar  irbsh-toggle-cygwin-irbsh nil)
(defun cygwin-convert-file-name ( name )
  "Convert file NAME, to cygwin format.
`x:/' to `/cygdrive/x/'.
NOTE: \"/cygdrive/\" is only an example for the cygdrive-prefix \(see
`cygwin-mount-cygdrive-prefix--internal')."
  (let ((cygdrive-prefix-len (length cygwin-mount-cygdrive-prefix--internal)))
    (save-match-data
      (cond ((eq irbsh-toggle-cygwin-irbsh nil) name)
          ((string-match "^[a-zA-Z]:/" name)
           (concat  (cygwin-mount-get-cygdrive-prefix) (substring name 0 1)  (substring name 2)))
            (t name)) )))


(defun irbsh-toggle-buffer-goto-irbsh (make-cd)
  "Switches other window to the *irbsh*1 buffer.  If no *irbsh*1 buffer exists
start a new irbsh and switch to it in other window.  If argument MAKE-CD is
non-nil, insert a \"cd DIR\" command into the irbsh, where DIR is the directory
of the current buffer.

Stores the window cofiguration before creating and/or switching window."
  (setq irbsh-toggle-pre-irbsh-win-conf (current-window-configuration))
  (let ((irbsh-buffer (get-buffer "*irbsh*1"))
	(cd-command
	 ;; Find out which directory we are in (the method differs for
	 ;; different buffers)
	 (or (and make-cd 
		  (buffer-file-name)
		  (file-name-directory (buffer-file-name))
		  (concat " cd " (file-name-directory (buffer-file-name))))
	     (and make-cd
		  list-buffers-directory
		  (concat " cd " list-buffers-directory)))))

    ;; Switch to an existin irbsh if one exists, otherwise switch to another
    ;; window and start a new irbsh
    (if irbsh-buffer
	(switch-to-buffer-other-window irbsh-buffer)
      (irbsh-toggle-buffer-switch-to-other-window)
      ;; Sometimes an error is generated when I call `irbsh'
      ;; (it has to do with my irbsh-mode-hook which inserts text into the
      ;; newly created irbsh-buffer and thats not allways a good idea).
      (condition-case the-error
	  (progn
            (call-interactively 'irbsh)
            (sit-for 2))
	(error (switch-to-buffer "*irbsh*1"))))
    (if (or cd-command irbsh-toggle-goto-eob)
	(goto-char (point-max)))
    (if cd-command
	(progn
	  (insert cd-command)
	  (if irbsh-toggle-automatic-cd
	      (comint-send-input))
	  ))))

(defun irbsh-toggle-buffer-switch-to-other-window ()
  "Switches to other window.  If the current window is the only window in the
current frame, create a new window and switch to it.

\(This is less intrusive to the current window configuration then 
`switch-buffer-other-window')"
  (let ((this-window (selected-window)))
    (other-window 1)
    ;; If we did not switch window then we only have one window and need to
    ;; create a new one.
    (if (eq this-window (selected-window))
	(progn
	  (split-window-vertically)
          (other-window 1)))))

    
(provide 'irbsh-toggle)
