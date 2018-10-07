(deftemplate girl
(slot name (type SYMBOL))
(slot place (type INTEGER)(default -1))
)

(deftemplate statement
(slot firstGirlName (type SYMBOL))
(slot firstGirlPlace (type INTEGER))
(slot firstTrue (type INTEGER)(default -1))
(slot secondGirlName (type SYMBOL))
(slot secondGirlPlace (type INTEGER))
(slot secondTrue (type INTEGER)(default -1))
(slot processed (type INTEGER)(default 0))
) 

(deffacts content
(girl (name Alla))
(girl (name Nina))
(girl (name Vika))
(girl (name Rita))
(girl (name Sonya))
(statement (firstGirlName Alla) (firstGirlPlace 1) (firstTrue 0) (secondGirlName Rita) (secondGirlPlace 3) (secondTrue 1))
(statement (firstGirlName Vika) (firstGirlPlace 5) (secondGirlName Nina) (secondGirlPlace 1))
(statement (firstGirlName Sonya) (firstGirlPlace 1) (secondGirlName Vika) (secondGirlPlace 2))
(statement (firstGirlName Rita) (firstGirlPlace 5) (secondGirlName Nina) (secondGirlPlace 4))
(statement (firstGirlName Nina) (firstGirlPlace 4) (secondGirlName Alla) (secondGirlPlace 1))
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


(defrule firstPartTruthfullness
(statement (firstTrue ~-1) (secondTrue -1))
?statement <- (statement (firstTrue ~-1))
=>
(modify ?statement (secondTrue (invert (fact-slot-value ?statement firstTrue) 0 1)))
)

(defrule secondPartTruthfullness
(statement (secondTrue ~-1) (firstTrue -1))
?statement <- (statement (secondTrue ~-1))
=>
(modify ?statement (firstTrue (invert (fact-slot-value ?statement secondTrue) 0 1)))
)


(defrule neededDataFound
(girl (name ?firstName) (place 1))
(girl (name Alla) (place ~-1))
?alla <- (girl (name Alla))
=>
(printout t ?firstName " is in the first place. Alla's place is " (fact-slot-value ?alla place) crlf)
)

(defrule statementResolved
(statement (firstGirlName ?firstGirlName) (firstGirlPlace ?firstGirlPlace) (firstTrue ~-1) (secondGirlName ?secondGirlName) (secondGirlPlace ?secondGirlPlace) (secondTrue ~-1) (processed 0))
(girl (name ?firstGirlName) (place ?firstPlace))
(girl (name ?secondGirlName) (place ?secondPlace))
(test (or (= ?firstPlace -1) (= ?secondPlace -1)))
?girl1 <- (girl (name ?firstGirlName))
?girl2 <- (girl (name ?secondGirlName))
?statement <- (statement (firstGirlName ?firstGirlName) (firstGirlPlace ?firstGirlPlace) (firstTrue ~-1) (secondGirlName ?secondGirlName) (secondGirlPlace ?secondGirlPlace) (secondTrue ~-1))
=>
(if (= (fact-slot-value ?statement firstTrue) 1) then
	(modify ?girl1 (place ?firstGirlPlace))
else
	(modify ?girl2 (place ?secondGirlPlace))
)
(modify ?statement (processed 1))
)

(defrule girlPlaceDiscovered
(girl (name ?name) (place ~-1))
(statement (firstGirlName ?name) (firstTrue -1))
?girl <- (girl (place ~-1))
?statement <- (statement (firstGirlName ?name) (secondTrue -1))
=>
(if (= (fact-slot-value ?girl place) (fact-slot-value ?statement firstGirlPlace)) then
	(modify ?statement (firstTrue 1))
else
	(modify ?statement (firstTrue 0))	
)
)

(defrule girlPlaceDiscovered2
(girl (name ?name) (place ~-1))
(statement (secondGirlName ?name) (secondTrue -1))
?girl <- (girl (place ~-1))
?statement <- (statement (secondGirlName ?name) (secondTrue -1))
=>
(if (= (fact-slot-value ?girl place) (fact-slot-value ?statement secondGirlPlace)) then
	(modify ?statement (secondTrue 1))
else
	(modify ?statement (secondTrue 0))
)
)

(defrule onlyOneRemains
(girl (name ?firstName) (place ~-1))
(girl (name ?secondName) (place ~-1))
(girl (name ?thirdName) (place ~-1))
(girl (name ?fourthName) (place ~-1))
(girl (name ?fifthName) (place -1))
(test (neq ?firstName ?secondName ?thirdName ?fourthName ?fifthName))
(test (neq ?secondName ?firstName ?thirdName ?fourthName ?fifthName))
(test (neq ?thirdName ?secondName ?firstName ?fourthName ?fifthName))
(test (neq ?fourthName ?secondName ?thirdName ?firstName ?fifthName))
(test (neq ?fifthName ?secondName ?thirdName ?fourthName ?firstName))
?girl1 <- (girl (name ?firstName))
?girl2 <- (girl (name ?secondName))
?girl3 <- (girl (name ?thirdName))
?girl4 <- (girl (name ?fourthName))
?girl5 <- (girl (name ?fifthName))
=>
(modify ?girl5 (place 
(- (- (- (- 15 (fact-slot-value ?girl1 place)) (fact-slot-value ?girl2 place)) (fact-slot-value ?girl3 place)) (fact-slot-value ?girl4 place))
))
)






