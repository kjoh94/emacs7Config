(setq bm-restore-repository-on-load t)
(require 'bm)

(setq bm-priority 1000)
(setq bm-highlight-style 'bm-highlight-only-fringe)
;;(setq bm-highlight-style 'bm-highlight-only-line)

(setq-default bm-buffer-persistence t)
(add-hook 'after-init-hook 'bm-load-and-restore)
(add-hook 'kill-emacs-hook 'bm-save)


(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)

(custom-theme-set-faces
   'darkburn
;;;;; bm
   `(bm-fringe-face ((t (:foreground "white" :background "blue"))))
   `(bm-fringe-persistent-face ((t (:foreground "white" :background "cyan")))))
