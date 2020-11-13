<?php
// Classes only have logic, not decisions to echo!

// Method = FUNCTION

class person {
	
	private $name = "bob"; // Now you can't echo $person->name from elsewhere, only call get_name
	
	private $ryan; // Save this.
	
	public $location = "Aldridge"; // You can access $person->location elsewhere.
	
	function __construct() {
		$this->ryan = "Quiet, Soldier!";
	}
	
	function get_name() { // This function defaults to public - 
		// Only in the VIEW do you echo things.
		return $this->name; // $this-> means get the object
	
	}

}
