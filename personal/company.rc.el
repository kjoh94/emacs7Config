(require 'company)

;;(setq company-idle-delay 0.5)
;;(setq company-tooltip-limit 10)
;;(setq company-minimum-prefix-length 2)

;;(global-company-mode 1)
;;(setq company-async-wait  0.03)
;;(setq company-async-timeout 2)

(setq company-tooltip-limit 20)
(setq company-idle-delay 0)
(setq company-echo-delay 0)

(add-hook 'c-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'asm-mode-hook 'company-mode)
(add-hook 'objc-mode-hook 'company-mode)
;;(add-hook 'lisp-mode-hook 'company-mode)
;;(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'python-mode-hook 'company-mode)



(require 'helm-company)

(autoload 'helm-company "helm-company") ;; Not necessary if using ELPA package
(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-c C-c") 'company-complete)
     (define-key company-active-map (kbd "C-c C-c") 'helm-company)))
