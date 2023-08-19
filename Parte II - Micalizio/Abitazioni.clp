;;*********
;;* MAIN *
;;********
(defmodule MAIN (export ?ALL))

;;****************
;;* DEFFUNCTIONS *
;;****************

   (deffunction MAIN::ask-question (?question ?allowed-values ?range)
     (printout t (format nil ?question))
     (bind ?answer (read))
     (if (and ?range TRUE) then
          (while (not(and (>= ?answer (nth$ 1 ?allowed-values)) (<= ?answer (nth$ 2 ?allowed-values)))) do
             (printout t "NOT A VALID ANSWER" crlf)
             (printout t (format nil ?question))
             (bind ?answer (read)))
      else (while (not (member$ ?answer ?allowed-values)) do
              (printout t "NOT A VALID ANSWER" crlf)
              (printout t (format nil ?question))
              (bind ?answer (read)))
    )
    ?answer)

(deffunction MAIN::boolean-conversion (?p)
    (if (eq (str-cat ?p) "Si") then (bind ?answer 1) else (if (eq (str-cat ?p) "No") then (bind ?answer 0) else (bind ?answer ?p)))
?answer)

(deffunction MAIN::calculate-cf-range (?lower-bound ?upper-bound ?mode ?choosen-value ?current-value ?weight)
        (bind ?lower-bound (boolean-conversion ?lower-bound))
        (bind ?upper-bound (boolean-conversion ?upper-bound))
        (bind ?choosen-value (boolean-conversion ?choosen-value))
        (bind ?current-value (boolean-conversion ?current-value)) 

        (if (> (abs (- ?upper-bound ?choosen-value)) (abs (- ?lower-bound ?choosen-value))) then
            (bind ?bound ?upper-bound)
        else (bind ?bound ?lower-bound))

        (bind ?answer (+ 100 (* -1 (abs (/ (* 10 (* ?weight (- ?choosen-value ?current-value)))(- ?bound ?choosen-value))))))

        (if (and (eq ?mode "gt") (> ?current-value ?choosen-value)) then (bind ?answer 100))
        (if (and (eq ?mode "lt") (< ?current-value ?choosen-value)) then (bind ?answer 100))

?answer)

(deffunction MAIN::calculate-cf-no-range(?choosen-value ?current-value ?weight)
    (if (or (eq (str-cat ?choosen-value) "Indifferente") (eq (str-cat ?choosen-value) (str-cat ?current-value))) then (bind ?answer 100) else (bind ?answer (- 100 (* 10 ?weight))))
?answer)

(deffunction MAIN::uniform-len-string(?string ?len)
    (bind ?answer ?string)
    (while (neq (str-length ?answer) ?len) do
      (if (< (str-length ?answer) ?len)
        then
          (bind ?answer (str-cat ?answer " "))
        else
          (bind ?answer (sub-string 1 ?len ?answer))
      )
    )
?answer)

   ;;*****************
   ;;* INITIAL STATE *
   ;;*****************

(defrule MAIN::start
  (declare (salience 1000))
  =>
  (set-fact-duplication TRUE)
  (focus QUESTIONS APARTMENT MAIN REMOVE-OLD-FACTS PRINT-RESULTS MODIFY-RESEARCH QUESTIONS APARTMENT MAIN  REMOVE-OLD-FACTS PRINT-RESULTS)

)

(defrule MAIN::combine-certainties_base ""
  (declare (salience 100)
    (auto-focus TRUE))
  (immobile (name ?estate))
  =>
  (assert (attribute (name weight_sum) (estate ?estate) (value 0)))
  (assert (attribute (name weighted_average) (estate ?estate) (value 0)))
)

(defrule MAIN::combine-certainties_recursive ""
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem  <- (attribute (name ?name) (estate ?e) (value ?v1) (certainty ?cf) (weight ?weight))
  ?wsum <- (attribute (name weight_sum) (estate ?e) (value ?weight_sum))
  ?wavg <- (attribute (name weighted_average) (estate ?e) (value ?weighted_average))
  (test (neq ?e nil))
  (test (neq ?name weight_sum))
  (test (neq ?name weighted_average))
  (test (neq ?name max_cf))
  =>
  (retract ?rem)
  (modify ?wavg (value (/ (+ (* ?weighted_average ?weight_sum) (* ?cf ?weight)) (+ ?weight_sum ?weight))))
  (modify ?wsum (value (+ ?weight_sum ?weight)))
)
  ;;******************
  ;;* QUESTION RULES *
  ;;******************

