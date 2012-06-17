;;;; common-setting.el --- common config file
;;

; tell me if there's something wrong
;(setq debug-on-error t)

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
(cond
  ((string-match "j[ap].*" (getenv "LANG"))
   (my-set-language-japanese))
  ((string-match "\\(zh_CN\\)\\|\\(CHS\\)" (getenv "LANG"))
   (my-set-language-chinese))
  (t (my-set-language-utf-8)))

;;font setting
(defvar en-font-list '("Consolas" "Monaco" "DejaVu Sans Mono" "Monospace" "Courier New"))
(defvar cn-font-list '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体")) 

(defvar my-font-en-name (nth 0 en-font-list))
(defvar my-font-en-size 11)

(defvar my-font-cn-name (nth 0 cn-font-list))
(defvar my-font-cn-size 13)

(setq my-font-string
      (concat my-font-en-name " "
              (number-to-string my-font-en-size)))

(defun my-frame-font ()
  "my frame font setting"
  ;; Setting English Font
  (set-face-attribute
   'default nil :font my-font-string)
  ;; Chinese Font
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset
                      (font-spec :family my-font-cn-name
                                 :size   my-font-cn-size))))

(defun my-console-font ()
  "my console font setting"
  (progn
    (add-to-list 'default-frame-alist
                 '(font . my-font-string))))

(if window-system (my-frame-font) (my-console-font))

;;server-mode
;;emacsclientw.exe -f "~\.emacs.d\server\server" -n -a "runemacs.exe" path\to\file
;;emacsclientw.exe --server-file ~\.emacs.d\server\server -n -a runemacs.exe path\to\file
;;~/.emacs.d/server的属主由Administrators组改为当前用户（右键属性--安全--高级--所有者）
(require 'server)
(when (and (= emacs-major-version 23)
           (or (eq window-system 'w32) (eq window-system 'win32)))
  (defun server-ensure-safe-dir (dir) "Noop" t)) ; Suppress error "directory
					                             ; ~/.emacs.d/server is unsafe"
					                             ; on windows.
(unless (server-running-p)
  (server-start))

(add-hook 'kill-emacs-hook
	  (lambda()
	    (if (file-exists-p "~/.emacs.d/server/server")
		(delete-file "~/.emacs.d/server/server"))))

;;color theme
(zz-load-path "site-lisp/color-theme")
(require 'color-theme)
(require 'color-theme-blackboard)
(color-theme-initialize)

(setq color-theme-choices '(color-theme-gnome2
                            color-theme-blackboard
                            color-theme-blackboard2
                            color-theme-dark-laptop
                            color-theme-midnight
                            color-theme-deep-blue
                            color-theme-arjen
                            color-theme-standard))

(if window-system
    (progn
      (funcall (nth 0 color-theme-choices))
      ;(funcall (nth (random (length color-theme-choices)) color-theme-choices))
      )
    (progn
      (set-face-background 'default "black")
      (set-face-foreground 'default "gray")))

;; set default-frame-alist
(if window-system
    (setq default-frame-alist
          (append
           '((scroll-bar-width . 16)
             (width . 140)
             (height . 40))
           default-frame-alist)))

;; quick display key help
(setq echo-keystrokes 0.1)

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
;(setq ring-bell-function 'ignore)
(setq ring-bell-function (lambda ()  t))
;; use clipboard
(setq x-select-enable-clipboard t)
;;mouse select
(setq mouse-drag-copy-region nil)
;; stops killing/yanking interacting with primary X11 selection
(setq x-select-enable-primary nil) 
;; active region sets primary X11 selection
(setq select-active-regions t)

;; font lock settings
;;(setq lazy-lock-defer-on-scrolling t)
;;(setq font-lock-support-mode 'lazy-lock-mode)

(setq font-lock-maximum-decoration t)
(setq font-lock-global-modes '(not shell-mode text-mode))
(setq font-lock-verbose t)
(setq font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))

;; let F7, as in vim do, to insert the current
;; time-stamp, whose form is the same as vim do, into
;; current cursor point.
(defun insert-time-stamp ()
  "Insert date from the system time.
      Which is in \"\%Y-\%m-\%d \%H:\%M:\%S\" mode, as in vim do. "
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))

;;ftp client
(if (or (eq window-system 'w32)
        (eq window-system 'win32))
    (setq ange-ftp-ftp-program-name "ftp.exe"))

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
(setq mark-holidays-in-calendar t)
(setq view-calendar-holidays-initially t)

;; settings for appt
(require 'appt)
(setq appt-issue-message nil)
(setq appt-message-warning-time 3)
(setq appt-display-format 'window)

;;chinese-calendar
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

;;buffer name in title
(setq frame-title-format
      (list "zhoujd@"
           (replace-regexp-in-string "\\..*$" ""system-name)
            ":"
            '(buffer-file-name "%f"
                               (dired-directory dired-directory "%b"))))

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq gnus-inhibit-startup-message t)

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

;; display local-mode calendar
(setq display-time-string-forms
      '("["24-hours":"minutes","dayname","monthname" "day","year"]"))
(display-time)

;; embrace light show
(show-paren-mode t)

(if (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))
(if (fboundp 'tool-bar-mode)     (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode)   (scroll-bar-mode -1))
;(if (fboundp 'menu-bar-mode)     (menu-bar-mode -1))

;;Minibuffer complete help
(icomplete-mode t)

;;mouse wheel support
(setq mouse-wheel-mode t)

;; ensure abbrev mode is always on
(setq-default abbrev-mode t)
;; do not bug me about saving my abbreviations
(setq save-abbrevs nil)

;;ido mode
(setq ido-save-directory-list-file nil)
(ido-mode t)

(custom-set-faces
 '(ido-subdir            ((t (:foreground "#66ff00"))))
 '(ido-first-match       ((t (:foreground "#ccff66"))))
 '(ido-only-match        ((t (:foreground "#ffcc33"))))
 '(ido-indicator         ((t (:foreground "#ffffff"))))
 '(ido-incomplete-regexp ((t (:foreground "#ffffff")))))

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

;;hide buffer *Async Shell Command*
(defadvice display-buffer (around async-shell-command activate)
   "If BUFFER is named *Async Shell Command*, don't display it."
   (or (and (bufferp (ad-get-arg 0))
	   (equal (buffer-name (ad-get-arg 0)) "*Async Shell Command*"))
       ad-do-it))

;;recentf/undo-kill-buffer
(setq recentf-menu-open-all-flag t
      recentf-max-saved-items 100
      recentf-max-menu-items  30
      recentf-exclude '("/tmp/" "/ssh:"))

(recentf-mode t)
(defadvice recentf-track-closed-file (after push-beginning activate)
  "Move current buffer to the beginning of the recent list after killed."
  (recentf-track-opened-file))

(defun undo-kill-buffer (arg)
  "Re-open the last buffer killed. With ARG, re-open the nth buffer."
  (interactive "p")
  (let ((recently-killed-list (copy-sequence recentf-list))
        (buffer-files-list
         (delq nil (mapcar (lambda (buf)
                             (when (buffer-file-name buf)
                               (expand-file-name (buffer-file-name buf))))
                           (buffer-list)))))
    (mapc
     (lambda (buf-file)
       (setq recently-killed-list
             (delete buf-file recently-killed-list)))
     buffer-files-list)
    (find-file (nth (- arg 1) recently-killed-list))))

(defun recentf-open-files-compl ()
   (interactive)
   (let* ((all-files recentf-list)
     (tocpl (mapcar (function 
       (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
           (prompt (append '("File name: ") tocpl))
          (fname (completing-read (car prompt) (cdr prompt) nil nil)))
     (find-file (cdr (assoc-ignore-representation fname tocpl)))))

(provide 'common-setting)

;;; common-setting.el ends here
