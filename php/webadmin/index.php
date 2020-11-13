<!DOCTYPE html>
<html>
<head>
<title>WebAdmin</title>
</head>
<body>
<h1>WebAdmin</h1>
<div id="info">
<h2>System Information</h2>
<?php
echo "<b>System identification:</b><pre>".`lsb_release -a`."</pre><br />";
echo "<b>Full uname:</b><pre>".`uname -a`."</pre><br />";
echo "<b>Kernel version:</b><pre>".`cat /proc/version`."</pre><br />";
echo "<b>System uptime:</b><pre>".`uptime`."</pre><br />";
echo "<b>Who's logged on:</b><pre>".`w`."</pre><br />";
echo "<b>Top ten CPU hoggers:</b><pre>".`ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10`."</pre><br />";
echo "<b>Top ten memory hoggers:</b><pre>".`ps -eo pmem,pid,user,args | sort -k 1 -r | head -10`."</pre><br />";
echo "<b>Memory usage:</b><pre>".`free -tm`."</pre><br />";
echo "<b>Network information:</b><pre>".`/sbin/ifconfig`."</pre><br />";
echo "<b>Network sockets:</b><pre>".`netstat -anlp`."</pre><br />";
echo "<b>Modules installed:</b><pre>".`lsmod`."</pre><br />";
echo "<b>Running processes:</b><pre>".htmlspecialchars(`ps aux`)."</pre><br />";
echo "<b>CPU info:</b><pre>".`cat /proc/cpuinfo`."</pre><br />";
?>
</div>
</body>
</html>