(defmodule QUESTIONS (import MAIN ?ALL)(export ?ALL))
  ;define a question


(defrule QUESTIONS::ask-a-question
 ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute ?the-attribute & ~box-mq & ~change-answer & ~soft-hard)
                   (valid-answers $?valid-answers)
                   (range ?range)
                   (profiling ?profiling)
        )
        (question 
              (attribute soft-hard)
              (the-question ?the-question_2)
              (valid-answers $?valid-answers_2)
              (range ?range_2)
        )
   =>
        (bind ?input (ask-question ?the-question ?valid-answers ?range))
        (modify ?f (already-asked TRUE))
        (assert (attribute (name ?the-attribute)
        (value ?input)))
        (if (and (and (and (and (not ?range) TRUE) (neq ?input No)) (neq ?input Indifferente)) (neq ?profiling TRUE)) then 
          (assert (soft-hard (name ?the-attribute)
          (is-hard  (ask-question ?the-question_2 ?valid-answers_2 ?range_2))
          (value ?input)))
        )
)

(defrule QUESTIONS::precursor-is-satisfied
    ?f <- (question (already-asked FALSE)
                    (precursors ?name is ?value $?rest))
          (attribute (name ?name) (value ?value))
    =>
    (if (eq (nth$ 1 ?rest) and)
     then (modify ?f (precursors (rest$ ?rest)))
     else (modify ?f (precursors ?rest))))

(defrule QUESTIONS::precursor-is-not-satisfied
    ?f <- (question (already-asked FALSE)
                    (precursors ?name is-not ?value $?rest))
          (attribute (name ?name) (value ~?value))
     =>
     (if (eq (nth$ 1 ?rest) and)
      then (modify ?f (precursors (rest$ ?rest)))
      else (modify ?f (precursors ?rest))))

  ;;*************************
  ;;* CHOOSE-APARTMENT *
  ;;*************************
(defmodule APARTMENT (import MAIN ?ALL)
              (export ?ALL))


   (defrule APARTMENT::refresh
    (declare (salience 100))
    (attribute (name change-answer))
    =>
    (refresh combine-certainties_base)
    (refresh APARTMENT::calculate-cf-budget)
    (refresh APARTMENT::calculate-cf-num-rooms)
    (refresh APARTMENT::calculate-cf-energy-class)
    (refresh APARTMENT::calculate-cf-elevator)
    (refresh APARTMENT::calculate-cf-balcony)
    (refresh APARTMENT::calculate-cf-square-meters)
    (refresh APARTMENT::calculate-cf-box-mq)
    (refresh APARTMENT::calculate-cf-backyard)
    (refresh APARTMENT::calculate-cf-city)
    (refresh APARTMENT::calculate-cf-region)
    (refresh APARTMENT::calculate-cf-type-property)
    (refresh APARTMENT::calculate-cf-floor-of-house)
    (refresh APARTMENT::calculate-cf-state-of-house)
    (refresh APARTMENT::calculate-cf-district)
    ;(refresh calculate-cf-country-place)
    (refresh APARTMENT::calculate-cf-have-children)
    (refresh APARTMENT::calculate-cf-is-sporty)
    (refresh APARTMENT::calculate-cf-is-old)
    (refresh APARTMENT::calculate-cf-got-car)
    (refresh APARTMENT::calculate-cf-got-car-2)
  )

  (defrule APARTMENT::calculate-cf-budget
      (question (attribute budget) (valid-answers ?min-range ?max-range))
      (immobile (name ?name)(price ?p))
      (attribute (name budget) (value ?budget))
      (weights-immobile (price ?w))
      =>
      (assert (attribute (name budget_) (value ?budget) (estate ?name) (weight ?w)
        (certainty (calculate-cf-range ?min-range ?max-range "lt" ?budget ?p ?w))
      ))
  )


  (defrule APARTMENT::calculate-cf-num-rooms
      (question (attribute num-rooms) (valid-answers ?min-range ?max-range))
      (immobile (name ?name)(num-of-rooms ?nr))
      (attribute (name num-rooms) (value ?rooms))
      (weights-immobile (num-of-rooms ?w))
      =>
      (assert (attribute (name num-rooms_) (value ?nr) (estate ?name) (weight ?w)
        (certainty (calculate-cf-range ?min-range ?max-range "gt" ?rooms ?nr ?w))
      ))
  )

    (defrule APARTMENT::calculate-cf-energy-class
      (question (attribute energy-class) (valid-answers ?min-range ?max-range))
      (immobile (name ?name)(energy-class ?e))
      (attribute (name energy-class) (value ?energy))
      (weights-immobile (energy-class ?w))
      =>
      (assert (attribute (name energy-class_) (value ?e) (estate ?name) (weight ?w)
        (certainty (calculate-cf-range ?min-range ?max-range "gt" ?energy ?e ?w))
      ))
  )

  

  (defrule APARTMENT::calculate-cf-elevator
    (question (attribute elevator) (valid-answers ?min-range ?max-range))
    (immobile (name ?name)(elevator ?e))
    (attribute (name elevator) (value ?elevator))
    (weights-immobile (elevator ?w))
    =>
    (assert (attribute (name elevator_) (value ?e) (estate ?name) (weight ?w)
      (certainty (calculate-cf-range ?min-range ?max-range "gt" ?elevator (boolean-conversion ?e) ?w))
    ))
)

