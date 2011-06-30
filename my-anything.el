;;
;;
;; anything
;;
;;
;; TODO
;; прикрутить поиск файлок в проекте, project-root.el
;; https://github.com/wolfmanjm/anything-on-rails

;; Хорошие примеры по добавлению своих источников http://www.emacswiki.org/emacs/RubikitchAnythingConfiguration

(require 'anything)
(require 'anything-config)

; ruby
; (require 'anything-etags)
(require 'anything-match-plugin)

;; Проблемы с загрузкой ruby-compilation
(setq load-path (cons "~/.emacs.d/anything-on-rails" load-path))
(require 'anything-rails)
(global-set-key (kbd "M-.") 'anything-etags-select-from-here)

;;    *If non-nil, use separate source file by file.
;(setq anything-gtags-classify t)

(setq anything-candidate-separator
      "------------------------------------------------------------------------------------")

(setq anything-c-adaptive-history-file "~/.emacs.tmp/anything-c-adaptive-history")

(global-set-key (kbd "M-z") 'anything)



;(require 'anything-gtags)

; (require 'anything-etags)

; (require 'anything-imenu)
;(require 'anything-git)
; (require 'anything-rake)

(setq anything-sources
      (list
       anything-c-source-fixme
       anything-c-source-buffers+
       anything-c-source-rails-project-files
       anything-c-source-file-cache
       anything-c-source-files-in-current-dir+
       ; anything-c-source-git-project-files
       ; anything-c-source-bookmarks
       anything-c-source-recentf
                                        ; anything-c-source-imenu    ; набо бы тоже узнать клавишу :)
                                        ;           anything-c-source-etags-select
                                        ; anything-c-source-rake-task
                                        ; anything-c-source-gtags-select ; Use M-.

                                        ;            anything-c-source-git-project-files

                                        ; anything-c-source-file-name-history ;тут больше чем в recentf но никогда не пользуюсь ими
                                        ;anything-c-source-locate  - как бы сделать отдельный поиск по locate

                                        ;anything-c-source-buffers
                                        ;anything-c-source-info-pages
                                        ;anything-c-source-man-pages
                                        ;anything-c-source-emacs-commands
))



