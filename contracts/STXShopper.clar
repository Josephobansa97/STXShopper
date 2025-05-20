(define-data-var item-counter uint u0)

(define-map items
  {id: uint}
  {
    seller: principal,
    price: uint,
    description: (string-ascii 100),
    buyer: (optional principal),
    status: (string-ascii 20)
  }
)

(define-map reputation-map principal int)

(define-public (list-item (price uint) (description (string-ascii 100)))
  (let ((item-id (var-get item-counter)))
    (begin
      (map-set items
        {id: item-id}
        {
          seller: tx-sender,
          price: price,
          description: description,
          buyer: none,
          status: "listed"
        })
      (var-set item-counter (+ item-id u1))
      (ok item-id)
    )
  )
)

(define-public (buy-item (item-id uint))
  (let ((item (map-get? items {id: item-id})))
    (match item item-data
      (begin
        (asserts! (is-eq (get status item-data) "listed") (err u100))
        (asserts! (>= (stx-get-balance tx-sender) (get price item-data)) (err u101))
        (map-set items 
          {id: item-id}
          (merge item-data {
            buyer: (some tx-sender),
            status: "sold"
          })
        )
        (ok item-id)
      )
      (err u404)
    )
  )
)

(define-public (confirm-delivery (item-id uint))
  (let ((item (map-get? items {id: item-id})))
    (match item 
           some-item
           (begin
             (asserts! (is-eq (get buyer some-item) (some tx-sender)) (err u102))
             (asserts! (is-eq (get status some-item) "sold") (err u103))
             (let ((transfer-result (stx-transfer? (get price some-item) tx-sender (get seller some-item))))
               (match transfer-result
                 success (begin
                   (map-set items {id: item-id} (merge some-item { status: "delivered" }))
                   (ok true))
                 error (err u104)))
           )
           (err u404))
  )
)

(define-public (rate-user (user principal) (score int))
  (begin
    (asserts! (<= score 10) (err u200))
    (asserts! (>= score -10) (err u201))
    (let ((current (default-to 0 (map-get? reputation-map user))))
      (map-set reputation-map user (+ current score))
    )
    (ok true)
  )
)

(define-read-only (get-item (item-id uint))
  (map-get? items {id: item-id})
)

(define-read-only (get-reputation (user principal))
  (default-to 0 (map-get? reputation-map user))
)
