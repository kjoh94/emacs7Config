(require 'helm-ring)
(eval-after-load "helm-ring"
  '(progn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; kjoh's note
     ;; override helm-mark-ring-get-marks in helm-ring.el
     ;; add function name on mark list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     (defun helm-mark-ring-get-marks (pos)
       (save-excursion
         (goto-char pos)
         (forward-line 0)
         (let ((line  (car (split-string (thing-at-point 'line) "[\n\r]")))
               (funcname (which-function)))
           (when (string= "" line)
             (setq line  "<EMPTY LINE>"))
           (format "%7d %s: %s" (line-number-at-pos)
                   (if funcname (format "[%s]" funcname) "")
                   line))))

     (defvar helm-source-register-2
       '((name . "Registers")
         (candidates . helm-register-candidates)
         (action-transformer . helm-register-action-transformer)
         (action))
       "See (info \"(emacs)Registers\")")

     (defun helm-register ()
       "Preconfigured `helm' for Emacs registers."
       (interactive)
       (helm :sources 'helm-source-register-2
             :resume 'noresume
             :buffer "*helm register*"))

     (defun helm-register-candidates ()
       "Collecting register contents and appropriate commands."
       (cl-loop for (char . val) in register-alist
                for key    = (single-key-description char)
                for string-actions =
                (cond
                 ((markerp val)
                  (let ((buf (marker-buffer val)))
                    (if (null buf)
                        (list "a marker in no buffer")
                      (list (concat
                             "a buffer position:"
                             (buffer-name buf)
                             ", position "
                             (int-to-string (marker-position val)))
                            'jump-to-register
                            'insert-register)))))
                when (markerp val)
                collect (cons (format "Register %3s: %s" key (car string-actions))
                              (cons char (cdr string-actions)))))
     
     ))
