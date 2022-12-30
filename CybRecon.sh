#!/bin/bash



REDCOLOR="\e[31m"
GREENCOLOR="\e[32m"
Yellow="\e[33m"
Blue="\e[34m"
Magenta="\e[95m"


echo -e "$GREENCOLOR



░█████╗░██╗░░░██╗██████╗░██████╗░███████╗░█████╗░░█████╗░███╗░░██╗
██╔══██╗╚██╗░██╔╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗░██║
██║░░╚═╝░╚████╔╝░██████╦╝██████╔╝█████╗░░██║░░╚═╝██║░░██║██╔██╗██║
██║░░██╗░░╚██╔╝░░██╔══██╗██╔══██╗██╔══╝░░██║░░██╗██║░░██║██║╚████║
╚█████╔╝░░░██║░░░██████╦╝██║░░██║███████╗╚█████╔╝╚█████╔╝██║░╚███║
░╚════╝░░░░╚═╝░░░╚═════╝░╚═╝░░╚═╝╚══════╝░╚════╝░░╚════╝░╚═╝░░╚══╝
"
echo -e "$Magenta                                             V0.0.1 (beta)
 ###################------------------------ Coded By Manav Surti"

echo -e "$Blue \n
    Connect with me on LinkedIn:https://www.linkedin.com/in/manav-surti-b53130223/"

usage(){
     echo -e "$REDCOLOR Usage: ./CybRecon.sh -d target.com -m options" 
}
usage



if [ ! -d $target ]
then
    mkdir $target
fi

cd $target

echo -e "$GREENCOLOR Target is set to $target in mode $MODE .........."

techstack_info(){
    echo -e "$Yellow Collecting Tech Stack Info...."
    whatweb  -a 3 -t 20 $target
}


lookup(){
    echo -e "$Blue Performing WHois Lookup on $target....."
    whois -M -x $target 
    nslookup $target
}



subdomain_enum(){
    echo -e "$Yellow [+] subdomain enumuration on $target is started......."
    echo -e "$Yellow [+] Finding subdomains with Subfinder..."
    subfinder -d $target -o subdomain1.txt
    echo -e "$Yellow [+] Finding subdomains with Sublist3r..."
    python3 ~/tools/Sublist3r/sublist3r.py -d $target -t 20 -o subdomain2.txt
    echo -e "$Yellow [+] Finding subdomains with Assetfiner..."
    assetfinder -subs-only $target > subdomain.txt

    cat subdomain1.txt >> subdomain.txt
    cat subdomain2.txt >> subdomain.txt
    rm subdomain1.txt
    rm subdomain2.txt
  
    echo -e "$Blue [+] Succesfully Collected all possible Subdomains"
    echo -e "$GREENCOLOR [+].....Filtering Out Unique Subdomains.... "
    cat subdomain.txt | sort | uniq > subdomains
}




live_subdomain(){
    echo -e "$REDCOLOR [+] Finding live subdomains with httprobe..."
    cat subdomains | httprobe -c 30  > alive_subdomain.txt
}



subdomain_takeover(){
    echo -e "$REDCOLOR [+] Checking for subdomain Takeover if Possible......"
    aquatone-discover -d $target -t 20
    aquatone-scan -d $target -t 20
    aquatone-takeover -d $target -t 10    
}




directory_fuzzing(){

    while read -r line
    do  
    dirsearch -u $line -r --include-status=200,300-399  -t 10 -o directory_fuzzing.txt
    done < alive.txt
}



help_info(){
    echo -e "$Magenta Help inf0...."
    echo -e "$GREENCOLOR ABOUT..."
    echo -e "$Blue CybRecon is an Information gathering tool "
    echo -e "$Blue which is used for Subdomain Enumuration as well to check whether Subdomain Takeover is possible or not moreover it provides you additional informations like Whois lookup, ns lookup"
    echo -e "\n\n"
    echo -e "$Yellow Usage: ./CybRecon.sh -d target.com -m modes"
    echo -e "$Yellow "
    echo -e "$GREENCOLOR OPTIONS/MODES: "
    echo -e "$REDCOLOR  Power | power | POWER      Run CybRecon in Power mode \n Enumurates all Subdomains, Directory Search on Subdomains  as well as checks for Subdomain takeover If possible"
    echo -e "$Magenta  Depth | depth | DEPTH      Run CybRecon in Depth mode \n Enumurates all Subdomains as well as checks for Subdomain takeover if possible"
    echo -e "$GREENCOLOR  Light | light | LIGHT      Run CybRecon in Light mode \n Enumurates all Subdomains only"
    echo -e "$Yellow FLAGS:"
    echo -e "$Yellow  -d    --domain    :   To set Domain of the target"
    echo -e "$Yellow  -h    --help      :   For Help Menu"
    echo -e "$GREENCOLOR   CybRecon in Power mode"
    echo -e "$Yellow        ./CybRecon.sh -d victim.com -m power"


}

while true; do
    case "$1" in
        '-d'|'--domain')
            if [ "$2" = '' ]
            then 
                 echo -e 
            fi

            target=$2
            shift 2
            continue
            ;;
        '-m'|'--mode')
                       
            if [ "$2" = '' ]
            then 
                 echo -e "$REDCOLOR Mode is not selected properly"
                 echo -e "$Yellow" help_info

                 exit
            fi
            MODE=$2 
            shift 2
            continue
            ;;
        '-h'| '--help')
            help_info
            exit 1
            ;; 
        '')
            break
            ;;

        *)
            echo "Unknown argument: $1"
            exit 1
            ;;


    esac
done



if [ "$MODE" = 'Power' ] || [ "$MODE" = 'power' ] || [ "$MODE" = 'POWER' ]  
then
   lookup
   techstack_info
   subdomain_enum
   live_subdomain
   subdomain_takeover
   directory_fuzzing

elif [ "$MODE" = 'Depth' ] || [ "$MODE" = 'depth' ] || [ "$MODE" = 'DEPTH' ]
then
    lookup
    techstack_info
    subdomain_enum
    live_subdomain
    subdomain_takeover
        

elif [ "$MODE" = 'Light' ] || [ "$MODE" = 'light' ] || [ "$MODE" = 'LIGHT' ] 
then
    lookup
    techstack_info
    subdomain_enum
    live_subdomain
    

else
    echo -e "$Yellow ./CybRecon.sh -h for more info"
fi

echo -e "$GREENCOLOR [+] Succesfully Completed the Scan with CybRecon."
