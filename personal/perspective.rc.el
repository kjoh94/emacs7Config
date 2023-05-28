(require 'perspective)

(add-hook 'persp-mode-hook
          (lambda ()
            (define-key persp-mode-map (kbd "C-x RET") 'persp-switch)))



(defun persp-init ()
  (interactive)

  (persp-mode)
  (persp-switch "main"))


(add-hook 'emacs-startup-hook (lambda ()
                             (persp-init)))

