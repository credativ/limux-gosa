<table summary="{t}Application{/t}" style="width:100%;">
 <tr>
  <td style="width:50%;">

   <table summary="{t}Generic settings{/t}">
     <tr>
      <td><LABEL for="cn">{t}Application name{/t}{$must}</LABEL></td>
      <td>
{render acl=$cnACL}
	<input type='text' id="cn" name="cn" value="{$cn}" title="{t}Application name GOsa{/t}">
{/render}
      </td>
    </tr>
    <tr>
     <td><LABEL for="description">{t}Description{/t}</LABEL></td>
     <td>
{render acl=$descriptionACL}
      <input type='text' id="description" name="description" value="{$description}" title="{t}Description function{/t}">
{/render}
     </td>
    </tr>
    <tr>
     <td><LABEL for="gosaApplicationName">{t}Display name{/t}</LABEL></td>
     <td>
{render acl=$gosaApplicationNameACL}
        <input id="gosaApplicationName" name="gosaApplicationName" type="text"
	  value="{$gosaApplicationName}" title="{t}Application name to be displayed (i.e. below icons){/t}">
{/render}
     </td>
    </tr>
    <tr>
     <td><LABEL for="gosaApplicationExecute">{t}Execute{/t}{$must}</LABEL></td>
     <td>
{render acl=$gosaApplicationExecuteACL}
        <input id="gosaApplicationExecute" name="gosaApplicationExecute" type="text"
	  value="{$gosaApplicationExecute}" title="{t}Path and/or binary name of application{/t}">
{/render}
     </td>
    </tr>
{if !$isReleaseApplikation}
   <tr>
    <td><br><LABEL for="base">{t}Base{/t}</LABEL>{$must}</td>
    <td>
     <br>
{render acl=$baseACL}
           {$base}
{/render}
     </td>
    </tr>
{/if}
   </table>
  </td>
  <td class='left-border'>

   &nbsp;
  </td>
  <td>

   <table summary="{t}Picture settings{/t}">
    <tr>
    <td>
    <LABEL for="picture_file">{t}Icon{/t}</LABEL>
    <br>
{if $IconReadable}
    <img alt="" src="getbin.php?rand={$rand}" border=1 style="width:48px; height:48; background-color:white; vertical-align:bottom;">
{else}
	{image path="images/empty.png"}

{/if}
    </td>
    <td>

    &nbsp;<br>

    <input type="hidden" name="MAX_FILE_SIZE" value="100000">
{render acl=$gosaApplicationIconACL}
    <input name="picture_file" type="file" size="20" maxlength="255" accept="image/*.png" id="picture_file">
{/render}
{render acl=$gosaApplicationIconACL}
<button type='submit' name='update' title="{t}Reload picture from LDAP{/t}">{t}Upload{/t}</button>

{/render}
{render acl=$gosaApplicationIconACL}
<button type='submit' name='remove_picture' title="{t}Remove picture from LDAP{/t}">{t}Remove picture{/t}</button>
    </td>
    <td>
   </table>
<br>
{/render}
{render acl=$gosaApplicationIconACL}
{t}Specify a path to an icon or an XDG icon specification filename instead{/t}
<br>
<input name="use_picture_path" onChange="document.mainform.submit()" type="checkbox" {$use_picture_path}>
{t}Filename{/t}
<input name="picture_path" type="text" size="20" {if !$use_picture_path}disabled{/if} value="{$picture_path}"></button>
{/render}
  </td>
 </tr>
</table>

<hr>

<h3>{t}Options{/t}</h3>
<table summary="{t}Application options{/t}" style="width:100%;">
  <tr>
    <td style='width:50%;' class='right-border'>

{render acl=$execForGroupmembersACL}
      <input type=checkbox name="execForGroupmembers" value="1" {$execForGroupmembers}>
{/render}
	{t}Only executable for members{/t}
      <br>
{render acl=$overwriteConfigACL}
      <input type=checkbox name="overwriteConfig" value="1" {$overwriteConfig}>
{/render}
	{t}Replace user configuration on startup{/t}
    </td>
    <td>
{render acl=$placeOnDesktopACL}
      <input type=checkbox name="placeOnDesktop" value="1" {$placeOnDesktop}>
{/render}
      {t}Place icon on members desktop{/t}
      <br>
{render acl=$placeInStartmenuACL}
      <input type=checkbox name="placeInStartmenu" value="1" {$placeInStartmenu}>
{/render}
      {t}Place entry in members start menu{/t}
      <br>
{render acl=$placeOnKickerACL}
      <input type=checkbox name="placeOnKicker" value="1" {$placeOnKicker}>
{/render}
      {t}Place entry in members launch bar{/t}
    </td>
  </tr>
</table>

<hr>

<table width="99%" summary="{t}Log on script{/t}">
	<tr>
		<td>
			<h3>{t}Log on script{/t}</h3>
{render acl=$gotoLogonScriptACL}
			<textarea name="gotoLogonScript" style='width:99%;height:220px;'>{$gotoLogonScript}</textarea>
{/render}
{render acl=$gotoLogonScriptACL}
			<input type="file" name="ScriptFileOn" value="{t}Import{/t}">
{/render}
{render acl=$gotoLogonScriptACL}
			<button type='submit' name='upLoadOn'>{t}Upload{/t}</button>

{/render}
			{image path="images/save.png" action="downloadScriptOn" title="{t}Download{/t}"}

			<h3>{t}Log off script{/t}</h3>
{render acl=$gotoLogoffScriptACL}
			<textarea name="gotoLogoffScript" style='width:99%;height:220px;'>{$gotoLogoffScript}</textarea>
{/render}
{render acl=$gotoLogoffScriptACL}
			<input type="file" name="ScriptFileOff" value="{t}Import{/t}">
{/render}
{render acl=$gotoLogoffScriptACL}
			<button type='submit' name='upLoadOff'>{t}Upload{/t}</button>

{/render}
			{image path="images/save.png" action="downloadScriptOff" title="{t}Download{/t}"}

		</td>
	</tr>
</table>

<div style="height:20px;"></div>

<!-- Place cursor -->
<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
	focus_field('cn');
  -->
</script>

<!-- #9128 freezed application: show entire path of execution -->
<script type="text/javascript" language="javascript">
var inputElement=$("gosaApplicationExecute");
if(inputElement && inputElement.disabled) {
    inputElement.writeAttribute('type', 'hidden');
    var execCommand=inputElement.getValue();
    var parentElement=inputElement.up();
    parentElement.update(execCommand); 
}
</script>
