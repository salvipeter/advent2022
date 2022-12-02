(define input
  (call-with-input-file "adv02.txt"
    (lambda (f)
      (let loop ()
        (let* ((opponent (read f))
               (me (read f)))
          (if (eof-object? opponent)
              '()
              (cons (cons opponent me) (loop))))))))

(define (score match)
  (+ (case (cdr match) ((X) 1) ((Y) 2) ((Z) 3))
     (cond ((member match '((A . Y) (B . Z) (C . X))) 6)
           ((member match '((A . X) (B . Y) (C . Z))) 3)
           (else 0))))

(define (adv02 data)
  (fold + 0 (map score data)))

(define (score-new match)
  (+ (case (cdr match) ((X) 0) ((Y) 3) ((Z) 6))
     (cond ((member match '((A . X) (B . Z) (C . Y))) 3)
           ((member match '((A . Z) (B . Y) (C . X))) 2)
           (else 1))))

(define (adv02b data)
  (fold + 0 (map score-new data)))
