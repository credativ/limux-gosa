<?php
require("class_baseGosaUserTest.php");

class test_login_repeat extends baseGosaUserTest
{
  public function __construct() {
    echo "test_login_repeat constructed\n";
    parent::__construct();
  }

  public function testMyTestCase()
  {
    $this->login();
    $this->open("/gosa/index.php");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("Offene Sitzung!");
    $this->click("id=dummy");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("Li Mux [limux] / Direktorium");
    $this->logout();
  }
}
?>