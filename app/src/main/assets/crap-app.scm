;; Farm Crap App Pro Copyright (C) 2016 Dave Griffiths
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;;
;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define db "/sdcard/farmcrapapppro/crapapp.db")
(set-current! 'db db)

(define (setup-database!)
  (db-close db) ;; close just in case (sorts out db file delete while running problem)
  (db-open db)
  (setup db "local")
  (setup db "farm")
  (insert-entity-if-not-exists
   db "local" "app-settings" "null" settings-entity-id-version
   (list
    (ktv "user-id" "varchar" "None Yet")
    (ktv "language" "int" 0)
    (ktv "email" "varchar" "None Yet")
    (ktv "units" "varchar" "metric"))))

;; stuff here depends on the android update mechanism


(define (get-custom-types)
  (map
   (lambda (e)
     (ktv-get e "name" ))
   (db-filter-only 
    db "farm" "manure" 
    (list)
    (list (list "name" "varchar")))))

(define (get-qualities-for-type-inc-custom type)
  (if (eq? type 'custom-manure)
      (get-custom-types)
      (get-qualities-for-type type)))

(define (update-calc! fn)
  (set! calc (fn calc))
  (run-calc))

(define (update-type! v) 
  (update-calc! 
   (lambda (c) 
     (calc-modify-quality ;; need to set a valid quality for this type
      (calc-modify-type c v)
      (car (get-qualities-for-type-inc-custom v)))))) ;; argh - sets to first

(define (update-amount! v) (update-calc! (lambda (c) (calc-modify-amount c v))))
(define (update-quality! v) (update-calc! (lambda (c) (calc-modify-quality c v))))
(define (update-application! v) (update-calc! (lambda (c) (calc-modify-application c v))))
(define (update-season! v) (update-calc! (lambda (c) (calc-modify-season c v))))
(define (update-crop! v) (update-calc! (lambda (c) (calc-modify-crop c v))))
(define (update-soil! v) (update-calc! (lambda (c) (calc-modify-soil c v))))
(define (update-fieldsize! v) (update-calc! (lambda (c) (calc-modify-fieldsize c v))))
(define (update-soil-test! v) (update-calc! (lambda (c) (calc-modify-soil-test c v))))
(define (clear-soil-test!) (update-calc! (lambda (c) (calc-modify-soil-test c '(soil-p-0 soil-k-0)))))

;; locally stored in the database
(define (mutate-units! v) (set-setting! "units" "varchar" (symbol->string v)))
(define (current-units) (string->symbol (get-setting-value "units")))
 
(define (mutate-email! v) (set-setting! "email" "varchar" v))
(define (current-email) (get-setting-value "email"))

(define (mutate-rainfall! v) (set-setting! "rainfall" "varchar" (symbol->string v)))
(define (current-rainfall) (string->symbol (get-setting-value "rainfall")))

(define (mutate-current-seek-mul! a)
  (set! calc (calc-modify-seek-mul calc a)))


;; (define (csv-headings)
;;   (string-append
;;    "Sield name\t"
;;    "Size\t"
;;    "Size units\t"
;;    "Soil\t"
;;    "Crop\t"
;;    "Manure\t"
;;    "Date\t"
;;    "N\t P\t K\t Nutrient units\t"
;;    "Amount\t"
;;    "Amount units\t"
;;    "Total Amount\t"
;;    "Total units\t"
;;    "Quality\t"
;;    "Season\t"
;;    "N Field Saving\t"
;;    "P Field Saving\t"
;;    "K Field Saving\t"
;;    "N Unit price\t"
;;    "P Unit price\t"
;;    "K Unit price\n"
;;    ))

;; (define (stringify-event event name soil crop size)
;;   (let ((aunits (amount-units event))
;;         (nunits (nutrient-units event)))
;;     (string-append
;;      name "\t"
;;      (number->string (convert-output size "hectares")) "\t"
;;      (if (equal? (current-units) metric) "ha" "acres") "\t"
;;      soil "\t"
;;      crop "\t"
;;      (event-type event) "\t"
;;      (date->string (event-date event)) "\t"
;;      (number->string (convert-output (list-ref (event-nutrients event) 0) "kg/ha")) "\t"
;;      (number->string (convert-output (list-ref (event-nutrients event) 1) "kg/ha")) "\t"
;;      (number->string (convert-output (list-ref (event-nutrients event) 2) "kg/ha")) "\t"
;;      (if (equal? (current-units) metric) "kg/ha" "units/acre") "\t"
;;      (number->string (convert-output (event-amount event) nunits)) "\t"
;;      nunits "\t"
;;      (number->string (convert-output (* size (event-amount event)) aunits)) "\t"
;;      aunits "\t"
;;      (event-quality event) "\t"
;;      (event-season event) "\t"
;;      "£" (get-cost-string-from-nutrient 0 (event-nutrients event) size) "\t"
;;      "£" (get-cost-string-from-nutrient 1 (event-nutrients event) size) "\t"
;;      "£" (get-cost-string-from-nutrient 2 (event-nutrients event) size) "\t"
;;      "£" (padcash->string (list-ref costs 0)) "\t"
;;      "£" (padcash->string (list-ref costs 1)) "\t"
;;      "£" (padcash->string (list-ref costs 2))
;;      )))

;; (define (stringify-field field)
;;   (foldl
;;    (lambda (event str)
;;      (string-append
;;       str
;;       (stringify-event
;;        event
;;        (field-name field)
;;        (field-soil field)
;;        (field-crop field)
;;        (field-size field)) "\n"))
;;    ""
;;    (field-events field)))

;; (define (stringify-fields)
;;   (foldl
;;    (lambda (field str)
;;      (string-append str (stringify-field field) "\n"))
;;    (csv-headings)
;;    (get-fields)))


(define (run-calc)
  (let ((amounts (calc-nutrients))
        (amount (calc-amount calc))
        (type (calc-type calc))
	(size (calc-fieldsize calc)))
    (append
     (list
      (update-widget 'text-view (get-id "amount-value") 'text
		     (string-append (number->string (convert-output amount (get-units))) " " (get-units)))
      (update-widget 'text-view (get-id "na")
		     'text (number->string (convert-output (list-ref amounts 0) "kg/ha")))
      (update-widget 'text-view (get-id "pa")
		     'text (number->string (convert-output (list-ref amounts 1) "kg/ha")))
      (update-widget 'text-view (get-id "ka")
		     'text (number->string (convert-output (list-ref amounts 2) "kg/ha")))
      ;; costs
      (update-widget 'text-view (get-id "costn")
		     'text (get-cost-string-from-nutrient 0 amounts size))
      (update-widget 'text-view (get-id "costp")
		     'text (get-cost-string-from-nutrient 1 amounts size))
      (update-widget 'text-view (get-id "costk")
		     'text (get-cost-string-from-nutrient 2 amounts size)))
     
     ;; still needed
     (if (eq? (get-current 'calc-mode #f) 'fieldcalc)
	 (begin
	   (msg "require-n" (entity-get-value "require-n"))
	   (msg (number? (entity-get-value "require-n")))
	   (list
	    (update-widget 'text-view (get-id "needed-n")
			   'text (number->string (convert-output (- (entity-get-value "require-n") (list-ref amounts 0)) "kg/ha")))
	    (update-widget 'text-view (get-id "needed-p")
			   'text (number->string (convert-output (- (entity-get-value "require-p") (list-ref amounts 1)) "kg/ha")))
	    (update-widget 'text-view (get-id "needed-k")
			   'text (number->string (convert-output (- (entity-get-value "require-k") (list-ref amounts 2)) "kg/ha")))
	    )) '())
     )))


(define (spacer size)
  (space (layout 'fill-parent size 1 'left 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define graph-width 320)

(define (maximum a b)
  (if (> a b) a b))

(define (build-lines events min max colour n)
  (let ((twidth (maximum (- max min) 1)))
    (cadr (foldl
           (lambda (event r)
             (let* ((t (date->day (ktv-get event "date")))
                    (last-point (car r))
                    (points-list (cadr r))
                    (x (* graph-width (/ (- t min) twidth)))
                    (y (- 250 (list-ref (event-nutrients event) n))))
               (list
                (list x y)
                (cons (drawlist-line
                       colour 5 (list (car last-point) (cadr last-point)
                                      x y))
                      points-list))))
           (list (list -10 250) '())
           events))))

(define (build-bars events min max)
  (let* ((twidth (maximum (- max min) 1))
         (month-width (* (/ 30 twidth) graph-width)))
    (foldl
     (lambda (event r)
       (let* ((t (date->day (ktv-get event "date")))
              (x (* graph-width (/ (- t min) twidth)))
              (y1 (- 250 (ktv-get event "nutrients-n")))
	      (y2 (- 250 (ktv-get event "nutrients-p")))
	      (y3 (- 250 (ktv-get event "nutrients-k"))))
	 (append
	  (if (< month-width 20)
	      (list
	       (drawlist-line '(200 0 0) 3 (list x 250 x y1))
	       (drawlist-line '(200 200 0) 3 (list (+ x 3) 250 (+ x 3) y2))
	       (drawlist-line '(0 0 200) 3 (list (+ x 6) 250 (+ x 6) y3)))
	      (list
	       (drawlist-line '(200 0 0) 10 (list x 250 x y1))
	       (drawlist-line '(200 200 0) 10 (list (+ x 5) 250 (+ x 5) y2))
	       (drawlist-line '(0 0 200) 10 (list (+ x 10) 250 (+ x 10) y3))))
	  r)))
     '()
     events)))

(define (month->text m)
  (cond
   ((eqv? m 1) "January")
   ((eqv? m 2) "Febuary")
   ((eqv? m 3) "March")
   ((eqv? m 4) "April")
   ((eqv? m 5) "May")
   ((eqv? m 6) "June")
   ((eqv? m 7) "July")
   ((eqv? m 8) "August")
   ((eqv? m 9) "September")
   ((eqv? m 10) "October")
   ((eqv? m 11) "November")
   ((eqv? m 12) "December")))

(define (build-t-scale first min max)
  (define (_y year-width x y)
    (if (> (- x (/ year-width 2)) graph-width)
        '()
        (append
         (list
          (drawlist-text (number->string y)
                         (- x (/ year-width 2))
                         180 '(150 150 150) 20 "vertical")
          (drawlist-line '(0 0 0) 1
                         (list x 0 x 250)))
         (_y year-width (+ x year-width) (+ y 1)))))

  (define (_m month-width x m)
    (if (> (- x (/ month-width 2)) graph-width)
        '()
        (append
         (list
          (drawlist-text (month->text (+ m 1))
                         (- x (/ month-width 2))
                         180 '(0 0 0) 20 "vertical")
          (drawlist-line '(0 0 0) 1
                         (list x 0 x 250)))
         (_m month-width (+ x month-width) (modulo (+ m 1) 12)))))

  (let* ((twidth (maximum (- max min) 1))
         (month-width (* (/ 30 twidth) graph-width))
         (first-month-x (* (/ (- 30 (list-ref first 0)) twidth) graph-width)))
    (if (<= twidth 0)
        '()
        (if (> month-width 20)
            (_m month-width first-month-x (- (list-ref first 1) 1))
            (_y
             (* (/ 365 twidth) graph-width)
             (* (/ (- 12 (list-ref first 1)) twidth) graph-width)
             (list-ref first 2))))))

(define (build-key)
  (let ((units (if (eq? (current-units) 'metric)
                   "Kg/hectare"
                   "units/acre"))
        (a (if (equal? (current-units) 'metric) 100 (convert-output 200 "kg/ha")))
        (b (if (equal? (current-units) 'metric) 150 (convert-output 150 "kg/ha")))
        (c (if (equal? (current-units) 'metric) 100 (convert-output 100 "kg/ha")))
        (d (if (equal? (current-units) 'metric) 50 (convert-output 50 "kg/ha"))))
    (list
     (drawlist-text units 15 180 '(0 0 0) 15 "vertical")
     (drawlist-text a 20 50 '(0 0 0) 10 "horizontal")
     (drawlist-text b 20 100 '(0 0 0) 10 "horizontal")
     (drawlist-text c 20 150 '(0 0 0) 10 "horizontal")
     (drawlist-text d 20 200 '(0 0 0) 10 "horizontal")
     (drawlist-text "N" 280 30 '(200 0 0) 20 "horizontal")
     (drawlist-text "P" 280 60 '(200 200 0) 20 "horizontal")
     (drawlist-text "K" 280 90 '(0 0 200) 20 "horizontal")
     )))

(define (newest-event-day events)
  (foldl
   (lambda (event latest)
     (let ((d (date->day (ktv-get event "date"))))
       (if (< latest d)
	   d latest)))
   0
   events))

(define (oldest-event-day events)
  (foldl
   (lambda (event latest)
     (let ((d (date->day (ktv-get event "date"))))
       (if (< d latest)
	   d latest)))
   999999
   events))

(define (build-graph)
  (let ((events (db-filter 
		 db "farm" "event" 
		 (list
		  (list "parent" "varchar" "=" (get-current 'field-id #f))))))
    (append
     (if (> (length events) 1)
	 (let* ((_min (oldest-event-day events))
		(_max (newest-event-day events))
                (safe (* (- _max _min) 0.1))
                (min (- _min safe))
                (max (+ _max safe)))
           (append
            (build-t-scale (string->date (ktv-get (car events) "date")) min max)
            (build-bars events min max)
            (build-key)))
         (list (drawlist-text "Not enough events for graph"
                              20 105 '(0 0 0) 20 "horizontal")))
     (list
      (drawlist-line '(0 0 0) 5 (list 0 0 320 0))
      (drawlist-line '(0 0 0) 5 (list 0 250 320 250))))))

(define (setup-for-picture-from-event)
  ;; setup the calculator values for the camera pic from the event
  (mutate-state!
   (lambda (s)
     (state-modify-calc
      s (calc-modify-amount
         (calc-modify-type
          (state-calc s)
          (event-type (current-event)))
         (event-amount (current-event)))))))

(define (update-seek-mul! manure)
  (if (and (eq? (current-units) 'imperial)
           (or (eq? manure 'cattle)
               (eq? manure 'pig)))
      (mutate-current-seek-mul! 100)
      (cond
       ((eq? manure 'poultry)
        (if (eq? (current-units) 'imperial)
            (mutate-current-seek-mul! 0.1)
            (mutate-current-seek-mul! 0.15)))
       (else
        (mutate-current-seek-mul! 1)))))

;; just for graph so don't have to be accurate!!!
(define (date->day d)
  (let ((d (string->date d)))
    (+ (* (list-ref d 2) 360)
       (* (list-ref d 1) 30)
       (list-ref d 0))))  

(define (date< a b)
  (cond
   ((< (list-ref a 2) (list-ref b 2)) #t)
   ((> (list-ref a 2) (list-ref b 2)) #f)
   (else ;; year is the same
    (cond
     ((< (list-ref a 1) (list-ref b 1)) #t)
     ((> (list-ref a 1) (list-ref b 1)) #f)
     (else ;; month is the same
      (cond
       ((< (list-ref a 0) (list-ref b 0)) #t)
       ((> (list-ref a 0) (list-ref b 0)) #f)
       (else #f)))))))


(define (string->date d)
  (let ((splot (string-split d (list #\/))))
    (list 
     (string->number (list-ref splot 0))
     (string->number (list-ref splot 1))
     (string->number (list-ref splot 2)))))

(define (date->string d)
  (string-append
   (number->string (list-ref d 0))
   "/"
   (number->string (list-ref d 1))
   "/"
   (number->string (list-ref d 2))))

(define (date->path d)
  (string-append
   (number->string (list-ref d 0))
   "-"
   (number->string (list-ref d 1))
   "-"
   (number->string (list-ref d 2))))

(define (date->season d)
  (cond
   ((or
     (eqv? (list-ref d 1) 2)
     (eqv? (list-ref d 1) 3)
     (eqv? (list-ref d 1) 4)) 'spring)
   ((or
     (eqv? (list-ref d 1) 5)
     (eqv? (list-ref d 1) 6)
     (eqv? (list-ref d 1) 7)) 'summer)
   ((or
     (eqv? (list-ref d 1) 8)
     (eqv? (list-ref d 1) 9)
     (eqv? (list-ref d 1) 10)) 'autumn)
   ((or
     (eqv? (list-ref d 1) 11)
     (eqv? (list-ref d 1) 12)
     (eqv? (list-ref d 1) 1)) 'winter)))


(define (get-polygons)
  (map
   (lambda (field)
     (list
      (ktv-get field "name")
      (ktv-get field "unique_id")
      ;; info text
      (list 
       (mtext-lookup (string->symbol (ktv-get field "crop")))
       (string-append (number->string (rounding-cash (ktv-get field "size"))) " ha"))
      (get-field-polygon (ktv-get field "unique_id"))))
   (db-all db "farm" "field")))

(define (get-field-polygon field-uid)
  (map
   (lambda (coord)
     (list
      (ktv-get coord "lat") 
      (ktv-get coord "lng")))
   (db-filter 
    db "farm" "coord" 
    (list
     (list "parent" "varchar" "=" field-uid)))))  

(define (get-farm-centre field-polygons)
  (polygons-centroid
   (map (lambda (field)
	  (list-ref field 3))
	field-polygons)))

(define (get-field-centre field-uid polygons)
  (let ((r (polygon-centroid (get-field-polygon field-uid))))
    ;; default to farm centre if there is no field poly yet
    (if (and (eqv? (car r) 0) (eqv? (cadr r) 0))
	(get-farm-centre polygons)
	r)))

(define (event-view-item id title)
  (horiz
   (text-view 0 (mtext-lookup title) 20 (layout 'wrap-content 'wrap-content 1 'centre 0))
   (text-view (make-id id) "" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))))

(define (update-event-view-item id)
  (update-widget 'text-view (get-id id) 'text (entity-get-value id)))

(define (update-event-view-item-lookup id)
  (update-widget 'text-view (get-id id) 'text (mtext-lookup (string->symbol (entity-get-value id)))))

(define (calc-results)
  (vert
   (mtext 'crop-availible)
   (horiz
    (mtext-scale 'nutrient-n-metric)
    (mtext-scale 'nutrient-p-metric)
    (mtext-scale 'nutrient-k-metric))
   (horiz
    (text-view (make-id "na") "12" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "pa") "12" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "ka") "12" 30 (layout 'wrap-content 'wrap-content 1 'centre 0)))
   
   (mtext 'cost-saving)
   (horiz
    (text-view (make-id "costn") "12" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "costp") "12" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "costk") "12" 30 (layout 'wrap-content 'wrap-content 1 'centre 0)))
   (spacer 10)
   (image-view (make-id "example") "test" (layout 'fill-parent 'fill-parent 1 'centre 0))
   (spacer 10)))

(define (calc-event-results)
  (vert
   (mtext 'crop-availible)
   (horiz
    (mtext-scale 'nutrient-n-metric)
    (mtext-scale 'nutrient-p-metric)
    (mtext-scale 'nutrient-k-metric))
   (horiz
    (text-view (make-id "na") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "pa") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "ka") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0)))
   
   (mtext 'cost-saving)
   (horiz
    (text-view (make-id "costn") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "costp") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "costk") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0)))

   (mtext 'crop-requirements)
   (horiz
    (text-view (make-id "require-n") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "require-p") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "require-k") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0)))

   (mtext 'still-needed)
   (horiz
    (text-view (make-id "needed-n") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "needed-p") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0))
    (text-view (make-id "needed-k") "0" 30 (layout 'wrap-content 'wrap-content 1 'centre 0)))

   (spacer 10)
   (image-view (make-id "example") "test" (layout 'fill-parent 'fill-parent 1 'centre 0))
   (spacer 10)))

(define (calc-manure-type-widget fn)
  (mspinner 
   'manure-type manure-type-list
   (lambda (v) 
     (let ((v (list-ref manure-type-list v)))
       (update-seek-mul! v)
       (fn v)
       (append
	(update-type! v)
	(update-amount! (convert-input (* (current-seek-mul) 50) (get-units)))
	(list
	 (update-widget 'seek-bar (get-id "amount") 'init 0)
	 (update-widget 'spinner (get-id "quality-spinner") 'array
			(symbol-list-to-names
			 (get-qualities-for-type-inc-custom v)))
	 (update-widget 'image-view (get-id "example") 'image
			(find-image (calc-type calc)
				    (calc-amount calc)))
	 )
	(let ((applications (get-application-for-type v)))
	  (if (null? applications)
	      (list
	       (update-widget 'spinner (get-id "application-type-spinner") 'disabled 0)
	       (update-widget 'spinner (get-id "application-type-spinner") 'array '("None")))
	      (list
	       (update-widget 'spinner (get-id "application-type-spinner") 'enabled 0)
	       (update-widget 'spinner (get-id "application-type-spinner") 'array
			      (symbol-list-to-names applications)))))	   
	)))))

(define (calc-manure-quality-widget fn)
  (mspinner 'quality cattle-quality-list 
	    (lambda (v) 
	      (let ((type (current-type)))
		(let ((quality 
		       (list-ref 
			(cond
			 ((eq? type 'cattle) cattle-quality-list)
			 ((eq? type 'pig) pig-quality-list)
			 ((eq? type 'poultry) poultry-quality-list)
			 (else fym-quality-list))
			v)))
		  (fn quality)
		  (update-quality! quality))))))

(define (calc-manure-application-widget fn)
  (mspinner 'application-type cattle-application-list 
	    (lambda (v) 
	      (let ((type (current-type)))
		(let ((application-list (get-application-for-type type)))
		  (let ((application (if (null? application-list) 'none
					 (list-ref application-list v))))
		    (fn application)
		    (update-application! application)))))))

(define (calc-amount-widget fn)
  (seek-bar (make-id "amount") 100 fillwrap
	    (lambda (v)
	      (fn v)
	      (append
	       (update-amount! (convert-input (* (current-seek-mul) v) (get-units)))
	       (list
		(update-widget 'image-view (get-id "example") 'image
			       (find-image (calc-type calc)
					   (calc-amount calc))))))))
  
(define (calc-gallery)
  (vert
   (list
    (button (make-id "load-gallery") "Load Gallery" 20 fillwrap
	    (lambda ()
	      (let ((path (string-append
			   (field-name (current-field)) "-"
			   (number->string (event-id (current-event))) "/")))
		(list
		 (list-files
		  (string-append "filelister-" path)
		  path
		  (lambda (images)
		    (list
		     (update-widget
		      'linear-layout (get-id "gallery") 'contents
		      (cons
		       (text-view (make-id "temp") "Gallery" 30 fillwrap)
		       (foldl
			(lambda (image r)
			  (append
			   (list (image-view (make-id image)
					     (string-append dirname path image)
					     (layout 'wrap-content 240 1 'left 0))
				 (spacer 10))
			   r))
			'()
			images)))))))))))))


(define (update-field-cropsoil-calc-from-current)
  (update-field-cropsoil-calc
   (get-crop-requirements/supply-from-current)))

(define (update-field-cropsoil-calc results)
  (list
   (update-widget 'text-view (get-id "supply-n") 'text 
		  (soil-nutrient-code-to-text (list-ref results 3)))
   (update-widget 'text-view (get-id "require-n") 'text (number->string (list-ref results 0)))
   (update-widget 'text-view (get-id "require-p") 'text (number->string (list-ref results 1)))
   (update-widget 'text-view (get-id "require-k") 'text (number->string (list-ref results 2)))))

(define (get-crop-requirements/supply-from-field field)
  (get-crop-requirements/supply 
   (string->symbol (ktv-get field "crop"))
   (string->symbol (ktv-get field "soil"))
   (string->symbol (ktv-get field "previous-crop"))
   (string->symbol (ktv-get field "regularly-manure"))
   (string->symbol (ktv-get field "soil-test-p"))
   (string->symbol (ktv-get field "soil-test-k"))))

(define (get-crop-requirements/supply-from-current)
  (msg "soil test is" (string->symbol (entity-get-value "soil-test-p")))

  (get-crop-requirements/supply 
   (string->symbol (entity-get-value "crop"))
   (string->symbol (entity-get-value "soil"))
   (string->symbol (entity-get-value "previous-crop"))
   (string->symbol (entity-get-value "regularly-manure"))
   (string->symbol (entity-get-value "soil-test-p"))
   (string->symbol (entity-get-value "soil-test-k"))))

(define (get-crop-requirements/supply crop soil previous-crop regularly-manure soil-test-p soil-test-k)
  (let ((sns (calc-sns (current-rainfall) soil crop previous-crop regularly-manure)))
    (msg soil-test-p soil-test-k)
    (let ((choices 
	   (list 
	    (list 'sns sns)
	    (list 'rainfall (current-rainfall))
	    (list 'soil soil)
	    (list 'crop crop)
	    (list 'p-index soil-test-p)
	    (list 'k-index soil-test-k))))
      (list 
       (decision crop-requirements-n-tree choices) 
       (decision crop-requirements-pk-tree (cons (list 'nutrient 'phosphorous) choices))
       (decision crop-requirements-pk-tree (cons (list 'nutrient 'potassium) choices))
       sns))))
		 
