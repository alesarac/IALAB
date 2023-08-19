;DATABASE

;;;;;;;;;;; DEF-TEMPLATE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate immobile
  (slot name (type STRING))
  (slot type (type SYMBOL) (allowed-symbols Alloggio Attico Villa))
  (slot square-meters (type INTEGER))
  (slot state (type SYMBOL) (allowed-symbols Nuovo Ristrutturato Ristrutturare))
  (slot num-of-rooms (type INTEGER))
  (slot floor (type SYMBOL) (allowed-symbols Terra Intermedio Ultimo))
  (slot city (type SYMBOL))
  (slot district (type SYMBOL)) ;quartiere
  (slot elevator (type SYMBOL) (allowed-values Si No))
  (slot box-auto (type SYMBOL) (allowed-values Si No))
  (slot box-mq (type INTEGER))
  (slot balcony (type SYMBOL) (allowed-values Si No))
  (slot backyard (type SYMBOL) (allowed-values Si No))
  (slot price (type INTEGER))
  (slot energy-class (type INTEGER) (allowed-values 1 2 3)))

(deftemplate weights-immobile
  (slot type (type INTEGER) (range  1 10))
  (slot square-meters (type INTEGER) (range  1 10))
  (slot state (type INTEGER) (range  1 10))
  (slot num-of-rooms (type INTEGER) (range  1 10))
  (slot floor (type INTEGER) (range  1 10))
  (slot city (type INTEGER) (range  1 10))
  (slot elevator (type INTEGER) (range  1 10))
  (slot box-auto (type INTEGER) (range  1 10))
  (slot box-mq (type INTEGER) (range  1 10))
  (slot terrace (type INTEGER) (range  1 10))
  (slot balcony (type INTEGER) (range  1 10))
  (slot furnished (type INTEGER) (range  1 10))
  (slot cellar (type INTEGER) (range  1 10))
  (slot pool (type INTEGER) (range  1 10))
  (slot heating-system (type INTEGER) (range  1 10))
  (slot backyard (type INTEGER) (range  1 10))
  (slot price (type INTEGER) (range  1 10))
  (slot energy-class (type INTEGER) (range  1 10))
  (slot region (type INTEGER) (range  1 10))
  (slot district (type INTEGER) (range  1 10))
)

(deftemplate weights-children
  (slot school (type INTEGER) (range  1 10))
  (slot park (type INTEGER) (range  1 10))
)

(deftemplate weights-sporty
  (slot gym (type INTEGER) (range  1 10))
  (slot park (type INTEGER) (range  1 10))
)

(deftemplate weights-old
  (slot hospital (type INTEGER) (range  1 10))
  (slot supermarket (type INTEGER) (range  1 10))
  (slot park (type INTEGER) (range  1 10))
)

(deftemplate weights-car
  (slot transports (type INTEGER) (range  1 10))
  (slot supermarket (type INTEGER) (range  1 10))
  (slot station (type INTEGER) (range  1 10))
  (slot box-auto (type INTEGER) (range  1 10))
)

(deftemplate region
  (slot name (type SYMBOL))
  (multislot cities (type SYMBOL)))


(deftemplate city
  (slot name (type SYMBOL))
  (slot region (type SYMBOL)))


(deftemplate district
  (slot name (type SYMBOL))
  (slot city (type SYMBOL))
  (slot transports  (type SYMBOL) (allowed-values Si No))
  (slot station  (type SYMBOL) (allowed-values Si No))
  (slot gym  (type SYMBOL) (allowed-values Si No))
  (slot supermarket  (type SYMBOL) (allowed-values Si No))
  (slot school  (type SYMBOL) (allowed-values Si No))
  (slot park  (type SYMBOL) (allowed-values Si No))
  (slot hospital  (type SYMBOL) (allowed-values Si No))
)

(deftemplate question
  (slot attribute (default ?NONE))
  (slot the-question (default ?NONE))
  (multislot valid-answers (default ?NONE))
  (slot already-asked (default FALSE))
  (multislot precursors (default ?DERIVE))
  (slot range (allowed-values FALSE TRUE) (default FALSE))
  (slot profiling (allowed-values FALSE TRUE) (default FALSE)))


