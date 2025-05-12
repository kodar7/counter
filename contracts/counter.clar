;; An on-chain counter that stores a count for each individual

;; Define a map data structure
(define-map counters
  principal
  uint
)

;; Function to retrieve the count for a given individual
(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)

;; Function to increment the count for the caller
(define-public (count-up)
  (ok (map-set counters tx-sender (+ (get-count tx-sender) u1)))
)

;; 1.Function to decrement the count for the caller if the count is greater than 0
(define-public (count-down)
  (if (>= (get-count tx-sender) u1)
    (ok (map-set counters tx-sender (- (get-count tx-sender) u1)))
    (err "Count cannot be negative")
  )
)

;; 2.Function to reset the count for the caller
(define-public (reset-count)
  (ok (map-set counters tx-sender u0))
)

;; 3.Function to set the count for the caller to a specific value
(define-public (set-count (new-count uint))
  (if (>= new-count u0)
    (ok (map-set counters tx-sender new-count))
    (err "New count must be non-negative")
  )
)

;; 4.Function to allow caller increment counter by custom amount 
(define-public (custom-up (amount uint))
  (if (>= amount u0)
    (ok (map-set counters tx-sender (+ (get-count tx-sender) amount)))
    (err "Custom amount must be greater than 0")
  )
)

;; 5.Function to allow caller decreament counter by custom amount 
(define-public (custom-down (amount uint))
  (if (>= amount u0)
    (ok (map-set counters tx-sender (- (get-count tx-sender) amount)))
    (err "Custom amount must be greater than 0")
  )
)
