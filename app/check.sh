#while true; do
    if [[ $(docker ps --filter "name=gimp-app" | grep Up) ]]; then 
        echo "success"
    else 
        echo "no"
    fi;
#    sleep 1;
#    clear;
#done;