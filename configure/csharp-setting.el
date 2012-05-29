;;;csharp programme setting

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

(speedbar-add-supported-extension "\\.cs$")

(provide 'csharp-setting)

;;; csharp-setting.el ends here
