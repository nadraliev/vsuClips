(deftemplate event
(slot name (type STRING))
(slot ticketsNumber (type INTEGER))
(slot ticketPrice (type FLOAT))
)

(deftemplate request
(slot eventName (type STRING))
(slot ticketsNumber (type INTEGER))
(slot moneyGiven (type FLOAT))
)

;; Ask user to enter request parameters (or quit to ... quit)
(deffunction inputRequest ()
(printout t "Please enter event name, number of tickers and amount of money you are giving (enter after every parameter)" crlf)
(printout t "Or type quit to exit" crlf)
(bind ?inputFirst (read))
(if (= (str-compare ?inputFirst quit) 0)
then
(halt)
else
(assert (request (eventName ?inputFirst) (ticketsNumber (read)) (moneyGiven (read))))
))

;; Executed after every rule. Clear all requests and user for a new one.
(deffunction endCycle ()
(do-for-all-facts ((?f request)) TRUE (retract ?f))
(inputRequest)
)

;; Ask user for a request at the start
(defrule start
(initial-fact)
=>
(inputRequest)
)

;; Not enough tickets rule
(defrule ticketsShortage
(request (eventName ?name) (ticketsNumber ?ticketsRequested))
(event (name ?name) (ticketsNumber ?ticketsInStore))
(test (< ?ticketsInStore ?ticketsRequested))
=>
(printout t "There are not enough tickets for event: " ?name ". Tickets left: " ?ticketsInStore crlf)
(endCycle)
)

;; Not enough money rule
(defrule notEnoughMoney
(request (eventName ?name) (ticketsNumber ?ticketsRequested) (moneyGiven ?moneyGiven))
(event (name ?name) (ticketsNumber ?ticketsInStore) (ticketPrice ?ticketPrice))
(test (>= ?ticketsInStore ?ticketsRequested))
(test (< ?moneyGiven (* ?ticketsRequested ?ticketPrice)))
=>
(printout t "You gave not enough money. Needed: " (* ?ticketsRequested ?ticketPrice) crlf)
(endCycle)
)

;; No such event
(defrule noSuchEvent
(request (eventName ?name))
(not (event (name ?name)))
=>
(printout t "No such event" crlf)
(endCycle)
)

;; Everything is ok
(defrule ticketsBuy
(request (eventName ?name) (ticketsNumber ?ticketsRequested) (moneyGiven ?moneyGiven))
(event (name ?name) (ticketsNumber ?ticketsInStore) (ticketPrice ?ticketPrice))
(test (>= ?ticketsInStore ?ticketsRequested))
(test (>= ?moneyGiven (* ?ticketsRequested ?ticketPrice)))
?eventFact <- (event (name ?name) (ticketsNumber ?ticketsInStore) (ticketPrice ?ticketPrice))
?requestFact <- (request (eventName ?name) (ticketsNumber ?ticketsRequested) (moneyGiven ?moneyGiven))
=>
(printout t "Here are yout tickets. Thanks." crlf)
(modify ?eventFact (ticketsNumber (- ?ticketsInStore ?ticketsRequested)))
(retract ?requestFact)
(endCycle)
)

(deffacts events
(event (name "show") (ticketsNumber 100) (ticketPrice 10.0))
(event (name "festival") (ticketsNumber 2000) (ticketPrice 8.0))
(event (name "museum") (ticketsNumber 40) (ticketPrice 6.0))
(event (name "theatre") (ticketsNumber 200) (ticketPrice 7.0))
(event (name "movie") (ticketsNumber 100) (ticketPrice 4.0))
)
