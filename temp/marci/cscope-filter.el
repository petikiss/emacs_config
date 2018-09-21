;;; cscope-filter.el --- Filter results in cscope buffer

;; Created:  Fang Lungang 10/28/2015
;; Modified: Fang Lungang 11/10/2015 15:10>

;; Copyright (C) 2015  Fang Lungang

;; Author: Fang Lungang <lgfang78@gmail.com>
;; Keywords: c, cscope
;; URL: https://github.com/lgfang/elisp/blob/master/cscope-filter.el
;; Version: 0.0.8

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This small "package" works atop the xcscope.el.  This package is to enable
;; users to filter the content of cscope buffer, a feature which can be useful
;; in really large projects.

;; To install this package, just copy this file into your load-path and add the
;; following into your init.el:

;; (require 'cscope-filter)

;; To use, simply run one of the following functions per your needs (Note that,
;; I defined hotkeys for them): cscope-filter-hide, cscope-filter-keep, and
;; cscope-filter-show-all.

;; NOTE: this package hide/keep files based text property `cscope-file', which
;; is absolute path and differs from the path shown in the cscope buffer.  E.g. a
;; file shown as "hello/world.c" may actually be ".../foobar/hello/world.c".
;; Hence, even though irrelevant it might seem, it will be hidden by
;; cscope-filter-hide "foobar".

;;; Code:

(require 'xcscope)

(defvar cscope-filter-invisible-areas ()
  "List of invisible overlays.")

(add-to-invisibility-spec 'csf)

(defun cscope-filter-add-overlay (start end)
  "Hide region between START and END."
  (let ((overlay (make-overlay start end)))
    (setq cscope-filter-invisible-areas
          (cons overlay cscope-filter-invisible-areas))
    (overlay-put overlay 'invisible 'csf)))

(defun cscope-filter-hide (regexp match-rule)
  "Hide entries which matches REGEXP according to MATCH-RULE."
  (interactive "MHide files matching regexp: ")
  (let ((begin nil))
    (goto-char (point-min))
    (while (/= (point) (point-max))
      (when (get-text-property (point) 'cscope-file)
        (if (funcall match-rule regexp)
            (if (not begin) (setq begin (point))) ; enter the region
          (if begin                               ; leave the region
              (progn
              (cscope-filter-add-overlay begin (point))
              (setq begin nil)))))
      (forward-line 1))
    ;; The last region may be at the end of buffer
    (if (and begin (eobp))
        (progn
          (cscope-filter-add-overlay begin (point))
          (setq begin nil)))))

(defun cscope-filter-hide-file (regexp)
  "Hide source lines matching REGEXP."
  (interactive "MHide files matching regexp: ")
  (cscope-filter-hide 
   regexp 
   (lambda(x)
     (string-match x (get-text-property (point) 'cscope-file)))))

(defun cscope-filter-hide-code (regexp)
  "Hide source lines matching REGEXP."
  (interactive "MHide code matching regexp: ")
  (cscope-filter-hide
   regexp
   (lambda (x)
     (and (/= -1 (get-text-property (point) 'cscope-line-number))
       (string-match
        x
        (buffer-substring-no-properties
         (line-beginning-position) (line-end-position)))))))

(defun cscope-filter-keep-file (regexp)
  "Show only entries from files name (and path) of which match REGEXP."
  (interactive "MShow only files matching regexp: ")
  (cscope-filter-hide
   regexp
   (lambda(x)
     (not (string-match x (get-text-property (point) 'cscope-file))))))

(defun cscope-filter-keep-code (regexp)
  "Show only source lines matching REGEXP."
  (interactive "MShow only code matching regexp: ")
  (cscope-filter-hide
   regexp
   (lambda (x)
     (and (/= -1 (get-text-property (point) 'cscope-line-number))
          (not
           (string-match 
            x
            (buffer-substring-no-properties
             (line-beginning-position) (line-end-position))))))))

(defun cscope-filter-show-all ()
  "Unhide all."
  (interactive)
  (set-buffer (get-buffer cscope-output-buffer-name))
  (mapc (lambda (overlay) (delete-overlay overlay))
        cscope-filter-invisible-areas)
  (setq cscope-filter-invisible-areas ()))

(define-key cscope:map "\C-csh" 'cscope-filter-hide-file)
(define-key cscope:map "\C-csk" 'cscope-filter-keep-file)
(define-key cscope-list-entry-keymap "h" 'cscope-filter-hide-file)
(define-key cscope-list-entry-keymap "k" 'cscope-filter-keep-file)
(define-key cscope-list-entry-keymap "H" 'cscope-filter-hide-code)
(define-key cscope-list-entry-keymap "K" 'cscope-filter-keep-code)
(define-key                             ; r -> reset cscope-filter
  cscope-list-entry-keymap "r" 'cscope-filter-show-all)

(provide 'cscope-filter)

;;; cscope-filter.el ends here
