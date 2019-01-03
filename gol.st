Object subclass: #GameOfLife.
GameOfLife instanceVariableNames: 'cells'.
GameOfLife comment: 'I model the game of life.

I am basically a matrix of cells being either alive (true) or dead (false).

I am able to compute my next state depending on my current state using #next method.'.

GameOfLife class extend [
	extent: aPoint [
		<category: 'instance creation'>
		^ self new
				cells: ((1 to: aPoint x) collect: [ :i |
							Array new: aPoint y withAll: false ]);
				yourself
	]
]

GameOfLife extend [
	cells [
		<category: 'private'>
		^ cells
	]

	cells: anObject [
		<category: 'private'>
		cells := anObject
	]

	isAliveAt: x at: y [
		<category: 'testing'>
		^ [
				(self cells at: x) at: y
			] on: SystemExceptions.IndexOutOfRange do: [ false ]
	]

	printOn: aStream [
		<category: 'printing'>
		(1 to: self extent y) do: [ :y |
				1 to: self extent x do: [ :x |
					(self isAliveAt: x at: y)
						ifTrue: [ aStream nextPut: $# ]
						ifFalse: [ aStream nextPut: Character space ] ] ] separatedBy: [ aStream << Character lf ]
	]

	cellAt: x at: y beAlive: aBoolean [
		<category: 'accessing'>
		^ (self cells at: x) at: y put: aBoolean
	]

	neighbourhoodCoordinatesOfCellAt: x at: y [
		<category: 'accessing'>
		^ {-1 @  1. 0 @ 1 . 1 @ 1.
			   -1 @  0.         1 @ 0.
			   -1 @ -1. 0 @ -1. 1 @ -1
			} collect: [ :toAdd | (x@y) + toAdd ]
	]

	neighbourhoodOfCellAt: x at: y [
		<category: 'accessing'>
		^ (self neighbourhoodCoordinatesOfCellAt: x at: y) collect: [ :p |
				self isAliveAt: p x at: p y ]
	]

	next [
		<category: 'computation'>
		| nextWorld |
			nextWorld := self class extent: self extent.
			"Fill the next world with new values."
			1 to: self extent x do: [ :x |
				1 to: self extent y do: [ :y |
					|aliveNeighboors|
					aliveNeighboors := (self neighbourhoodOfCellAt: x at: y) select: [ :b | b = true ].
					(((self isAliveAt: x at: y) and: [ (aliveNeighboors size between: 2 and: 3) ])
						or: [ (self isAliveAt: x at: y) not and: [ (aliveNeighboors size = 3) ] ])
						ifTrue: [
							nextWorld
								cellAt: x
								at: y
								beAlive: true ] ] ].
			^ nextWorld
	]

	extent [
		<category: 'accessing'>
		^ self cells size @ self cells first size
	]
]
