<div style="text-align:center;">
<h2>XPath Scraper</h2>
Your XPath: <input type="text" id="xpath" style="width: 400px;"/>
<br />
Result: <input type="text" id="result" style="width: 400px;"/>
<br />
<br />
<?php
$url = $_GET['url'];

$page = file_get_contents($url);

?>
    <form>URL: <input type="text" name="url" value="<?php echo $url; ?>" style="width:600px;"/><input type="submit" value="Scrape"/></form>
</div>
    <base href="<?php echo $url; ?>"/>
<?php echo $page; ?>
<script src="http://code.jquery.com/jquery-1.6.1.min.js"></script>
<script>
function getElementXPath(elt)
{
     var path = "";
     for (; elt && elt.nodeType == 1; elt = elt.parentNode)
     {
    idx = getElementIdx(elt);
    xname = elt.tagName;
    if (idx > 1) xname += "[" + idx + "]";
    path = "/" + xname + path;
     }
 
     return path;   
}

function getElementIdx(elt)
{
    var count = 1;
    for (var sib = elt.previousSibling; sib ; sib = sib.previousSibling)
    {
        if(sib.nodeType == 1 && sib.tagName == elt.tagName) count++
    }
    
    return count;
}

document.addEventListener('click', function(evt) {
    
    console.log(evt);
        
        evt.preventDefault();

    var xpath = getElementXPath(evt.target).toLowerCase();
    
    document.getElementById('xpath').value = xpath;
  //  $('#result').val(document.evaluate($(this).val(), document));
//    console.log(document.evaluate(xpath, document, null, XPathResult.ANY_TYPE, null).stringValue);
});

</script>


