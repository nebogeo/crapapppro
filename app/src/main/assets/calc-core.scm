;; -*- mode: scheme; -*-
;; Farm Crap App Pro Copyright (C) 2016 FoAM Kernow
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

;; these are the symbols used everywhere

(msg "calc-core")

(define NVZ-nitrogen-warning 250)

(define manure-type-list (list 'cattle 'fym 'pig 'poultry 'compost 
			       'paper-crumble 'spent-mushroom 
			       'water-treatment-cake 
			       'food-industry-waste 'digestate-food 
			       'digestate-farm 'biosolid 
			       'custom-manure))

(define units-list (list 'metric 'imperial))
(define soil-type-list 
  (list 'sandyshallow 'mediumshallow 'medium 'deepclay 'deepsilt 'organic 'peat))

(define soil-test-p-list (list 'soil-p-0 'soil-p-1 'soil-p-2 'soil-p-3 'soil-p-4))
(define soil-test-k-list (list 'soil-k-0 'soil-k-1 'soil-k-2- 'soil-k-2+ 'soil-k-3 'soil-k-4))
(define soil-test-m-list (list 'soil-m-0 'soil-m-1 'soil-m-2 'soil-m-3 'soil-m-4 'soil-m-5 'soil-m-6 'soil-m-7 'soil-m-8 'soil-m-9))

(define crop-type-for-manure-calc-list 
  (list 'normal 'grass-oilseed))

(define previous-crop-type-list 
  (list 'cereals 'oilseed 'potatoes 
	'sugarbeet 'peas 'beans 'low-n-veg 'medium-n-veg 'forage 
	'uncropped 'grass-low-n 'grass-high-n 'grass-other))
(define season-list (list 'autumn 'winter 'spring 'summer))

(define cattle-quality-list (list 'DM2 'DM6 'DM10 'dirtywater 'solid 'liquidstrainer 'liquidweeping 'liquidmechanical))
(define pig-quality-list (list 'DM2 'DM4 'DM6 'liquid 'solid))
(define poultry-quality-list (list 'DM20 'DM40 'DM60 'DM80))
(define fym-quality-list (list 'fym-cattle 'fym-pig 'fym-sheep 'fym-duck 'fym-horse 'fym-goat))
(define paper-crumble-quality-list (list 'chemical-physical 'biological))
(define food-industry-waste-quality-list (list 'dairy 'soft-drinks 'brewing 'general))
(define digestate-food-quality-list (list 'whole 'separated-liquor 'separated-fibre))
(define digestate-farm-quality-list (list 'whole 'separated-liquor 'separated-fibre))
(define biosolid-quality-list (list 'digested-cake 'thermally-dried 'lime-stabilised 'composted))
(define compost-quality-list (list 'green 'green-food))
(define recently-grown-grass-list (list 'no '1yr '2yr '3yr)) 
(define yesno-list (list 'yes 'no))

(define fym-application-list
  (list 'straight-surface 'straight-ploughed 'stored-spread 'stored-ploughed))
(define pig-application-list
  (list 'splash-surface 'splash-incorporated 'shoe-bar-spreader 'shallow-injected))
(define cattle-application-list
  (list 'splash-surface 'splash-incorporated 'shoe-bar-spreader 'shallow-injected))
(define poultry-application-list
  (list 'surface 'ploughed))
(define biosolid-application-list 
  (list 'surface 'ploughed))

(define custom-manure-type-list 
  (list 'custom-slurry-dm2
	'custom-slurry-dm6
	'custom-slurry-dm10
	'custom-fym-incorporated
	'custom-fym-removed))

(define rainfall-list (list 'rain-high 'rain-medium 'rain-low))

(define backup-freq-list (list 'never 'daily 'weekly 'monthly))

;; metric/imperial conversion
(define (tons/acre->tonnes/ha a) (* a 2.47105381))
(define (tonnes/ha->tons/acre a) (/ a 2.47105381))
(define (gallons/acre->m3/ha a) (* a 0.0112336377))
(define (m3/ha->gallons/acre a) (/ a 0.0112336377))
(define (kg/ha->units/acre a) (* a 0.8))
(define (units/acre->kg/ha a) (/ a 0.8))
(define (acres->hectares a) (* a 0.404686))
(define (hectares->acres a) (* a 2.47105))
(define (m3->gallons a) (* a 219.969))

(define (m2->hectares a) (/ a 10000))
(define (hectares->m2 a) (* a 10000))

;; overwritten by db values
(define costs (list 0 0 0 0 0))
(define custom-override #f)
(define (set-custom-override! s) (set! custom-override s))

(define (abs n)
  (if (< n 0) (- n) n))

(define (in-list? n l)
  (cond
   ((null? l) #f)
   ((equal? n (car l)) #t)
   (else (in-list? n (cdr l)))))

(define (find n l)
  (cond
    ((null? l) #f)
    ((equal? n (car (car l))) (car l))
    (else (find n (cdr l)))))

(define (process-nutrients amount nutrients)
  ;;(msg "amount is:" amount)
  (map
   (lambda (q)
     (if (number? q)
	 (rounding (* amount q))
	 q))
   nutrients))

(define (rounding a)
  (/ (round (* 10 a)) 10))
  
(define (get-qualities-for-type t)
  (cond
   ((eq? t 'cattle) cattle-quality-list)
   ((eq? t 'pig) pig-quality-list)
   ((eq? t 'poultry) poultry-quality-list)
   ((eq? t 'fym) fym-quality-list)
   ((eq? t 'compost) compost-quality-list)
   ((eq? t 'paper-crumble) paper-crumble-quality-list)
   ((eq? t 'food-industry-waste) food-industry-waste-quality-list)
   ((eq? t 'digestate-food) digestate-food-quality-list)
   ((eq? t 'digestate-farm) digestate-farm-quality-list)
   ((eq? t 'biosolid) biosolid-quality-list)
   (else '())))

(define (get-application-for-type t)
  (cond
   ((eq? t 'cattle) cattle-application-list)
   ((eq? t 'pig) pig-application-list)
   ((eq? t 'fym) fym-application-list)
   ((eq? t 'poultry) poultry-application-list)
   ((eq? t 'biosolid) biosolid-application-list)
   (else '())))

(define (get-units-for-type t)
  (cond
   ((eq? t 'cattle) "m3/ha")
   ((eq? t 'pig) "m3/ha")
   ((eq? t 'poultry) "tonnes/ha")
   ((eq? t 'compost) "tonnes/ha")
   ((eq? t 'digestate-food) "m3/ha")
   ((eq? t 'digestate-farm) "m3/ha")
   (else "tonnes/ha")))

(define (imperial->metric amount units)
  (if (eq? (current-units) 'metric)
      amount
      (if (equal? units "m3/ha")
          (gallons/acre->m3/ha amount)
          (tons/acre->tonnes/ha amount))))

(define (metric->imperial amount units)
  (if (eq? (current-units) 'metric)
      amount
      (kg/ha->units/acre amount)))

(define (rounding-cash a)
  (/ (round (* 100 a)) 100))

(define (padcash->string a)
  (let ((t (number->string (rounding-cash a))))
    ;; removed in online version...
    ;;(substring t 0 (- (string-length t) 1))
    t))

;; todo: this text should be in translations.scm
(define (convert-input amount units)
  (if (eq? (current-units) 'metric)
      amount
      (cond
       ((or (equal? units "m3/ha") (equal? units "gallons/acre"))
        (gallons/acre->m3/ha amount))
       ((or (equal? units "tonnes/ha") (equal? units "tons/acre"))
        (tons/acre->tonnes/ha amount))
       ((or (equal? units "kg/ha") (equal? units "units/acre"))
        (units/acre->kg/ha amount))
       ((or (equal? units "hectares") (equal? units "acres"))
        (acres->hectares amount))
       ((equal? units "tonnes") amount) ;; tonnes are metric everywhere!?
       (else (msg "I don't understand how to convert" units)))))

(define (convert-output amount units)
  (cond 
   ((eq? #f amount) 0) ;; if it's missing from the database
   ((eq? 'NA amount) 0) ;; can't really store N/A in real so just set to 0
   (else 
    (rounding
     (if (eq? (current-units) 'metric)
	 amount
	 (cond
	  ((or (equal? units "m3/ha") (equal? units "gallons/acre"))
	   (m3/ha->gallons/acre amount))
	  ((or (equal? units "tonnes/ha") (equal? units "tons/acre"))
	   (tonnes/ha->tons/acre amount))
	  ((or (equal? units "kg/ha") (equal? units "units/acre"))
	   (kg/ha->units/acre amount))
	  ((or (equal? units "hectares") (equal? units "acres"))
	   (hectares->acres amount))
	  ((or (equal? units "m3") (equal? units "gallons"))
	   (m3->gallons amount))
	  ((equal? units "tonnes") amount) ;; tonnes are metric everywhere!?
	  (else (msg "I don't understand how to convert" units))))))))
  
(define (convert-output->string amount units)
  (if (eq? amount 'NA)
      "N/A" (number->string (convert-output amount units))))

(define default-crop '((crop barley) (sown spring) (application incorporated) (process feed)))

(define (crop-params->readable crop)
  (foldl
   (lambda (p r)
     (string-append 
      r (if (number? (cadr p)) (number->string (cadr p))
	    (mtext-lookup (cadr p)))
      " "))
   "" 
   crop))

;; the manure calculator
(define calc
  (list 'cattle 50 'DM2 'autumn 
	default-crop
	'mediumshallow 'splash-surface
	(list date-day date-month date-year)
	1 1 
	'(soil-p-0 soil-k-0)))

(define (calc-type s) (list-ref s 0))
(define (calc-modify-type s v) (list-replace s 0 v))
(define (calc-amount s) (list-ref s 1))
(define (calc-modify-amount s v) (list-replace s 1 v))
(define (calc-quality s) (list-ref s 2))
(define (calc-modify-quality s v) (list-replace s 2 v))
(define (calc-season s) (list-ref s 3))
(define (calc-modify-season s v) (list-replace s 3 v))
(define (calc-crop s) (list-ref s 4))
(define (calc-modify-crop s v) (list-replace s 4 v))
(define (calc-soil s) (list-ref s 5))
(define (calc-modify-soil s v) (list-replace s 5 v))
(define (calc-application s) (list-ref s 6))
(define (calc-modify-application s v) (list-replace s 6 v))
(define (calc-date s) (list-ref s 7))
(define (calc-modify-date s v) (list-replace s 7 v))
(define (calc-seek-mul s) (list-ref s 8))
(define (calc-modify-seek-mul s v) (list-replace s 8 v))
(define (calc-fieldsize s) (list-ref s 9))
(define (calc-modify-fieldsize s v) (list-replace s 9 v))
(define (calc-soil-test s) (list-ref s 10))
(define (calc-modify-soil-test s v) (list-replace s 10 v))

;; shortcuts
(define (current-date) (calc-date calc))
(define (current-seek-mul) (calc-seek-mul calc))
(define (current-type) (calc-type calc))
(define (current-quality) (calc-quality calc))

(define (calc-nutrients)
  (let ((type (calc-type calc))
	(amount (calc-amount calc))
	(quality (calc-quality calc))
	(season (calc-season calc))
	(crop (calc-crop calc))
	(soil (calc-soil calc))
	(application (calc-application calc))
	(soil-test (calc-soil-test calc)))
    (if custom-override  
	(get-custom-manure-nutrients amount custom-override season 
				     crop soil soil-test)
	(get-nutrients type amount quality season 
		       (crop-params->manure-crop crop) 
		       soil application soil-test))))


(define (get-units)
  (let ((type (calc-type calc)))
    (if (eq? (current-units) 'metric)
        (get-units-for-type type)
        (if (equal? (get-units-for-type type) "m3/ha")
            "gallons/acre"
            "tons/acre"))))

(define (get-metric/imperial-units-for-type type)
  (if (eq? (current-units) 'metric)
      (get-units-for-type type)
      (if (equal? (get-units-for-type type) "m3/ha")
 	  "gallons/acre"
 	  "tons/acre")))

;; i18n??
(define (get-cost-string-from-nutrient nutrient-index amounts mul)
  (if (number? (list-ref amounts nutrient-index))  
      (string-append "£" (padcash->string (* (list-ref amounts nutrient-index)
					     (list-ref costs nutrient-index) mul)))
      "£N/A"))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; the complex bit

(define (previous-crop-grass? previous-crop)
  (or (eq? previous-crop 'grass-low-n)
      (eq? previous-crop 'grass-high-n)
      (eq? previous-crop 'grass-other)))

;; any crop except grass grazed, silage, hay, esablished (but not rye)
(define (is-crop-arable? c)
  (or 
   (not (eq? (get-choice-value c 'crop) 'grass))
   (eq? (get-choice-value c 'subtype) 'rye)))

(define (crop-params->manure-crop c)
  (if (or
       (not (is-crop-arable? c)) ;; it's grass!
       (and (eq? (get-choice-value c 'crop) 'rape) ;; or oilseed
	    (eq? (get-choice-value c 'subtype) 'oilseed)))
      'grass-oilseed 'normal))

(define (crop-type-for-manure->crop-params c)
  (if (eq? c 'grass-oilseed) 
      '((crop grass)) 
      '((crop wheat)))) ;; anything else will be converted to "normal"

;; table on pp 188 (replaced with new version, see below)
(define (grassland-modifier crop soil previous-crop recently-grown-grass)
  (if (previous-crop-grass? previous-crop)
      ;; grass -> grass
      (if (not (eq? recently-grown-grass 'no))
	  grassland-high-sns
	  (if (eq? soil 'sandyshallow)
	      grassland-low-sns
	      grassland-med-sns))
      ;; arable -> grass
      ;; table 3.6 grassland recommendation page 13
      ;; ignore bottom part (cereals, sugar beet etc - as this is just
      ;; saying the default situation is low sns)
      (if (and (not (eq? soil 'sandyshallow))
	       (or (eq? previous-crop 'potato)
		   (eq? previous-crop 'peas)
		   (eq? previous-crop 'oilseed)
		   (eq? previous-crop 'beans)))
	  grassland-med-sns
	  grassland-low-sns)))

(define (sns-search tree params regularly-manure)
  (let ((sns (decision tree params)))
    ;; increase sns by one if they regularly manure (pp 188)
    (if (and (< sns 6) (eq? regularly-manure 'yes))
	(+ sns 1)
	sns)))

;; calculate soil nitrogen supply
(define (calc-sns rainfall soil crop previous-crop regularly-manure recently-grown-grass)
  (let ((params (list 
		 (list 'rainfall rainfall)
		 (list 'recently-grown-grass recently-grown-grass)
		 ;; soil medium category doesn't exist in sns tables
		 (list 'soil (if (eq? soil 'medium)
				 'mediumshallow soil))
		 (list 'previous-crop previous-crop))))
    ;; special options needed for grass:
    (cond
     ;; from grass -> grass (pp 188)
     ;; changed from anything -> grass
     ;; (new rb209 grassland recommendations pp 12 table 3.6)
     ((not (is-crop-arable? crop))
      (grassland-modifier crop soil previous-crop recently-grown-grass))
     ;; grass -> arable (pp 94)
     ((and (is-crop-arable? crop) 
	   (previous-crop-grass? previous-crop))
      (sns-search previous-grass-soil-nitrogen-supply-tree
		  params regularly-manure))
     (else
      (sns-search soil-nitrogen-supply-tree 		  
		  params regularly-manure)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stuff for crop requirements

;; sulphur risk
;; Use rainfall and soil type data:

;; All light sand and shallow soils = High risk
;; Medium soils with low rainfall = Low risk
;; Medium soils with medium or high rainfall = High risk
;; Deep clay, deep silt, organic and peat soils with low or medium rainfall = Low risk
;; Deep clay, deep silt, organic and peat soils with high rainfall = High risk

(define (calc-sulphur-risk rainfall soil)
  (cond
   ((or (eq? soil 'sandyshallow)
	(eq? soil 'mediumshallow)) 'high)
   ((and (eq? soil 'medium)
	 (or 
	  (eq? rainfall 'rain-high)
	  (eq? rainfall 'rain-medium))) 'high)
   ((or (eq? soil 'peat)
	 (eq? soil 'deepclay)
	 (eq? soil 'deepsilt)
	 (eq? soil 'organic))
    (if (eq? rainfall 'rain-high) 'high
	'low))
   (else 'low)))

;; not used (yet)
(define (calc-nitrogencategory amount)
  (cond
   ((< amount 100) "under100")
   ((and (> amount 100) (< amount 200)) "100-200")
   ((and (> amount 200) (< amount 300)) "200-300")
   (else "300-400")))

(define (grassland-nitrogen-modifier sns crop)
  (cond
   ((and (eq? (get-choice-value crop 'crop) 'grass)
	 (eq? (get-choice-value crop 'subtype) 'silage))
    (cond 
     ;; Silage (page 15 grassland reccomendations)
     ;; High SNS sites -> apply 10 less for first cut, 20 less for second cut
     ;; Low SNS sites -> apply 10 more for first cut, 20 more for second cut
     ((eq? (get-choice-value crop 'cut) 'one)
      (cond ((eqv? sns grassland-high-sns) -10)
	    ((eqv? sns grassland-low-sns) 10)
	    (else 0)))
     ((eq? (get-choice-value crop 'cut) 'two)
      (cond ((eqv? sns grassland-high-sns) -20)
	    ((eqv? sns grassland-low-sns) 20)
	    (else 0)))
     (else 0)))
   ;; Grazed (page 16 grassland reccomendations) 
   ((and (eq? (get-choice-value crop 'crop) 'grass)
	 (eq? (get-choice-value crop 'subtype) 'grazed))
    (cond
     ((eqv? sns grassland-high-sns) -30)
     ((eqv? sns grassland-low-sns) 30)
     (else 0)))
   (else 0)))

(define (get-crop-requirements/supply rainfall crop-params soil previous-crop regularly-manure soil-test-p soil-test-k soil-test-m recently-grown-grass month)
  (let ((sns (calc-sns rainfall soil crop-params previous-crop regularly-manure recently-grown-grass))
	(risk (calc-sulphur-risk rainfall soil)))
    (let ((choices 
	   (append
	    crop-params
	    (list 
	     ;; this is now supplied by the crop type (grown not current)
	     ;;(list 'season (symbol->string (month->season month)))
	     (list 'nitrogencategory 'under100) ;; we don't know this yet...
	     (list 'sns sns) ;; sns not used for grass requirement, ok to be grassland low/med/high
	     (list 'rainfall rainfall)
	     (list 'soil soil)
	     (list 'risk risk)
	     (list 'p-index soil-test-p)
	     (list 'k-index soil-test-k)
	     (list 'm-index soil-test-m)
	     (list 'month month)))))
      (list 
       (let ((n (decision crop-requirements-n-tree choices)))
	 (if (eq? n 'NA) 'NA (+ n (grassland-nitrogen-modifier sns crop-params))))
       (decision crop-requirements-pk-tree (cons (list 'nutrient 'phosphorus) choices))
       (decision crop-requirements-pk-tree (cons (list 'nutrient 'potassium) choices))
       (decision crop-requirements-pk-tree (cons (list 'nutrient 'sulphur) choices))
       (decision crop-requirements-pk-tree (cons (list 'nutrient 'magnesium) choices))
       sns
       risk))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stuff for manure nutrients

(define (manure-get-totals manure-type amount soil-type n-total-percent params)
  ;; total values
  (process-nutrients 
   amount 
   (list
    ;; if pig or cattle slurry, then this is the percent value
    (if (zero? n-total-percent) 
	(decision manure-tree (append (list (list 'nutrient 'n-total)) params))
	n-total-percent)
    (decision manure-tree (append (list (list 'nutrient 'p-total)) params))
    (decision manure-tree (append (list (list 'nutrient 'k-total)) params))
    (decision manure-tree (append (list (list 'nutrient 's-total)) params))
    (decision manure-tree (append (list (list 'nutrient 'm-total)) params)))))

(define (manure-get-crop-avail amount n-total-percent soil-test params)
  ;; crop available values
  ;; sometimes we use totals as crop available figures
  (let ((p-type (if (or (eq? (car soil-test) 'soil-p-2) 
			(eq? (car soil-test) 'soil-p-3)
			(eq? (car soil-test) 'soil-p-4))
		    'p-total
		    'p-avail))
	(k-type (if (or (eq? (cadr soil-test) 'soil-k-2-)
			(eq? (cadr soil-test) 'soil-k-2+) 
			(eq? (cadr soil-test) 'soil-k-3)
			(eq? (cadr soil-test) 'soil-k-4))
		    'k-total
		    'k-avail)))    
    (process-nutrients 
     amount 
     (list
      ;; if pig or cattle slurry, then this is the percent value
      (let ((n (decision manure-tree (append (quote ((nutrient n-avail))) params))))
	;; N/A value
	(if (eq? n 'NA) n
	    ;; apply percent or return straight value
	    (if (zero? n-total-percent) n (pc n-total-percent n))))
      (decision manure-tree (append (list (list 'nutrient p-type)) params))
      (decision manure-tree (append (list (list 'nutrient k-type)) params))
      (decision manure-tree (append (list (list 'nutrient 's-avail)) params))
      (decision manure-tree (append (list (list 'nutrient 'm-avail)) params))))))

;; crop here is only one identifier, not the crop params - grass-oilseed or normal
(define (get-nutrients manure-type amount quality season crop soil-type application soil-test)
  ;; apply all the extra conditional stuff here
  (let ((params (list (list 'type manure-type) 
		      (list 'quality quality) 
		      (list 'season season) 
		      (list 'crop crop)
		      (list 'p-index (car soil-test)) ;; first soil test item is P
		      ;; also we have to convert soil to the two
		      ;; types in manure (pp 66, note b)
		      (list 'soil (cond 
				   ((eq? soil-type 'sandyshallow) 'sandyshallow)
				   ((eq? soil-type 'mediumshallow) 'sandyshallow)
				   (else 'mediumheavy)))
		      (list 'application application))))
    
    ;; get the total for pig or cattle slurry or poultry, then we apply the 
    ;; percent value later to get the crop available
    (let ((n-total-percent (if (or (eq? manure-type 'pig) 
				   (eq? manure-type 'cattle)
				   (eq? manure-type 'poultry))
			       (decision n-total-tree params) 0)))
      (list
       (manure-get-totals manure-type amount soil-type n-total-percent params)
       (manure-get-crop-avail amount n-total-percent soil-test params)))))

(define (custom-manure->params type)
  (cond
   ((eq? type 'custom-slurry-dm2) '((type cattle) (quality DM2)))
   ((eq? type 'custom-slurry-dm6) '((type cattle) (quality DM6)))
   ((eq? type 'custom-slurry-dm10) '((type cattle) (quality DM10)))
   ((eq? type 'custom-fym-incorporated) '((type fym) (application straight-ploughed)))
   (else '((type fym) (application straight-surface)))))   

(define (get-custom-manure-nutrients amount custom season crop soil-type soil-test)
  (let ((type (car custom))
	(totals (cdr custom))) ;; strip out type
    (let ((params 
	   (append
	    (custom-manure->params type)
	    (list
	     (list 'season season) 
	     (list 'crop crop)
	     ;; also we have to convert soil to the two
	     ;; types in manure (pp 66, note b)
	     (list 'soil (cond 
			  ((eq? soil-type 'sandyshallow) 'sandyshallow)
			  ((eq? soil-type 'mediumshallow) 'sandyshallow)
			  (else 'mediumheavy)))))))
      (list 
       ;; total
       (process-nutrients amount totals)
       ;; build     
       (process-nutrients 
	amount 
	(list
	 (pc (list-ref totals 0) (decision custom-manure-percent-tree (append (quote ((nutrient n-avail))) params)))
	 (pc (list-ref totals 1) (decision custom-manure-percent-tree (append (quote ((nutrient p-avail))) params)))
	 (pc (list-ref totals 2) (decision custom-manure-percent-tree (append (quote ((nutrient k-avail))) params)))
	 (pc (list-ref totals 3) (decision custom-manure-percent-tree (append (quote ((nutrient s-avail))) params)))
	 (pc (list-ref totals 4) (decision custom-manure-percent-tree (append (quote ((nutrient m-avail))) params)))))))))