(deftemplate attribute
   (slot name)
   (slot estate)
   (slot weight (default 100.0))
   (multislot value)
   (slot certainty (default -1)))

(deftemplate soft-hard
   (slot name)
   (slot value)
   (slot is-hard))

;;;;;;;;;;; DEF-FACTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;25 Alloggi
;10 ville
;15 attici


(deffacts definition-of-immobili
  (immobile (name "Alloggio da 3 stanze") (type Alloggio) (square-meters 70) (state Nuovo) (num-of-rooms 3) (floor Intermedio) (city Roma) (district Trastevere) (elevator Si) (box-auto Si) (box-mq 10) (balcony Si) (backyard No) (price 230000) (energy-class 1))
  (immobile (name "Alloggio da 2 stanza") (type Alloggio) (square-meters 40) (state Ristrutturato) (num-of-rooms 2) (floor Terra) (city Roma) (district Garbatella) (elevator Si) (box-auto No) (box-mq 0) (balcony No) (backyard No) (price 45000) (energy-class 2))
  (immobile (name "Alloggio da 2 stanze 2") (type Alloggio) (square-meters 55) (state Ristrutturare) (num-of-rooms 2) (floor Ultimo) (city Torino) (district Lingotto) (elevator Si) (box-auto Si) (box-mq 15) (balcony No) (backyard No) (price 55000) (energy-class 3))
  (immobile (name "Alloggio da 4 stanze") (type Alloggio) (square-meters 95) (state Nuovo) (num-of-rooms 4) (floor Terra) (city Torino) (district Lingotto) (elevator Si) (box-auto Si) (box-mq 12) (balcony Si) (backyard Si) (price 95000) (energy-class 2))
  (immobile (name "Alloggio da 5 stanze") (type Alloggio) (square-meters 110) (state Nuovo) (num-of-rooms 5) (floor Ultimo) (city Palermo) (district Roccella) (elevator Si) (box-auto No) (box-mq 0) (balcony Si) (backyard Si) (price 300000) (energy-class 2))
  (immobile (name "Alloggio Teras") (type Alloggio) (square-meters 65) (state Ristrutturare) (num-of-rooms 3) (floor Intermedio) (city Palermo) (district Settecannoli) (elevator Si) (box-auto Si) (box-mq 17) (balcony No) (backyard No) (price 75000) (energy-class 2))
  (immobile (name "Alloggio in via Roma") (type Alloggio) (square-meters 45) (state Ristrutturato) (num-of-rooms 2) (floor Intermedio) (city Palermo) (district Settecannoli) (elevator Si) (box-auto Si) (box-mq 13) (balcony Si) (backyard No) (price 69000) (energy-class 2))
  (immobile (name "Alloggio in corso Dante") (type Alloggio) (square-meters 57) (state Ristrutturato) (num-of-rooms 3) (floor Ultimo) (city Roma) (district Garbatella) (elevator Si) (box-auto No) (box-mq 0) (balcony Si) (backyard No) (price 87000) (energy-class 2))
  (immobile (name "Alloggio da ristrutturare") (type Alloggio) (square-meters 62) (state Ristrutturare) (num-of-rooms 3) (floor Intermedio) (city Roma) (district Trastevere) (elevator No) (box-auto No) (box-mq 0) (balcony Si) (backyard No) (price 97000) (energy-class 3))
  (immobile (name "Alloggio nuovo") (type Alloggio) (square-meters 85) (state Nuovo) (num-of-rooms 4) (floor Intermedio) (city Novara) (district Porta_Mortara) (elevator Si) (box-auto Si) (box-mq 10) (balcony Si) (backyard Si) (price 130000) (energy-class 1))
  (immobile (name "Alloggio con giardino privato") (type Alloggio) (square-meters 59) (state Ristrutturare) (num-of-rooms 2) (floor Intermedio) (city Torino) (district Cenisia) (elevator Si) (box-auto No) (box-mq 0) (balcony Si) (backyard Si) (price 68000) (energy-class 2))
  (immobile (name "Alloggio ristrutturato") (type Alloggio) (square-meters 75) (state Ristrutturato) (num-of-rooms 3) (floor Ultimo) (city Torino) (district Lingotto) (elevator Si) (box-auto Si) (box-mq 15) (balcony Si) (backyard No) (price 99000) (energy-class 1))
  (immobile (name "Alloggio in via Spoleto") (type Alloggio) (square-meters 90) (state Nuovo) (num-of-rooms 4) (floor Intermedio) (city Catania) (district Librino) (elevator Si) (box-auto Si) (box-mq 17) (balcony Si) (backyard No) (price 125000) (energy-class 2))
  (immobile (name "Alloggio con vista mare") (type Alloggio) (square-meters 60) (state Ristrutturato) (num-of-rooms 3) (floor Intermedio) (city Catania) (district Ognina) (elevator Si) (box-auto Si) (box-mq 12) (balcony Si) (backyard Si) (price 178000) (energy-class 2))
  (immobile (name "Alloggio nuovo 1") (type Alloggio) (square-meters 95) (state Nuovo) (num-of-rooms 4) (floor Terra) (city Catania) (district Ognina) (elevator Si) (box-auto Si) (box-mq 20) (balcony Si) (backyard Si) (price 213000) (energy-class 1))
  (immobile (name "Alloggio vacanze") (type Alloggio) (square-meters 74) (state Nuovo) (num-of-rooms 3) (floor Intermedio) (city Palermo) (district Roccella) (elevator Si) (box-auto No) (box-mq 0) (balcony Si) (backyard No) (price 124000) (energy-class 2))
  (immobile (name "Alloggio vista lago") (type Alloggio) (square-meters 50) (state Nuovo) (num-of-rooms 2) (floor Terra) (city Civitavecchia) (district Mediana) (elevator Si) (box-auto Si) (box-mq 10) (balcony Si) (backyard No) (price 110000) (energy-class 1))
  (immobile (name "Alloggio in via Giarino") (type Alloggio) (square-meters 40) (state Ristrutturato) (num-of-rooms 2) (floor Intermedio) (city Catania) (district Librino) (elevator Si) (box-auto No) (box-mq 0) (balcony No) (backyard No) (price 68000) (energy-class 2))
  (immobile (name "Alloggio in piazza del Duomo") (type Alloggio) (square-meters 45) (state Ristrutturare) (num-of-rooms 2) (floor Ultimo) (city Torino) (district Cenisia) (elevator No) (box-auto Si) (box-mq 13) (balcony No) (backyard No) (price 74000) (energy-class 2))
  (immobile (name "Alloggio nuovo 2") (type Alloggio) (square-meters 100) (state Nuovo) (num-of-rooms 4) (floor Intermedio) (city Civitavecchia) (district Orsini) (elevator Si) (box-auto Si) (box-mq 19) (balcony Si) (backyard Si) (price 115000) (energy-class 1))
  (immobile (name "Alloggio con giardino privato 1") (type Alloggio) (square-meters 105) (state Nuovo) (num-of-rooms 4) (floor Ultimo) (city Roma) (district Trastevere) (elevator Si) (box-auto Si) (box-mq 20) (balcony Si) (backyard No) (price 207000) (energy-class 1))
  (immobile (name "Alloggio Tecnocasa") (type Alloggio) (square-meters 110) (state Ristrutturare) (num-of-rooms 4) (floor Terra) (city Civitavecchia) (district Orsini) (elevator No) (box-auto Si) (box-mq 15) (balcony Si) (backyard No) (price 209000) (energy-class 3))
  (immobile (name "Alloggio Tempocasa") (type Alloggio) (square-meters 55) (state Ristrutturato) (num-of-rooms 2) (floor Terra) (city Novara) (district San_Rocco) (elevator Si) (box-auto Si) (box-mq 10) (balcony No) (backyard No) (price 96000) (energy-class 2))
  (immobile (name "Alloggio con vista lago") (type Alloggio) (square-meters 68) (state Nuovo) (num-of-rooms 3) (floor Intermedio) (city Novara) (district Porta_Mortara) (elevator No) (box-auto No) (box-mq 0) (balcony No) (backyard Si) (price 87000) (energy-class 3))
  (immobile (name "Alloggio in corso Giulio Cesare") (type Alloggio) (square-meters 45) (state Nuovo) (num-of-rooms 2) (floor Intermedio) (city Novara) (district San_Rocco) (elevator Si) (box-auto No) (box-mq 0) (balcony Si) (backyard No) (price 51000) (energy-class 2))

  (immobile (name "Villa da 7 stanze") (type Villa) (square-meters 130) (state Ristrutturato) (num-of-rooms 7) (floor Terra) (city Torino) (district Lingotto) (elevator No) (box-auto No) (box-mq 0) (balcony Si) (backyard No) (price 450000) (energy-class 2))
  (immobile (name "Villa con giardino") (type Villa) (square-meters 135) (state Nuovo) (num-of-rooms 6) (floor Terra) (city Novara) (district San_Rocco) (elevator No) (box-auto Si) (box-mq 25) (balcony Si) (backyard Si) (price 370000) (energy-class 1))
  (immobile (name "Villa da 10 stanzze") (type Villa) (square-meters 200) (state Ristrutturare) (num-of-rooms 10) (floor Terra) (city Novara) (district Porta_Mortara) (elevator No) (box-auto Si) (box-mq 50) (balcony Si) (backyard No) (price 575000) (energy-class 3))
  (immobile (name "Villa da 8 stanze") (type Villa) (square-meters 160) (state Nuovo) (num-of-rooms 8) (floor Terra) (city Novara) (district Porta_Mortara) (elevator No) (box-auto Si) (box-mq 30) (balcony Si) (backyard No) (price 334000) (energy-class 1))
  (immobile (name "Villa con giardino numero 2") (type Villa) (square-meters 95) (state Nuovo) (num-of-rooms 5) (floor Terra) (city Civitavecchia) (district Orsini) (elevator No) (box-auto No) (box-mq 0) (balcony Si) (backyard No) (price 290000) (energy-class 1))
  (immobile (name "Villa unifamigliare") (type Villa) (square-meters 105) (state Nuovo) (num-of-rooms 5) (floor Terra) (city Civitavecchia) (district Orsini) (elevator No) (box-auto Si) (box-mq 35) (balcony Si) (backyard No) (price 314000) (energy-class 1))
  (immobile (name "Villa bifamigliare") (type Villa) (square-meters 400) (state Ristrutturare) (num-of-rooms 10) (floor Terra) (city Civitavecchia) (district Mediana) (elevator No) (box-auto Si) (box-mq 100) (balcony Si) (backyard No) (price 1000000) (energy-class 3))
  (immobile (name "Villa ristrutturata con giardino") (type Villa) (square-meters 350) (state Ristrutturato) (num-of-rooms 10) (floor Terra) (city Palermo) (district Settecannoli) (elevator No) (box-auto Si) (box-mq 85) (balcony Si) (backyard No) (price 850000) (energy-class 2))
  (immobile (name "Villa nuova con giardino") (type Villa) (square-meters 230) (state Nuovo) (num-of-rooms 9) (floor Terra) (city Catania) (district Librino) (elevator No) (box-auto Si) (box-mq 70) (balcony Si) (backyard No) (price 640000) (energy-class 2))
  (immobile (name "Villa unifamiliare da ristrutturare") (type Villa) (square-meters 175) (state Ristrutturare) (num-of-rooms 7) (floor Terra) (city Palermo) (district Roccella) (elevator No) (box-auto Si) (box-mq 45) (balcony No) (backyard No) (price 530000) (energy-class 3))

  (immobile (name "Attico in centro") (type Attico) (square-meters 40) (state Ristrutturato) (num-of-rooms 2) (floor Ultimo) (city Civitavecchia) (district Mediana) (elevator No) (box-auto No) (box-mq 0) (balcony No) (backyard No) (price 130000) (energy-class 2))
  (immobile (name "Attico con vista mare") (type Attico) (square-meters 45) (state Ristrutturare) (num-of-rooms 2) (floor Ultimo) (city Catania) (district Ognina) (elevator No) (box-auto No) (box-mq 0) (balcony No) (backyard No) (price 120000) (energy-class 3))
  (immobile (name "Attico in via Rosmini") (type Attico) (square-meters 55) (state Nuovo) (num-of-rooms 2) (floor Ultimo) (city Palermo) (district Settecannoli) (elevator No) (box-auto No) (box-mq 0) (backyard No) (price 115000) (energy-class 1))
  (immobile (name "Attico da risrtutturare") (type Attico) (square-meters 70) (state Ristrutturare) (num-of-rooms 3) (floor Ultimo) (city Novara) (district Porta_Mortara) (elevator No) (box-auto Si) (box-mq 10) (balcony Si) (backyard No) (price 170000) (energy-class 2))
  (immobile (name "Attico nuovo") (type Attico) (square-meters 65) (state Nuovo) (num-of-rooms 3) (floor Ultimo) (city Novara) (district San_Rocco) (elevator No) (box-auto Si) (box-mq 12) (balcony No) (backyard No) (price 230000) (energy-class 1))
  (immobile (name "Attico con giardino privato") (type Attico) (square-meters 60) (state Nuovo) (num-of-rooms 2) (floor Ultimo) (city Novara) (district Porta_Mortara) (elevator No) (box-auto No) (box-mq 0) (backyard No) (price 85000) (energy-class 2))
  (immobile (name "Attico in centro 1") (type Attico) (square-meters 48) (state Ristrutturato) (num-of-rooms 2) (floor Ultimo) (city Torino) (district Cenisia) (elevator No) (box-auto No) (box-mq 0) (backyard No) (price 65000) (energy-class 2))
  (immobile (name "Attico ristrutturato") (type Attico) (square-meters 42) (state Ristrutturato) (num-of-rooms 2) (floor Ultimo) (city Novara) (district Porta_Mortara) (elevator No) (box-auto No) (box-mq 0) (backyard No) (price 46000) (energy-class 1))
  (immobile (name "Attico in via spoleto") (type Attico) (square-meters 57) (state Ristrutturare) (num-of-rooms 2) (floor Ultimo) (city Novara) (district Porta_Mortara) (elevator No) (box-auto Si) (box-mq 14) (balcony No) (backyard No) (price 72000) (energy-class 3))
  (immobile (name "Attico in periferia") (type Attico) (square-meters 68) (state Nuovo) (num-of-rooms 2) (floor Ultimo) (city Novara) (district San_Rocco) (elevator No) (box-auto Si) (box-mq 13) (balcony Si) (backyard No) (price 68000) (energy-class 2))
  (immobile (name "Attico in piazza Massaua") (type Attico) (square-meters 43) (state Nuovo) (num-of-rooms 2) (floor Ultimo) (city Novara) (district San_Rocco) (elevator No) (box-auto No) (box-mq 0) (balcony No) (backyard No) (price 53000) (energy-class 2))
  (immobile (name "Attico da ristrutturare") (type Attico) (square-meters 54) (state Ristrutturare) (num-of-rooms 2) (floor Ultimo) (city Civitavecchia) (district Orsini) (elevator No) (box-auto No) (box-mq 0) (balcony No) (backyard No) (price 76000) (energy-class 3))
  (immobile (name "Attico in centro 2") (type Attico) (square-meters 63) (state Nuovo) (num-of-rooms 3) (floor Ultimo) (city Roma) (district Garbatella) (elevator No) (box-auto Si) (box-mq 10) (balcony No) (backyard No) (price 69000) (energy-class 1))
  (immobile (name "Attico con vista mare 1") (type Attico) (square-meters 51) (state Nuovo) (num-of-rooms 2) (floor Ultimo) (city Palermo) (district Roccella) (elevator No) (box-auto Si) (box-mq 11) (balcony No) (backyard No) (price 62000) (energy-class 2))
  (immobile (name "Attico in via Aldo Moro") (type Attico) (square-meters 49) (state Nuovo) (num-of-rooms 2) (floor Ultimo) (city Catania) (district Librino) (elevator No) (box-auto No) (box-mq 0) (balcony No) (backyard No) (price 530000) (energy-class 2))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deffacts definition-of-regions
  ;1 del Nord
  (region (name Piemonte) (cities Novara Torino))
  ;1 del Centro
  (region (name Lazio) (cities Roma Civitavecchia))
  ;1 del Sud
  (region (name Sicilia) (cities Palermo Catania)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts definition-of-cities

  (city (name Novara)
    (region Piemonte))

  (city (name Torino)
    (region Piemonte))

  (city (name Roma)
    (region Lazio))

  (city (name Civitavecchia)
    (region Lazio))

  (city (name Roma)
    (region Lazio))

  (city (name Civitavecchia)
    (region Lazio))

  (city (name Palermo)
    (region Sicilia))

  (city (name Catania)
    (region Sicilia))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts definition-of-districts

  (district
    (name Lingotto)
	  (city Torino)
    (transports Si)
    (station No)
    (gym No)
    (supermarket Si)
    (school No)
    (park Si)
    (hospital Si)
  )

  (district
    (name Cenisia)
    (city Torino)
    (transports Si)
    (station Si)
    (gym Si)
    (supermarket Si)
    (school Si)
    (park No)
    (hospital No)
  )

  (district
    (name San_Rocco)
    (city Novara)
    (transports No)
    (station Si)
    (gym No)
    (supermarket Si)
    (school No)
    (park Si)
    (hospital Si)
  )

  (district
    (name Porta_Mortara)
	  (city Novara)
    (transports Si)
    (station No)
    (gym Si)
    (supermarket Si)
    (school Si)
    (park No)
    (hospital No)
  )

  (district
    (name Garbatella)
    (city Roma)
    (transports Si)
    (station No)
    (gym No)
    (supermarket Si)
    (school No)
    (park Si)
    (hospital Si)
  )

  (district
    (name Trastevere)
    (city Roma)
    (transports Si)
    (station Si)
    (gym Si)
    (supermarket No)
    (school No)
    (park No)
    (hospital No)
  )

  (district
    (name Orsini)
	  (city Civitavecchia)
    (transports No)
    (station No)
    (gym No)
    (supermarket Si)
    (school Si)
    (park Si)
    (hospital Si)
  )

  (district
    (name Mediana)
    (city Civitavecchia)
    (transports Si)
    (station Si)
    (gym Si)
    (supermarket Si)
    (school No)
    (park No)
    (hospital No)
  )

  (district
    (name Settecannoli)
    (city Palermo)
    (transports Si)
    (station No)
    (gym Si)
    (supermarket No)
    (school No)
    (park Si)
    (hospital No)
  )

  (district
    (name Roccella)
    (city Palermo)
    (transports Si)
    (station Si)
    (gym No)
    (supermarket Si)
    (school Si)
    (park No)
    (hospital No)
  )

  (district
    (name Ognina)
    (city Catania)
    (transports Si)
    (station Si)
    (gym No)
    (supermarket Si)
    (school No)
    (park No)
    (hospital Si)
  )

  (district
    (name Librino)
    (city Catania)
    (transports No)
    (station Si)
    (gym No)
    (supermarket No)
    (school No)
    (park Si)
    (hospital No)
  )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts weights-immobile
(weights-immobile
  (type 9)
  (square-meters 10)
  (state 8)
  (num-of-rooms 7)
  (floor 3)
  (city 6)
  (elevator 3)
  (box-auto 3)
  (box-mq 2)
  (terrace 2)
  (balcony 3)
  (furnished 3)
  (cellar 2)
  (pool 1)
  (heating-system 3)
  (backyard 2)
  (price 9)
  (energy-class 5)
  (region 8)
  (district 5))
)


(deffacts weights-children
  (weights-children
    (school 5)
    (park 3)
  )
)

(deffacts weights-sporty
  (weights-sporty
    (gym 4)
    (park 4)
  )
)

(deffacts weights-old
  (weights-old
    (hospital 7)
    (supermarket 5)
    (park 3)
  )
)

(deffacts weights-car
  (weights-car
    (transports 7)
    (supermarket 2)
    (station 4)
    (box-auto 3)
  )
)

(deffacts question-attribute

  (question   (attribute budget)
              (the-question "%nQuanto vuoi spendere?%n[30000,...,1000000]: ")
              (valid-answers 30000 1000000)
              (range TRUE))

  (question   (attribute type-property)
              (the-question "%nChe tipo di immobile cerchi?%n[Alloggio,Attico,Villa,Indifferente]: ")
              (valid-answers Alloggio Attico Villa Indifferente))

  (question   (attribute square-meters)
              (the-question "%nDa quanti mq vuoi che sia la casa?%n[40,...,400]: ")
              (valid-answers 40 400)
              (range TRUE));

  (question   (attribute state-of-house)
              (the-question "%nChe tipo di immobile preferisci?%n[Nuovo,Ristrutturato,Ristrutturare,Indifferente]: ")
              (valid-answers Nuovo Ristrutturato Ristrutturare Indifferente))

  (question   (attribute floor-of-house)
              (the-question "%nIn quale piano preferisci vivere?%n[Terra,Intermedio,Ultimo,Indifferente]: ")
              (valid-answers Terra Intermedio Ultimo Indifferente))

  (question   (attribute num-rooms)
              (the-question "%nDi quante stanze vuoi che sia la casa?%n[2,...,10]: ")
              (valid-answers 2 10)
              (range TRUE));

  (question   (attribute elevator)
              (the-question "%nE' necessaria la presenza di un ascensore?%n[Si,No]: ")
              (valid-answers No Si)
              );

  (question   (attribute balcony)
              (the-question "%nE' necessaria la presenza di un balcone?%n[Si,No]: ")
              (valid-answers No Si)
              );

  (question   (attribute backyard)
              (the-question "%nE' necessaria la presenza di un giardino?%n[Si,No]: ")
              (valid-answers No Si)
              )

  (question   (attribute energy-class)
              (the-question "%nClasse energetica della casa?%n (numerico)[(1->A),..,(7->G)]: ")
              (valid-answers 1 7)
              (range TRUE))

  (question   (attribute city)
              (the-question "%nIn quale citta' vuoi comprare casa?%n[Novara, Torino, Roma, Civitavecchia, Palermo, Catania, Palermo, Indifferente]: ")
              (valid-answers Novara Torino Roma Civitavecchia Palermo Catania Palermo Indifferente))

   (question  (attribute change-answer)
              (the-question "%nQuale risposta desideri cambiare?%n[Prezzo, Stato, Tipologia, Nessuna]: ")
              (valid-answers Prezzo Stato Tipologia Nessuna))

    (question (attribute soft-hard)
              (the-question "%nIl valore inserito e' l'unico accettabile?%n[No, Si]: ")
              (valid-answers No Si))

    (question (attribute have-children)
              (the-question "%nHai dei bambini?%n[No, Si]: ")
              (valid-answers No Si)
              (profiling TRUE)
    )

    (question (attribute is-sporty)
              (the-question "%nSei uno sportivo?%n[No, Si]: ")
              (valid-answers No Si)
              (profiling TRUE))

    (question (attribute got-car)
              (the-question "%nHai l'auto?%n[No, Si]: ")
              (valid-answers No Si)
              (profiling TRUE))

    (question (attribute is-old)
              (the-question "%nHai piu' di 60 anni?%n[No, Si]: ")
              (valid-answers No Si)
              (profiling TRUE))

              ;Domande per profilare:
              ; Hai dei bambini? -si-> Scuola or Parco
              ; Sei uno sportivo/a? -si-> Parco or Palestra
              ; Hai l'auto? -no-> Trasporti or Supermercato or Stazione 
              ; Hai l'auto? -si-> box-auto
              ; Hai più di 60 anni? -si-> Ospedale or Supermercato or Parco
)
