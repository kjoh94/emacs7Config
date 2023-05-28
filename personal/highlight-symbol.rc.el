;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hightlight-symbol
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'highlight-symbol)

(defun highlight-symbol-at-point-all-windows ()
  "Toggle highlighting of the symbol at point in all windows."
  (interactive)
  (let ((symbol (highlight-symbol-get-symbol)))
    (unless symbol (error "No symbol at point"))
    (save-selected-window                           ; new
      (cl-dolist (x (window-list))                  ; new
        (select-window x)                           ; new
        (if (highlight-symbol-symbol-highlighted-p symbol)
            (highlight-symbol-remove-symbol symbol)
          (highlight-symbol-add-symbol symbol))))))

;;(setq highlight-symbol-priority 1005)  ;; kjoh's note: added for priority
(global-set-key (kbd "C-M-]")  'highlight-symbol-at-point)
;;(global-set-key [f3] 'highlight-symbol-next)
;;(global-set-key [(shift f3)] 'highlight-symbol-prev)
;;(global-set-key [(control meta f3)] 'highlight-symbol-query-replace)

;; disable mouse-3 button for highlight
;; (global-set-key [mouse-3]
;;                 (lambda (event)
;;                   (interactive "e")
;;                   (save-excursion
;;                     (goto-char (posn-point (event-start event)))
;;                     (highlight-symbol-at-point-all-windows))))


(add-hook 'after-init-hook (lambda ()
                             (defalias 'highlight-symbol-at-point 'highlight-symbol)))
