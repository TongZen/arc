(require mzscheme)

(require "ac.scm")

(define-syntax test-scm
  (syntax-rules(:valueof :should)
    ((test msg :valueof expr :should predicate args ...)
     (let ((got expr))
       (if (predicate got args ...)
         (begin
           (display ". ")
           (display msg)
           (newline))
         (begin
           (display "F ")
           (display msg)
           (newline)
           (display "  got ")
           (display got)
           (newline)))))))

(define (idfn x)
  x)

; evaluates expr twice
(define-syntax test-ac
  (syntax-rules(:valueof :should)
    ((test msg :valueof expr :should predicate args ...)
     (let ((got (arc-eval 'expr))
           (ans (arc-eval '(predicate expr args ...))))
       (if ans
         (begin
           (display ". ")
           (display msg)
           (newline))
         (begin
           (display "F ")
           (display msg)
           (newline)
           (display "  got ")
           (display got)
           (newline)))))))

(define-syntax pending
  (syntax-rules(:valueof :should)
    ((test msg :valueof expr :should predicate args ...)
     (begin
       (display "X ")
       (display msg)
       (newline)))))

(define (satisfy x f)
  (f x))
(xdef satisfy satisfy)

(define be equal?)
(xdef be be)



(require "brackets.scm")
(use-bracket-readtable)
(aload "arc.arc")

(test-ac "iso works on nil"
  :valueof (iso () ())
  :should be 't)

(test-ac "iso works on nil - 2"
  :valueof (iso () t)
  :should be ())

(test-ac "iso works on nil - 3"
  :valueof (iso () 3)
  :should be ())

(test-ac "iso works on tables"
  :valueof (iso (obj 1 2 3 4) (obj 3 4 1 2))
  :should be 't)

(test-ac "iso works on queues"
  :valueof (with (q1 (queue)
                  q2 (queue))
              (enq 1 q1)
              (enq 1 q2)
              (enq 2 q1)
              (enq 2 q2)
              (enq 3 q1)
              (enq 3 q2)
              (iso q1 q2))
  :should be 't)

(test-ac "len works on nil"
  :valueof (len ())
  :should be 0)

(test-ac "len works on tables"
  :valueof (len (obj 1 2 3 4 5 6))
  :should be 3)

(test-ac "len works on queues"
  :valueof (let q (queue)
             (enq 1 q)
             (enq 2 q)
             (enq 3 q)
             (len q))
  :should be 3)