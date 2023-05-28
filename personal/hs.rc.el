;; hide-ifdef mode
(add-hook 'c-mode-hook 'hide-ifdef-mode)
(add-hook 'c++-mode-hook 'hide-ifdef-mode)

;; hs-minor-mode
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'lisp-mode-hook 'hs-minor-mode)

;; (add-hook 'hs-minor-mode-hook
;;           (lambda ()
;;             (define-key hs-minor-mode-map "\C-c@\C-s" 'show-ifdef-block)
;;             (define-key hs-minor-mode-map "\C-c@\C-h" 'hide-ifdef-block)
;;             ))
;;(setq hide-ifdef-initially  t)
