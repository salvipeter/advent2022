(define (add-crate! crates line)
  (let loop ((i 0))
    (let ((index (+ (* i 4) 1)))
      (when (> (string-length line) index)
        (let ((c (string-ref line index)))
          (when (char-upper-case? c)
            (vector-set! crates i
                         (cons (string->symbol (string c))
                               (vector-ref crates i)))))
        (loop (+ i 1))))))

(define input
  (call-with-input-file "adv05.txt"
    (lambda (f)
      (let ((crates (make-vector 9 '())))
        (let loop ((acc '()))
                (let ((line (read-line f)))
                  (if (eof-object? line)
                      (cons (vector-map reverse crates) (reverse acc))
                      (let ((matches (#/move (.*) from (.*) to (.*)$/ line)))
                        (if matches
                            (loop (cons (map string->number
                                             (cdr (rxmatch-substrings matches)))
                                        acc))
                            (begin
                              (add-crate! crates line)
                              (loop acc)))))))))))

(define (move-crate! crates cmd reverse-crates?)
  (let ((n (car cmd))
        (from (- (cadr cmd) 1))
        (to (- (caddr cmd) 1)))
    (let ((lst (take (vector-ref crates from) n)))
      (vector-set! crates from (drop (vector-ref crates from) n))
      (vector-set! crates to
                   (append (if reverse-crates?
                               (reverse lst)
                               lst)
                           (vector-ref crates to))))))

(define (adv05 data first-part?)
  (let ((crates (vector-copy (car data))))
    (for-each (lambda (cmd)
                (move-crate! crates cmd first-part?))
              (cdr data))
    (with-output-to-string
      (lambda ()
        (vector-for-each display
                         (vector-map car crates))))))
