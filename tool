#!/usr/bin/racket
#lang racket

(define tool-name
  (command-line
    #:program "tool"
    #:args (name)
    name))

(module* main #f
  (let ([path (tool-path tool-name)])
    (if (file-exists? path)
      (editor path)
      (new-tool path))))


(define (editor path)
  (system (format "~a ~a" "nvim" path)))

(define (new-tool path)
  (call-with-output-file path (lambda (out)
    (display (template) out)))
  (system (format "chmod +x ~a" path))
  (editor path)
  (when (template? path) (delete-file path)))

(define (tool-path name)
  (format "~a/~a/~a" (find-system-path 'home-dir) ".toolchain" name))

(define (template) #<<end-template
#!/usr/bin/env racket
#lang racket

(module* main #f
  )
end-template
)

(define (template? path)
  (string=? (file->string path) (template)))
