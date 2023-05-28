;; my configurations
(setq custom-safe-themes t)
;;(load-theme 'leuven t)
;;(load-theme 'ample t)
;;(load-theme 'tango-plus t)
;;(load-theme 'soft-morning t)
(load-theme 'darkburn t)
;;(load-theme 'zen-and-art t)
;;(load-theme 'cherry-blossom t)
;;(load-theme 'zenburn t)
;;(load-theme 'solarized-dark t)
;;(load-theme 'anti-zenburn t)

(desktop-save-mode 1)

(global-hl-line-mode -1)

;; mark-ring
(setq set-mark-command-repeat-pop 1)
(setq mark-ring-max 100)

;; no-confirm message
(setq confirm-nonexistent-file-or-buffer nil) ; no confirm message
(setq prelude-guru nil)
;;(setq prelude-whitespace t)
(setq prelude-whitespace nil)
;;(setq prelude-clean-whitespace-on-save nil)
(setq whitespace-line-column  120)

(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-merge-split-window-function 'split-window-horizontally)
(setq-default ediff-auto-refine 'on)
(setq-default ediff-ignore-similar-regions t)
(setq-default ediff-highlight-all-diffs t)
(setq ediff-diff-options "-bB")
(setq ediff-coding-system-for-read 'raw-text-dos)

(setq prelude-flyspell nil)
(setq ispell-program-name "aspell")
(setq ispell-dictionary "english")

(setq ring-bell-function 'ignore)
(setq visible-bell nil)
(setq register-preview-delay 0)

(setq history-length 20)
(put 'minibuffer-history 'history-length 50)
(put 'evil-ex-history 'history-length 50)
(put 'kill-ring 'history-length 25)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; ido settings
;;;;;;;;;;;;;;;;;;;;;;;;
;;(require 'recentf)
;;(recentf-mode 1)
;;(ido-mode 1)
;;(setq ido-enable-flex-matching t)
;;(setq ido-everywhere t)
;;(setq ido-use-filename-at-point (quote guess))
(setq ido-use-filename-at-point nil)
(setq iregister-preview-delayregister-preview-delaydo-use-filename-at-point nil)
;;(setq ido-use-url-at-point nil)
;;(setq ido-auto-merge-delay-time 9)
;;(setq ido-max-directory-size 100000)
;;(flx-ido-mode 1)
(setq ido-enable-regexp nil)
;; vertical mode
;;(require 'ido-vertical-mode)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)

(defun ido-ignore-non-user (name)
  "Ignore all non-user (a.k.a. *starred*) buffers except *ielm*."
  (and (string-match "^\*" name)
       (not (string= name "*scratch*"))
       (not (string-match "^\*gud" name))))

;;(setq ido-ignore-buffers '("\\` " ido-ignore-non-user))
(setq ido-ignore-buffers '("\\` " "*Messages*" "*Completions*" "*Backtrace*" "project" " \\*.*\\*" "^\*Ido\*" "\\*tramp/.*\\*" "\\.dired\\'"))


(if (fboundp 'global-flycheck-mode)
    (global-flycheck-mode -1))

;;(add-hook 'c-mode-hook 'flycheck-mode)
;;(add-hook 'c++-mode-hook 'flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;
;; maxframe
;; emacs 25.1: don't need this maxframe
;;(require 'maxframe)
;;(add-hook 'window-setup-hook 'maximize-frame t)
;;


;;;;;;;;;;;;;;;
;; font
;;;;;;;;;;;;;;;;;;;
(when (eq system-type 'darwin)
  (set-face-font 'default "Monaco-15")
  (set-fontset-font "fontset-default" '(#x1100 . #xffdc)
                    '("NanumGothicOTF" . "iso10646-1"))
  (set-fontset-font "fontset-default" '(#xe0bc . #xf66e)
                    '("NanumGothicOTF" . "iso10646-1"))
  (set-fontset-font "fontset-default" 'kana
                    '("Hiragino Kaku Gothic Pro" . "iso10646-1"))
  (set-fontset-font "fontset-default" 'han
                    '("Hiragino Kaku Gothic Pro" . "iso10646-1"))
  (set-fontset-font "fontset-default" 'japanese-jisx0208
                    '("Hiragino Kaku Gothic Pro" . "iso10646-1"))
  (set-fontset-font "fontset-default" 'katakana-jisx0201
                    '("Hiragino Kaku Gothic Pro" . "iso10646-1")))

(when (eq system-type 'gnu/linux)
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   ;; '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 125 :width normal))))
   '(default ((t (:family "Inconsolata" :foundry "PfEd" :slant normal :weight normal :height 155 :width normal)))) ))

(when (eq system-type 'windows-nt)
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 143 :width normal))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; old my config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq mark-ring-max 10)
;;(put 'dired-find-alternate-file 'disabled nil)
;;(setq confirm-nonexistent-file-or-buffer nil) ; no confirm message
;;(setq find-name-arg "-iname")
;;(setq wdired-allow-to-change-permissions t)
;;(setq ediff-split-window-function 'split-window-horizontally)
;;(setq ediff-merge-split-window-function 'split-window-horizontally)
;;(setq font-lock-maximum-decoration nil)
;;(setq completion-ignore-case t)
;;(setq read-buffer-completion-ignore-case t)
;;(setq read-file-name-completion-ignore-case t)
;;(add-hook 'scheme-mode-hook 'turn-on-paredit)
;;(setq scheme-program-name "mzscheme")
;;
;;(setq kill-buffer-query-functions
;;      (remq 'process-kill-buffer-query-function
;;            kill-buffer-query-functions))
;;(require 'misc)
;;
;;(put 'set-goal-column 'disabled nil)
;;
;;(require 'uniquify)
;;(setq uniqueify-buffer-name-style 'reverse)
;;
;;(flyspell-mode-off)
;;(setq kill-ring-max 100)
;;
;;
;;(when (require 'browse-kill-ring nil 'noerror)
;;    (browse-kill-ring-default-keybindings))
;;
;;;;(tooltip-mode -1)
;;;;(setq tooltip-use-echo-area t)
;;;;(setq next-line-add-newlines t)
;;;;(require 'visible-mark)
;;;;(visible-mark-mode)
;;;;(setq delete-by-moving-to-trash t)
(prefer-coding-system 'utf-8-unix)
(setq default-input-method 'korean-hangul)
(setenv "LANG" "ko_KR.UTF-8")

;;(setq artist-aspect-ratio 2)
(setq gdb-many-windows t)
;;(setq gdb-show-main nil)

;;(setq gtags-suggested-key-mapping t)
;;
;;(setq vc-svn-diff-switches nil)
;;(setq vc-diff-switches '("--normal" "-bB"))
;;(setq system-time-locale "C")
;;
;;(add-to-list 'file-coding-system-alist '("\\.ivf\\'" no-conversion . no-conversion))
;;
;;


;; (let (
;;       (mypaths
;;        '(
;;          "~/bin"
;;          "c:/Program Files/java/jdk1.7.0_21/bin"
;;          "c:/Program Files/videoLAN/VLC"
;;          "c:/mplayer"
;;          "c:/cygwin/bin"
;;          "c:/Windows/"
;;          "c:/ffmpeg/bin"
;;          "c:/Program Files/Beyond Compare 3"
;;          "c:/Program Files/Graphviz2.30/bin"
;;          "c:/cygwin/usr/bin"
;;          "c:/cygwin/usr/local/bin"
;;          "c:/Windows/system32/"
;;          )))
;;   (setenv "PATH" (mapconcat 'identity mypaths ";"))
;;   (setq exec-path (append mypaths (list "." exec-directory))))
;; (setq eshell-path-env (concat "c:/cygwin/bin;c:/cygwin/usr/bin;c:/cygwin/usr/local/bin;" eshell-path-env))


(setq split-width-threshold nil)
(setq fill-column 100)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
(setq grep-find-use-xargs 'exec-plus) ;; more faster than 'exec
(set-scroll-bar-mode 'left)

(add-hook 'dired-mode-hook 'ensure-buffer-name-ends-in-slash)
(defun ensure-buffer-name-ends-in-slash ()
  "change buffer name to end with slash"
  (let ((name (buffer-name)))
    (if (not (string-match "/$" name))
        (rename-buffer (concat name "/") t))))


(if (eq system-type 'windows-nt)
    (progn
      (setq w32-lwindow-modifier 'super)
      (setq w32-rwindow-modifier 'super)
      (setq w32-recognize-altgr nil)
      (add-hook 'dired-mode-hook
                (lambda ()
                  (make-local-variable 'coding-system-for-read)
                  (setq coding-system-for-read 'euc-kr)))
      ;; (require 'w32-browser)
      ;; (require 'cygwin-mount)
      ;; (cygwin-mount-activate)
      ))



;; Prevent issues with the Windows null device (NUL)
;; when using cygwin find with rgrep.
(defadvice grep-compute-defaults (around grep-compute-defaults-advice-null-device)
  "Use cygwin's /dev/null as the null-device."
  (let ((null-device "/dev/null"))
    ad-do-it))
(ad-activate 'grep-compute-defaults)

(prelude-global-mode t)

(setq process-coding-system-alist nil)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; projectile
(setq projectile-indexing-method 'alien)
(setq projectile-enable-caching nil)
(setq projectile-cache-file (expand-file-name  "projectile.cache" prelude-savefile-dir))
(setq projectile-project-root-files-top-down-recurring nil)
(setq projectile-project-root-files-bottom-up '(".projectile"))

(require 'font-lock+)                   ; load after font-lock.el

;; increase global helm-candidate-number-limit
(require 'helm-config)
(setq helm-candidate-number-limit 3333)
(setq helm-buffer-max-length 55)

(setq mode-require-final-newline nil)

(add-to-list 'auto-mode-alist '("\\.dj\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rbx\\'" . ruby-mode))