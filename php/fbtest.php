<?php
require 'facebookapi/php/facebook.php';
?>
<!DOCTYPE html>
<html>
<head>
<title>FB Test Page</title>
<script type="text/javascript">
</script>
<style type="text/css">
img { padding:5px; border-style:none;}
#profile_pics { background-color:#666666; padding:5px; }
</style>
</head>
<body>

<?php
  $appapikey = '8fd7899ac52b475e90ec5ac46e112992';    //CHANGE THIS
  $appsecret = '698a166e513aa63b75d0d08ebb917daf'; //CHANGE THIS
  $facebook = new Facebook($appapikey, $appsecret);
  $user_id = $facebook->require_login();
  
  $fb_user = $facebook->user;
  
//$albums = $facebook->api_client->photos_getAlbums($user_id, NULL);
//print_r($albums); 


  $friends = $facebook->api_client->friends_get();
  $friends = array_slice($friends, 0, 10);
  
echo "Here's a list of 10 of your friends. Click on one to see all their photos.<br />";
$i=0;
foreach ($friends as $friend) {
    $personArray = $facebook->api_client->users_getInfo($friend, "name");
    $query="SELECT pic_square FROM profile WHERE id=".$friend;
    $result=$facebook->api_client->fql_query($query);
    foreach ($result as $img) {
        ?>
      <a href="fbtest.php?uid=<?php echo $friend; ?>"><img src="<?php echo $img[pic_square]; ?>" /></a>
    <?php
    }
    $person[$i]=$personArray[0];
    $i++;
}

if (isset($_GET['uid'])) {
    echo "Here are their pictures:<br />";
    $query="SELECT aid FROM album WHERE owner=".$_GET['uid'];
    $result=$facebook->api_client->fql_query($query);
    foreach ($result as $albums) {
        $query="SELECT src_small FROM photo WHERE aid=".$albums[aid];
        $result=$facebook->api_client->fql_query($query);
        foreach ($result as $picture) {
            echo "<img src='".$picture[src_small]."' /><br />";
        }
    }
}



  
  /*
  $i=0;
  foreach ($person as $f)
  {
    echo " ".$f['name'];


    //MORE DETAILS HERE IN STEP 2
  
    echo "<br />";
    $i++;
  }
  echo "<br />";
*/

/*


<!--
<script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php/en_GB" type="text/javascript"></script><script type="text/javascript">FB.init("8fd7899ac52b475e90ec5ac46e112992");</script>
<fb:login-button v="2" size="medium" onlogin="window.location.reload(true);">Connect with Facebook</fb:login-button>
<br /><br />
<fb:profile-pic uid="loggedinuser" size="square" facebook-logo="false"></fb:profile-pic>
<br /><fb:name uid="loggedinuser" useyou="false" linked="true"></fb:name>
<br /><br />
Your friends should appear here:
<br />
<div id="profile_pics" style="position:absolute; display:block; float:left; max-width:600px;"></div>
<script type="text/javascript">
var widget_div = document.getElementById("profile_pics");
FB.ensureInit(function () {
  FB.Facebook.get_sessionState().waitUntilReady(function() {
  FB.Facebook.apiClient.friends_get(null, function(result) {
    var markup = "";
    var num_friends = result ? Math.min(1000, result.length) : 0;
    if (num_friends > 0) {
      for (var i=0; i<num_friends; i++) {
        markup += 
          '<fb:profile-pic size="square" uid="'+result[i]+'" facebook-logo="false"></fb:profile-pic>';
// if ((1+(i/5))==Math.floor(1+(i/5))) { markup+="<br />";}
      }
    }
    widget_div.innerHTML = markup;
    FB.XFBML.Host.parseDomElement(widget_div);
  });
  });
});
</script>
<br /><br />
-->
*/
?>
</body>

</html>