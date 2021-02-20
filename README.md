# mastermind
created as part of the odin project curiculum https://www.theodinproject.com/
set your own code and watch it be broken by dumb logic and random selection or beat a random code in 10 attempts 
uses numbers 1 to 6 to represent red yellow green blue black adn white in the original mastemind game 
unter a guess and receive a result 
O indicates a peg is correct colour and place 
X represents correct colour wrong place

## implementing minimax 
due to a bug with the original array iterating over itself while modifying and therefore not properly removing impossible answers taht was not discovered code was refactored following a minimax method hower this approach has a significant start up time and is not required so refactored code was abandonned and bug in original was fixed by iterating over a duplicate array instead.
the refeactored code could have the minimax algorithm applied and may be revisited in future
