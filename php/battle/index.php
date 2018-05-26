<!DOCTYPE html>
<html>
<head>

<style>
#battle_results {
height:500px;
width:700px;
overflow:auto;
border: 1px solid black;
padding:5px;
}
</style>

<title>Battle</title>

<script src="http://code.jquery.com/jquery-1.4.4.min.js"></script>

<script>
$(document).ready(function(){
    $('#fight').click(function(){
        $.post("post.php", $("#battle_form").serialize(), function(data) { $('#battle_results').html(data) } );
    });
});
</script>

</head>
<body>

<h1>Battle</h1>

<form name="battle_form" id="battle_form">

<label for="name1">Player 1 name: </label>
<input type="text"name="name[1]" id="name1">

<label>Select warrior type: </label>
<input type="radio" name="type[1]" value="Ninja" id="type1ninja"><label for="type1ninja">Ninja</label>
<input type="radio" name="type[1]" value="Samurai" id="type1samurai"><label for="type1samurai">Samurai</label>
<input type="radio" name="type[1]" value="Brawler" id="type1brawler"><label for="type1brawler">Brawler</label>

<br />

<label for="name2">Player 2 name: </label>
<input type="text"name="name[2]" id="name2">

<label>Select warrior type: </label>
<input type="radio" name="type[2]" value="Ninja" id="type2ninja"><label for="type2ninja">Ninja</label>
<input type="radio" name="type[2]" value="Samurai" id="type2samurai"><label for="type2samurai">Samurai</label>
<input type="radio" name="type[2]" value="Brawler" id="type2brawler"><label for="type2brawler">Brawler</label>

<br />

<input type="button" value="Fight!" id="fight" />

</form>

<br />

<div id="battle_results">
</div>

</body>
</html>
