#! /usr/bin/env bash

# run this inside the Devilbox container
# ./shell.sh

# run this script
# chmod +x skitup.sh
# ./skitup.sh

# ask for dir to install to
clear
script_path="/shared/httpd/shell/skitup/"
script_path_files="/shared/httpd/shell/skitup/files/"
tsconfig_path_file="/shared/httpd/shell/skitup/tsconfig/"
jsconfig_path_file="/shared/httpd/shell/skitup/jsconfig/"
purejsconfig_path_file="/shared/httpd/shell/skitup/purejs/"

echo ""
echo ""
echo "Give your SvelteKit project a name."
echo ""
echo ""
read -r name

www_path="/shared/httpd"
project_path="$www_path/$name"

# echo $project_path

clear

echo ""
echo ""
echo " The SvelteKit project will be installed to.."
echo ""
echo ""
echo "$www_path/$name"
echo ""
echo "Ok to proceed? (y)"
echo ""
read -r option
clear

if [[ "$option" == "y" ]]; then
    # do something

    cd "$www_path" || exit 1

    mkdir "$name" || exit 1
    cd "$name" || exit 1

    # npm init svelte@next .

    npm init svelte .

    cd "$www_path/$name"

    npm install --verbose

    npm install --save-dev tailwindcss postcss autoprefixer @sveltejs/adapter-node@next @sveltejs/adapter-static@next env-cmd --verbose

    npx tailwindcss init tailwind.config.cjs -p

    mv postcss.config.js postcss.config.cjs

    # npm install --save-dev @sveltejs/adapter-node@next --verbose

    # npm install --save-dev env-cmd --verbose

    # copy /shared/httpd/SHELL/skit/files/ to project folder, this includes the .vscode folder with the settings.json file
    rsync -a "$script_path_files" . || exit 1


    # https://onlinelinuxtools.com/escape-shell-characters


    # replace exact SVELTE_KIT_PROJECT_PATH string in file .vscode/settings.json with project $name
    # https://askubuntu.com/a/1007368
    sed -i "s/SVELTE_KIT_PROJECT_PATH/$name/g" .vscode/settings.json


    # replace exact \"svelte-kit dev\" string in file package.json with "env-cmd svelte-kit dev"
    # https://askubuntu.com/a/1007368
    env_cmd_sveltekit_dev="\"env-cmd svelte-kit dev\""    
    sed -i "s/\"svelte-kit dev\"/$env_cmd_sveltekit_dev/g" package.json


    # replace exact \"svelte-kit build\" string in file package.json with "env-cmd svelte-kit build && ./copy.sh"
    env_cmd_sveltekit_build="\"env-cmd svelte-kit build \&\& \.\/copy.sh\""    
    sed -i "s/\"svelte-kit build\"/$env_cmd_sveltekit_build/g" package.json


    # add .vscode to .gitignore file
    # https://www.cyberciti.biz/faq/linux-append-text-to-end-of-file/
    echo ".vscode" >> .gitignore

    mv app.css ./src/app.css

    mv __layout.svelte ./src/routes/__layout.svelte

    mv index.svelte ./src/routes/index.svelte

    mv app.html ./src/app.html

    rm -rf .prettierrc

    # https://linuxize.com/post/bash-check-if-file-exists/

    # https://kit.svelte.dev/faq#aliases

    TSCONFIG=tsconfig.json

    JSCONFIG=jsconfig.json

    # for a project with Typescript support
    if test -f "$TSCONFIG"; then

        echo "$TSCONFIG exists"

        # copy /shared/httpd/SHELL/skit/tsconfig/ to project folder
        rsync -a "$tsconfig_path_file" . || exit 1
    fi

    # for a project with Type-checked JavaScript
    if test -f "$JSCONFIG"; then

        echo "$JSCONFIG exists"

        # copy /shared/httpd/SHELL/skit/jsconfig/ to project folder
        rsync -a "$jsconfig_path_file" . || exit 1

    fi

    # for a pure JavaScript project we still make the compiler aware of the path alias
    if [ ! -f "$TSCONFIG" ]; then

        echo "$TSCONFIG does not exist"

        if [ ! -f "$JSCONFIG" ]; then

            echo "$JSCONFIG does not exist"

            # copy /shared/httpd/SHELL/skit/purejs/ to project folder
            rsync -a "$purejsconfig_path_file" . || exit 1

        fi

    fi

    mkdir src/lib

    mkdir src/components

    echo "**************************************************************"
    echo "**************************************************************"
    echo ""
    echo "Done!"
    echo ""
    read -p "Press [Enter] key to EXIT..."
    clear     

else
    # do something else
    exit 1
fi