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
 '(default ((t (:family "DejaVu Sans Mono" :Foundry "osx" :slant normal :weight normal :height 107 :width normal)))))

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


(global-set-key (kbd "<f1>")  'pop-tag-mark)
(global-set-key (kbd "<f2>")  'find-tag-under-point)
(global-set-key (kbd "<f3>")  'highlight-symbol-at-point)
;(global-set-key (kbd "<f4>")  'global-highlight-changes-mode)
(global-set-key (kbd "<f5>") 'open-dot-emacs)
;(global-set-key (kbd "<f6>") 'list-bookmarks)
(global-set-key (kbd "<f7>") 'goto-line)
;(global-set-key (kbd "<f8>") 'shell)
;(global-set-key (kbd "<f9>") 'compile)
(global-set-key (kbd "<f10>") 'close-all-buffers)
;(global-set-key (kbd "<f11>") 'find-file-in-tags)
(global-set-key (kbd "<f12>") 'find-file-in-tags)



;(global-set-key (kbd "C-c i") 'indent-region)
;(global-set-key (kbd "C-c o") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
;(global-set-key (kbd "C-c m") 'man-follow)
;(global-set-key (kbd "C-c f") 'open-file-under-cursor)

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

;(require 'tramp)
;(setq tramp-default-method "scp")

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
(load-file "~/marci/etags-select.el")

;;(setq tags-table-list '("/vobs/tas/TAGS"))
;(setq tags-table-list '("/local/scratch/views/emrtsis_esekiws5873_homok2/vobs/tas"))

(defun find-tag-under-point()
  (interactive)
   (if (get-buffer etags-select-buffer-name)
      (progn (kill-buffer etags-select-buffer-name)
             (delete-window))
    (etags-select-find-tag-at-point)))

;(global-set-key (kbd "<f2>")   'find-tag-under-point)


;; -------------------------------------------------------------------------------------------
;; -- HIGHLIGHT-SYMBOL --
(load-file "~/marci/highlight-symbol.el")
(require 'highlight-symbol)
;(global-set-key [f3] 'highlight-symbol-at-point)


;; -------------------------------------------------------------------------------------------
;; -- FIND_FILE_IN-TAGS --
(load-file "~/marci/find-file-in-tags.el")
;(global-set-key (kbd "<f12>")   'find-file-in-tags)


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


; can be removed - if it was not missing :)
(load-file "~/marci/xcscope.el")
;(load-file "~/marci/cscope-filter.el")
(require 'xcscope)
;(require 'cscope-filter)
(global-set-key (kbd "<f4>")   'cscope-find-this-symbol)



;; ---------------------------------------------------------------------
;; go back to previous buffer
;; ---------------------------------------------------------------------

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))



;; ---------------------------------------------------------------------
;; close all buffer
;; ---------------------------------------------------------------------
(defun kill-buffer-other-window (arg)
  "Kill the buffer in the other window, and make the current buffer full size. If no other window, kills current buffer."
  (interactive "p")
  (let ((buf (save-window-excursion
               (other-window arg)
               (current-buffer))))
    (delete-windows-on buf)
    (kill-buffer buf)))


(defun close-all-buffers ()
  (interactive)
  (if (y-or-n-p "Really close all buffer?")
    (progn (mapc 'kill-buffer (buffer-list)))))

