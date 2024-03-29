;;; adjust-parens.el --- Indent and dedent Lisp code, automatically adjust close parens -*- lexical-binding: t; -*-

;; Copyright (C) 2013  Free Software Foundation, Inc.

;; Author: Barry O'Reilly <gundaetiapo@gmail.com>
;; Version: 1.0

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
;;
;; This package provides commands for indenting and dedenting Lisp
;; code such that close parentheses are automatically adjusted to be
;; consistent with the new level of indentation.
;;
;; When reading Lisp, the programmer pays attention to open parens and
;; the close parens on the same line. But when a sexp spans more than
;; one line, she deduces the close paren from indentation alone. Given
;; that's how we read Lisp, this package aims to enable editing Lisp
;; similarly: automatically adjust the close parens programmers ignore
;; when reading. A result of this is an editing experience somewhat
;; like python-mode, which also offers "indent" and "dedent" commands.
;; There are differences because lisp-mode knows more due to existing
;; parens.
;;
;; To use:
;;   (require 'adjust-parens)
;;
;; This binds two keys in Lisp Mode:
;;   (local-set-key (kbd "TAB") 'lisp-indent-adjust-parens)
;;   (local-set-key (kbd "<backtab>") 'lisp-dedent-adjust-parens)
;;
;; lisp-indent-adjust-parens potentially calls indent-for-tab-command
;; (the usual binding for TAB in Lisp Mode). Thus it should not
;; interfere with other TAB features like completion-at-point.
;;
;; Some examples follow. | indicates the position of point.
;;
;;   (let ((x 10) (y (some-func 20))))
;;   |
;;
;; After one TAB:
;;
;;   (let ((x 10) (y (some-func 20)))
;;     |)
;;
;; After three more TAB:
;;
;;   (let ((x 10) (y (some-func 20
;;                              |))))
;;
;; After two Shift-TAB to dedent:
;;
;;   (let ((x 10) (y (some-func 20))
;;         |))
;;
;; When dedenting, the sexp may have sibling sexps on lines below. It
;; makes little sense for those sexps to stay at the same indentation,
;; because they cannot keep the same parent sexp without being moved
;; completely. Thus they are dedented too. An example of this:
;;
;;   (defun func ()
;;     (save-excursion
;;       (other-func-1)
;;       |(other-func-2)
;;       (other-func-3)))
;;
;; After Shift-TAB:
;;
;;   (defun func ()
;;     (save-excursion
;;       (other-func-1))
;;     |(other-func-2)
;;     (other-func-3))
;;
;; If you indent again with TAB, the sexps siblings aren't indented:
;;
;;   (defun func ()
;;     (save-excursion
;;       (other-func-1)
;;       |(other-func-2))
;;     (other-func-3))
;;
;; Thus TAB and Shift-TAB are not exact inverse operations of each
;; other, though they often seem to be.

;;; Code:

;; Future work:
;;   - Consider taking a region as input in order to indent a sexp and
;;     its siblings in the region. Dedenting would not take a region.
;;   - Write tests

(require 'cl)

(defun last-sexp-with-relative-depth (from-pos to-pos rel-depth)
  "Parsing sexps from FROM-POS (inclusive) to TO-POS (exclusive),
return the position of the last sexp that had depth REL-DEPTH relative
to FROM-POS. Returns nil if REL-DEPTH is not reached.

Examples:
  Region:   a (b c (d)) e (f g (h i)) j

  Evaluate: (last-sexp-with-relative-depth pos-a (1+ pos-j) 0)
  Returns:  position of j

  Evaluate: (last-sexp-with-relative-depth pos-a (1+ pos-j) -1)
  Returns:  position of (h i)

This function assumes FROM-POS is not in a string or comment."
  (save-excursion
    (goto-char from-pos)
    (let (the-last-pos
          (parse-state '(0 nil nil nil nil nil nil nil nil)))
      (while (< (point) to-pos)
        (setq parse-state
              (parse-partial-sexp (point)
                                  to-pos
                                  nil
                                  t ; Stop before sexp
                                  parse-state))
        (and (not (eq (point) to-pos))
             (eq (car parse-state) rel-depth)
             (setq the-last-pos (point)))
        ;; The previous parse may not advance. To advance and maintain
        ;; correctness of depth, we parse over the next char.
        (setq parse-state
              (parse-partial-sexp (point)
                                  (1+ (point))
                                  nil
                                  nil
                                  parse-state)))
      the-last-pos)))

(defun adjust-close-paren-for-indent ()
  "Adjust a close parentheses of a sexp so as
lisp-indent-adjust-parens can indent that many levels.

If a close paren was moved, returns a two element list of positions:
where the close paren was moved from and the position following where
it moved to.

If there's no close parens to move, either return nil or allow
scan-error to propogate up."
  (save-excursion
    (let ((deleted-paren-pos
           (save-excursion
             (beginning-of-line)
             (backward-sexp)
             ;; Account for edge case when point has no sexp before it
             (if (bobp)
                 nil
               ;; If the sexp at point is a list,
               ;; delete its closing paren
               (when (eq (scan-lists (point) 1 0)
                         (scan-sexps (point) 1))
                 (forward-sexp)
                 (delete-char -1)
                 (point))))))
      (when deleted-paren-pos
        (let ((sexp-to-close
               (last-sexp-with-relative-depth (point)
                                              (progn (end-of-line)
                                                     (point))
                                              0)))
          (when sexp-to-close
            (goto-char sexp-to-close)
            (forward-sexp))
          ;; Note: when no sexp-to-close found, line is empty. So put
          ;; close paren after point.
          (insert ")")
          (list deleted-paren-pos (point)))))))

(defun adjust-close-paren-for-dedent ()
  "Adjust a close parentheses of a sexp so as
lisp-dedent-adjust-parens can dedent that many levels.

If a close paren was moved, returns a two element list of positions:
where the close paren was moved from and the position following where
it moved to.

If there's no close parens to move, either return nil or allow
scan-error to propogate up."
  (save-excursion
    (let ((deleted-paren-pos
           (save-excursion
             (when (< (point)
                      (progn (up-list)
                             (point)))
               (delete-char -1)
               (point)))))
      (when deleted-paren-pos
        (let ((sexp-to-close
               ;; Needs to work when dedenting in an empty list, in
               ;; which case backward-sexp will signal scan-error and
               ;; sexp-to-close will be nil.
               (condition-case nil
                   (progn (backward-sexp)
                          (point))
                 (scan-error nil))))
          ;; Move point to where to insert close paren
          (if sexp-to-close
              (forward-sexp)
            (backward-up-list)
            (forward-char 1))
          (insert ")")
          ;; The insertion makes deleted-paren-pos off by 1
          (list (1+ deleted-paren-pos)
                (point)))))))

(defun adjust-parens-p ()
  "Whether to adjust parens."
  (save-excursion
    (let ((orig-pos (point)))
      (back-to-indentation)
      (and (not (use-region-p))
           (<= orig-pos (point))))))

(defun adjust-parens-and-indent (adjust-function prefix-arg)
  "Adjust close parens and indent the region over which the parens
moved."
  (let ((region-of-change (list (point) (point))))
    (cl-loop for i from 1 to (or prefix-arg 1)
             with finished = nil
             while (not finished)
             do
             (condition-case err
                 (let ((close-paren-movement
                        (funcall adjust-function)))
                   (if close-paren-movement
                       (setq region-of-change
                             (list (min (car region-of-change)
                                        (car close-paren-movement)
                                        (cadr close-paren-movement))
                                   (max (cadr region-of-change)
                                        (car close-paren-movement)
                                        (cadr close-paren-movement))))
                     (setq finished t)))
               (scan-error (setq finished err))))
    (apply 'indent-region region-of-change))
  (back-to-indentation))

(defun lisp-indent-adjust-parens (&optional prefix-arg)
  "Indent Lisp code to the next level while adjusting sexp balanced
expressions to be consistent.

This command can be bound to TAB instead of indent-for-tab-command. It
potentially calls the latter."
  (interactive "P")
  (if (adjust-parens-p)
      (adjust-parens-and-indent 'adjust-close-paren-for-indent
                                prefix-arg)
    (indent-for-tab-command prefix-arg)))

(defun lisp-dedent-adjust-parens (&optional prefix-arg)
  "Dedent Lisp code to the previous level while adjusting sexp
balanced expressions to be consistent.

Binding to <backtab> (ie Shift-Tab) is a sensible choice."
  (interactive "P")
  (when (adjust-parens-p)
    (adjust-parens-and-indent 'adjust-close-paren-for-dedent
                              prefix-arg)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "TAB") 'lisp-indent-adjust-parens)
            (local-set-key (kbd "<backtab>") 'lisp-dedent-adjust-parens)))

;;;; ChangeLog:

;; 2013-08-29  Barry O'Reilly  <gundaetiapo@gmail.com>
;; 
;; 	* README: Update with corrected information.
;; 	* packages/adjust-parens/adjust-parens.el: Add new package.
;; 


(provide 'adjust-parens)

;;; adjust-parens.el ends here
