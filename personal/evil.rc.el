(setq evil-want-C-i-jump t)
(setq evil-want-C-u-scroll nil)
(setq evil-want-C-w-delete t)
(setq evil-want-visual-char-semi-exclusive t)

(require 'evil)

(evil-mode 1)

;;;;;;;;;;;;;;;;;;;;;
;;; esc quits
;;;;;;;;;;;;;;;;;;;;;
;;(define-key evil-normal-state-map [escape] 'keyboard-quit)
;;(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

(define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
(define-key evil-insert-state-map "\C-e" 'end-of-line)
(define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
(define-key evil-motion-state-map "\C-e" 'evil-end-of-line)
(define-key evil-normal-state-map "\C-f" 'evil-forward-char)
(define-key evil-insert-state-map "\C-f" 'evil-forward-char)
(define-key evil-insert-state-map "\C-f" 'evil-forward-char)
(define-key evil-normal-state-map "\C-b" 'evil-backward-char)
(define-key evil-insert-state-map "\C-b" 'evil-backward-char)
(define-key evil-visual-state-map "\C-b" 'evil-backward-char)
(define-key evil-normal-state-map "\C-d" 'evil-delete-char)
(define-key evil-insert-state-map "\C-d" 'evil-delete-char)
(define-key evil-visual-state-map "\C-d" 'evil-delete-char)
(define-key evil-normal-state-map "\C-n" 'evil-next-line)
(define-key evil-insert-state-map "\C-n" 'evil-next-line)
(define-key evil-visual-state-map "\C-n" 'evil-next-line)
(define-key evil-normal-state-map "\C-p" 'evil-previous-line)
(define-key evil-insert-state-map "\C-p" 'evil-previous-line)
(define-key evil-visual-state-map "\C-p" 'evil-previous-line)
(define-key evil-normal-state-map "\C-y" 'yank)
(define-key evil-insert-state-map "\C-y" 'yank)
(define-key evil-visual-state-map "\C-y" 'yank)
;;(define-key evil-normal-state-map "\C-w" 'kill-region)
;;(define-key evil-insert-state-map "\C-w" 'kill-region)
(define-key evil-visual-state-map "\C-w" 'kill-region)
;;(define-key evil-normal-state-map "Q" 'call-last-kbd-macro)
;;(define-key evil-visual-state-map "Q" 'call-last-kbd-macro)

(define-key evil-normal-state-map (kbd "C-.") nil)
(define-key evil-normal-state-map (kbd "M-.") nil)


(define-key evil-normal-state-map (kbd "SPC") 'evil-scroll-page-down)
(define-key evil-visual-state-map (kbd "SPC") 'evil-scroll-page-down)
(define-key evil-normal-state-map (kbd "<backspace>") 'evil-scroll-page-up)
(define-key evil-visual-state-map (kbd "<backspace>") 'evil-scroll-page-up)

(require 'highlight-symbol)
(define-key evil-normal-state-map "gD" 'highlight-symbol-at-point-all-windows)

(define-key evil-normal-state-map (kbd "C-r") 'isearch-backward-regexp)
(define-key evil-insert-state-map (kbd "C-r") 'isearch-backward-regexp)
(define-key evil-visual-state-map (kbd "C-r") 'isearch-backward-regexp)

(define-key evil-normal-state-map (kbd "C-`") 'redo)
(define-key evil-normal-state-map (kbd ",m") 'evil-show-marks)

(define-key evil-normal-state-map "zO" 'evil-open-folds)
(define-key evil-normal-state-map "zC" 'evil-close-folds)
(define-key evil-normal-state-map "zz" 'evil-toggle-fold)
(define-key evil-normal-state-map "zb" 'hs-hide-level)


;;  helm-gtags hot key on stack
(define-key evil-normal-state-map (kbd ",,") 'kjoh/helm-gtags-save-current-context)
(define-key evil-normal-state-map (kbd ",C") 'helm-gtags-clear-stack)
(define-key evil-normal-state-map (kbd ",B") 'bm-show-all)

(define-key evil-normal-state-map (kbd ",k") 'man) ; man page
(define-key evil-normal-state-map (kbd ",/") 'prelude-google)
(define-key evil-visual-state-map (kbd ",/") 'prelude-google)

(define-key evil-normal-state-map (kbd ",!") 'nuke)
(define-key evil-normal-state-map (kbd ",1") 'show-file-path)
(define-key evil-visual-state-map (kbd ",1") 'show-file-path)
(define-key evil-normal-state-map (kbd ",2") 'show-dir-name)
(define-key evil-visual-state-map (kbd ",2") 'show-dir-name)

;; gud keymapping
(define-key evil-normal-state-map (kbd ",gb") 'gud-break)
(define-key evil-normal-state-map (kbd ",gd") 'gud-remove)
(define-key evil-normal-state-map (kbd ",gf") 'gud-finish)
(define-key evil-normal-state-map (kbd ",gi") 'gud-stepi)
(define-key evil-normal-state-map (kbd ",gj") 'gud-jump)
(define-key evil-normal-state-map (kbd ",gl") 'gud-refresh)
(define-key evil-normal-state-map (kbd ",gn") 'gud-next)
(define-key evil-normal-state-map (kbd ",gp") 'gud-print)
(define-key evil-normal-state-map (kbd ",gc") 'gud-cont)
(define-key evil-normal-state-map (kbd ",gs") 'gud-step)
(define-key evil-normal-state-map (kbd ",gt") 'gud-tbreak)
(define-key evil-normal-state-map (kbd ",gu") 'gud-until)
(define-key evil-normal-state-map (kbd ",gv") 'gud-pv)
(define-key evil-normal-state-map (kbd ",g<") 'gud-up)
(define-key evil-normal-state-map (kbd ",g>") 'gud-down)

(define-key evil-normal-state-map (kbd ",b") 'gud-break)
(define-key evil-normal-state-map (kbd ",d") 'gud-remove)
(define-key evil-normal-state-map (kbd ",f") 'gud-finish)
(define-key evil-normal-state-map (kbd ",i") 'gud-stepi)
(define-key evil-normal-state-map (kbd ",l") 'gud-refresh)
(define-key evil-normal-state-map (kbd ",n") 'gud-next)
(define-key evil-normal-state-map (kbd ",p") 'gud-print)
(define-key evil-normal-state-map (kbd ",c") 'gud-cont)
(define-key evil-normal-state-map (kbd ",s") 'gud-step)
(define-key evil-normal-state-map (kbd ",t") 'gud-tbreak)
(define-key evil-normal-state-map (kbd ",u") 'gud-until)
(define-key evil-normal-state-map (kbd ",v") 'gud-pv)
(define-key evil-normal-state-map (kbd ",<") 'gud-up)
(define-key evil-normal-state-map (kbd ",>") 'gud-down)

(define-key evil-normal-state-map  ";" nil)
(define-key evil-normal-state-map ";;" 'toggle-window-split)

(define-key evil-normal-state-map "+" 'evil-window-increase-height)
(define-key evil-normal-state-map "-" 'evil-window-decrease-height)

(evil-define-operator evil-destroy-char (beg end type register yank-handler)
  :motion evil-forward-char
  (evil-delete-char beg end type ?_))

(evil-define-operator evil-destroy-change (beg end type register yank-handler delete-func)
  (evil-change beg end type ?_ yank-handler delete-func))


;; [2016-04-24 Sun 00:19]
;; To be comfortable with 'evil-surround', comment below two lines
(define-key evil-normal-state-map "c" 'evil-destroy-change)
(define-key evil-visual-state-map "R" 'evil-destroy-change)
(define-key evil-normal-state-map "x" 'evil-destroy-char)

(add-hook 'evil-after-load-hook
          (lambda()
            ;;config
            ))

;; [2016-04-29 Fri 21:53] kjoh
;; 'evil-global-marker-p' function override
;; (eval-after-load "evil-common"
;;   '(progn
;;      (defun evil-global-marker-p (char)
;;        "Whether CHAR denotes a global marker."
;;        (or (and (>= char ?A) (<= char ?Z))
;;            (and (>= char ?a) (<= char ?z))
;;            (assq char (default-value 'evil-markers-alist))))
;;      ))

(evil-set-initial-state 'eshell-mode 'emacs)
(evil-set-initial-state 'bm-show-mode 'emacs)
(evil-set-initial-state 'diff-mode 'emacs)
(evil-set-initial-state 'gud-mode 'emacs)
(evil-set-initial-state 'rtags-mode 'emacs)
(evil-set-initial-state 'rtags-taglist-mode 'emacs)
(evil-set-initial-state 'rtags-location-stack-visualize-mode 'emacs)
(evil-set-initial-state 'git-commit-mode 'insert)

;; (loop for (mode . state) in '((inferior-emacs-lisp-mode . emacs)
;;                               (nrepl-mode . insert)
;;                               (pylookup-mode . emacs)
;;                               (comint-mode . normal)
;;                               (shell-mode . insert)
;;                               (git-commit-mode . insert)
;;                               (git-rebase-mode . emacs)
;;                               (term-mode . emacs)
;;                               (help-mode . emacs)
;;                               (helm-grep-mode . emacs)
;;                               (grep-mode . emacs)
;;                               (bc-menu-mode . emacs)
;;                               (magit-branch-manager-mode . emacs)
;;                               (rdictcc-buffer-mode . emacs)
;;                               (dired-mode . emacs)
;;                               (wdired-mode . normal))
;;       do (evil-set-initial-state mode state))

(defun evil-undefine ()
  (interactive)
  (let (evil-mode-map-alist)
    (call-interactively (key-binding (this-command-keys)))))

;;(define-key evil-normal-state-map (kbd "TAB") 'evil-undefine)

;;(setq evil-move-cursor-back nil)
(setq evil-highlight-closing-paren-at-point-states t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; kjoh's note
;; override evil-show-marks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(evil-define-command evil-show-marks (mrks)
  "Shows all marks.
If MRKS is non-nil it should be a string and only registers
corresponding to the characters of this string are shown."
  :repeat nil
  (interactive "<a>")
  ;; To get markers and positions, we can't rely on 'global-mark-ring'
  ;; provided by Emacs (although it will be much simpler and faster),
  ;; because 'global-mark-ring' does not store mark characters, but
  ;; only buffer name and position. Instead, 'evil-markers-alist' is
  ;; used; this is list maintained by Evil for each buffer.
  (let ((all-markers
         ;; get global and local marks
         (append (cl-remove-if (lambda (m)
                                 (or (evil-global-marker-p (car m))
                                     (not (markerp (cdr m)))))
                               evil-markers-alist)
                 (cl-remove-if (lambda (m)
                                 (or (not (evil-global-marker-p (car m)))
                                     (not (markerp (cdr m)))))
                               (default-value 'evil-markers-alist)))))
    (when mrks
      (setq mrks (string-to-list mrks))
      (setq all-markers (cl-delete-if (lambda (m)
                                        (not (member (car m) mrks)))
                                      all-markers)))
    ;; map marks to list of 4-tuples (char row col file)
    (setq all-markers
          (mapcar (lambda (m)
                    (with-current-buffer (marker-buffer (cdr m))
                      (save-excursion
                        (goto-char (cdr m))
                        (let ((funcname (which-function)))
                          (list (car m)
                                (line-number-at-pos (point))
                                (current-column)
                                ;; (format "%s: %s" (buffer-name) (if funcname (format "[%s]" funcname) ""))
                                (buffer-name)
                                (if funcname (format "%s" funcname) "")
                                )))))
                  all-markers))
    (evil-with-view-list
      :name "evil-marks"
      :mode-name "Evil Marks"
      :format [("Mark" 8 nil)
               ("Line" 8 nil)
               ("Column" 8 nil)
               ("Buffer" 20 nil)
               ("Function" 1000 nil)]
      :entries (cl-loop for m in (sort all-markers (lambda (a b) (< (car a) (car b))))
                        collect `(nil [,(char-to-string (nth 0 m))
                                       ,(number-to-string (nth 1 m))
                                       ,(number-to-string (nth 2 m))
                                       (,(nth 3 m))
                                       ,(nth 4 m)]))
      :select-action #'evil--show-marks-select-action)))


(require 'evil-jumper)

(setq evil-jumper-ignored-file-patterns (quote ("COMMIT_EDITMSG" "\\*.+\\*$")))
(setq evil-jumper-max-length  100)
(setq evil-jumper-auto-center nil)
(setq evil-jumper--debug nil)

(global-evil-jumper-mode)


(require 'evil-surround)
(global-evil-surround-mode 1)

(add-hook 'c++-mode-hook (lambda ()
                           (push '(?< . ("< " . " >")) evil-surround-pairs-alist)))
(add-hook 'c-mode-hook (lambda ()
                           (push '(?< . ("< " . " >")) evil-surround-pairs-alist)))



(eval-after-load "evil-common"
  '(progn
     (defun evil-paste-pop (count)
       "Replace the just-yanked stretch of killed text with a different stretch.
This command is allowed only immediatly after a `yank',
`evil-paste-before', `evil-paste-after' or `evil-paste-pop'.
This command uses the same paste command as before, i.e., when
used after `evil-paste-after' the new text is also yanked using
`evil-paste-after', used with the same paste-count argument.

The COUNT argument inserts the COUNTth previous kill.  If COUNT
is negative this is a more recent kill."
       (interactive "p")
       (unless (memq last-command
                     '(evil-paste-after
                       evil-paste-before
                       evil-visual-paste
                       yank))
         (user-error "Previous command was not an evil-paste: %s" last-command))
       (unless evil-last-paste
         (user-error "Previous paste command used a register"))
       (evil-undo-pop)
       (goto-char (nth 2 evil-last-paste))
       (setq this-command (nth 0 evil-last-paste))
       ;; use temporary kill-ring, so the paste cannot modify it
       (let ((kill-ring (list (current-kill
                               (if (and (> count 0) (nth 5 evil-last-paste))
                                   ;; if was visual paste then skip the
                                   ;; text that has been replaced
                                   (1+ count)
                                 count))))
             (kill-ring-yank-pointer kill-ring))
         (when (eq last-command 'evil-visual-paste)
           (let ((evil-no-display t))
             (evil-visual-restore)))
         (funcall (nth 0 evil-last-paste) (nth 1 evil-last-paste))
         ;; if this was a visual paste, then mark the last paste as NOT
         ;; being the first visual paste
         (when (eq last-command 'evil-visual-paste)
           (setcdr (nthcdr 4 evil-last-paste) nil))))))


(defun evil-next-line-first-non-whitespace (&optional count)
  (interactive "p")
  (evil-next-line (or count 1))
  (if (= (evil-column) 0)
      (evil-first-non-blank)))

(defun evil-previous-line-first-non-whitespace (&optional count)
  (interactive "p")
  (evil-previous-line (or count 1))
  (if (= (evil-column) 0)
      (evil-first-non-blank)))

(define-key evil-normal-state-map "j" 'evil-next-line-first-non-whitespace)
(define-key evil-normal-state-map "k" 'evil-previous-line-first-non-whitespace)
