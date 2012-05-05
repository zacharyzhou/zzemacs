;;;; common-setting.el --- common config file
;;

; tell me if there's something wrong
;; (setq debug-on-error t)

(zz-load-path "site-lisp")

;;; disable loading of "default.el" at startup
;(setq inhibit-default-init t)
;(keyboard-translate ?\C-h ?\C-?)  ; translate `C-h' to DEL
;(keyboard-translate ?\C-? ?\C-h)  ; translate DEL to `C-h'.

;;; the current frame to make it transparent
;(set-frame-parameter (selected-frame) 'alpha '(85 50))

; -*- Chinese -*-
(defun my-set-language-chinese ()
  "This This is for chinese setting"
  (interactive)
  (set-language-environment 'Chinese-GB18030)
  (set-buffer-file-coding-system 'chinese-gb18030)
  (message "This is for chinese"))

; -*- Japanese -*-
(defun my-set-language-japanese ()
  "This This is for japanese setting"
  (interactive)
  (set-language-environment 'Japanese)
  (set-buffer-file-coding-system 'japanese-shift-jis)
  (message "This is for japanese"))

; -*- utf-8 -*-
(defun my-set-language-utf-8 ()
  "This This is for utf-8 setting"
  (interactive)
  (set-language-environment 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (message "This is for utf-8"))

;; -*- Language switch -*-
;(cond
;  ((string-match "j[ap].*" (getenv "LANG")) (my-set-language-japanese))
;  ((string-match "(zh.*)|(CHS)" (getenv "LANG")) (my-set-language-chinese))
;  (t (my-set-language-utf-8)))

(my-set-language-utf-8)

;;font setting
(setq my-font-name "DejaVu Sans Mono")
(setq my-font-size 10)
(setq my-font-string
      (concat my-font-name " "
              (number-to-string my-font-size)))

(defun my-frame-font ()
  "my frame font setting"
  ;; Setting English Font
  (set-face-attribute
   'default nil :font my-font-string)
  ;; Chinese Font
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset
                      (font-spec :family my-font-name
                                 :size my-font-size))))

(defun my-console-font ()
  "my console font setting"
  (progn
    (add-to-list 'default-frame-alist
                 '(font . my-font-string))))

(if window-system
    (my-frame-font)
    (my-console-font))

;; start gnuserv on Windows
(if (or (eq window-system 'w32)
        (eq window-system 'win32))
    (progn
      (require 'gnuserv)
      (setq server-done-function
            'bury-buffer gnuserv-frame (car (frame-list)))
      (gnuserv-start)
      ;; open buffer in existing frame instead of creating new one...
      (setq gnuserv-frame (selected-frame))
      (message "gnuserv started."))
    (progn
      ;;emacs server
      (server-force-delete)
      (server-mode t)
      (message "server-mode started.")))

;;color theme
(zz-load-path "site-lisp/color-theme")
(require 'color-theme)
(color-theme-initialize)
(zz-load-file "site-lisp/color-theme-blackboard.el")

(if window-system
    ;;(color-theme-deep-blue)
    ;;(color-theme-midnight)
    ;;(color-theme-arjen)
    (color-theme-gnome2)
    ;;(color-theme-blackboard)
    )

;; set default-frame-alist
(if window-system
    (progn
      (add-to-list 'default-frame-alist '(scroll-bar-width . 16))
      (add-to-list 'default-frame-alist '(menu-bar-lines . 20))
      (add-to-list 'default-frame-alist '(tool-bar-lines . 0))
      (add-to-list 'default-frame-alist '(width . 140))
      (add-to-list 'default-frame-alist '(height . 40))))

;; scroll bar right
(set-scroll-bar-mode `right)

;; no need temp file
(setq make-backup-files nil)
(setq-default make-backup-files nil)

;; auto add newline in file
(setq require-final-newline t)
;;Non-nil if Transient-Mark mode is enabled.
(setq-default transient-mark-mode t)
;; keep cursor on tail of line
;(setq track-eol t)
;; keep slience
(setq visible-bell t);
;; don`t flash the screen on console mode
(setq ring-bell-function (lambda ()  t))
;; use clipboard
(setq x-select-enable-clipboard t)
;;
(setq mouse-drag-copy-region nil)  ;;
;; stops killing/yanking interacting with primary X11 selection
(setq x-select-enable-primary nil) 
;; active region sets primary X11 selection
(setq select-active-regions t)

;; font lock settings
;;(setq lazy-lock-defer-on-scrolling t)
;;(setq font-lock-support-mode 'lazy-lock-mode)

(setq font-lock-maximum-decoration t)
(setq font-lock-global-modes '(not shell-mode text-mode))
(setq font-lock-gloal-modes '(not text-mode))
(setq font-lock-verbose t)
(setq font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))

;; let F7, as in vim do, to insert the current
;; time-stamp, whose form is the same as vim do, into
;; current cursor point.
(defun insert-time-stamp()
  "Insert date from the system time.
      Which is in \"\%Y-\%m-\%d \%H:\%M:\%S\" mode, as in vim do. "
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
;;(global-set-key (kbd "<f7>") 'insert-time-stamp)

;;ftp client
(setq ange-ftp-ftp-program-name "angeftp")
;;mouset avoidance
(mouse-avoidance-mode 'animate)

(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;Diary Setting
(setq diary-file "~/diary/rj")
(setq calendar-latitude +39.9)
(setq calendar-longitude +116.4)
(setq calendar-location-name "shenyang")
(setq calendar-remove-frame-by-deleting t)
(setq calendar-week-start-day 1)

(setq christian-holidays nil)
(setq hebrew-holidays nil)
(setq islamic-holidays nil)

(setq general-holidays
      '((holiday-fixed 1  1     "New Year's Day")
        (holiday-fixed 3  8     "Women's Day")
        (holiday-fixed 4  1     "April Fool's Day")
        (holiday-fixed 5  1     "Labor Day")
        (holiday-fixed 10 1     "National Day")
        (holiday-fixed 12 25    "Christmas")
        (holiday-fixed 2  5     "Lantern Festival")
        (holiday-fixed 4  4     "Ching Ming Festival")
        (holiday-fixed 6  22    "Dragon Boat Festival")
        (holiday-fixed 9  28    "Mid-Autumn Festival")
        (holiday-float 5  0  2  "Mother's Day")
        (holiday-float 6  0  3  "Father's Day")))

(setq mark-diary-entries-in-calendar nil)
(setq appt-issue-message nil)

(setq mark-holidays-in-calendar t)
(setq view-calendar-holidays-initially t)

;;Thursday, January 22, 2004: Chinese New Year (甲-申)
(setq chinese-calendar-celestial-stem
      ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
(setq chinese-calendar-terrestrial-branch
      ["子" "丑" "寅" "卯" "辰" "巳" "戊" "未" "申" "酉" "戌" "亥"])

;;work direction
;;(setq default-directory "~/work")

(setq column-number-mode t)
(setq default-fill-column 80)

;;'y' for 'yes', 'n' for 'no'
(fset 'yes-or-no-p 'y-or-n-p)

(setq x-stretch-cursor nil)

(setq-default kill-whole-line t)
(global-auto-revert-mode t)

;; //auto load: transient-mark-mode,delete-selection-mode
(pc-selection-mode t)

(setq pc-select-selection-keys-only t)
(setq require-final-newline t)

;;scroll properity
;(setq scroll-step 1)
;(setq scroll-margin 3)
(setq scroll-conservatively 10000)

(setq kill-ring-max 200)

;; disable auto wrap
(setq truncate-partial-width-windows nil)

(winner-mode t)

;;(add-to-list 'load-path "~/tmp")
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(setq session-save-file-coding-system 'utf-8)

;;(load "desktop")
(desktop-load-default)
(desktop-read)

;;buffer name in title
;(setq frame-title-format "%b@zhoujd-LiveInEmacs")
(setq frame-title-format
      (list "zhoujd@"
           (replace-regexp-in-string "\\..*$" ""system-name)
            ":"
            '(buffer-file-name "%f"
                               (dired-directory dired-directory "%b"))))

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(setq truncate-partial-width-windows nil);

;; indent setting
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list ())
(dotimes (i 40 tab-stop-list)
  (setq tab-stop-list
        (cons (* (- 40 i) default-tab-width)
              tab-stop-list)))

(setq mouse-yank-at-point t)

(global-font-lock-mode t)
(auto-compression-mode t)
(column-number-mode t)
(blink-cursor-mode nil)

;; display local-mode calendar
(setq display-time-string-forms
      '("["24-hours":"minutes","dayname","monthname" "day","year"]"))
(display-time)

;; embrace light show
(show-paren-mode t)
;;(menu-bar-mode t)
(tool-bar-mode nil)
;;Minibuffer complete help
(icomplete-mode  t)

;;mouse wheel support
(setq mouse-wheel-mode t)

;; ensure abbrev mode is always on
(setq-default abbrev-mode t)
;; do not bug me about saving my abbreviations
(setq save-abbrevs nil)

;;ido mode
;(setq ido-enable-flex-matching t)
;(setq ido-everywhere t)
;(ido-mode 1)

(custom-set-faces
 '(ido-subdir ((t (:foreground "#66ff00"))))      ;; Face used by ido for highlighting subdirs in the alternatives.
 '(ido-first-match ((t (:foreground "#ccff66")))) ;; Face used by ido for highlighting first match.
 '(ido-only-match ((t (:foreground "#ffcc33"))))  ;; Face used by ido for highlighting only match.
 '(ido-indicator ((t (:foreground "#ffffff"))))   ;; Face used by ido for highlighting its indicators (don't actually use this)
 '(ido-incomplete-regexp ((t (:foreground "#ffffff"))))) ;; Ido face for indicating incomplete regexps. (don't use this either)

;;shell settting
(custom-set-variables
 '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
 '(comint-scroll-to-bottom-on-output t) ; always add output at the bottom
 '(comint-scroll-show-maximum-output t) ; scroll to show max possible output
 '(comint-completion-autolist t)        ; show completion list when ambiguous
 '(comint-input-ignoredups t)           ; no duplicates in command history
 '(comint-completion-addsuffix t)       ; insert space/slash after file completion
 )

; interpret and use ansi color codes in shell output windows
(ansi-color-for-comint-mode-on)

;; automatically_close_completions_in_emacs_shell_comint_mode.txt
(defun comint-close-completions ()
  "Close the comint completions buffer.
Used in advice to various comint functions to automatically close
the completions buffer as soon as I'm done with it. Based on
Dmitriy Igrishin's patched version of comint.el."
  (if comint-dynamic-list-completions-config
      (progn
        (set-window-configuration comint-dynamic-list-completions-config)
        (setq comint-dynamic-list-completions-config nil))))

(defadvice comint-send-input (after close-completions activate)
  (comint-close-completions))

(defadvice comint-dynamic-complete-as-filename (after close-completions activate)
  (if ad-return-value (comint-close-completions)))

(defadvice comint-dynamic-simple-complete (after close-completions activate)
  (if (member ad-return-value '('sole 'shortest 'partial))
      (comint-close-completions)))

(defadvice comint-dynamic-list-completions (after close-completions activate)
    (comint-close-completions)
    (if (not unread-command-events)
        ;; comint's "Type space to flush" swallows space. put it back in.
        (setq unread-command-events (listify-key-sequence " "))))

(defun kill-shell-buffer(process event)
  "The one actually kill shell buffer when exit. "
  (kill-buffer (process-buffer process))
  )
(defun kill-shell-buffer-after-exit()
  "kill shell buffer when exit."
  (set-process-sentinel (get-buffer-process (current-buffer))
                        #'kill-shell-buffer)
  )
(add-hook 'shell-mode-hook 'kill-shell-buffer-after-exit t)

;;dired setting
(setq dired-recursive-deletes t)
(setq dired-recursive-copies t)
(defadvice dired-find-file (around dired-find-file-single-buffer activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer))
        (filename (dired-get-file-for-visit)))
    ad-do-it
    (when (and (file-directory-p filename)
               (not (eq (current-buffer) orig)))
      (kill-buffer orig))))
(defadvice dired-up-directory (around dired-up-directory-single-buffer activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer)))
    ad-do-it
    (kill-buffer orig)))

;;only auto spit windows
(setq split-height-threshold 0)
(setq split-width-threshold nil)

;;windows shell setting
(if (or (eq window-system 'w32) (eq window-system 'win32))
    (progn 
      ;;set current shell
      (setq shell-file-name "bash")
      (setq shell-command-switch "-c")
      (setq explicit-shell-file-name shell-file-name)
      (setenv "SHELL" shell-file-name)
      (setq explicit-sh-args '("--login" "-i"))
      (if (boundp 'w32-quote-process-args)
          (setq w32-quote-process-args ?\"))))

(message "common-setting is end")

;;; common-setting.el ends here
