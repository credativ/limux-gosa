<?php
require("class_baseGosaUserTest.php");
class test_client_create_existing extends baseGosaUserTest
{
  public function testMyTestCase()
  {
    $this->login();
    $this->click("id=plugMenuId_6");
    $this->waitForPageToLoad("30000");
    $this->click("link=Arbeitsstation");
    $this->waitForPageToLoad("30000");
    $this->click("name=edit_continue");
    $this->waitForPageToLoad("30000");
    $this->type("id=cn", "automatedTest1");
    $this->type("id=macAddress", "00:13:33:33:33:37");
    $this->select("name=gotoMode", "label=Aktiv");
    $this->click("//li[@onclick=\"document.mainform.arg.value='workstartup'; document.mainform.submit();\"]");
    $this->waitForPageToLoad("30000");
    $this->click("name=FAIdebianMirror");
    $this->select("name=FAIdebianMirror", "label=http://master.mini.muenchen.de/repo");
    $this->waitForPageToLoad("30000");
    $this->select("name=FAIrelease", "label=plophos/4.1.0");
    $this->waitForPageToLoad("30000");
    $this->click("name=FAIclassesSel");
    $this->select("name=FAIclassesSel", "label=regexp:Modul_Standard\\s\\[P\\]");
    $this->click("name=AddClass");
    $this->waitForPageToLoad("30000");
    $this->click("id=add_ldap_server");
    $this->waitForPageToLoad("30000");
    $this->click("//li[@onclick=\"document.mainform.arg.value='workservice'; document.mainform.submit();\"]");
    $this->waitForPageToLoad("30000");
    $this->click("id=AutoSync");
    $this->click("css=div.tabs > ul > li");
    $this->waitForPageToLoad("30000");
    $this->click("name=edit_finish");
    $this->waitForPageToLoad("30000");
    try {
        $this->assertFalse($this->isTextPresent("Es existiert bereits ein Eintrag mit diesem Name Attribut im System!"));
    } catch (PHPUnit_Framework_AssertionFailedError $e) {
        array_push($this->verificationErrors, $e->toString());
    }
    $this->verifyTextPresent("automatedTest1");
    $this->click("link=Arbeitsstation");
    $this->waitForPageToLoad("30000");
    $this->click("name=edit_continue");
    $this->waitForPageToLoad("30000");
    $this->type("id=cn", "automatedTest1");
    $this->type("id=macAddress", "00:13:33:33:33:37");
    $this->select("name=gotoMode", "label=Aktiv");
    $this->click("//li[@onclick=\"document.mainform.arg.value='workstartup'; document.mainform.submit();\"]");
    $this->waitForPageToLoad("30000");
    $this->click("name=FAIdebianMirror");
    $this->select("name=FAIdebianMirror", "label=http://master.mini.muenchen.de/repo");
    $this->waitForPageToLoad("30000");
    $this->select("name=FAIrelease", "label=plophos/4.1.0");
    $this->waitForPageToLoad("30000");
    $this->click("name=FAIclassesSel");
    $this->select("name=FAIclassesSel", "label=regexp:Modul_Standard\\s\\[P\\]");
    $this->click("name=AddClass");
    $this->waitForPageToLoad("30000");
    $this->click("id=add_ldap_server");
    $this->waitForPageToLoad("30000");
    $this->click("//li[@onclick=\"document.mainform.arg.value='workservice'; document.mainform.submit();\"]");
    $this->waitForPageToLoad("30000");
    $this->click("id=AutoSync");
    $this->click("css=div.tabs > ul > li");
    $this->waitForPageToLoad("30000");
    $this->click("name=edit_finish");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("Es existiert bereits ein Eintrag mit diesem Name Attribut im System!");
    $this->click("//button[@onclick=\"next_msg_dialog();\"]");
    $this->click("name=edit_cancel");
    $this->waitForPageToLoad("30000");
    $this->click("id=listing_selected_5");
    $this->click("link=Entfernen");
    $this->waitForPageToLoad("30000");
    $this->verifyTextPresent("(Arbeitsstation) - cn=automatedTest1,ou=workstations,ou=systems,ou=Direktorium,o=Landeshauptstadt München,c=de");
    $this->click("name=delete_confirmed");
    $this->waitForPageToLoad("30000");
    try {
        $this->assertFalse($this->isTextPresent("automatedTest1"));
    } catch (PHPUnit_Framework_AssertionFailedError $e) {
        array_push($this->verificationErrors, $e->toString());
    }
    $this->verifyTextPresent("Liste der Systeme");
    $this->logout();
  }
}
?>