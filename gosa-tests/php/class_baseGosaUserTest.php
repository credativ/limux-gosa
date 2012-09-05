<?php
require("class_baseGosaTest.php");
/* this class serves for all Gosa tests requiring a logged-in user. */
if(!class_exists("baseGosaUserTest")) {

define("GOSA_USER","limux");
define("GOSA_PASS","limux");

class baseGosaUserTest extends baseGosaTest
{
  protected function login()
  {
    $this->open("/gosa/index.php");
    $this->type("name=username", GOSA_USER);
    $this->type("id=password", GOSA_PASS);
    $this->click("id=login");
    $this->waitForPageToLoad("30000");
    $this->assertTrue($this->isTextPresent("Li Mux [limux] / Direktorium"));
  }
  protected function logout() {
    $this->assertTrue($this->isTextPresent("Li Mux [limux] / Direktorium"));
    $this->click("css=div[title=\"Abmelden\"] > div.img");
    $this->waitForPageToLoad("30000");
    $this->assertTrue($this->isTextPresent("GOsa Anmeldung"));
  }
}

}
?>