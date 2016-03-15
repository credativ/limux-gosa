<?php

class filterACL {

  static function query($base, $scope, $filter, $attributes, $category, $objectStorage= "")
  {
    $config= session::global_get('config');
    $ldap= $config->get_ldap_link(TRUE);
    $flag= ($scope == "sub")?GL_SUBSEARCH:0;
    $result=array();
    $result= array_merge($result,filterACL::get_list($base, $filter, $attributes, $category, array(), $flag | GL_SIZELIMIT, "cat"));
    if($scope == "sub"){
      $result= array_merge($result,filterACL::get_list($base, $filter, $attributes, $category, array(), $flag | GL_SIZELIMIT, "search"));
    }
    $result= array_merge($result,filterACL::get_list($base, $filter, $attributes, $category, $objectStorage, $flag | GL_SIZELIMIT, ""));
    return(filterACL::unifyResult($result));
  }

  static function unifyResult($result)
  {
    $res=array();
    foreach($result as $entry){
      if(!isset($res[$entry['dn']])){
        $res[$entry['dn']]=$entry;
      }
    }
    return(array_values($res)); 
  }

  static function get_list($base, $filter, $attributes, $category, $objectStorage, $flags= GL_SUBSEARCH, $method= "")
  {
    $ui= session::global_get('ui');
    $config= session::global_get('config');

    // Move to arrays for category and objectStorage
    if (!is_array($category)) {
      $category= array($category);
    }
    if (!is_array($objectStorage)) {
      $objectStorage= array($objectStorage);
    }

    if(empty($method)){
      $method= (empty($objectStorage) && !($flags & GL_SUBSEARCH))?"ls":"search";
    }

    // Initialize search bases
    $bases= array();
    
    if (translate_objectpath_enabled()) {
      /* The department object has no object path attribute
         so we need to inject it manually. */
      $bases[$config->current['STOREBASE']] = "";
    }

    // Get list of sub bases to search on
    if (count($objectStorage) == 0) {
      $bases[$base]= "";
    } else {
      foreach ($objectStorage as $oc) {
        $oc= preg_replace('/,$/', '', $oc);
        $tmp= explode(',', $oc);
        if (count($tmp) == 1) {
          preg_match('/([^=]+)=(.*)$/', $oc, $m);
          if ($flags & GL_SUBSEARCH) {
            $bases[$base][]= $m[1].":dn:=".$m[2];
          } else {
            $bases["$oc,$base"][]= $m[1].":dn:=".$m[2];
          }
        } else {
          // No, there's no \, in pre defined RDN values
          preg_match('/^([^,]+),(.*)$/', $oc, $matches);
          preg_match('/([^=]+)=(.*)$/', $matches[1], $m);
          if ($flags & GL_SUBSEARCH) {
            $bases[$base][]= $m[1].":dn:=".$m[2];
          } else {
            $bases[$matches[2].",$base"][]= $m[1].":dn:=".$m[2];
          }
        }
      }
    }

    // Get LDAP link
    $ldap= $config->get_ldap_link($flags & GL_SIZELIMIT);

    // Do search for every base
    $result= array();
    $limit_exceeded = FALSE;
    foreach($bases as $base => $dnFilters) {

      // Break if the size limit is exceeded
      if($limit_exceeded){
        return($result);
      }

      // Switch to new base and search
      if (is_array($dnFilters)){
        $dnFilter= "(|";
        foreach ($dnFilters as $df) {
          $dnFilter.= "($df)";
        }
        $dnFilter.= ")";
      } else {
        $dnFilter= "";
      }

      // add attributes needed for dn translation unless all attributes are fetched anyway
      if (translate_objectpath_enabled() && !empty($attributes)) {
          $additionalAttributes = array("lhmObjectPath", "cn");

          foreach ($additionalAttributes as $attr) {
              if (!in_array($attr, $attributes)) {
                  $attributes[] = $attr;
              }
          }
      }

      $ldap->cd($base);
      if ($method == "ls") {
        $ldap->ls("(&$filter$dnFilter)", $base, $attributes);
      } elseif ($method == "cat") {
        $ldap->cat($base, $attributes, "(&$filter$dnFilter)");
      } else {
        $ldap->search("(&$filter$dnFilter)", $attributes);
      }

      // Check for size limit exceeded messages for GUI feedback
      if (preg_match("/size limit/i", $ldap->get_error())){
        session::set('limit_exceeded', TRUE);
        $limit_exceeded = TRUE;
      } 

      /* Crawl through result entries and perform the migration to the
         result array */
      while($attrs = $ldap->fetch()) {
        $dn= $ldap->getDN();

        if (translate_objectpath_enabled() && isset($attrs["lhmObjectPath"][0]) && isset($attrs["cn"][0])) {
          // translate from stored dn to logical dn
          if (strpos($dn, $config->current['STOREBASE']) !== false) {
            $dn = $ldap->storeToLogicalDn("cn", $attrs, $dn);
          }
        }

        /* Convert dn into a printable format */
        if ($flags & GL_CONVERT){
          $attrs["dn"]= convert_department_dn($dn);
        } else {
          $attrs["dn"]= $dn;
        }

        /* Skip ACL checks if we are forced to skip those checks */
        if($flags & GL_NO_ACL_CHECK){
          $result[]= $attrs;
        }else{

          /* Sort in every value that fits the permissions */
          foreach ($category as $o){
            if((preg_match("/\//",$o) && preg_match("/r/",$ui->get_permissions($dn,$o))) ||
                (!preg_match("/\//",$o) && preg_match("/r/",$ui->get_category_permissions($dn, $o)))){
              $result[]= $attrs;
              break;
            }
          }
        }
      }

    }

    return $result;
  }


}

?>
