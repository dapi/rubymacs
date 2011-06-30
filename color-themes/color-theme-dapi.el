;; (require 'color-theme)
;; (color-theme-initialize)
;; (load-file "~/.emacs.d/color-theme-dapi.el")
;;
;; And then (color-theme-dapi) to activate it.


(eval-when-compile    (require 'color-theme))
(defun color-theme-dapi ()
  "Light on dark color theme by Danil Pismenny, based on the dreams, created 2011-06-29."
  (interactive)
  (color-theme-install
   '(color-theme-dapi
     ((background-color . "#061010")
      (background-mode . dark)
      (border-color . "red")
      (cursor-color . "red")
      (foreground-color . "#d8d09c")
      (mouse-color . "white"))
     ;; (;(cua-global-mark-cursor-color . "cyan")
      ;; (cua-normal-cursor-color . "red")
      ;; (cua-overwrite-cursor-color . "yellow")
      ;; (cua-read-only-cursor-color . "darkgreen")
      ;; (hl-line-face . hl-line)
      ;; (ibuffer-deletion-face . font-lock-type-face)
      ;; (ibuffer-filter-group-name-face . bold)
      ;; (ibuffer-marked-face . font-lock-warning-face)
      ;; (ibuffer-title-face . font-lock-type-face)
      ;; (list-matching-lines-buffer-name-face . underline)
      ;; (list-matching-lines-face . match)
      ;; (ns-use-system-highlight-color . t)
      ;; (view-highlight-face . highlight)
      ;; (viper-replace-overlay-cursor-color . "red4")
      ;; (widget-mouse-face . highlight))
     (default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "apple" :family "DejaVu_Sans_Mono"))))
     (aquamacs-variable-width ((t (:stipple nil :strike-through nil :underline nil :slant normal :weight normal :height 120 :width normal :family "Lucida Grande"))))
     (autoface-default ((t (:family "DejaVu_Sans_Mono" :foundry "apple" :width normal :weight normal :slant normal :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :foreground "#d8d09c" :background "#061010" :stipple nil :height 130))))
     (blank-newline ((t (:foreground "lightgrey" :weight normal))))
     (bold ((t (:bold t :weight bold))))
     (bold-italic ((t (:italic t :bold t :slant italic :weight bold))))
     (border ((t (:background "red"))))
     (buffer-menu-buffer ((t (nil))))
     (button ((t (:underline t))))
     (completion-list-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "apple" :family "DejaVu_Sans_Mono" :height 130))))
     (completions-annotations ((t (:italic t :slant italic))))
     (completions-common-part ((t (:family "DejaVu_Sans_Mono" :foundry "apple" :width normal :weight normal :slant normal :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :foreground "#d8d09c" :background "#061010" :stipple nil :height 130))))
     (completions-first-difference ((t (:bold t :weight bold))))
     (cua-global-mark ((t (:background "yellow1" :foreground "black"))))
     (cua-rectangle ((t (:background "maroon" :foreground "white"))))
     (cua-rectangle-noselect ((t (:background "dimgray" :foreground "white"))))
     (cursor ((t (:background "red"))))
     (custom-button ((t (:background "lightgrey" :foreground "black" :box (:line-width 2 :style released-button)))))
     (custom-button-mouse ((t (:background "grey90" :foreground "black" :box (:line-width 2 :style released-button)))))
     (custom-button-pressed ((t (:background "lightgrey" :foreground "black" :box (:line-width 2 :style pressed-button)))))
     (custom-button-pressed-unraised ((t (:underline t :foreground "violet"))))
     (custom-button-unraised ((t (:underline t))))
     (custom-changed ((t (:background "blue1" :foreground "white"))))
     (custom-comment ((t (:background "dim gray"))))
     (custom-comment-tag ((t (:foreground "gray80"))))
     (custom-documentation ((t (nil))))
     (custom-face-tag ((t (:family "Sans Serif" :height 0.8))))
     (custom-group-tag ((t (:foreground "light blue"))))
     (custom-group-tag-1 ((t (:family "Sans Serif" :foreground "pink"))))
     (custom-invalid ((t (:background "red1" :foreground "yellow1"))))
     (custom-link ((t (:underline t :foreground "cyan1"))))
     (custom-modified ((t (:background "blue1" :foreground "white"))))
     (custom-rogue ((t (:background "black" :foreground "pink"))))
     (custom-saved ((t (:underline t))))
     (custom-set ((t (:background "white" :foreground "blue1"))))
     (custom-state ((t (:foreground "lime green"))))
     (custom-themed ((t (:background "blue1" :foreground "white"))))
     (custom-variable-button ((t (:bold t :underline t :weight bold))))
     (custom-variable-tag ((t (:bold t :family "Sans Serif" :foreground "light blue" :weight bold :height 0.8))))
     (custom-visibility ((t (:underline t :foreground "cyan1" :height 0.8))))
     (echo-area ((t (:stipple nil :strike-through nil :underline nil :slant normal :weight normal :width normal :family "Lucida Grande"))))
     (emacs-lisp-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "apple" :family "DejaVu_Sans_Mono" :height 130))))
     (epa-field-body ((t (:italic t :foreground "turquoise" :slant italic))))
     (epa-field-name ((t (:bold t :foreground "PaleTurquoise" :weight bold))))
     (epa-mark ((t (:bold t :foreground "orange" :weight bold))))
     (epa-string ((t (:foreground "lightyellow"))))
     (epa-validity-disabled ((t (:italic t :slant italic))))
     (epa-validity-high ((t (:bold t :foreground "PaleTurquoise" :weight bold))))
     (epa-validity-low ((t (:italic t :slant italic))))
     (epa-validity-medium ((t (:italic t :foreground "PaleTurquoise" :slant italic))))
     (escape-glyph ((t (:foreground "cyan"))))
     (file-name-shadow ((t (:foreground "grey70"))))
     (fixed-pitch ((t (:family "Monospace"))))
     (font-lock-builtin-face ((t (:foreground "LightSteelBlue"))))
     (font-lock-comment-delimiter-face ((t (:foreground "chocolate1"))))
     (font-lock-comment-face ((t (:foreground "chocolate1"))))
     (font-lock-constant-face ((t (:foreground "Aquamarine"))))
     (font-lock-doc-face ((t (:foreground "LightSalmon"))))
     (font-lock-function-name-face ((t (:foreground "LightSkyBlue"))))
     (font-lock-keyword-face ((t (:foreground "Cyan1"))))
     (font-lock-negation-char-face ((t (nil))))
     (font-lock-preprocessor-face ((t (:foreground "LightSteelBlue"))))
     (font-lock-regexp-grouping-backslash ((t (:bold t :weight bold))))
     (font-lock-regexp-grouping-construct ((t (:bold t :weight bold))))
     (font-lock-string-face ((t (:foreground "LightSalmon"))))
     (font-lock-type-face ((t (:foreground "PaleGreen"))))
     (font-lock-variable-name-face ((t (:foreground "LightGoldenrod"))))
     (font-lock-warning-face ((t (:bold t :foreground "Pink" :weight bold))))
     (fringe ((t (:foreground "grey55"))))
     (fundamental-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "apple" :family "DejaVu_Sans_Mono" :height 130))))
     (header-line ((t (:italic t :family "DejaVu_Sans_Mono" :foundry "apple" :width normal :weight normal :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :background "#061010" :stipple nil :foreground "grey70" :slant oblique :height 130))))
     (help-argument-name ((t (:italic t :slant italic))))
     (help-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "apple" :family "DejaVu_Sans_Mono" :height 130))))
     (highlight ((t (:background "#202a2a"))))
     (hl-line ((t (:background "#202a2a"))))
     (ibuffer-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "apple" :family "DejaVu_Sans_Mono" :height 130))))
     (isearch ((t (:background "palevioletred2" :foreground "brown4"))))
     (isearch-fail ((t (:background "red4"))))
     (iswitchb-current-match ((t (:foreground "LightSkyBlue"))))
     (iswitchb-invalid-regexp ((t (:bold t :weight bold :foreground "Pink"))))
     (iswitchb-single-match ((t (:foreground "chocolate1"))))
     (iswitchb-virtual-matches ((t (:foreground "LightSteelBlue"))))
     (italic ((t (:italic t :slant italic))))
     (latex-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :foundry "apple" :stipple nil :strike-through nil :underline nil :slant normal :weight normal :height 130 :width normal :family "Lucida Grande"))))
     (lazy-highlight ((t (:background "paleturquoise4"))))
     (link ((t (:foreground "cyan1" :underline t))))
     (link-visited ((t (:underline t :foreground "violet"))))
     (match ((t (:background "RoyalBlue3"))))
     (menu ((t (nil))))
     (minibuffer ((t (:family "Lucida Grande" :width normal :weight normal :slant normal :underline nil :strike-through nil :stipple nil))))
     (minibuffer-prompt ((t (:stipple nil :strike-through nil :underline nil :slant normal :weight normal :width normal :family "Lucida Grande" :foreground "cyan"))))
     (mode-line ((t (:family "Lucida Grande" :underline nil :strike-through nil :stipple nil :background "red4" :foreground "gray90" :box (:line-width -1 :style released-button) :strike-through nil :underline nil :slant normal :weight normal :width normal :height 120))))
     (mode-line-buffer-id ((t (:bold t :weight bold))))
     (mode-line-emphasis ((t (:bold t :weight bold))))
     (mode-line-flags ((t (:family "Monaco"))))
     (mode-line-highlight ((t (:background "red"))))
     (mode-line-inactive ((t (:family "Lucida Grande" :underline nil :strike-through nil :stipple nil :background "grey40" :foreground "black" :box (:line-width -1 :color "grey75" :style nil) :strike-through nil :underline nil :slant normal :weight normal :width normal :height 120))))
     (mouse ((t (:background "white"))))
     (next-error ((t (:foreground "black" :background "gray40"))))
     (nobreak-space ((t (:foreground "cyan" :underline t))))
     (notify-user-of-mode ((t (:foreground "cyan"))))
     (ns-working-text-face ((t (:underline t))))
     (org-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :foundry "apple" :stipple nil :strike-through nil :underline nil :slant normal :weight normal :height 120 :width normal :family "Monaco"))))
     (query-replace ((t (:foreground "brown4" :background "palevioletred2"))))
     (region ((t (:background "gray40" :foreground "black"))))
     (ruby-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "apple" :family "DejaVu_Sans_Mono" :height 130))))
     (scroll-bar ((t (nil))))
     (secondary-selection ((t (:background "SkyBlue4"))))
     (shadow ((t (:foreground "grey70"))))
     (show-paren-match ((t (:bold t :foreground "white" :weight bold))))
     (show-paren-mismatch ((t (:background "purple" :foreground "white"))))
     (text-mode-default ((t (:stipple nil :background "#061010" :foreground "#d8d09c" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :foundry "apple" :stipple nil :strike-through nil :underline nil :slant normal :weight normal :height 130 :width normal :family "Lucida Grande"))))
     (tool-bar ((t (:background "grey75" :foreground "black" :box (:line-width 1 :style released-button)))))
     (tooltip ((t (:family "Sans Serif" :background "lightyellow" :foreground "black"))))
     (trailing-whitespace ((t (:background "red1"))))
     (underline ((t (:underline t))))
     (variable-pitch ((t (:family "Sans Serif"))))
     (vertical-border ((t (nil))))
     (widget-button ((t (:family "DejaVu_Sans_Mono" :foundry "apple" :weight normal :slant normal :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :background "#061010" :stipple nil :foreground "gray80" :width condensed :height 130))))
     (widget-button-pressed ((t (:width condensed :stipple nil :background "#061010" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :foundry "apple" :family "DejaVu_Sans_Mono" :foreground "red1" :height 130))))
     (widget-documentation ((t (:foreground "lime green"))))
     (widget-field ((t (:background "dim gray"))))
     (widget-inactive ((t (:foreground "grey70"))))
     (widget-single-line-field ((t (:background "dim gray")))))))

(add-to-list 'color-themes '(color-theme-dapi  "dapi" "Danil Pismenny"))

(provide 'color-theme-dapi)
