;;scheme programme setting

;;PLT scheme
;(setq scheme-program-name "mzscheme")
;;MIT scheme
;(setq scheme-program-name "mit-scheme")

;;Support racket file
(setq auto-mode-alist
 (append
  (list
   ;; insert entries for other modes here if needed.
   (cons "\\.rkt$" 'scheme-mode))
  auto-mode-alist))

;;eldoc
(require 'eldoc-extension)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-inteeraction-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)
(setq eldoc-minor-mode-string "")

;;auto-complete setting
(defvar ac-source-scheme
  '((candidates
     . (lambda ()
         (require 'scheme-complete)
         (all-completions ac-target (car (scheme-current-env))))))
  "Source for scheme keywords.")

;;Auto-complete-mode config
(add-hook 'scheme-mode-hook
          '(lambda ()
             (make-local-variable 'ac-sources)
             (setq ac-sources (append ac-sources '(ac-source-scheme)))))

;;scheme complete
(autoload 'scheme-smart-complete "scheme-complete" nil t)
(eval-after-load 'scheme
  '(progn
    ;;(define-key scheme-mode-map "\t"   'scheme-complete-or-indent)
    (define-key scheme-mode-map "\e\t" 'scheme-smart-complete)))

(autoload 'scheme-get-current-symbol-info "scheme-complete" nil t)
(add-hook 'scheme-mode-hook
          (lambda ()
            (make-local-variable 'eldoc-documentation-function)
            (setq eldoc-documentation-function 'scheme-get-current-symbol-info)
            (eldoc-mode t)
            (setq lisp-indent-function 'scheme-smart-indent-function)))

;;quack
(require 'quack)

;;geiser for scheme
(zz-load-path "site-lisp/geiser/elisp")
(require 'geiser)
(setq geiser-active-implementations '(racket))
(unless (or (eq window-system 'w32) (eq window-system 'win32))
  (zz-add-os-path "/usr/racket/bin")
  (zz-add-os-path "/usr/local/Gambit-C/bin/"))

;;Gambit-C
(autoload 'gambit-inferior-mode "gambit" "Hook Gambit mode into cmuscheme.")
(autoload 'gambit-mode "gambit" "Hook Gambit mode into scheme.")
(add-hook 'inferior-scheme-mode-hook (function gambit-inferior-mode))
(add-hook 'scheme-mode-hook (function gambit-mode))
(setq gambit-highlight-color "gray")
(setq scheme-program-name "gsi -:d-")
(require 'gambit)


(provide 'scheme-setting)

;; scheme-setting.el end here