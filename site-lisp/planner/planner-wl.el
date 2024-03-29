;;; planner-wl.el --- Wanderlust integration for the Emacs Planner

;; Copyright (C) 2004, 2008 Yvonne Thomson (yvonne AT netbrains DOT com DOT au)
;; Parts copyright (C) 2004, 2008 Angus Lees (gus AT inodes DOT org)
;; Parts copyright (C) 2004, 2005, 2006, 2007, 2008 Free Software Foundation, Inc.

;; Author: Yvonne Thomson (yvonne AT thewatch DOT net)
;; Keywords: planner, wanderlust, wl
;; URL: http://www.wjsullivan.net/PlannerMode.html

;; This file is part of Planner.  It is not part of GNU Emacs.

;; Planner is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; Planner is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Planner; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Add
;;
;;   (require 'planner-wl)
;;
;; to your .emacs or .wl. You will then be able to call
;; M-x planner-create-task-from-buffer from Wanderlust summary buffers
;; with the correct annotation.

;; To add keybindings to Wanderlust, call (from .emacs or .wl)
;;
;;   (planner-wl-insinuate)
;;
;; This binds C-c C-t in summary buffers to `planner-create-task-from-buffer'

;; Note:
;;  `planner-wl-annotation-from-wl' uses `wl-summary-from-function' (and
;;   related options) rather than `planner-ignored-from-addresses'

;; URLs are of the form wl://foldername/msg-id

;;;_ + Contributors

;; Angus Lees (gus AT inodes DOT org) remade quite a bit of this file.

;; Jeremy Cowgar (jeremy AT cowgar DOT com) updated this to work with
;; Wanderlust 2.12.0.

;;; Code:

(require 'planner)
(require 'wl)
(require 'wl-summary)

;;;###autoload
(defun planner-wl-insinuate ()
  "Hook Planner into Wanderlust.
Add special planner keybindings to`wl-summary-mode-map'.
From the Wanderlust Summary view, you can type C-c C-t to create a task."
  (define-key wl-summary-mode-map (kbd "C-c C-t") 'planner-create-task-from-buffer))

;;;###autoload
(defun planner-wl-annotation-from-wl ()
  "If called from wl, return an annotation.
Suitable for use in `planner-annotation-functions'."
  (when (equal major-mode 'wl-summary-mode)
    (let* ((msgnum (wl-summary-message-number))
           (msg-id (elmo-message-field wl-summary-buffer-elmo-folder
                                       msgnum 'message-id))
           (wl-message-entity
            (if (fboundp 'elmo-message-entity)
                (elmo-message-entity
                 wl-summary-buffer-elmo-folder msgnum)
              (elmo-msgdb-overview-get-entity
               msgnum (wl-summary-buffer-msgdb)))))
      (planner-make-link
       (concat "wl://" wl-summary-buffer-folder-name "/" msg-id)
       (concat "E-Mail " (wl-summary-line-from))
       t))))

;;;###autoload
(defun planner-wl-browse-url (url)
  "If this is a Wanderlust URL, jump to it."
  (when (string-match "\\`wl:/*\\(.+\\)/\\(.+\\)" url)
    (let ((group (match-string 1 url))
          (article (match-string 2 url)))
      (wl-summary-goto-folder-subr group 'no-sync t nil t)
      (wl-summary-jump-to-msg-by-message-id article)
      (wl-summary-redisplay)
      ;; force a non-nil return value
      t)))

(planner-add-protocol "wl:/*" 'planner-wl-browse-url nil)
(custom-add-option 'planner-annotation-functions
                   'planner-wl-annotation-from-wl)
(add-hook 'planner-annotation-functions 'planner-wl-annotation-from-wl)

(provide 'planner-wl)

;;; planner-wl.el ends here
