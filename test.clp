(deftemplate sd
(slot name (type SYMBOL))
(slot place (type INTEGER)(default -1))
)

(defrule fd
(sd (name shit|notshit))
?X <- (sd (name shit|notshit))
=>
(printout t (fact-slot-value ?X name) crlf)
)

(deffunction invert (?value ?pos1 ?pos2)
(if (lexemep ?value) then
	(if (eq ?value ?pos1) then
		?pos2
	else
		?pos1
	)
else
	(if (= ?value ?pos1) then
		?pos2
	else 
		?pos1
	)
)
)
	