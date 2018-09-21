(require 'compile)

(defconst cscope-command "cscope -dLC ")

(defvar cscope-hit-face compilation-info-face
  "Face name to use for cscope hits.")

(defvar cscope-error-face 'compilation-error
  "Face name to use for cscope error messages.")

(defvar cscope-match-face 'match
  "Face name to use for cscope matches.")

(define-compilation-mode cscope-mode "Cscope"
  (setq cscope-last-buffer (current-buffer))

  (set (make-local-variable 'compilation-error-face)
       cscope-hit-face)
  (set (make-local-variable 'compilation-error-regexp-alist)
       cscope-regexp-alist)
  ;; compilation-directory-matcher can't be nil, so we set it to a regexp that
  ;; can never match.
  (set (make-local-variable 'compilation-directory-matcher) '("\\`a\\`"))

  (set (make-local-variable 'compilation-disable-input) t)
  (set (make-local-variable 'compilation-error-screen-columns)
       nil)
  (add-hook 'compilation-filter-hook 'cscope--filter nil t)
  )

(defconst cscope-regexp-alist
  '(
    ("^\\([^[:blank:]]+\\)[:]\\([[:digit:]]+\\)"
     1 2 nil nil nil))
  "Regexp used to match cscope hits.  See `compilation-error-regexp-alist'.")

(defvar cscope-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map compilation-minor-mode-map)
    (define-key map " " 'scroll-up-command)
    (define-key map "\^?" 'scroll-down-command)
    (define-key map "\C-c\C-f" 'next-error-follow-minor-mode)

    (define-key map "\r" 'compile-goto-error)  ;; ?
    (define-key map "n" 'next-error-no-select)
    (define-key map "p" 'previous-error-no-select)
    (define-key map "{" 'compilation-previous-file)
    (define-key map "}" 'compilation-next-file)
    (define-key map "\t" 'compilation-next-error)
    (define-key map [backtab] 'compilation-previous-error)
    map)
  "Keymap for cscope buffers.")

(defun cscope--filter ()
  "Remove the scope information printed by cscope.
This function is called from `compilation-filter-hook'."
  (save-excursion
    (forward-line 0)
    (let ((end (point)) beg)
      (goto-char compilation-filter-start)
      (forward-line 0)
      (setq beg (point))
      ;; Only operate on whole lines so we don't get caught with part of an
      ;; escape sequence in one chunk and the rest in another.
      (when (< (point) end)
        (setq end (copy-marker end))
        ;; Remove the scope and reformat the line number.
        (while (re-search-forward "[[:blank:]]+[^[:blank:]]+[[:blank:]]+\\(.+\\)" end 1)
          (replace-match (concat ":" (match-string 1)) t t))
	(goto-char beg)
	(while (re-search-forward (format "\\([^[:alpha:]]+\\)\\(%s\\)\\([^[:alpha:]]+\\)"
					  (buffer-local-value 'cscope-lookup-symbol (current-buffer)))
				  end 1)
	  (replace-match (concat (match-string 1)
				 (propertize (match-string 2) 'face nil 'font-lock-face cscope-match-face)
				 (match-string 3))
			 t t))
	))))

(defun cscope--interactive (prompt)
  (list
   (let (sym)
     (setq sym (current-word))
     (read-string
      (if sym
	  (format "%s (default %s): "
		  (substring prompt 0 (string-match "[ :]+\\'" prompt))
		  sym)
	prompt)
      nil nil sym)
     ))
  )

(defun cscope--find-file-in-heirarchy (current-dir fname)
  "Search for a file named FNAME upwards through the directory hierarchy, starting from CURRENT-DIR"
  (unless (fboundp 'cl-labels) (fset 'cl-labels 'labels))
  (cl-labels ((parent-directory (dir)
			     (unless (or (equal "/" dir)
					 (string-match "^[a-zA-Z]:/$" dir))
			       (file-name-directory (directory-file-name dir)))))
    (let ((file (concat current-dir fname))
	  (parent (parent-directory (expand-file-name current-dir))))
      (if (file-exists-p file)
	  file
	(when parent
	  (cscope--find-file-in-heirarchy parent fname))))))

(defun cscope--run-query (lookup)
  (let ((cscope-database (cscope--find-file-in-heirarchy (file-name-directory (buffer-file-name)) "cscope.files")))
    (if cscope-database
	(with-current-buffer
	    (compilation-start (format "cd %s %s %s"
				       (if (eq system-type 'windows-nt)
					   (replace-regexp-in-string "\/" "\\\\" (file-name-directory cscope-database))
					 (file-name-directory cscope-database))
				       (if (eq system-type 'windows-nt) "&" "&&")
				       (concat cscope-command lookup))
			       'cscope-mode)
	  (setq cscope-lookup-symbol (substring lookup 2))
	  (make-local-variable 'cscope-lookup-symbol))
      (message "Unable to find cscope.files"))))

(defun cscope-find-this-symbol (symbol)
  "Locate a symbol in source code."
  (interactive (cscope--interactive "Find this symbol: "))
  (cscope--run-query (concat "-0" symbol)))

(defun cscope-find-global-definition (symbol)
  "Find a symbol's global definition."
  (interactive (cscope--interactive "Find this global definition: "))
  (cscope--run-query (concat "-1" symbol)))

(defun cscope-find-called-functions (symbol)
  "Display functions called by a function."
  (interactive (cscope--interactive "Find functions called by this function: "))
  (cscope--run-query (concat "-2" symbol)))

(defun cscope-find-functions-calling-this-function (symbol)
  "Display functions calling a function."
  (interactive (cscope--interactive "Find functions calling this function: "))
  (cscope--run-query (concat "-3" symbol)))

(defun cscope-find-this-text-string (symbol)
  "Locate where a text string occurs."
  (interactive (cscope--interactive "Find this text string: "))
  (cscope--run-query (concat "-4" symbol)))

(defun cscope-find-files-including-file (symbol)
  "Locate a file."
  (interactive (cscope--interactive "Find file: "))
  (cscope--run-query (concat "-7" symbol)))

(defun cscope-find-this-file (symbol)
  "Locate all files #including a file."
  (interactive (cscope--interactive "Find files #including this file: "))
  (cscope--run-query (concat "-8" symbol)))

(provide 'ascope)