(defrule APARTMENT::calculate-cf-balcony
  (question (attribute balcony) (valid-answers ?min-range ?max-range))
  (immobile (name ?name)(balcony ?b))
  (attribute (name balcony) (value ?balcony))
  (weights-immobile (balcony ?w))
  =>
  (assert (attribute (name balcony_) (value ?b) (estate ?name) (weight ?w)
    (certainty (calculate-cf-range ?min-range ?max-range "gt" ?balcony ?b ?w))
  ))
  )

(defrule APARTMENT::calculate-cf-box-auto
  (question (attribute box-auto) (valid-answers ?min-range ?max-range))
  (immobile (name ?name)(box-auto ?b))
  (attribute (name box-auto) (value ?box-auto))
  (weights-immobile (box-auto ?w))
  =>
  (assert (attribute (name box-auto_) (value ?b) (estate ?name) (weight ?w)
     (certainty (calculate-cf-range ?min-range ?max-range "gt" ?box-auto ?b ?w))
  ))
  )

  (defrule APARTMENT::calculate-cf-square-meters
      (question (attribute square-meters) (valid-answers ?min-range ?max-range))
      (immobile (name ?name)(square-meters ?sm))
      (attribute (name square-meters) (value ?sqr))
      (weights-immobile (square-meters ?w))
      =>
      (assert (attribute (name square-meters_) (value ?sm) (estate ?name) (weight ?w)
                     (certainty (calculate-cf-range ?min-range ?max-range "gt" ?sqr ?sm ?w))
                     ))
  )

  (defrule APARTMENT::calculate-cf-box-mq
      (question (attribute box-mq) (valid-answers ?min-range ?max-range))
      (immobile (name ?name)(box-mq ?mq))
      (attribute (name box-mq) (value ?boxmq))
      (weights-immobile (box-mq ?w))
      =>
      (assert (attribute (name box-mq_) (value ?mq) (estate ?name) (weight ?w)
                     (certainty (calculate-cf-range ?min-range ?max-range "gt" ?boxmq ?mq ?w))
                     ))
  )

  (defrule APARTMENT::calculate-cf-backyard
      (question (attribute backyard) (valid-answers ?min-range ?max-range))
      (immobile (name ?name)(backyard ?b))
      (attribute (name square-meters-preferred) (value ?backyard))
      (weights-immobile (backyard ?w))
      =>
      (assert (attribute (name backyard_) (value ?b) (estate ?name) (weight ?w)
                     (certainty (calculate-cf-range ?min-range ?max-range "gt" ?backyard ?b ?w))
                     ))
  )

  (defrule APARTMENT::calculate-cf-city
      (question (attribute city))
      (immobile (name ?name)(city ?c))
      (attribute (name city) (value ?city))
      (weights-immobile (city ?w))
      =>
      (assert (attribute (name city_) (value ?c) (estate ?name) (weight ?w)
                     (certainty (calculate-cf-no-range ?city ?c ?w))
                     ))
    )

    (defrule APARTMENT::calculate-cf-region
      (question (attribute preferred-region))
      (immobile (name ?name)(city ?city))
      (city (name ?city) (region ?r))
      (attribute (name region) (value ?region))
      (weights-immobile (region ?w))
      =>
      (assert (attribute (name region_) (value ?r) (estate ?name) (weight ?w)
                     (certainty (calculate-cf-no-range ?region ?r ?w))
                     ))
    )

    (defrule APARTMENT::calculate-cf-type-property
      (question (attribute type-property))
      (immobile (name ?name)(type ?t))
      (attribute (name type-property) (value ?type))
      (weights-immobile (type ?w))
      =>
      (assert (attribute (name type-property_) (value ?t) (estate ?name) (weight ?w) 
                     (certainty (calculate-cf-no-range ?type ?t ?w))
                     ))
    )

    (defrule APARTMENT::calculate-cf-floor-of-house
      (question (attribute floor-of-house))
      (immobile (name ?name)(floor ?f))
      (attribute (name floor-of-house) (value ?floor))
      (weights-immobile (floor ?w))
      =>
      (assert (attribute (name floor-of-house_) (value ?f) (estate ?name) (weight ?w)
                     (certainty (calculate-cf-no-range ?floor ?f ?w))
                     ))
    )
    
    (defrule APARTMENT::calculate-cf-state-of-house
      (question (attribute state-of-house))
      (immobile (name ?name)(state ?s))
      (attribute (name state-of-house) (value ?state))
      (weights-immobile (state ?w) )
      =>
      (assert (attribute (name state-of-house_) (value ?s) (estate ?name) (weight ?w)
                     (certainty (calculate-cf-no-range ?state ?s ?w))
                     ))
    )

  (defrule APARTMENT::calculate-cf-district
    (question (attribute district))
    (immobile (name ?name)(city ?city))
    (district (name ?d) (city ?city))
    (attribute (name district) (value ?district))
    (weights-immobile (district ?w))
    =>
    (assert (attribute (name district_) (value ?d) (estate ?name) (weight ?w)
                      (certainty (calculate-cf-no-range ?district ?d ?w))
    ))
  )

