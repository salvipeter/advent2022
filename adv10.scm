(define input
  (call-with-input-file "adv10.txt"
    (lambda (f)
      (let loop ()
        (let ((cmd (read f)))
          (cond ((eof-object? cmd) '())
                ((eq? 'noop cmd) (cons '(noop) (loop)))
                (else (let ((n (read f)))
                        (cons `(addx ,n) (loop))))))))))

(define (step state)
  (let-values (((x cycle sum) (apply values state)))
    (if (= (mod cycle 40) 20)
        (list x (+ cycle 1) (+ sum (* cycle x)))
        (list x (+ cycle 1) sum))))

;;; Works with both 2- and 3-element STATEs
(define (add state n)
  (cons (+ (car state) n)
        (cdr state)))

(define (adv10 data)
  (caddr
   (fold (lambda (cmd state)
           (case (car cmd)
             ((noop) (step state))
             ((addx) (add (step (step state)) (cadr cmd)))))
         '(1 1 0) data)))

(define (crt state)
  (let-values (((x cycle) (apply values state)))
    (let ((pos (mod (- cycle 1) 40)))
      (display (if (< (abs (- pos x)) 2) #\# #\.))
      (when (= (mod cycle 40) 0)
        (newline))
      (list x (+ cycle 1)))))

(define (adv10b data)
  (fold (lambda (cmd state)
          (case (car cmd)
            ((noop) (crt state))
            ((addx) (add (crt (crt state)) (cadr cmd)))))
        '(1 1) data)
  #t)
