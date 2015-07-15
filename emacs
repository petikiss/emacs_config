;; ---------------------------------------------------------------------
;; Don't fuck with this part.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(default-input-method "rfc1345")
 '(global-font-lock-mode t nil (font-lock))
 '(nxml-child-indent 3)
 '(show-paren-mode t nil (paren))
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :Foundry "osx" :slant normal :weight normal :height 109 :width normal)))))

;; ---------------------------------------------------------------------
;; TABs and spaces

                                        ; set all kind of TABs to 8 chars
(setq c-basic-offset 3)
(setq default-tab-width 3)
(setq tab-width 3)
(setq py-indent-offset 3)
(setq-default indent-tabs-mode nil)
(setq c-default-style "linux")
(c-set-offset (quote arglist-cont-nonempty) (quote +) nil)
(c-set-offset (quote arglist-intro) (quote +) nil)
(c-set-offset (quote arglist-close) (quote 0) nil)
(c-set-offset (quote case-label) (quote +) nil)
(c-set-offset (quote innamespace) (quote 0) nil)
(c-set-offset (quote access-label) (quote /) nil)

(defun untabify-buffer ()
  "untabify the whole buffer"
  (untabify (point-min) (point-max)))

(add-hook 'c-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'delete-trailing-whitespace)
            (add-hook 'before-save-hook 'untabify-buffer)))

                                        ; show trailing whitespace at end of lines
(setq-default show-trailing-whitespace t)

                                        ; show empty lines after end of buffer
                                        ;(setq default-indicate-empty-lines t)


;; ---------------------------------------------------------------------
;; reverse video

(set-cursor-color "black")
(set-foreground-color "black")
(set-background-color "gainsboro")

;; ---------------------------------------------------------------------
;; iswitch mode

(iswitchb-mode 1)

