(require 'helm-ag)
(setq helm-ag-insert-at-point 'symbol)

(setq helm-ag-base-command "ag")
(setq helm-ag-command-option "--smart-case")
;;

(defun kjoh/helm-ag (&optional n)
  (interactive "p")
  (if (> n 1)
      (helm-ag)
    (if (projectile-project-root)
        (helm-ag (projectile-project-root))
      ;; otherwise fallback to `helm-mini'
      (helm-ag))))

;; keybindings
(add-hook 'prelude-mode-hook
          (lambda ()
            (define-key prelude-mode-map (kbd "C-c g") 'kjoh/helm-ag)
            (define-key prelude-mode-map (kbd "C-c C-g") 'kjoh/helm-ag)))
