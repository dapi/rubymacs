
;;
;;
;;
;; iswitchb-mode
;;
;; интерактивная фигня для быстрого переключения ‘C-x b’
(iswitchb-mode 1)

(defun iswitchb-local-keys ()
  (mapc (lambda (K)
	      (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
	    '(("<right>" . iswitchb-next-match)
	      ("<left>"  . iswitchb-prev-match)
	      ("<up>"    . ignore             )
	      ("<down>"  . ignore             ))))

(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)
;(setq iswitchb-buffer-ignore '("^ " "*"))
(add-to-list 'iswitchb-buffer-ignore "^ ")
(add-to-list 'iswitchb-buffer-ignore "^*")
;; (add-to-list 'iswitchb-buffer-ignore "*Messages*")
;; (add-to-list 'iswitchb-buffer-ignore "*ECB")
;; (add-to-list 'iswitchb-buffer-ignore "*Buffer")
;; (add-to-list 'iswitchb-buffer-ignore "*WoMan")
;; (add-to-list 'iswitchb-buffer-ignore "*Completions")
;; (add-to-list 'iswitchb-buffer-ignore "*ftp ")
;; (add-to-list 'iswitchb-buffer-ignore "*bsh")
;; (add-to-list 'iswitchb-buffer-ignore "*jde-log")
;; (add-to-list 'iswitchb-buffer-ignore "*file")
(add-to-list 'iswitchb-buffer-ignore "^[tT][aA][gG][sS]$")

