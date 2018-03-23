(deftemplate mouse (slot color) (slot number) )
(deftemplate cat (slot state) (slot eaten_mice_no) (slot days_without_mice) )

(deffacts init-facts
  (mouse (color gray) (number 5))
  (mouse (color white) (number 3))
  (cat (state "hungry") (eaten_mice_no 0) (days_without_mice 0))
)

(defrule r1 "When cat is hungry, he wants to eat"
  ?fact-id <- (cat (state ?state))
  (test (eq ?state "hungry"))
  =>
  (modify ?fact-id (state "wants to eat"))
)

(defrule r2 "When cat wants to eat and there are mice, he eats"
(declare (salience 2))
  ?fact-id1 <- (cat (state "wants to eat") (eaten_mice_no ?eaten))
  ?fact-id2 <- (mouse (color ?color) (number ?number))
  (test (> ?number 0))
  =>
  (if (eq ?color white) then (printout t "py-py!" crlf)
                        else (printout t "pyyyyy" crlf))
  (modify ?fact-id2 (number (- ?number 1))  )

  (modify ?fact-id1 (eaten_mice_no (+ ?eaten 1)) )
  (printout t "meow" crlf)
)

(defrule r3 "after eating 5 mice, the cat becomes fat"
  (declare (salience 10))
  ?fact-id1 <- (cat (state "wants to eat") (eaten_mice_no ?eaten))
  (test (= ?eaten 5))

=>
  (modify ?fact-id1 (state "fat"))
)

(defrule r4 "When cat is fat, then wants to sleep"
  ?fact-id <- (cat (state ?state))
  (test (eq ?state "fat"))
  =>
  (modify ?fact-id (state "sleep"))
)

(defrule r5 "Fat cats after sleep become hungry and forget how many mice they ate"
(declare (salience 1))
  ?fact-id1 <- (cat (state ?state) (eaten_mice_no ?eaten))
  (test (eq ?state "sleep"))
  =>
  (modify ?fact-id1(state "hungry") (eaten_mice_no 0))
)

(defrule r6 "Hungry cats without mice are suffering"
(declare (salience 1))
?fact-id1 <- (cat (state "wants to eat") (days_without_mice ?days))
?fact-id2 <- (mouse (color ?color) (number ?number))
(test (= ?number 0))
(test (<= ?days 6))
=>
(modify ?fact-id1(days_without_mice (+ ?days 1)))
)

(defrule r7 "Hungry cats without mice are dying after 7 days"
?fact-id <- (cat (state "wants to eat") (days_without_mice ?days))
(test (= ?days 7))
=>
(modify ?fact-id(state "dead"))
)

(defrule r8 "Mice reproduce while the cat is sleeping"
(declare (salience 2))
  ?cat <- (cat (state ?state))
  ?mice <- (mouse (color ?color) (number ?number))
  (test (eq ?state "sleep"))
  (test (> ?number 1))
  (test(< ?number 6))
  =>
  (modify ?mice (number (+ (mod (random) 5) ?number)))
)
