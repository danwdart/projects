<?php
$attribs = array(
		'name'		=> 'Kirupa',
		'job'		=> 'Engineer',
		'school'	=> 'MIT',
		'homeTown'	=> 'Spanish Fort',
		'homeState'	=> 'Alabama'
		);
$kirupa = new User( $attribs );

echo 'Name: '.$kirupa->getName().'<br />';		// Kirupa
echo 'Job: '.$kirupa->getJob().'<br />';		// Engineer
echo 'School: '.$kirupa->getSchool().'<br />';		// MIT
echo 'Home Town: '.$kirupa->getHomeTown().'<br />';	// Spanish Fort
echo 'Home State: '.$kirupa->getHomeState().'<br />';	// Alabama

class User {
	private $name;
	private $job;
	private $school;
	private $homeTown;
	private $homeState;

	function __construct( $attribs ) {
		$this->name		= $attribs['name'];
		$this->job		= $attribs['job'];
		$this->school		= $attribs['school'];
		$this->homeTown		= $attribs['homeTown'];
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

	/* job methods */
	function setJob( $val ) {
		$this->job = $val;
		return;
	}

	function getJob() {
		return $this->job;
	}

	/* school methods */
	function setSchool( $val ) {
		$this->school = $val;
		return;
	}

	function getSchool() {
		return $this->school;
	}

	/* home town methods */
	function setHomeTown( $val ) {
		$this->homeTown = $val;
	}

	function getHomeTown() {
		return $this->homeTown;
	}

	/* home state methods */
	function setHomeState( $val ) {
		$this->homeState = $val;
	}

	function getHomeState() {
		return $this->homeState;
	}
}
?>
