(require 'which-func)

(setq which-func-modes nil)

(add-to-list 'which-func-modes 'org-mode)
(add-to-list 'which-func-modes 'emacs-lisp-mode)
(add-to-list 'which-func-modes 'c-mode)
(add-to-list 'which-func-modes 'c++-mode)
(add-to-list 'which-func-modes 'python-mode)
(add-to-list 'which-func-modes 'ruby-mode)

(which-function-mode 1)

