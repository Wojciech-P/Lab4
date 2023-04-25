#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --date) echo "$(date)"; exit 0;;
        --logs) 
            if [[ $# -eq 1 || $2 =~ ^-?[0-9]+$ && $2 -le 100 && $2 -gt 0 ]]; then
                if [[ $# -eq 1 ]]; then
                    num_of_logs=100
                else
                    num_of_logs=$2
                fi
                for (( i=1; i<=$num_of_logs; i++ ))
                do
                    echo "log$i.txt created by $0 on $(date)" > log$i.txt
                done
                exit 0
            else
                echo "Error: Invalid argument"
                exit 1
            fi;;
        --help) echo "Usage: $0 [OPTIONS]
        --date     display today's date
        --logs     create 100 log files
        --logs N   create N log files, where N is an integer between 1 and 100
        --help     display this help message"
                exit 0;;
        *) echo "Error: Invalid option. Try --help for more information."
           exit 1;;
    esac
    shift
done

branch_name=$(date +%Y-%m-%d-%H-%M-%S)
git checkout -b $branch_name

echo "*log*" > .gitignore

git add .gitignore
git commit -m "Add .gitignore file"
git push --set-upstream origin $branch_name

git checkout main
git merge $branch_name

git tag v1.0
