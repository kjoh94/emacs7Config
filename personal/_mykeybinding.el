(global-set-key (kbd "C-x k") nil)
(global-set-key (kbd "C-x f") nil)
(global-set-key (kbd "C-x C-r") nil)


(global-set-key [(control tab)] 'other-window)
(global-set-key [(shift control tab)] 'other-frame)

;; kill line
(setq kill-whole-line t)

;; kill buffer
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-x K") 'ido-kill-buffer)

(global-set-key (kbd "C-x C-r") 'rgrep)
(global-set-key (kbd "C-c R") 'revert-buffer)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(global-set-key [remap revert-buffer] 'revert-buffer-no-confirm)


;;; auto indent when writing code
(defun set-newline-and-indent ()
  (local-set-key (kbd "RET") 'newline-and-indent))

(defun set-newline-and-indent ()
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'c-mode-hook 'set-newline-and-indent)
(add-hook 'c++-mode-hook 'set-newline-and-indent)
(add-hook 'lisp-mode-hook 'set-newline-and-indent)
(add-hook 'emacs-lisp-mode-hook 'set-newline-and-indent)
(add-hook 'python-mode-hook 'set-newline-and-indent)
(add-hook 'actionscript-mode-hook 'set-newline-and-indent)

(add-hook 'c-mode-hook (lambda () (setq comment-start "//"
                                        comment-end   "")))

(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key (kbd "C-c C-c") nil)))

;; (add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)
;; (add-hook 'c++-mode-hook 'c-turn-on-eldoc-mode)

;;(add-hook 'c-mode-hook 'linum-mode)
;;(add-hook 'python-mode-hook 'linum-mode)
;;(add-hook 'emacs-lisp-mode-hook 'linum-mode)

(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

(global-set-key (kbd "C-M-j") nil)
(global-set-key (kbd "C-M-j") 'kj/copy-sexp)
(global-set-key (kbd "C-M-SPC") 'kj/mark-sexp)
(global-set-key (kbd "C-5") 'kj/middle-of-line)
;;(global-set-key (kbd "C-c @") 'browse-url-at-point)
(global-set-key (kbd "C-x r v") 'list-registers)

;;;;;;;; helm-gtags
;(global-set-key (kbd "C-c C-f") 'helm-gtags-find-files)
;(global-set-key (kbd "M-,") 'helm-gtags-select)
;(global-set-key (kbd "M-.") 'helm-gtags-find-tag)
;(global-set-key (kbd "C-c <SPC>") 'helm-all-mark-rings)

;;(global-set-key (kbd "C-x M-m") 'minimap-toggle)
;;(global-set-key (kbd "M-Z") 'zap-up-to-char)

(global-set-key (kbd "C-=") nil)
(global-set-key (kbd "C-1") 'er/expand-region)

;;;;;;;;;;;
;; ace jump
(global-set-key (kbd "C-c j") nil)
(global-set-key (kbd "s-.") nil)
(global-set-key (kbd "C-c J") nil)
(global-set-key (kbd "s->") nil)

;; [2016-05-01 Sun 08:24] kjoh'note
;; ace-jump disabled, use avy
;;(global-set-key (kbd "C-0") 'ace-jump-mode)
;;(global-set-key (kbd "C-M-0") 'ace-jump-buffer)
(global-set-key (kbd "C-0") 'avy-goto-word-or-subword-1)

(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "C-x r 1") 'helm-register)

(add-hook 'dired-mode-hook
          (lambda ()
            ;;(prelude-off)
            (hl-line-mode)
            (define-key dired-mode-map "-" 'dired-up-directory)
            (define-key dired-mode-map (kbd "C-c =") 'mkm/ediff-marked-pair)
            (define-key dired-mode-map "f" nil)
            (define-key dired-mode-map "v" nil)
            (define-key dired-mode-map "y" nil)
            (define-key dired-mode-map "f" 'dired-file-path)
            (define-key dired-mode-map "R" 'kjoh/dired-do-rename)
            (define-key dired-mode-map "C" 'kjoh/dired-do-copy)))

(if (eq system-type 'windows-nt)
    (add-hook 'dired-mode-hook
              (lambda ()
                (define-key dired-mode-map [(meta return)] 'dired-w32-browser)
                (define-key dired-mode-map [(meta shift return)] 'kj/dired-w32explore))))



(defun kj/dired-w32explore()
  (interactive)
  (if (dired-get-filename nil t)
      (w32explore (dired-get-filename nil t))
    (w32explore default-directory)))

(add-hook 'prelude-mode-hook
          (lambda ()
            (define-key prelude-mode-map (kbd "C-c o") nil)
            (define-key prelude-mode-map (kbd "C-c g") nil)
            (define-key prelude-mode-map (kbd "C-c G") nil)
            (define-key prelude-mode-map (kbd "C-c y") nil)
            (define-key prelude-mode-map (kbd "C-c U") nil)
            (define-key prelude-mode-map (kbd "M-o") nil)
            ;(define-key map [(control shift up)]  'move-text-up)
            ;(define-key map [(control shift down)]  'move-text-down)
            ;(define-key map [(meta shift up)]  'move-text-up)
            ;(define-key map [(meta shift down)]  'move-text-down)
            (define-key prelude-mode-map [(shift return)] nil)
            (define-key prelude-mode-map [(control return)] 'prelude-smart-open-line)
            ;;(define-key prelude-mode-map [(control shift return)] 'prelude-smart-open-line-above)
            (define-key prelude-mode-map [(control meta return)] 'prelude-smart-open-line-above)
            (define-key prelude-mode-map (kbd "C-c n") nil)
            (define-key prelude-mode-map (kbd "C-c f") nil)
            ;(define-key prelude-mode-map (kbd "C-M-\\") 'prelude-indent-region-or-buffer)
            (define-key prelude-mode-map (kbd "C-M-z") nil)
            (define-key prelude-mode-map (kbd "C-c u") nil)
            (define-key prelude-mode-map (kbd "C-c e") nil)
            (define-key prelude-mode-map (kbd "C-c s") nil)
            (define-key prelude-mode-map (kbd "C-c D") nil)
            (define-key prelude-mode-map (kbd "C-c d") nil)
            (define-key prelude-mode-map (kbd "C-c M-d") nil)
            (define-key prelude-mode-map (kbd "C-c r") nil)
            (define-key prelude-mode-map (kbd "C-c t") nil)
            (define-key prelude-mode-map (kbd "C-c k") nil)
            (define-key prelude-mode-map (kbd "C-c TAB") nil)
            (define-key prelude-mode-map (kbd "C-c h") nil)
            (define-key prelude-mode-map (kbd "C-c +") nil)
            (define-key prelude-mode-map (kbd "C-c -") nil)
            (define-key prelude-mode-map (kbd "C-c I") nil)
            (define-key prelude-mode-map (kbd "C-c S") nil)
            ;;(define-key prelude-mode-map (kbd "C-x f") 'prelude-recentf-ido-find-file)
            (define-key prelude-mode-map (kbd "C-x f") nil)
            ;; helm
            (define-key prelude-mode-map (kbd "C-c i") 'helm-imenu)
            (define-key prelude-mode-map (kbd "C-c SPC") 'helm-all-mark-rings)

            (define-key prelude-mode-map [?\s-d] nil)
            (define-key prelude-mode-map [?\s-p] nil)
            (define-key prelude-mode-map [?\s-f] nil)
            (define-key prelude-mode-map [?\s-g] nil)
            ))


;; (global-set-key [(control return)] (lambda ()
;;                                      (interactive)
;;                                      (end-of-line)
;;                                      (newline-and-indent)))

(add-hook 'c-mode-common-hook
          (lambda()
            (setq cc-search-directories '("." ".." "../inc" "../include" "./inc" "./include" "../src" "/usr/include" "/usr/local/include/*" ))
            (local-set-key  (kbd "C-c I") 'ff-find-other-file)))

;; gud-gdb
(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key (kbd "<f1>") 'gud-print)
            ;;(local-set-key (kbd "<f4>") 'gud-next)
            ))

;; C-g is same to 'q'
(add-hook 'view-mode-hook
          (lambda()
            (define-key view-mode-map (kbd "C-g") 'View-quit)))

;(global-set-key "\C-xf" 'my-recentf-ido-find-file)
;(global-set-key "\C-x\C-f" 'my-ido-find-file)


;prelude-mode-map
;(let ((map (make-sparse-keymap)))
;    (define-key map (kbd "C-c o") 'prelude-open-with)
;    (define-key map (kbd "C-c g") 'prelude-google)
;    (define-key map (kbd "C-c G") 'prelude-github)
;    (define-key map (kbd "C-c y") 'prelude-youtube)
;    (define-key map (kbd "C-c U") 'prelude-duckduckgo)
;    (define-key map [(shift return)] 'prelude-smart-open-line)
;    (define-key map (kbd "M-o") 'prelude-smart-open-line)
;    (define-key map [(control shift return)] 'prelude-smart-open-line-above)
;    (define-key map [(control shift up)]  'move-text-up)
;    (define-key map [(control shift down)]  'move-text-down)
;    (define-key map [(meta shift up)]  'move-text-up)
;    (define-key map [(meta shift down)]  'move-text-down)
;    (define-key map (kbd "C-c n") 'prelude-cleanup-buffer)
;    (define-key map (kbd "C-c f")  'prelude-recentf-ido-find-file)
;    (define-key map (kbd "C-M-\\") 'prelude-indent-region-or-buffer)
;    (define-key map (kbd "C-M-z") 'prelude-indent-defun)
;    (define-key map (kbd "C-c u") 'prelude-view-url)
;    (define-key map (kbd "C-c e") 'prelude-eval-and-replace)
;    (define-key map (kbd "C-c s") 'prelude-swap-windows)
;    (define-key map (kbd "C-c D") 'prelude-delete-file-and-buffer)
;    (define-key map (kbd "C-c d") 'prelude-duplicate-current-line-or-region)
;    (define-key map (kbd "C-c M-d") 'prelude-duplicate-and-comment-current-line-or-region)
;    (define-key map (kbd "C-c r") 'prelude-rename-file-and-buffer)
;    (define-key map (kbd "C-c t") 'prelude-visit-term-buffer)
;    (define-key map (kbd "C-c k") 'prelude-kill-other-buffers)
;    (define-key map (kbd "C-c TAB") 'prelude-indent-rigidly-and-copy-to-clipboard)
;    (define-key map (kbd "C-c h") 'helm-prelude)
;    (define-key map (kbd "C-c +") 'prelude-increment-integer-at-point)
;    (define-key map (kbd "C-c -") 'prelude-decrement-integer-at-point)
;    (define-key map (kbd "C-c I") 'prelude-find-user-init-file)
;    (define-key map (kbd "C-c S") 'prelude-find-shell-init-file)
;    ;; make some use of the Super key
;    (define-key map [?\s-d] 'projectile-find-dir)
;    (define-key map [?\s-p] 'projectile-switch-project)
;    (define-key map [?\s-f] 'projectile-find-file)
;    (define-key map [?\s-g] 'projectile-grep)
;
;    (define-key map (kbd "s-r") 'prelude-recentf-ido-find-file)
;    (define-key map (kbd "s-j") 'prelude-top-join-line)
;    (define-key map (kbd "s-k") 'prelude-kill-whole-line)
;    (define-key map (kbd "s-m m") 'magit-status)
;    (define-key map (kbd "s-m l") 'magit-log)
;    (define-key map (kbd "s-m f") 'magit-file-log)
;    (define-key map (kbd "s-m b") 'magit-blame-mode)
;    (define-key map (kbd "s-o") 'prelude-smart-open-line-above)
;
;    map)
;

(global-set-key (kbd "C-x M-m") 'minimap-toggle)

(global-set-key (kbd "C-x 4 ~") 'prelude-swap-windows)


(global-set-key "\C-_" nil)
(global-set-key "\C-_" 'text-scale-decrease)
(global-set-key (kbd "C--") 'negative-argument)

;; don't use prelude-exchange-point-and-mark
(define-key global-map
  [remap exchange-point-and-mark]
  nil)

;; (add-hook 'hs-minor-mode-hook
;;           (lambda ()
;;             (define-key hs-minor-mode-map (kbd "C-.") 'hs-toggle-hiding)
;;             (define-key hs-minor-mode-map (kbd "C-M-.") 'hs-hide-level)))

(define-key key-translation-map [C-kanji] (kbd "C-SPC"))

(global-set-key (kbd "C-c y") 'bury-buffer)

(global-set-key (kbd "C-<escape>") 'narrow-or-widen-dwim)


(require 'helm-gtags)
(global-set-key (kbd "M-,") 'helm-gtags-select)
(global-set-key (kbd "C-c C-f") 'helm-gtags-find-files)
(global-set-key (kbd "C-x f") 'helm-gtags-show-stack)
(global-set-key (kbd "M-8") 'helm-gtags-pop-stack)
(global-set-key (kbd "M-*") 'helm-gtags-pop-stack)

(global-set-key (kbd "C-c b") nil)
(global-set-key (kbd "C-x p") nil)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-h a") 'helm-apropos)

(global-set-key (kbd "C-x b") 'helm-mini)

(global-set-key (kbd "C-c r j") 'ivy-resume)

;; python
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map (kbd "C-c C-b") 'python-shell-send-buffer)))


;; \C-_ : text-scale-decrease
(add-hook 'undo-tree-mode-hook
          (lambda ()
            (define-key undo-tree-map "\C-_" nil)))

(require 'projectile)
(global-set-key (kbd "C-x C-b") 'projectile-switch-to-buffer)
(global-set-key (kbd "C-x p b") 'projectile-switch-to-buffer)
(global-set-key (kbd "C-x p f") 'projectile-find-file)