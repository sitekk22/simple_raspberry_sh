#!/bin/bash
help_triggered=false

quit(){
	kill $$
	exit
}

if [[ "$1" == "-h" || "$1" == "--help" ||  -z "$1" ]]; then
	help_triggered=true
	echo "  First arugment- build directory path"
	echo "  Second argument- project name"
	echo "  Third argument- Raspberry Pi path"
	quit
fi


if ! [ -d $1 ]; then
	echo "$1 is not valid directory"
	quit		
fi


if [[ -z $2  && "$help_triggered" != true ]]; then
	echo "Specify project name as second command line argument"
	quit
fi


if [ -z $3 ] && [ "$help_triggered" != true ]; then
	echo "Specify Raspberry Pi path as third command line argument"
	quit
fi

make -C "$1" 1>/dev/null

clear

upload_file(){
	if ! [[ -a "$1$2.uf2" ]]; then
		echo "$2 is not valid project name, make sure it's name without .uf2"
		quit
	fi
	
	if [ -d $3 ]; then
		echo -e "\nUPLOADING"
	fi 
	
	cp "$1$2.uf2" $3 2>/dev/null

}


trap quit SIGINT

until upload_file "$1" "$2" "$3"
do
    clear
    upload_file "$1" "$2" "$3"
    echo -e "Enter bootloader on RPI\nPress CTRL+C to exit"
    
    sleep 0.1
done
echo "DONE"
quit


