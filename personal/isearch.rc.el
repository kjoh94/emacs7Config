;; I-search with initial contents
;; (defvar isearch-initial-string nil)

;; (defun isearch-set-initial-string ()
;;   (remove-hook 'isearch-mode-hook 'isearch-set-initial-string)
;;   (setq isearch-string isearch-initial-string)
;;   (isearch-search-and-update))

;; (defun isearch-forward-at-point (&optional regexp-p no-recursive-edit)
;;   "Interactive search forward for the symbol at point."
;;   (interactive "P\np")
;;   (if regexp-p (isearch-forward regexp-p no-recursive-edit)
;;     (let* ((end (progn (skip-syntax-forward "w_") (point)))
;;            (begin (progn (skip-syntax-backward "w_") (point))))
;;       (if (eq begin end)
;;           (isearch-forward regexp-p no-recursive-edit)
;;         (setq isearch-initial-string (buffer-substring begin end))
;;         (add-hook 'isearch-mode-hook 'isearch-set-initial-string)
;;         (isearch-forward regexp-p no-recursive-edit)))))

;; (defalias 'sfap 'isearch-forward-at-point)
;; (global-set-key (kbd "C-M-]")  'isearch-forward-at-point)


;;;
;; Move to beginning of word before yanking word in isearch-mode.
;; Make C-s C-w and C-r C-w act like Vim's g* and g#, keeping Emacs'
;; C-s C-w [C-w] [C-w]... behaviour.

(require 'thingatpt)

(defun my-isearch-yank-word-or-char-from-beginning ()
  "Move to beginning of word before yanking word in isearch-mode."
  (interactive)
  ;; Making this work after a search string is entered by user
  ;; is too hard to do, so work only when search string is empty.
  (if (= 0 (length isearch-string))
    (progn (skip-syntax-backward "w_") (point)))
  (isearch-yank-word-or-char)

  ;; Revert to 'isearch-yank-word-or-char for subsequent calls
  (substitute-key-definition 'my-isearch-yank-word-or-char-from-beginning
                             'isearch-yank-word-or-char
                             isearch-mode-map))

(add-hook 'isearch-mode-hook
          (lambda ()
            "Activate my customized Isearch word yank command."
            (substitute-key-definition 'isearch-yank-word-or-char
                                       'my-isearch-yank-word-or-char-from-beginning
                                       isearch-mode-map)))

(defadvice isearch-repeat (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)))

(setq lazy-highlight-cleanup  nil)


(defun isearch-exit-chord-worker (&optional arg)
  (interactive "p")
  (execute-kbd-macro (kbd "<backspace> <return>")))

(defun isearch-exit-chord (arg)
  (interactive "p")
  (isearch-printing-char)
  (unless (fboundp 'smartrep-read-event-loop)
    (require 'smartrep))
  (run-at-time 0.3 nil 'keyboard-quit)
  (condition-case e
    (smartrep-read-event-loop
      '(("j" . isearch-exit-chord-worker)
         ("n" . isearch-exit-chord-worker)
         ("N" . isearch-exit-chord-worker)
         ))
    (quit nil)))

;; example bindings
(define-key isearch-mode-map "j" 'isearch-exit-chord)
(define-key isearch-mode-map "n" 'isearch-exit-chord)
(define-key isearch-mode-map "N" 'isearch-exit-chord)