(defun iswitchb-local-keys ()
  (mapc (lambda (K)
          (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
        '(("<right>" . iswitchb-next-match)
          ("<left>" . iswitchb-prev-match)
          ("<up>" . ignore)
          ("<down>" . ignore))))

(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

;; ---------------------------------------------------------------------
;; dired mode

                                        ; 'a' does not open new buffer
(put 'dired-find-alternate-file 'disabled nil)


;; ---------------------------------------------------------------------
;; keybindings

(global-set-key (kbd "<f5>") 'open-dot-emacs)
;(global-set-key (kbd "<f6>") 'list-bookmarks)
(global-set-key (kbd "<f7>") 'goto-line)
;(global-set-key (kbd "<f8>") 'shell)
;(global-set-key (kbd "<f9>") 'compile)

                                        ;(global-set-key (kbd "C-<next>") 'next-buffer)
                                        ;(global-set-key (kbd "C-<prior>") 'previous-buffer)

(global-set-key (kbd "C-c i") 'indent-region)
(global-set-key (kbd "C-c o") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-c m") 'man-follow)
(global-set-key (kbd "C-c f") 'open-file-under-cursor)

(put 'upcase-region 'disabled nil) ; C-c C-u
(put 'downcase-region 'disabled nil) ; C-c C-l

(global-set-key (kbd "C-z") 'yank) ; for querty/quertz compatibility

                                        ; accented characters (for en-us keyboard)
(global-set-key (kbd "C-' a") "á")
(global-set-key (kbd "C-' e") "é")
(global-set-key (kbd "C-' i") "í")
(global-set-key (kbd "C-' o") "ó")
(global-set-key (kbd "C-; o") "ö")
(global-set-key (kbd "C-\" o") "ő")
(global-set-key (kbd "C-' u") "ú")
(global-set-key (kbd "C-; u") "ü")
(global-set-key (kbd "C-\" u") "ű")

(global-set-key (kbd "C-' A") "Á")
(global-set-key (kbd "C-' E") "É")
(global-set-key (kbd "C-' I") "Í")
(global-set-key (kbd "C-' O") "Ó")
(global-set-key (kbd "C-; O") "Ö")
(global-set-key (kbd "C-\" O") "Ő")
(global-set-key (kbd "C-' U") "Ú")
(global-set-key (kbd "C-; U") "Ü")
(global-set-key (kbd "C-\" U") "Ű")


(defun open-dot-emacs ()
  (interactive)
  (find-file "~/.emacs"))

(defun kill-buffer-other-window (arg)
  "Kill the buffer in the other window, and make the current buffer full size. If no other window, kills current buffer."
  (interactive "p")
  (let ((buf (save-window-excursion
               (other-window arg)
               (current-buffer))))
    (delete-windows-on buf)
    (kill-buffer buf)))

;; ---------------------------------------------------------------------
;; shell

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(setq comint-input-ring-size 1024)

;; ---------------------------------------------------------------------
;; LaTeX

(add-hook 'LaTeX-mode-hook
          '(lambda ()
             (turn-on-reftex)
             (local-set-key (kbd "C-c TAB") 'TeX-complete-symbol)
             (ispell-change-dictionary "american")))

(add-hook 'latex-mode-hook 'turn-on-reftex)

(setq reftex-plug-into-AUCTeX t)

;; ---------------------------------------------------------------------
;; remote editing via scp

(require 'tramp)
(setq tramp-default-method "scp")

;; ---------------------------------------------------------------------
;; Make the mouse fuck off when you type.

(mouse-avoidance-mode 'banish)


;; ---------------------------------------------------------------------
;; miscellaneous

                                        ; "y or n" instead of "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

                                        ; don't make pesky backup~ files
(setq make-backup-files nil)

                                        ; don't use version numbers for backup files
(setq version-control 'never)

                                        ; remove splash screen
(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message t)

;; ---------------------------------------------------------------------
;; stuff

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

; Use "`" to jump to the matching parenthesis.
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert the
character typed."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
    ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
    (t (self-insert-command (or arg 1))) ))

(global-set-key "`" `goto-match-paren)


(require 'linum)
(global-linum-mode 1)

(desktop-save-mode 1)
(setq scroll-step 1)
(mouse-wheel-mode t)
(line-number-mode 1)


; eval-buffer




;; -------------------------------------------------------------------------------------------
;; -- ETAGS-SELECT --
;; find . -name \*.cc -o -name \*.hh -o -name \*.c | etags -
;;load the etags-select.el source code
(load-file "~/emacs_config/etags-select.el")


(setq tags-table-list '(""))



(defun find-tag-under-point()
  (interactive)
   (if (get-buffer etags-select-buffer-name)
      (progn (kill-buffer etags-select-buffer-name)
             (delete-window))
    (etags-select-find-tag-at-point)))

(global-set-key (kbd "<f4>")   'find-tag-under-point)


;; -------------------------------------------------------------------------------------------
;; -- HIGHLIGHT-SYMBOL --
(load-file "~/emacs_config/highlight-symbol.el")
(require 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-at-point)


;; -------------------------------------------------------------------------------------------
;; -- FIND_FILE_IN-TAGS --
(load-file "~/emacs_config/find-file-in-tags.el")
(global-set-key (kbd "<f12>")   'find-file-in-tags)


;; -------------------------------------------------------------------------------------------
;; -- SEARCH IN FILE --
(require 'thingatpt)

(defun my-isearch-yank-word-or-char-from-beginning ()
  "Move to beginning of word before yanking word in isearch-mode."
  (interactive)
  ;; Making this work after a search string is entered by user
  ;; is too hard to do, so work only when search string is empty.
  (if (= 0 (length isearch-string))
      (beginning-of-thing 'word))
  (isearch-yank-word-or-char)
  ;; Revert to 'isearch-yank-word-or-char for subsequent calls
  (substitute-key-definition 'my-isearch-yank-word-or-char-from-beginning
                 'isearch-yank-word-or-char
                 isearch-mode-map))

(add-hook 'isearch-mode-hook
 (lambda ()
   "Activate my customized Isearch word yank command."
   (substitute-key-definition 'isearch-yank-word-or-char
                  'my-isearch-yank-word-or-char-from-beginning
                  isearch-mode-map)))

;; (global-set-key (kbd "<f2>")   'my-isearch-yank-word-or-char-from-beginning)


;; -----------------------------------------------------------------------------------------
;; --  Set the title to file name. --
;; -------------------------------------------------------------------------------------------


(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))


;; -------------------------------------------------------------------------------------------
;;                                ClearCase WTF
;; -------------------------------------------------------------------------------------------


(defun ct-co()
 (interactive)
 (shell-command (concat "ct co -nc " (buffer-file-name) ))
 (revert-buffer t t) )


(defun ct-unco()
  (interactive)
  (shell-command (concat "ct unco " (buffer-file-name) ))
  (revert-buffer t t) )


(defun ct-lsco()
  (interactive)
  (message "Checked out files are:")
  (shell-command "ct lsco -all -me -short -cview | sort | uniq") )


(defun wpct-getinfo()
  (interactive)
  (shell-command "wpct getinfo") )


;; -------------------------------------------------------------------------------------------
;;                                Sticky functions
;; -------------------------------------------------------------------------------------------


(require 'semantic)
(semantic-mode)
(global-semantic-stickyfunc-mode)



;; -------------------------------------------------------------------------------------------
;;                                Reverting files
;; -------------------------------------------------------------------------------------------


(global-auto-revert-mode 1)


(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files.") )


;; ---------------------------------------------------------------------
;; Hide/Show functions block
;; ---------------------------------------------------------------------

(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-<down>") 'hs-show-block)
    (local-set-key (kbd "C-<up>")  'hs-hide-block)
    (hs-minor-mode t)))


