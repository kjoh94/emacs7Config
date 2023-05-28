;;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

;; customize
;;(setq helm-gtags-path-style 'root)
(setq helm-gtags-ignore-case t)
(setq helm-gtags-read-only nil)
(setq process-adaptive-read-buffering t)
(setq helm-gtags-auto-update t)
(setq helm-gtags-cache-select-result t)
(setq helm-gtags-update-interval-second nil)

(setq helm-gtags-max-stack-size 100)
(setq helm-gtags-action-at-one-if-one t)

;; key bindings
(eval-after-load "helm-gtags"
  '(progn
     ;; (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     ;; (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     ;; (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     ;; (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
     ;; (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     ;; (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     ;; (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)

     (define-key helm-gtags-mode-map (kbd "M-.") (lambda ()
                                                   (interactive)
                                                   (kj/helm-gtags-symbol-str-killring)
                                                   (helm-gtags-find-tag)))

     (define-key helm-gtags-mode-map (kbd "C-.") (lambda ()
                                                   (interactive)
                                                   (kj/helm-gtags-symbol-str-killring)
                                                   (helm-gtags-find-tag)))

     (define-key helm-gtags-mode-map (kbd "C-c C-r") (lambda ()
                                                       (interactive)
                                                       (kj/helm-gtags-symbol-str-killring)
                                                       (helm-gtags-find-rtag)))

     (define-key helm-gtags-mode-map (kbd "C-c C-s") (lambda ()
                                                   (interactive)
                                                   (kj/helm-gtags-symbol-assign-str-killring)
                                                   (helm-gtags-find-symbol)))

     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-select)
     (define-key helm-gtags-mode-map (kbd "M-*") 'helm-gtags-pop-stack)
     (define-key helm-gtags-mode-map (kbd "M-8") 'helm-gtags-pop-stack)
     ;;(define-key helm-gtags-mode-map (kbd "M-0") 'helm-gtags-show-stack)
     (define-key helm-gtags-mode-map (kbd "C-x f") 'helm-gtags-show-stack)
     (define-key helm-gtags-mode-map (kbd "C-c C-e") 'helm-gtags-parse-file)
     (define-key helm-gtags-mode-map (kbd "C-c C-f") 'helm-gtags-find-files)
     ;;(define-key helm-gtags-mode-map (kbd "C-c C-<") 'helm-gtags-previous-history)
     ;;(define-key helm-gtags-mode-map (kbd "C-c C->") 'helm-gtags-next-history)

     (require 'evil)
     (define-key helm-gtags-mode-map [remap evil-jump-to-tag] 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map [remap pop-tag-mark] 'helm-gtags-pop-stack)
     ))


(add-hook 'prelude-mode-hook
          (lambda ()
            (define-key prelude-mode-map (kbd "C-c C-f") 'helm-gtags-find-files)
            (define-key prelude-mode-map (kbd "M-,") 'helm-gtags-select)))

(defun kj/helm-gtags-symbol-str-killring ()
  "prepend 'symbol' to kill ring for helm-gtags-find-*"
  (let ((symbol-name (thing-at-point 'symbol)))
    (when symbol-name
      (with-temp-buffer
        (insert symbol-name)
        (clipboard-kill-region (point-min) (point-max))))))

(defun kj/helm-gtags-symbol-assign-str-killring ()
  "prepend 'symbol =' to kill ring for helm-gtags-find-*"
  (let ((symbol-name (thing-at-point 'symbol)))
    (when symbol-name
      (with-temp-buffer
        (insert symbol-name)
        (insert "\\ *=[^=]")
        (clipboard-kill-region (point-min) (point-max))))))



(eval-after-load "helm-gtags"
  '(progn
     (defun helm-gtags--update-tags-command (how-to)
       (cl-case how-to
         (entire-update "global -u")
         (generate-other-directory (concat "gtags " (helm-gtags--read-tag-directory)))
         (single-update (concat "global -u --single-update "
                                (shell-quote-argument
                                 (expand-file-name (buffer-file-name)))))))
     (defsubst helm-gtags--current-context ()
       (let ((file (if (equal major-mode 'dired-mode)
                       default-directory
                     (buffer-file-name (current-buffer)))))
         (list :file file :position (point) :line (what-line) :readonly buffer-file-read-only)))))
