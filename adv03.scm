(define input
  (call-with-input-file "adv03.txt"
    (lambda (f)
      (let loop ()
        (let ((line (read-line f)))
          (if (eof-object? line)
              '()
              (cons line (loop))))))))

(define (wrong-item rucksack)
  (let ((size (/ (string-length rucksack) 2)))
    (let loop ((i 0))
      (if (= i size)
          #f
          (let ((item (string-ref rucksack i)))
            (if (>= (string-scan-right rucksack item) size)
                item
                (loop (+ i 1))))))))

(define (priority item)
  (- (char->integer item)
     (if (char-lower-case? item)
         (- (char->integer #\a) 1)
         (- (char->integer #\A) 27))))

(define (adv03 data)
  (fold + 0 (map (lambda (r) (priority (wrong-item r))) data)))

(define (badge-item group)
  (let ((a (list-ref group 0))
        (b (list-ref group 1))
        (c (list-ref group 2)))
    (let ((size (string-length a)))
      (let loop ((i 0))
        (if (= i size)
            #f
            (let ((item (string-ref a i)))
              (if (and (string-scan b item)
                       (string-scan c item))
                  item
                  (loop (+ i 1)))))))))

(define (adv03b data)
  (let loop ((l data))
    (if (null? l)
        0
        (+ (priority (badge-item (take l 3)))
           (loop (drop l 3))))))