;  (defrule APARTMENT::calculate-cf-country-place
;    (question (attribute country-place))
;    (immobile (name ?name)(city ?city))
;    (city (name ?city) (region ?region))
;    (region (name ?region) (place ?p))
;    (attribute (name country-place) (value ?place))
;    (weights-immobile (country-place ?w))
;    =>
;    (assert (attribute (name country-place_) (value ?p) (estate ?name) (weight ?w)
;                   (certainty (calculate-cf-no-range ?place ?p ?w))
;    ))
;  )

  (defrule APARTMENT::calculate-cf-have-children
    (question (attribute have-children))
    (attribute (name have-children) (value Si))
    (immobile (name ?name)(city ?city) (district ?d))
    (district (name ?d) (city ?city) (school ?sc) (park ?pa))
    (weights-children (school ?w_school) (park ?w_park))
    =>
    (assert (attribute (name school_) (value ?sc) (estate ?name) (weight ?w_school)
                      (certainty (calculate-cf-range No Si "gt" Si ?sc ?w_school))
    ))
    (assert (attribute (name park_) (value ?pa) (estate ?name) (weight ?w_park)
                      (certainty (calculate-cf-range No Si "gt" Si ?pa ?w_park))
    ))
  )

    (defrule APARTMENT::calculate-cf-is-sporty
    (question (attribute is-sporty))
    (attribute (name is-sporty) (value Si))
    (immobile (name ?name)(city ?city) (district ?d))
    (district (name ?d) (city ?city) (gym ?gym) (park ?pa))
    (weights-sporty (gym ?w_gym) (park ?w_park))
    =>
    (assert (attribute (name gym_) (value ?gym) (estate ?name) (weight ?w_gym)
                      (certainty (calculate-cf-range No Si "gt" Si ?gym ?w_gym))
    ))
    (assert (attribute (name park_) (value ?pa) (estate ?name) (weight ?w_park)
                      (certainty (calculate-cf-range No Si "gt" Si ?pa ?w_park))
    ))
  )

  (defrule APARTMENT::calculate-cf-is-old
    (question (attribute is-old))
    (attribute (name is-old) (value Si))
    (immobile (name ?name)(city ?city) (district ?d))
    (district (name ?d) (city ?city) (hospital ?h) (supermarket ?sm) (park ?pa))
    (weights-old (hospital ?w_hospital) (supermarket ?w_market) (park ?w_park))
    =>
    (assert (attribute (name hospital_) (value ?h) (estate ?name) (weight ?w_hospital)
                      (certainty (calculate-cf-range No Si "gt" Si ?h ?w_hospital))
    ))
    (assert (attribute (name supermarket_) (value ?sm) (estate ?name) (weight ?w_market)
                      (certainty (calculate-cf-range No Si "gt" Si ?sm ?w_market))
    ))
    (assert (attribute (name park_) (value ?pa) (estate ?name) (weight ?w_park)
                      (certainty (calculate-cf-range No Si "gt" Si ?pa ?w_park))
    ))
  )

