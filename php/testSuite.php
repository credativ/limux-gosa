<?
$path="http://localhost:4444/wd/hub/static/resource/hub.html";
$text=@file_get_contents($path);
if($text=="" || strpos($text,"WebDriver Hub")===FALSE)
  die("Please start the Selenium WebDriver\n");
$ok=$bad=0;
foreach(glob("test_*.php") as $filename) {
  echo "running $filename\n";
  $retval=0;
  exec("phpunit $filename",$out,$retval);
  if($retval) {
    echo "test run finished with errors:\n".implode("\n",$out)."\n";
    $bad++;
  } else {
    echo "test run finished OK\n";
    $ok++;
  }
}
echo "test suite finished. $ok working tests, $bad broken tests\n";
?>