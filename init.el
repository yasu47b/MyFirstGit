(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq load-path (append
		 '("~/.emacs.d"
		   "~/.emacs.d/auto-install")
		 load-path))

;; コピー、ペーストのためのkill-ring
(require 'browse-kill-ring)
(global-set-key (kbd "C-c k") 'browse-kill-ring)

;;; 現在行を目立たせる　
;; (global-hl-line-mode)

;; install-elisp
;; install-elisp のコマンドを使える様にします。
(require 'install-elisp)
;; 次に、Elisp ファイルをインストールする場所を指定します。
(setq install-elisp-repository-directory "~/.emacs.d/lisp/")

(require 'flymake)
;;(require 'set-perl5lib)

(set-face-background 'flymake-errline "magenta")
(set-face-foreground 'flymake-errline "black")
(set-face-background 'flymake-warnline "orange3")
(set-face-foreground 'flymake-warnline "black")

(setq flymake-gui-warnings-enabled nil)


(add-hook 'find-file-hook 'flymake-find-file-hook)
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)

(push '("\\.cgi$" flymake-perl-init) flymake-allowed-file-name-masks)


(global-set-key "\M-p" 'flymake-goto-prev-error)
(global-set-key "\M-n" 'flymake-goto-next-error)
(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-mode-alist (cons '("\\.t$" . perl-mode) auto-mode-alist))

;; auto-complete
;; 補完候補を自動ポップアップ
(require 'auto-complete)
(require 'auto-complete-config)

(global-auto-complete-mode t)
(setq ac-modes (cons 'js-mode ac-modes))

;; 以下、手動トリガー
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")  ; TABで補完開始(トリガーキー)
;; or
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)  ; M-TABで補完開始

(add-to-list 'default-frame-alist '(cursor-type . 'box)) ;; ボックス型カーソル


;; anything-etags+.el
(require 'anything-config)
;;(global-set-key "\M-." 'anything-etags+-select-one-key)


;; tab
;;(when (require 'tabbar nil t)
;;  (tabbar-mode))


;;==========================================================
;;         popwin の設定
;;==========================================================

(require 'popwin)
(popwin-mode 1)

;;==========================================================
;;         direx の設定
;;==========================================================
;; direx
(require 'direx)
(require 'direx-project)

(defun my/dired-jump ()
  (interactive)
  (cond (current-prefix-arg
         (dired-jump))
        ((not (one-window-p))
         (or (ignore-errors
               (direx-project:jump-to-project-root) t)
             (direx:jump-to-directory)))
        (t
         (or (ignore-errors
               (direx-project:jump-to-project-root-other-window) t)
             (direx:jump-to-directory-other-window)))))

(global-set-key (kbd "C-x C-j") 'my/dired-jump)

(push '(direx:direx-mode :position left :width 20 :dedicated t)
      popwin:special-display-config)


;;(setq direx:leaf-icon ""
;;      direx:open-icon ""
;;      direx:closed-icon "25A018")
;;==========================================================
;;         web-modeの設定
;;==========================================================
(require 'web-mode)
;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.html.ep$"     . web-mode))


(defun web-mode-hook ()
  "Hooks for Web mode."
  ;; 変更日時の自動修正
  (setq time-stamp-line-limit -200)
  (if (not (memq 'time-stamp write-file-hooks))
      (setq write-file-hooks
            (cons 'time-stamp write-file-hooks)))
  (setq time-stamp-format " %3a %3b %02d %02H:%02M:%02S %:y %Z")
  (setq time-stamp-start "Last modified")
  (setq time-stamp-end "$")
  ;; web-modeの設定
  (setq web-mode-markup-indent-offset 2) ;; html indent
  (setq web-mode-css-indent-offset 2)    ;; css indent
  (setq web-mode-code-indent-offset 2)   ;; script indent(js,php,etc..)
  ;; htmlの内容をインデント
  ;; TEXTAREA等の中身をインデントすると副作用が起こったりするので
  ;; デフォルトではインデントしない
  ;;(setq web-mode-indent-style 2)
  ;; コメントのスタイル
  ;;   1:htmlのコメントスタイル(default)
  ;;   2:テンプレートエンジンのコメントスタイル
  ;;      (Ex. {# django comment #},{* smarty comment *},{{-- blade comment --}})
  (setq web-mode-comment-style 2)
  ;; 終了タグの自動補完をしない
  ;;(setq web-mode-disable-auto-pairing t)
  ;; color:#ff0000;等とした場合に指定した色をbgに表示しない
  ;;(setq web-mode-disable-css-colorization t)
  ;;css,js,php,etc..の範囲をbg色で表示
  ;; (setq web-mode-enable-block-faces t)
  ;; (custom-set-faces
  ;;  '(web-mode-server-face
  ;;    ((t (:background "grey"))))                  ; template Blockの背景色
  ;;  '(web-mode-css-face
  ;;    ((t (:background "grey18"))))                ; CSS Blockの背景色
  ;;  '(web-mode-javascript-face
  ;;    ((t (:background "grey36"))))                ; javascript Blockの背景色
  ;;  )
  ;;(setq web-mode-enable-heredoc-fontification t)
)
(add-hook 'web-mode-hook  'web-mode-hook)
;; 色の設定
(custom-set-faces
 '(web-mode-doctype-face
   ((t (:foreground "#82AE46"))))                          ; doctype
 '(web-mode-html-tag-face
   ((t (:foreground "#E6B422" :weight bold))))             ; 要素名
 '(web-mode-html-attr-name-face
   ((t (:foreground "#C97586"))))                          ; 属性名など
 '(web-mode-html-attr-value-face
   ((t (:foreground "#82AE46"))))                          ; 属性値
 '(web-mode-comment-face
   ((t (:foreground "#D9333F"))))                          ; コメント
 '(web-mode-server-comment-face
   ((t (:foreground "#D9333F"))))                          ; コメント
 '(web-mode-css-rule-face
   ((t (:foreground "#A0D8EF"))))                          ; cssのタグ
 '(web-mode-css-pseudo-class-face
   ((t (:foreground "#FF7F00"))))                          ; css 疑似クラス
 '(web-mode-css-at-rule-face
   ((t (:foreground "#FF7F00"))))                          ; cssのタグ
 )

;; python
;;; flymake for python
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pychecker"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
(load-library "flymake-cursor")
(custom-set-variables
   '(help-at-pt-timer-delay 0.9)
   '(help-at-pt-display-when-idle '(flymake-overlay)))
(global-set-key [f10] 'flymake-goto-prev-error)
(global-set-key [f11] 'flymake-goto-next-error)
(put 'scroll-left 'disabled nil)


(defalias 'perl-mode 'cperl-mode)
(setq auto-mode-alist (append '(("\\.psgi$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.cgi$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.pl$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.pm$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.t$" . cperl-mode)) auto-mode-alist))

;; smartchr
(require 'smartchr)
(add-hook 'cperl-mode-hook
          '(lambda ()
             (progn
               (local-set-key (kbd "D") (smartchr '("D" "use Data::Dumper; warn Dumper ")))
               )))
