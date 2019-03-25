## What is Docker? 

* Docker is a CLI tool, running on a __**host**__, that makes it easier to create, deploy and run applications by creating bundled environments with a minimal set of all the dependencies they need to run. This helps standardize an app's operation across different operating systems and development environments. 
* Accessed/managed through SSH - Secure Shell
  * AWS, Google Cloud, DigitalOcean
    * All utilize SSH as their primary means of 'logging in' to your cloud-based computer
  * Nothing more than an always-connected computer designed to host a web or app server
  
* [Virtual Machines vs Docker](https://www.docker.com/resources/what-container)


## How does docker do its thing?
Docker is nothing more than an application running on a host computer. From our perspective, it runs similarly on a cloud-platform as it does on your own computer. When you start a dockerized app on a host running docker, the container starts talking to docker-CLI, and docker-CLI knows how to translate that app's requests into something that the host operating system understands. 

This may not sound impressive at first, but imagine trying to run a Windows app on OSX. Or an OSX app on Windows. Or a linux app on either of the previous two. If your app is designed to run inside a docker container, then the docker CLI running on any of those computers will know how to translate the requests (made from inside the docker container) to a system-call that can actually be executed by the hardware that the OS is installed on. 

Fundamentally, this is __all__ that docker does. It translates the commands that your app sends into something that the host operating system can understand and execute. Its basically an enrormously complex API written for Windows, Linux and OSX.


* Images - aka “Classes” or templates
    * A “compiled” image made of layers defined by commands listed in a Dockerfile
* Containers - aka “instances” or running programs
    * An instance of an image
    * Populated with environment variables necessary to run the image for you

## 


In order to use docker as a developer, its important to understand how to use containers before we attempt to create one.

### Practice - Using a pre-made docker image: DuckDNS

DuckDNS is a free service that keeps your computer’s IP address publicly available. This is important because most ISPs will change your IP address if you ever have a power outage or service interruption. DuckDNS will let you select a subdomain (the 'xxx' part of xxx.duckdns.org) that will __always__ point to the IP address of your computer. 

This service can be combined with OpenVPN-AS (which is available as another docker image at www.dockerhub.com) to create an automatically-updating vpn server. This will provide you access to whatever network your laptop/computer is on, as if you were connected to the same router/wifi that your laptop/computer’s local network is connected to. 

Lets get started.

1. DuckDNS - www.duckdns.org
    * Sign up / register account
    * Acquire api token
    * Create unique subdomain
    * In your terminal:
      ```  
      mkdir duckdns
      cd duckdns
      docker pull linuxserver/duckdns
      ```
    * This will download the pre-built layers of the duckdns image from linuxserver’s repo to your local machine. All of these layers together make up this app. NOTE: Docker handles the downloading and storage of all of its images independently. The image you download will NOT be present in this directory, docker will manage it. You can view all of the images you have downloaded to your machine (globally) with the command:
      ```
      docker image ls
      ```
    * Next up is making a container from that image using your issued token and chosen subdomain. To do this we will make a shell script that will automate this for us in the future, this will let us update/rebuild the container periodically to include the latest security updates. 
      ```
      touch create_duckdns_container.sh
      code create_duckdns_container.sh
      ```
    * Copy/Paste the following into this shell script, making sure to enter [YOUR_TOKEN] and [YOUR_SUBDOMAIN]:
      ```
      # Stop currently running container and remove it
      docker stop duckdns; exit 0;
      docker rm duckdns; exit 0;

      # Create a new container (an instance made from the most recently downloaded image) with YOUR personal variables, but don’t run it yet
      docker create \
      --name=duckdns \
      -e TZ=America/Los_Angeles \
      -e SUBDOMAINS= [YOUR_TOKEN] \
      -e TOKEN=[YOUR_TOKEN] \
      -e LOG_FILE=false \
      --restart unless-stopped \
      linuxserver/duckdns
      ```
    * Here we are using the docker cli to create a new __container__. We could just enter that command, line by line everytime we want to rebuild our image, but making this into a shell script makes this process much faster and less error prone. 
    * This script tells the shell to:
      * Stop any previously running containers that we have named ‘duckdns’ (we haven’t made any yet, but this command will future-proof our script after we’ve started our first container).
      * Remove any previous containers that we have made called “duckdns” (again, future-proofing)
      * Create/build a new container with the listed parameters (i.e. your timezone, subdomain and token).
      * Its important to recognize that this is where you 'pass in' any variables relevant to **your** container. Some containers, like this one, require you to pass in certain variables for the app do to something, some images are built to run 'as-is' and dont require this. It depends on the app and how the developer built the image. Each repo will have its own usage instructions on what variables you can pass into a container and you should always read the docs.
    * Lastly, when we ‘touched’ this script, our shell made this file without execution privileges by default. That means that it can be read and/or written to, but not executed as a program. We need it to be executed, so you can explicitly permit this with:
      ```
      sudo chmod +x create_duckdns_container.sh
      ```
    * Now the script can be executed, and we can see the built container with 
      ```
      ./create_duckdns_container.sh     # run the script
      docker ps -a                      # list all containers, '-a' means 'all', both running and stopped
      ```
    * You can now start your container, which will run continuously unless manually stopped, with the command:
      ```
      docker start duckdns
      ```
    * And can be stopped with:
      ```
      docker stop duckdns
      ```
    * To see any terminal output occuring INSIDE this docker container, you can run:
      ```
      docker logs duckdns
      ```
    * Step one is complete! Your docker container will now update [YOUR_SUBDOMAIN].duckdns.org every 5 minutes.


Next steps:

Only having a couple days to put this lesson together, I wasnt able to create a project that we could "build" together. In lieu of creating a project myself, I vetted a tutorial that I find very useful and helpful [here](*https://docker-curriculum.com/#webapps-with-docker).

Start reading up on this tutorial and I'll be around to help in case you get stuck.
