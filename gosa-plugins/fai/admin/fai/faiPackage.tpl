
<table width="100%" summary="{t}FAI package{/t}">
 <tr>
  <td class='right-border'>
   <h3>{t}Generic{/t}
   </h3>
   <table summary="{t}Generic settings{/t}" cellspacing="4">
    <tr>
     <td><LABEL for="cn">{t}Name{/t}</LABEL>
     </td>
     <td>
      {render acl=$cnACL}
       <input type='text' value="{$cn}" size="45" disabled id="cn">
      {/render}
     </td>
    </tr>
    <tr>
     <td><LABEL for="description">{t}Description{/t}</LABEL>
     </td>
     <td>
      {render acl=$descriptionACL}
       <input type='text' value="{$description}" size="45" name="description" id="description">
      {/render}
     </td>
    </tr>
   </table>
  </td>
  <td width="50%" valign="top">
   <h3>{t}Repository{/t}
   </h3>
   <table summary="{t}Repository settings{/t}" cellspacing="4">
    <tr>
     <td>{t}Release{/t}:
     </td>
     <td>
      {$release}
     </td>
    </tr>
    <tr>
     <td>{t}Section{/t}:
     </td>
     <td>
      {$section}
     </td>
    </tr>
    <tr>
     <td>{t}Install method{/t}:
     </td>
     <td>
      {render acl=$FAIinstallMethodACL}
       <select name="FAIinstallMethod" title='{t}Please select the installation method{/t}' size=1>
        {html_options options=$FAIinstallMethods output=$FAIinstallMethod selected=$FAIinstallMethod}
       </select>
      {/render}
     </td>
    </tr>
   </table>
  </td>
 </tr>
</table>
<hr>
<table width="99%" summary="{t}Package settings{/t}">
 <tr>
  <td colspan="2">
   <h3>{t}Used packages{/t}
   </h3>
   {$listing}
  </td>
 </tr>
 </table>
 <table width="99%" summary="">
 {render acl=$FAIpackageACL}
  <tr>
   <td>
{if $direct_packages_add}
    <input type="text" size="25" name="addPpkgsText" value="" />
    <button type='submit' name='AddManualpkg'>
    {msgPool type=addButton}</button>&nbsp;
       <button type='submit' name='Addpkg'>{t}Add from list{/t}</button>
{/if}
   </td>
   <td style="text-align: right; ">
{if $debconf_configurations}
   <button type="submit" name="EditConfigurations">{t}Edit package configurations{/t}</button>
{/if}                                                                           
 {/render}
   </td>
   </td>
  </tr>
</table><!-- Place cursor -->
<script language="JavaScript" type="text/javascript"><!-- // First input field on page	focus_field('cn','description');  --></script>
