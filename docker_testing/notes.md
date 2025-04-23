# Docker notes

##### Getting into image shell

1. `docker build .`

2. Get sha256 from output, 
   e.g. `58f28ec8c2185cd9824f36649ac4dcf884ee4eef7326a43419288a3563b33ba1`

3. `docker run -it 58f28ec8c2185cd9824f36649ac4dcf884ee4eef7326a43419288a3563b33ba1 /bin/bash`

##### Remove images

`docker rmi -f $(docker images -aq)`

##### Remove containers

`docker rm -vf $(docker ps -aq)`