<h3>{t}Select objects to add{/t}</h3>
{$List}
<hr>
<div class="plugin-actions">
<input type="text" name="ppdSearch" title="PPD-Suchfeld" value="{$ppdFilter}" /><button type="submit" name="SearchPPD">Nach {if $mode eq "ppd"}Druckermodell{else}Hersteller{/if} suchen</button>
 <button type='submit' name='ClosePPDSelection'>{t}Close{/t}</button>
</div>
