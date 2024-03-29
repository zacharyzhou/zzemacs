;;;; macro-setting.el --- macro config file
;;

(defmacro if-ms-windows (if-cause &optional else-cause)
  `(if ,(eq system-type 'windows-nt)
       ,if-cause ,else-cause))

(defmacro if-not-ms-windows (if-cause &optional else-cause)
  `(if-ms-windows ,else-cause ,if-cause))

(defmacro unless-ms-windows (&rest body)
  `(if-not-ms-windows (progn ,@body)))

(defmacro when-ms-windows (&rest body)
  `(if-ms-windows (progn ,@body)))

(defmacro with-utf-8-env (&rest body)
  `(let ((curr-lang current-language-environment))
     (set-language-environment 'utf-8)
     ,@body
     (set-language-environment curr-lang)))

(defmacro with-chinese-env (&rest body)
  `(let ((curr-lang current-language-environment))
     (set-language-environment 'Chinese-GB18030)
     ,@body
     (set-language-environment curr-lang)))

(defmacro if-emacs24-3 (if-cause &optional else-cause)
  `(if ,(and (>= emacs-major-version 24)
             (>= emacs-minor-version 3))
       ,if-cause ,else-cause))

(defmacro when-emacs24-3 (&rest body)
  `(if-emacs24-3 (progn ,@body)))

;;marcro for start-process
(defmacro execute-set-key (name args)
  `(lambda ()
     (interactive)
     (apply 'start-process ,name nil ,args)))

;;start shell in environment setting
(defmacro with-start-shell (&rest body)
  `(let ((env-shell      shell-file-name)
         (env-shell-cmd  shell-command-switch)
         (env-shell-file explicit-shell-file-name)
         (env-shell      (getenv "SHELL")))
     ,@body
     (setq shell-file-name env-shell)
     (setq shell-command-switch env-shell-cmd)
     (setq explicit-shell-file-name env-shell-file)
     (setenv "SHELL" env-shell)
     ))

;;(defkeys-map global-map
;;  ((kbd "M-1") "hello")
;;  ((kbd "M-2") "zhoujd"))
(defmacro defkeys-map (map &rest keys)
  (let ((ks (mapcar
             #'(lambda (k)
                 (cons 'define-key (cons map k)))
             keys))) 
    `(progn ,@ks)))

;;run command macro
(defmacro run-command-sort (cmd)
  `(cond ((fboundp 'async-shell-command) (async-shell-command ,cmd))
         ((fboundp 'shell-command) (shell-command ,cmd))
         (t (message "no shell command function can be run"))))

;;start shell
(defmacro start-quick-shell (name)
  `(lambda () (interactive) (start-shell ,name)))


(provide 'macro-setting)

;;; macro-setting.el ends here
