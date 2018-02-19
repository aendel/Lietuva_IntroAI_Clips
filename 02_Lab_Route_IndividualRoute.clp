(deftemplate fragment  (slot from_street_name) (slot to_street_name))
(deftemplate car (slot location))
(deftemplate obstacles (slot location) (slot tlights) (slot cars)
                                      (slot pedestrians) (slot spec_service))

(deffacts my-fragments
  (fragment (from_street_name "Via Pacinotti,147") (to_street_name "Piazza S.Vito Martire,2"))
  (fragment (from_street_name "Piazza S.Vito Martire,2") (to_street_name "Via Principe di Piemonte,3"))
  (fragment (from_street_name "Via Principe di Piemonte,3") (to_street_name "Via Marsala,2"))
  (fragment (from_street_name "Via Marsala,2") (to_street_name "SP5i,1"))
  (fragment (from_street_name "SP5i,1") (to_street_name "Via Pitrè,6"))
  (fragment (from_street_name "Via Pitrè,6") (to_street_name "Via Palermo,142"))
  (fragment (from_street_name "Via Palermo,142") (to_street_name "Via Palermo,46"))
  (fragment (from_street_name "Via Palermo,46") (to_street_name "Via Pacinotti,228"))
)

(deffacts my-car
  (car(location nil))
)

(deffacts my-obstacles
  (obstacles (location "Via Pacinotti,147") (tlights 0) (cars 0) (pedestrians 1) (spec_service 0))
  (obstacles (location "Piazza S.Vito Martire,2") (tlights 1) (cars 0) (pedestrians 1) (spec_service 0))
  (obstacles (location "Via Principe di Piemonte,3") (tlights 0) (cars 1) (pedestrians 1) (spec_service 0))
  (obstacles (location "SP5i,1") (tlights 1) (cars 0) (pedestrians 0) (spec_service 1))
  (obstacles (location "Via Pitrè,6") (tlights 0) (cars 0) (pedestrians 1) (spec_service 0))
  (obstacles (location "Via Palermo,142") (tlights 1) (cars 1) (pedestrians 0) (spec_service 0))
  (obstacles (location "Via Palermo,46") (tlights 0) (cars 0) (pedestrians 0) (spec_service 0))
  (obstacles (location "Via Pacinotti,228") (tlights 0) (cars 0) (pedestrians 1) (spec_service 1))
)

(defrule Home "When your location is 'nil' you start from a location chosen by the user."
  ?p <- (car (location nil))
  =>
  (printout t "Where do you want to go?" crlf)
  (bind ?response (read))
  (modify ?p (location ?response))
)

(defrule Step "GO until the end"
  ?car <- (car (location ?location))
  ?to <- (fragment (from_street_name ?location) (to_street_name ?unknown))
  =>
  (printout t "There is no obstacles in the street, you can go." crlf)
  (modify ?car (location ?unknown))
)

(defrule Check-Tlights "Check traffic light before go"
  (declare (salience 100))
  ?car <- (car (location ?location))
  ?street <- (obstacles (location ?location) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?spec_service))
  (test (> ?tlights 0))
   =>
   (printout t "Traffic light are not green, you must wait." crlf)
   (modify ?street(tlights 0))
)

(defrule Check-Cars "Check for other cars in the street"
  (declare (salience 100))
  ?car <- (car (location ?location))
  ?street <- (obstacles (location ?location) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?spec_service))
(test (> ?cars 0))
  =>
(printout t "There are other cars in the street. Wait for them." crlf)
(modify ?street(cars 0))
)

(defrule Check-Pedestrians "Check pedestrians in the street"
  (declare (salience 100))
  ?car <- (car (location ?location))
  ?street <- (obstacles (location ?location) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?spec_service))
(test (> ?pedestrians 0))
  =>
(printout t "There is at least one pedestrian in the street. Wait for them." crlf)
(modify ?street(pedestrians 0))
)

(defrule Check-Spec_service "Check for special services in the street"
  (declare (salience 100))
  ?car <- (car (location ?location))
  ?street <- (obstacles (location ?location) (tlights ?tlights) (cars ?cars) (pedestrians ?pedestrians) (spec_service ?spec_service))
(test (> ?spec_service 0))
  =>
(printout t "There are some special services in the street. Wait for them." crlf)
(modify ?street(spec_service 0))
)
