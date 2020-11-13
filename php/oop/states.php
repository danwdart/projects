<?php
$attribs = array(
		'name'		=> 'Kirupa',
		'homeState'	=> 'Alabama'
		);
$kirupa = new User( $attribs );

echo 'Name: '.$kirupa->getName().'<br />';			// Kirupa
echo 'Home State: '.$kirupa->getHomeState().'<br />';		// Alabama
echo 'State Abbr.: '.$kirupa->getHomeStateAbbr().'<br />';	// AL

class User {
	private $name;
	private $homeState;
	
	function __construct( $attribs ) {
		$this->name		= $attribs['name'];
		$this->homeState	= $attribs['homeState'];
	}
	
	/* name methods */
	function setName( $val ) {
		$this->name = $val;
		return;
	}
	
	function getName() {
		return $this->name;
	}
	
	/* home state methods */
	function setHomeState( $val ) {
		$this->homeState = $val;
	}
	
	function getHomeState() {
		return $this->homeState;
	}
	
	function getHomeStateAbbr() {
		$abbr = States::$ABBRS[$this->getHomeState()]; // this is not a function but an array (variable), so still needs an $
		if( $abbr ) {
			return $abbr;
		}
		else {
			return 'Unknown';
		}
	}
}

class States {
	/* ideally this would be held in a database */
		static $ABBRS = array ( // Static vats don't change and can be accessed without a method? - caps
		'Alabama'	=> 'AL',
		'Michigan'	=> 'MI',
		'New York'	=> 'NY'
		);
}
?>
