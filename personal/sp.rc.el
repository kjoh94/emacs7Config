(require 'smartparens)

(defun my-open-block-c-mode (id action context)
  (when (eq action 'insert)
    (indent-according-to-mode)
    (newline)
    (newline)
    (indent-according-to-mode)
    (previous-line)
    (indent-according-to-mode)))

;; we use :add to keep any global handlers. If you want to replace
;; them, simply specify the "bare list" as an argument:
;; '(my-open-block-c-mode)
(sp-local-pair 'c-mode "{" nil :post-handlers '(:add my-open-block-c-mode))
(sp-local-pair 'c++-mode "{" nil :post-handlers '(:add my-open-block-c-mode))


(add-to-list 'sp-ignore-modes-list 'org-mode)