(defrule APARTMENT::calculate-cf-got-car
    (question (attribute got-car))
    (attribute (name got-car) (value No))
    (immobile (name ?name)(city ?city) (district ?d))
    (district (name ?d) (city ?city) (transports ?t) (supermarket ?sm) (station ?s))
    (weights-car (transports ?w_transports) (supermarket ?w_market) (station ?w_station))
    =>
    (assert (attribute (name transports_) (value ?t) (estate ?name) (weight ?w_transports)
                      (certainty (calculate-cf-range No Si "gt" Si ?t ?w_transports))
    ))
    (assert (attribute (name supermarket_) (value ?sm) (estate ?name) (weight ?w_market)
                      (certainty (calculate-cf-range No Si "gt" Si ?sm ?w_market))
    ))
    (assert (attribute (name station_) (value ?s) (estate ?name) (weight ?w_station)
                      (certainty (calculate-cf-range No Si "gt" Si ?s ?w_station))
    ))
)

(defrule APARTMENT::calculate-cf-got-car-2
  (question (attribute got-car))
  (attribute (name got-car) (value Si))
  (immobile (name ?name)(box-auto ?b))
  (weights-car (box-auto ?w))
  =>
  (assert (attribute (name box-auto_) (value ?b) (estate ?name) (weight ?w)
     (certainty (calculate-cf-range No Si "gt" Si ?b ?w))
  ))
  )



(defmodule MODIFY-RESEARCH (import MAIN ?ALL) (import APARTMENT ?ALL))

(defrule MODIFY-RESEARCH::ask-update
 ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute change-answer)
                   (valid-answers $?valid-answers)
                   (range ?range)
        )
   => 
        (modify ?f (already-asked TRUE))
        (bind ?input (ask-question ?the-question ?valid-answers ?range))
        (if (eq ?input Prezzo) then
            (assert (attribute (name change-answer) (value budget)))
          else (if (eq ?input Stato) then 
                  (assert (attribute (name change-answer) (value state-of-house)))
                else (if (eq ?input Tipologia) then 
                    (assert (attribute (name change-answer) (value type-property))))))
)

(defrule MODIFY-RESEARCH::update-answer
  (attribute (name change-answer) (value ?value))
  ?question <- (question (attribute ?value))
  =>
  (modify ?question (already-asked FALSE))
)

(defrule MODIFY-RESEARCH::update-remove-old-attribute
  (attribute (name change-answer) (value ?value))
  ?attribute <- (attribute (name ?value))
  =>
  (retract ?attribute)
)

(defrule MODIFY-RESEARCH::update-remove-old-soft-hard
  (attribute (name change-answer) (value ?value))
  ?soft-hard <- (soft-hard (name ?value))
  =>
  (retract ?soft-hard)
)


(defrule MODIFY-RESEARCH::update-remove-old-cf 
  ?fact <- (attribute (name ?name))
  =>
  (if (or (or (eq ?name weight_sum) (eq ?name weighted_average)) (eq ?name count)) then (retract ?fact))
)


;;*********************
;;* REMOVE OLD FACTS *
;;*********************

