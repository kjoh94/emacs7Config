;;(load-file "~/cedet/cedet-devel-load.el")

;;(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)


;; these are too much
;;(semantic-load-enable-gaudy-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)

(semantic-mode 1)

(global-ede-mode 1)

;;C-c , SPC       semantic-complete-analyze-inline
;;C-c , ,         semantic-force-refresh
;;C-c , G         semantic-symref
;;C-c , J         semantic-complete-jump
;;C-c , g         semantic-symref-symbol
;;C-c , j         semantic-complete-jump-local
;;C-c , l         semantic-analyze-possible-completions
;;C-c , m         semantic-complete-jump-local-members
;;C-c , n         senator-next-tag
;;C-c , p         senator-previous-tag
;;C-c , r         senator-copy-tag-to-register
;;C-c , u         senator-go-to-up-reference

(defun my-cedet-hook ()
  ;;(setq ac-sources (append '(ac-source-semantic) ac-sources))
  (local-set-key [(meta return)] 'semantic-ia-complete-symbol-menu)
  ;;(local-set-key "\C-c?" 'semantic-ia-complete-symbol)
  (local-set-key (kbd "C-;") 'semantic-analyze-proto-impl-toggle)
  (local-set-key (kbd "C-c , i") 'semantic-decoration-include-visit)
  (local-set-key (kbd "C-c j") 'kjoh/semantic-ia-fast-jump)
  (local-set-key (kbd "C-c 3") 'semantic-ia-show-summary)
  (local-set-key "\C-cv" 'semantic-ia-show-variants))


(add-hook 'c-mode-common-hook 'my-cedet-hook)
(add-hook 'lisp-mode-hook 'my-cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'my-cedet-hook)
(add-hook 'scheme-mode-hook 'my-cedet-hook)
(add-hook 'erlang-mode-hook 'my-cedet-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; override ia.el functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun kjoh/semantic-ia-fast-jump (point)
  (interactive "d")
  (require 'helm-gtags)
  (let ((k nil)
        (r nil))
    (condition-case nil
        (progn
          (helm-gtags-find-tag-directory)
          (helm-gtags-save-current-context)
          (setq k 1))
      ('error
       ;; (message "helm-gtags error")
       ))
    (setq r (semantic-ia-fast-jump point))
    (if (= 1 r)
        (if k (helm-gtags--push-context helm-gtags-saved-context))
      (if (= 0 r)
          (if k (helm-gtags--push-context helm-gtags-saved-context))))
    (setq helm-gtags-saved-context nil)))


;; [2016-04-29 Fri 23:27] kjoh's note
;; semantic-stickyfunc-fetch-stickyline() override
(eval-after-load "semantic/util-modes"
  '(progn
     (defun semantic-stickyfunc-fetch-stickyline ()
       "Make the function at the top of the current window sticky.
Capture its function declaration, and place it in the header line.
If there is no function, disable the header line."
       (save-excursion
         ;; [2016-04-29 Fri 23:27] kjoh's note
         ;; just use current location
         ;; (goto-char (window-start (selected-window)))
         (let* ((noshow (bobp))
                (str
                 (progn
                   ;; kjoh's note
                   ;; (forward-line -1)
                   ;; (end-of-line)
                   ;; Capture this function
                   (let* ((tag (semantic-stickyfunc-tag-to-stick)))
                     ;; TAG is nil if there was nothing of the appropriate type there.
                     (if (not tag)
                         ;; Set it to be the text under the header line
                         (if noshow
                             ""
                           (if semantic-stickyfunc-show-only-functions-p ""
                             (buffer-substring (point-at-bol) (point-at-eol))
                             ))
                       ;; Go get the first line of this tag.
                       (goto-char (semantic-tag-start tag))
                       ;; Klaus Berndl <klaus.berndl@sdm.de>:
                       ;; goto the tag name; this is especially needed for languages
                       ;; like c++ where a often used style is like:
                       ;;     void
                       ;;     ClassX::methodM(arg1...)
                       ;;     {
                       ;;       ...
                       ;;     }
                       ;; Without going to the tag-name we would get"void" in the
                       ;; header line which is IMHO not really useful
                       (search-forward (semantic-tag-name tag) nil t)
                       (buffer-substring (point-at-bol) (point-at-eol))
                       ))))
                (start 0))
           (while (string-match "%" str start)
             (setq str (replace-match "%%" t t str 0)
                   start (1+ (match-end 0)))
             )
           ;; In 21.4 (or 22.1) the header doesn't expand tabs.  Hmmmm.
           ;; We should replace them here.
           ;;
           ;; This hack assumes that tabs are kept smartly at tab boundaries
           ;; instead of in a tab boundary where it might only represent 4 spaces.
           (while (string-match "\t" str start)
             (setq str (replace-match "        " t t str 0)))
           str)))))

;; [2016-04-30 Sat 18:03] kjoh
;; semantic-ia--fast-jump-helper override
;; add highlighting feature when jump to other file
(eval-after-load "semantic/ia"
  '(progn
     (defun semantic-ia--fast-jump-helper (dest)
       "Jump to DEST, a Semantic tag.
This helper manages the mark, buffer switching, and pulsing."
       (require 'evil-jumper)
       ;; We have a tag, but in C++, we usually get a prototype instead
       ;; because of header files.  Let's try to find the actual
       ;; implementation instead.
       (when (semantic-tag-prototype-p dest)
         (let* ((refs (semantic-analyze-tag-references dest))
                (impl (semantic-analyze-refs-impl refs t))
                )
           (when impl (setq dest (car impl)))))

       ;; Make sure we have a place to go...
       (if (not (and (or (semantic-tag-with-position-p dest)
                         (semantic-tag-get-attribute dest :line))
                     (semantic-tag-file-name dest)))
           (error "Tag %s has no buffer information"
                  (semantic-format-tag-name dest)))

       ;; Once we have the tag, we can jump to it.  Here
       ;; are the key bits to the jump:

       ;; 1) Push the mark, so you can pop global mark back, or
       ;;    use semantic-mru-bookmark mode to do so.
       (push-mark)
       (when (fboundp 'push-tag-mark)
         (push-tag-mark))

       ;; kjoh's: fancy pulsing depends on buffer changed
       (let ((prev (buffer-file-name (current-buffer))))
         ;; 2) Visits the tag.
         (semantic-go-to-tag dest)
         ;; 3) go-to-tag doesn't switch the buffer in the current window,
         ;;    so it is like find-file-noselect.  Bring it forward.
         (setq evil-jumper--jumping t)  ; kjoh, disable evil-jump push
         (switch-to-buffer (current-buffer))
         (setq evil-jumper--jumping nil) ; kjoh, restrore
         ;; 4) Fancy pulsing.
         (if (not (eq prev (buffer-file-name (current-buffer))))
             (progn
               (pulse-momentary-highlight-one-line (point))
               1)
           0)))))


(defvar c-files-regex ".*\\.\\(c\\|cc\\|cpp\\|h\\|hpp\\)"
  "A regular expression to match any c/c++ related files under a directory")

(defun my-semantic-parse-dir (root regex)
  "
   This function is an attempt of mine to force semantic to
   parse all source files under a root directory. Arguments:
   -- root: The full path to the root directory
   -- regex: A regular expression against which to match all files in the directory
  "
  (let (
        ;;make sure that root has a trailing slash and is a dir
        (root (file-name-as-directory root))
        (files (directory-files root t ))
       )
    ;; remove current dir and parent dir from list
    (setq files (delete (format "%s." root) files))
    (setq files (delete (format "%s.." root) files))
    (while files
      (setq file (pop files))
      (if (not(file-accessible-directory-p file))
          ;;if it's a file that matches the regex we seek
          (progn (when (string-match-p regex file)
               (save-excursion
                 (semanticdb-file-table-object file))
           ))
          ;;else if it's a directory
          (my-semantic-parse-dir file regex)
      )
     )
  )
)

(defun my-semantic-parse-current-dir (regex)
  "
   Parses all files under the current directory matching regex
  "
  (my-semantic-parse-dir (file-name-directory(buffer-file-name)) regex)
)

(defun lk-parse-curdir-c ()
  "
   Parses all the c/c++ related files under the current directory
   and inputs their data into semantic
  "
  (interactive)
  (my-semantic-parse-current-dir c-files-regex)
)

(defun lk-parse-dir-c (dir)
  "Prompts the user for a directory and parses all c/c++ related files
   under the directory
  "
  (interactive (list (read-directory-name "Provide the directory to search in:")))
  (my-semantic-parse-dir (expand-file-name dir) c-files-regex)
)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; global EDE
;; project sample
;;;;;;;;;;;;;;;;;;;;;;;;;
;; (ede-cpp-root-project "Test"
;;                 :name "Test Project"
;;                 :file "~/work/project/CMakeLists.txt"
;;                 :include-path '("/"
;;                                 "/Common"
;;                                 "/Interfaces"
;;                                 "/Libs"
;;                                )
;;                 :system-include-path '("~/exp/include")
;;                 :spp-table '(("isUnix" . "")
;;                              ("BOOST_TEST_DYN_LINK" . "")))

;;(ede-cpp-root-project "libvpx"
;;                :name "libvpx Project"
;;                :file "/Volumes/stash/Work/libvpx-svn/trunk/README"
;;                :include-path '("/"
;;                                "../include"
;;                                "../../include"
;;                               ))

;; (ede-cpp-root-project "mesa"
;;                 :name "mesa Project"
;;                 :file "/home/kjoh/work/mesa/mesa-17.0.0-rc1/src/Makefile"
;;                 :include-path '("/"
;;                                 "../include"
;;                                 "../../include"
;;                                 "../inc"
;;                                 "../../inc"
;;                                ))

;; (ede-cpp-root-project "angle"
;;                 :name "angle Project"
;;                 :file "/home/kyongjoo.oh/angle/README.md"
;;                 :include-path '("/"
;;                                 "../include"
;;                                 "../../include"
;;                                ))
