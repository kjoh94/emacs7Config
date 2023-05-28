(require 'package)
(package-initialize)
(require 'rtags)
(require 'company)

(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)

(rtags-enable-standard-keybindings)

(setq rtags-display-result-backend 'helm)
;;(setq rtags-display-result-backend 'ivy)
(setq rtags-use-bookmarks nil)
(setq rtags-symbolnames-case-insensitive t)
(setq rtags-wildcard-symbol-names t)
(setq rtags-max-bookmark-count 300)

(eval-after-load 'rtags
  '(progn
     (define-key c-mode-base-map (kbd "C-c r g") 'rtags-guess-function-at-point)
     (define-key c-mode-base-map (kbd "C-c r m") 'rtags-symbol-info)
     (define-key c-mode-base-map (kbd "C-c r t") 'rtags-symbol-type)
     (define-key c-mode-base-map (kbd "C-c r s") 'rtags-display-summary)
     (define-key c-mode-base-map (kbd "C-c r /") (lambda ()
                                                   (interactive)
                                                   (kj/rtags-symbol-str-killring)
                                                   (rtags-find-all-references-at-point)))
     (define-key c-mode-base-map (kbd "C-c r r") (lambda ()
                                                   (interactive)
                                                   (kj/rtags-symbol-str-killring)
                                                   (rtags-find-references-at-point)))
     (define-key c-mode-base-map (kbd "C-c r 1") 'rtags-location-stack-back)
     (define-key c-mode-base-map (kbd "C-c r 0") 'rtags-location-stack-forward)
     (define-key c-mode-base-map (kbd "C-c r -") 'rtags-location-stack-remove)
     (define-key c-mode-base-map (kbd "C-c r %") 'rtags-location-stack-replace)
     (define-key c-mode-base-map (kbd "C-c r C-d") 'rtags-location-stack-top-here)
     (define-key c-mode-base-map (kbd "C-c r f") 'rtags-location-stack-visualize)
     (define-key c-mode-base-map (kbd "C-c r ,") 'kjoh/rtags-location-stack-push)
     (define-key c-mode-base-map (kbd "C-c r z") 'kjoh/rtags-location-stack-reset)
     (define-key c-mode-base-map (kbd "C-c r *") 'kjoh/rtags-list-all-symbols)
     (define-key c-mode-base-map (kbd "C-c r i") 'rtags-imenu)
     (define-key c-mode-base-map (kbd "C-c r '") 'kj/rtags-find-symbol-at-point)
     (define-key rtags-location-stack-visualize-mode-map (kbd "s") 'kjoh/rtags-show-in-other-window)
     (define-key rtags-location-stack-visualize-mode-map (kbd "M-o") 'kjoh/rtags-show-in-other-window)
     ;; (define-key rtags-location-stack-visualize-mode-map (kbd "RET") 'kjoh/rtags-select-other-window)

     (define-key dired-mode-map (kbd "C-c r 1") 'rtags-location-stack-back)
     (define-key dired-mode-map (kbd "C-c r 0") 'rtags-location-stack-forward)
     (define-key dired-mode-map (kbd "C-c r f") 'rtags-location-stack-visualize)
     (define-key dired-mode-map (kbd "C-c r z") 'kjoh/rtags-location-stack-reset)
     (define-key dired-mode-map (kbd "C-c r *") 'kjoh/rtags-list-all-symbols)
     (define-key dired-mode-map (kbd "C-c r f") 'rtags-location-stack-visualize)
     (define-key dired-mode-map (kbd "C-c r ;") 'rtags-find-file)

     (setq  rtags-verify-protocol-version nil)
     ;; hash table for function name
     (defvar rtags-function-name-hash (make-hash-table :test 'equal))

     (defun rtags-location-stack-push (&optional loc-arg)
       "Push current location into location stack.
If loc-arg is non-nil, then push it instead.
See `rtags-current-location' for loc-arg format."
       (let ((bm (or loc-arg (rtags-current-location)))
             (tmp-stack nil)
             (tmp-index 0))
         ;;(unless (string= bm (car rtags-location-stack))
         (unless nil
           (while (> rtags-location-stack-index 0)
             (decf rtags-location-stack-index)
             (push (pop rtags-location-stack) tmp-stack)
             (incf tmp-index))
           (while (> tmp-index 0)
             (decf tmp-index)
             (push (pop tmp-stack) rtags-location-stack))
           (push bm rtags-location-stack)
           ;;;; kjoh's note
           (puthash bm (which-function) rtags-function-name-hash)
           (when (> (length rtags-location-stack) rtags-max-bookmark-count)
             (nbutlast rtags-location-stack (- (length rtags-location-stack) rtags-max-bookmark-count)))
           (run-hooks 'rtags-jump-hook))))

     (defun rtags-location-stack-visualize-update ()
       (let ((buffer (get-buffer "*RTags Location Stack*"))
             (stack-length (length rtags-location-stack)))
         (when buffer
           (with-current-buffer buffer
             (let ((idx -1)
                   (buffer-read-only nil)
                   (lines))
               (erase-buffer)
               (mapc (lambda (entry)
                       (incf idx)
                       (push (if (= idx rtags-location-stack-index)
                                 (concat entry " [" (gethash entry rtags-function-name-hash) "] <--")
                               (concat entry " [" (gethash entry rtags-function-name-hash) "]")) lines))
                     rtags-location-stack)
               (insert (mapconcat 'identity lines "\n")))
             (rtags-location-stack-visualize-mode)
             (forward-line (- stack-length (+ 1 rtags-location-stack-index)))
             (if (get-buffer-window buffer)
                 (set-window-point (get-buffer-window buffer 'visible) (point))
               nil)
             ))))

     (defun rtags-symbol-type ()
       "Print symbol type under cursor."
       (interactive)
       (let* ((info (rtags-symbol-info-internal :targets t))
              (type (cdr (assoc 'type info))))
         (when (called-interactively-p 'any)
           (if type
               (message "RTags: %s: %s\n%s" (or (cdr (assoc 'symbolName info)) "<unknown>") type (assoc 'usr (car (cdr (assoc 'targets info)))))
             (message "RTags: type not found")))
         type))

     (defun rtags-find-all-references-at-point (&optional prefix)
       (interactive "P")
       (let ((otherwindow (and prefix (listp prefix)))
             (tagname (or (rtags-current-symbol) (rtags-current-token)))
             (pathfilter (and (numberp prefix) (rtags-buffer-file-name))))
         (when (or (not (rtags-called-interactively-p)) (rtags-sandbox-id-matches))
           (rtags-delete-rtags-windows)
           (rtags-location-stack-push)
           (let ((arg (rtags-current-location))
                 (fn (rtags-buffer-file-name)))
             (rtags-reparse-file-if-needed)
             (with-current-buffer (rtags-get-buffer)
               (rtags-call-rc :path fn
                              :path-filter pathfilter
                              "-r" arg
                              "-e"
                              "-o"
                              (unless rtags-sort-references-by-input "--no-sort-references-by-input")
                              (unless rtags-print-filenames-relative "-K"))
               (rtags-handle-results-buffer tagname nil nil fn otherwindow 'find-all-references-at-point))))))


     (defun rtags-find-references-at-point (&optional prefix)
       "Find all references to the symbol under the cursor.

If there's exactly one result jump directly to it, and if optional
PREFIX is given jump to it in other window. If there's more show a
buffer with the different alternatives and jump to the first one, if
`rtags-jump-to-first-match' is true. References to references will be
treated as references to the referenced symbol."
       (interactive "P")
       (let ((otherwindow (and prefix (listp prefix)))
             (tagname (or (rtags-current-symbol) (rtags-current-token)))
             (pathfilter (and (numberp prefix) (rtags-buffer-file-name))))
         (when (or (not (rtags-called-interactively-p)) (rtags-sandbox-id-matches))
           (rtags-delete-rtags-windows)
           (rtags-location-stack-push)
           (let ((arg (rtags-current-location))
                 (fn (rtags-buffer-file-name)))
             (rtags-reparse-file-if-needed)
             (with-current-buffer (rtags-get-buffer)
               (rtags-call-rc :path fn
                              :path-filter pathfilter "-r" arg
                              "-o"
                              (unless rtags-sort-references-by-input "--no-sort-references-by-input"))
               (rtags-handle-results-buffer tagname nil nil fn otherwindow 'find-references-at-point))))))


     (defun kjoh/rtags-location-stack-push ()
       (interactive)
       (rtags-location-stack-push)
       (message "pushed stack"))


     (defun kjoh/rtags-location-stack-reset ()
       (interactive)
       (rtags-location-stack-reset)
       (setq rtags-function-name-hash (make-hash-table :test 'equal)))

     (defun kjoh/rtags-show-in-other-window ()
       (interactive)
       ;; (message "About to show")
       (rtags-select t nil t)
       (rtags-location-stack-visualize-update))


     (defun kjoh/rtags-select-other-window (&optional not-other-window)
       (interactive "P")
       (rtags-select (not not-other-window))
       (rtags-location-stack-visualize-update))

     (defun kjoh/rtags-list-all-symbols (&optional prefix)
       (interactive "P")
       (when (or (not (rtags-called-interactively-p)) (rtags-sandbox-id-matches))
         (kjoh/rtags-find-symbols-by-star "Find rsymbol" "-F" nil nil prefix)))

     (defun kjoh/rtags-find-symbols-by-star (prompt switch &optional filter regexp-filter other-window)
       (rtags-delete-rtags-windows)
       (rtags-location-stack-push)
       (let ((symbol-to-find "*")
             (path (rtags-buffer-file-name))
             input)
         (setq prompt (concat prompt ": "))
         (setq input (rtags-completing-read prompt #'rtags-symbolname-complete nil nil symbol-to-find 'rtags-symbol-history))
         (setq rtags-symbol-history (rtags-remove-last-if-duplicated rtags-symbol-history))
         (when (not (equal "" input))
           (with-current-buffer (rtags-get-buffer)
             (rtags-call-rc :path path switch input :path-filter filter
                            :path-filter-regex regexp-filter
                            (when rtags-wildcard-symbol-names "--wildcard-symbol-names")
                            ;; (when rtags-symbolnames-case-insensitive "-I")
                            (unless prefix "-I")
                            (unless rtags-print-filenames-relative "-K"))
             (rtags-handle-results-buffer input nil nil path other-window 'find-symbols-by-name-internal)))))

     (defun rtags-location-stack-remove ()
       (interactive)
       (let ((bm (rtags-current-location))
             (tmp-stack nil)
             (tmp-index 0)
             (cnt 0))
         (unless (string= bm (car rtags-location-stack))
           (while (>= rtags-location-stack-index 0)
             (message "**** %d" rtags-location-stack-index)
             (decf rtags-location-stack-index)
             (push (pop rtags-location-stack) tmp-stack)
             (incf tmp-index))
           (while (> tmp-index 0)
             (decf tmp-index)
             (incf cnt)
             (if (= cnt 1)
                 (pop tmp-stack)
               (push (pop tmp-stack) rtags-location-stack)
               (incf rtags-location-stack-index))
             (rtags-location-stack-visualize-update)
             ))))

     (defun rtags-location-stack-top-here ()
       (interactive)
       (let ((bm (rtags-current-location)))
         (unless (string= bm (car rtags-location-stack))
           (while (> rtags-location-stack-index 0)
             (message "**** %d" rtags-location-stack-index)
             (pop rtags-location-stack)
             (decf rtags-location-stack-index))
           (rtags-location-stack-visualize-update))))

     (defun rtags-location-stack-replace ()
       (interactive)
       (let ((bm (rtags-current-location))
             (tmp-stack nil)
             (tmp-index 0)
             (cnt 0))
         (unless (string= bm (car rtags-location-stack))
           (while (>= rtags-location-stack-index 0)
             (message "**** %d" rtags-location-stack-index)
             (decf rtags-location-stack-index)
             (push (pop rtags-location-stack) tmp-stack)
             (incf tmp-index))
           (while (> tmp-index 0)
             (decf tmp-index)
             (incf cnt)
             (if (= cnt 1)
                 (let ((ttt nil))
                   (pop tmp-stack)
                   (push bm rtags-location-stack)
                   (puthash bm (which-function) rtags-function-name-hash))
               (push (pop tmp-stack) rtags-location-stack))
             (incf rtags-location-stack-index)
             (rtags-location-stack-visualize-update)
             ))))

     (defun rtags-location-stack-jump (by)
       (interactive)
       (let (;; copy of repeat-on-final-keystroke functionality from repeat.el
             (repeat-char
              (if (eq repeat-on-final-keystroke t)
                  last-command-event
                (car (memq last-command-event
                           (listify-key-sequence
                            repeat-on-final-keystroke)))))
             (instack (replace-regexp-in-string "[0-9]+:$" "" (nth rtags-location-stack-index rtags-location-stack)))
             (cur (replace-regexp-in-string "[0-9]+:$" "" (rtags-current-location))))
         (if (not (string= instack cur))
             ;; location ring may contain locations from many sandboxes. In case current location is remote
             ;; and following is local one, we want following be visited as local file.
             ;; that's why 4th arg is t.
             (rtags-goto-location instack t nil t)
           (let ((target (+ rtags-location-stack-index by)))
             (when (and (>= target 0) (< target (length rtags-location-stack)))
               (setq rtags-location-stack-index target)
               (rtags-goto-location (nth rtags-location-stack-index rtags-location-stack) t nil t))))
         (rtags-location-stack-visualize-update)
         (when repeat-char
           (let ((map (make-sparse-keymap)))
             (define-key map (vector repeat-char)
               `(lambda ()
                  (interactive)
                  (rtags-location-stack-jump ,by)))
             (rtags-set-transient-map map)))))
     ))


(defun kj/rtags-symbol-str-killring ()
  "prepend 'symbol' to kill ring for rtags-find-*"
  (let ((symbol-name (thing-at-point 'symbol)))
    (when symbol-name
      (with-temp-buffer
        (insert symbol-name)
        (clipboard-kill-region (point-min) (point-max))))))

(defun kj/rtags-find-symbol-at-point ()
  (interactive)
  (rtags-find-symbol-at-point '(4)))