<?php
require("class_baseGosaTest.php");

class test_loginLogout extends baseGosaTest
{
  public function __construct() {
    echo "test_loginLogout constructed\n";
    parent::__construct();
  }
  public function testMyTestCase()
  {
    $this->open("/gosa/");
    $this->type("name=username", "limux");
    $this->type("id=password", "limux");
    $this->click("id=login");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("Li Mux [limux] / Direktorium");
    $this->click("css=div[title=\"Abmelden\"] > div.img");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("GOsa Anmeldung");
  }
}
?>