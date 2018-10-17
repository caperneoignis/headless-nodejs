# Docker image with headless Chrome, Jenkins slave, and Node 8

Ideal for running end-to-end integration tests in CI using jenkins and kubernetes.

    docker run -itv $PWD:/tests caperneoignis/headless-nodejs

This will open a bash prompt where you can `npm install && npm test` or whatever.

## Browsers

Start Chrome with `google-chrome --headless --disable-gpu --no-sandbox`.

### Warning

Headless Chrome currently requires the `--no-sandbox` flag in order to run in a container. 
This is potentially unsafe so you should not use it on untrusted sites. 

## Other software

Image includes `yarn`, `git` and `build-essential` required for building native NPM modules.

## Kubernetes

If using Kubernetes plugin with Jenkins to run Jenkins slaves, you can input this image as you would openshift containers of the same purpose. This should run the commands as a Jenkins slave would in a normal 'bare-metal' setup. So your Jenkins pipeline files only need to be updated with the associated tag you applied to the container template in the gobal configuration. 
