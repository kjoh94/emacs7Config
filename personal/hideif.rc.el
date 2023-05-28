(setq hide-ifdef-define-alist nil)
(setq hide-ifdef-define-alist
      '((list-name-1 HAVE_FUNC_1 HAVE_FUNC_2)
        (list-name-2  CONFIG_MULTITHREAD PACKET_TESTING)))
(add-hook 'hide-ifdef-mode-hook
          '(lambda () (hide-ifdef-use-define-alist 'list-name-1)))
