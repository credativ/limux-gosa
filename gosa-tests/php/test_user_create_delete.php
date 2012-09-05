<?php
require("class_baseGosaUserTest.php");
class test_user_create_delete extends baseGosaUserTest
{
  public function testMyTestCase()
  {
    $this->login();
    $this->verifyTextPresent("Li Mux [limux] / Direktorium");
    $this->click("id=plugMenuId_1");
    $this->waitForPageToLoad("30000");
    $this->click("css=ul.level3 > li > a > div.img");
    $this->waitForPageToLoad("30000");
    $this->type("id=sn", "Automated");
    $this->type("id=givenName", "Test");
    $this->type("id=uid", "automated.test");
    $this->click("name=edit_finish");
    $this->waitForPageToLoad("30000");
    $this->type("id=new_password", "testpass");
    $this->type("id=repeated_password", "testpass");
    $this->click("id=password_finish");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("automated.test");
    $this->click("id=listing_selected_2");
    $this->click("link=Entfernen");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("cn=Test Automated,ou=Direktorium,o=Landeshauptstadt München,c=de");
    $this->click("name=delete_confirmed");
    $this->waitForPageToLoad("30000");
    try {
        $this->assertFalse($this->isTextPresent("automated.test"));
    } catch (PHPUnit_Framework_AssertionFailedError $e) {
        array_push($this->verificationErrors, $e->toString());
    }
    $this->logout();
  }
}
?>