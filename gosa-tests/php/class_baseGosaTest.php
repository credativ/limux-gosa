<?php
/* this class sets up the Selenium environment */
if(!class_exists("baseGosaTest")) {

class baseGosaTest extends PHPUnit_Extensions_SeleniumTestCase
{
  protected function setUp()
  {
    $this->setBrowser("*chrome");
    $this->setBrowserUrl("http://192.168.1.100/");
  }
}

}
?>