#!/usr/bin/racket
#lang racket/base
(require threading
         racket/cmdline
         racket/string
         racket/port
         racket/system)

(define prompt-mode (make-parameter #f))

(define tool-name
  (command-line
    #:program "battery"
    #:once-each
    [("--prompt") "Show terminal prompt specific formatting" (prompt-mode #t)]))

(module* main #f
  (if (prompt-mode)
    (show-prompt (battery-level))
    (displayln (battery-level))))

(define (show-prompt level)
  (printf "~a~a%\n" (if (power-connected) "=" "0") level))

(define (power-connected)
  (let ([status (system->string "acpi -a")])
    (string-contains? status "on-line")))

(define (battery-level)
  (~> (system->string "acpi -b")
    (string-split _ "\n")
    (filter (lambda (l) (not (string-contains? l "unavailable"))) _)
    (car)
    (regexp-match #px#"\\d{1,3}(?=%)" _)
    (car)))

(define (system->string cmd)
  (if (string-contains? cmd "-a")
    "Adapter 0: off-line"
    "Battery 0: Discharging, 94%, 06:51:39 remaining"))
