root {
	// Sets counter
	NS <- 99;
} - {
	*:BeerOnWall;
}

BeerOnWall {
	Stdout <- NS;
	Stdout <- " bottles of beer on the wall, ";
	Stdout <- NS;
	Stdout <- " bottles of beer.\n";
	NS <- 0->* | -1 <- NS;
	Stdout <- "Take one down and pass it around, ";
	Stdout <- NS;
	Stdout <- " bottles of beer on the wall.\n";
	NS <- NS;
} - {
	<=1:Finish;
	*:BeerOnWall;
}

Finish {
	Stdout <- "1 bottle of beer on the wall, 1 bottle of beer.\n";
	Stdout <- "Take one down pass it around, no more bottles of beer on the wall.\n";
} - {}