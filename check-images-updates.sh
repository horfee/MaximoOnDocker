#!/bin/bash

compare_version () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

skopeo_version=$(skopeo -v)
if [[ $? -gt 0 ]]; then
    sudo apt update
    sudo apt install -f skopeo
fi

dockerFile=$1
images=($(sed -n -e 's/^FROM\s*\(.*\)\s*[aA][sS]\s\s*\w*/\1/p' $dockerFile))


update_images=()

for image in ${images[@]}
do
    img=(${image//:/ })
    img=${img[0]}
    currentversion=(${image//:/ })
    currentversion=${currentversion[1]}

    echo "Checking versions for image $img (current version : $currentversion)"
    versions=$(skopeo list-tags docker://$img | jq .Tags[])
    elligibleversions=()
    for version in ${versions[@]}
    do
        version=${version//\"/}
        if [[ "${version}" == *"_"* ]]; then 
            continue
        fi
        
        compare_version $currentversion $version
        if [[ $? == 2 ]]; then
            elligibleversions+=($version)
        fi
    done
    available_versions=$(IFS=, ; echo "${elligibleversions[@]}")
    
    update_choice=
    if [[ ${#elligibleversions[@]} == 0 ]]; then
        update_choice=n
    else
        echo "New versions available : $available_versions"
    fi
    
    while [[ -z "${update_choice}" ]];
    do
        echo -n "Do you want to update it ? [o/N] "
        read update_choice
        if [[ -z "${update_choice}" ]]; then
            update_choice=n
        fi

        if [[ "oOnN" != *"${update_choice}"* ]]; then # != "o"]] && [[ "${update_choice}" != "O" ]] && [[ "${update_choice}" != "n"]] && [[ "${update_choice}" != "N" ]]; then
            echo "invalid choice"
            update_choice=
        fi
    done

    if [[ "oO" == *"${update_choice}"* ]]; then # == "o"]] || [[ "${update_choice}" == "O" ]]; then
        desired_version=
        while [[ -z "${desired_version}" ]];
        do
            echo -n "type in the desired version : "
            read desired_version
            if [[ ! "${elligibleversions[@]}" == *"${desired_version}"* ]]; then
                echo "Invalid version number"
                desired_version=
            fi
        done
        update_images+=("${img}:${currentversion}:${desired_version}")
    fi
done

for update_image in "${update_images[@]}"
do
    params=(${update_image//:/ })
    image=${params[0]}
    actual_version=${params[1]}
    new_version=${params[2]}

    echo "Processing image $image"
    sed -i -e "s/^FROM\s*${image//\//\\/}:$actual_version\s*\([aA][sS]\s\s*\w*\)/FROM ${image//\//\\/}:$new_version \1/" $dockerFile
done