(defmodule REMOVE-OLD-FACTS (import MAIN ?ALL))

(defrule REMOVE-OLD-FACTS::remove-hard-budget
   (soft-hard (name budget) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (price ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-type-property
   (soft-hard (name type-property) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (type ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-square-meters
   (soft-hard (name square-meters) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (square-meters ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-state-of-house
   (soft-hard (name state-of-house) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (state ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-floor-of-house
   (soft-hard (name floor-of-house) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (floor ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-num-rooms
   (soft-hard (name num-rooms) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (num-of-rooms ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-elevator
   (soft-hard (name elevator) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (elevator ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-balcony
   (declare (salience 20))
   (soft-hard (name balcony) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (balcony ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-box-auto
   (soft-hard (name box-auto) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (box-auto ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-box-mq
   (soft-hard (name box-mq) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (box-mq ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-backyard
   (soft-hard (name backyard) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (backyard ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-energy-class
   (soft-hard (name energy-class) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (energy-class ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

(defrule REMOVE-OLD-FACTS::remove-hard-city
   (soft-hard (name city) (value ?value) (is-hard Si))
   ?f <- (attribute (name weighted_average) (estate ?estate))
   (immobile (name ?estate) (city ?value_2))
   (test (neq ?value ?value_2))
   =>
   (retract ?f)
)

  ;;*****************************
  ;;* PRINT SELECTED APARTMENT *
  ;;*****************************
(defmodule PRINT-RESULTS (import MAIN ?ALL))

   (defrule PRINT-RESULTS::refresh
    (declare (salience 100))
    (attribute (name change-answer))
    =>
    (refresh PRINT-RESULTS::header)
    (refresh PRINT-RESULTS::print-results)
    
    ;(refresh calculate-cf-country-place)
  )

(defrule PRINT-RESULTS::header
   (declare (salience 20))
   =>
  (printout t crlf crlf(uniform-len-string "Immobile" 42) "  ")
  (printout t (uniform-len-string "Prezzo(Euro)" 12) "  ")
  (printout t (uniform-len-string "Tipologia" 10) "  ")
  (printout t (uniform-len-string "Citta'" 15) "  ")
  (printout t (uniform-len-string "Stato" 15) "  ")
  (printout t (uniform-len-string "mq" 4) "  ")
  (printout t (uniform-len-string "CF" 6) crlf)

   (assert (attribute (name max_cf) (value 0)))
   (assert (attribute (name count) (value 1)))
)



(defrule PRINT-RESULTS::find-max-cf
  (declare (salience 10))
  (attribute (name weighted_average) (estate ?estate) (value ?cf))
  ?max <- (attribute (name max_cf) (value ?max_cf))
  =>
  (if (> ?cf ?max_cf) then (modify ?max (value ?cf) (estate ?estate)))
)

(defrule PRINT-RESULTS::print-results
  (declare (salience 5))
  (immobile (name ?name) (price ?price) (type ?type) (city ?city) (state ?state) (square-meters ?mq))
  ?max <- (attribute (name max_cf) (estate ?name) (value ?cf))
  ?rem <- (attribute (name weighted_average) (estate ?name))
  ?count <- (attribute (name count) (value ?counted_val))
  =>
  (printout t (uniform-len-string (str-cat ?name) 42) "  ")
  (printout t (uniform-len-string (str-cat ?price) 12) "  ")
  (printout t (uniform-len-string (str-cat ?type) 10) "  ")
  (printout t (uniform-len-string (str-cat ?city) 15) "  ")
  (printout t (uniform-len-string (str-cat ?state) 15) "  ")
  (printout t (uniform-len-string (str-cat ?mq) 4) "  ")
  (printout t (uniform-len-string (str-cat (round ?cf)) 6) crlf)

  (if (< ?counted_val 5) then 
    (retract ?rem)
    (modify ?max (value 0))
    (refresh find-max-cf)
    (modify ?count (value (+ ?counted_val 1)))
  )
)

(defrule PRINT-RESULTS::print-no-results
  (declare (salience 1))
  (attribute (name count) (value 1))
  =>
  (printout t  "<Non e' stato trovato alcun risultato con le caratteristiche obbligatorie richieste>" crlf)
)
                                                                        


