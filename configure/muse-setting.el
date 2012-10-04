;;;this muse setting

(zz-load-path "site-lisp/muse/lisp")

(require 'muse-mode)

(require 'muse-html)        
(require 'muse-latex)       
(require 'muse-texinfo)     
(require 'muse-docbook)     
(require 'muse-wiki nil t)   
(require 'muse-project)     

;;set code format to utf-8
(setq muse-html-meta-content-type (concat "text/html; charset=utf-8"))

;;html charset
(setq muse-html-charset-default "utf-8")

;;html encoding
(setq muse-html-encoding-default "utf8")

;;muse projects
(setq muse-project-alist
      '(("Website" ("~/Pages" :default "index")
         (:base "html" :path "~/public_html")
         (:base "pdf" :path "~/public_html/pdf"))))


(provide 'muse-setting)

;;; muse-setting.el
