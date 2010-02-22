;;; For imwheel
;
;
;

(setq imwheel-scroll-interval 3)
(defun imwheel-scroll-down-some-lines ()
  (interactive)
  (scroll-down imwheel-scroll-interval))
(defun imwheel-scroll-up-some-lines ()
  (interactive)
  (scroll-up imwheel-scroll-interval))



(setq scroll-step 1)
(global-hl-line-mode 1)

;(iswitchb-mode 1)
(global-set-key [(control meta \))] 'imwheel-scroll-up-some-lines)
(global-set-key [(control meta \()] 'imwheel-scroll-down-some-lines)

(global-set-key [(mouse-4)] 'scroll-down)
(global-set-key [(mouse-5)] 'scroll-up)
(global-set-key [(mouse-5)] 'scroll-up)
