;; ;; This line is unnecessary if you get this program from MELPA
;; (add-to-list 'load-path "~/.emacs.d/elisp/helm-swoop")

(require 'helm-swoop)

;; Change keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
;;(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "M-I") 'kjoh/helm-swoop-with-narrow)

(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direction. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-horizontally)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle nil)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; ----------------------------------------------------------------

;; * `M-x helm-swoop` when region active
;; * `M-x helm-swoop` when the cursor is at any symbol
;; * `M-x helm-swoop` when the cursor is not at any symbol
;; * `M-3 M-x helm-swoop` or `C-u 5 M-x helm-swoop` multi separated line culling
;; * `M-x helm-multi-swoop` multi-occur like feature
;; * `M-x helm-multi-swoop-all` apply all buffers
;; * `C-u M-x helm-multi-swoop` apply last selected buffers from the second time
;; * `M-x helm-swoop-same-face-at-point` list lines have the same face at the cursor is on
;; * During isearch `M-i` to hand the word over to helm-swoop
;; * During helm-swoop `M-i` to hand the word over to helm-multi-swoop-all
;; * While doing `helm-swoop` press `C-c C-e` to edit mode, apply changes to original buffer by `C-x C-s`

;; Helm Swoop Edit
;; While doing helm-swoop, press keybind [C-c C-e] to move to edit buffer.
;; Edit the list and apply by [C-x C-s]. If you'd like to cancel, [C-c C-g]


(defun kjoh/helm-swoop-pre-input_function()
  (if (or (equal major-mode 'dired-mode)
          (equal major-mode 'rtags-location-stack-visualize-mode))
      (thing-at-point nil)
    (thing-at-point 'symbol)))

(setq helm-swoop-pre-input-function 'kjoh/helm-swoop-pre-input_function)


(defun kjoh/helm-swoop-with-narrow()
  (interactive)
  (let ((narrowed (buffer-narrowed-p)))
    (if (not narrowed)
        (narrow-to-defun))
    (helm-swoop)
    (if (not narrowed)
        (widen))))

(eval-after-load "helm-swoop"
  '(progn
     (defun helm-c-source-swoop ()
       `((name . ,(buffer-name (current-buffer)))
         (init . (lambda ()
                   (unless helm-swoop-cache
                     (with-current-buffer (helm-candidate-buffer 'local)
                       (insert ,(helm-swoop--get-content)))
                     ;;(setq helm-swoop-cache t)  ;; kjoh, originally 'helm-swoop-cache' is t
                     (setq helm-swoop-cache nil))))
         (candidates-in-buffer)
         (get-line . ,(if helm-swoop-speed-or-color
                          'helm-swoop--buffer-substring
                        'buffer-substring-no-properties))
         (keymap . ,helm-swoop-map)
         (header-line . "[C-c C-e] Edit mode, [M-i] apply all buffers")
         (action . (lambda ($line)
                     (helm-swoop--goto-line
                      (when (string-match "^[0-9]+" $line)
                        (string-to-number (match-string 0 $line))))
                     (let (($regex (mapconcat 'identity
                                              (split-string helm-pattern " ")
                                              "\\|")))
                       (when (or (and (and (featurep 'migemo) (featurep 'helm-migemo))
                                      (migemo-forward $regex nil t))
                                 (re-search-forward $regex nil t))
                         (goto-char (match-beginning 0))))
                     (helm-swoop--recenter)))
         (migemo) ;;? in exchange for those matches ^ $ [0-9] .*
         ))))
