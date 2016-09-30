# Symcon



## An Symcon installation running on Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/tommi2day/symcon.svg)](https://hub.docker.com/r/tommi2day/symcon/)


Description: http://www.symcon.de

Docker Sources: https://github.com/Tommi2Day/ipsymcon-docker

### Build

You need to handover the apt repository branch of symcon ("stable", "beta" or "testing") 
to the dockerfile as build argument VERSION
```
rel=${1:-testing}
git clone https://github.com/Tommi2Day/ipsymcon-docker.git
cd ipsymcon-docker
docker build --build-arg VERSION=$rel -t tommi2day/symcon:$rel .
```

### Volumes
* /var/lib/symcon
* /var/log/symcon
* /root

### exposed Ports
* 3777 
* 82

### Run on Unix

```sh
rel=${1:-testing}
docker run -d\
  -v "./work":/var/lib/symcon \
  -v "./log":/var/log/symcon \
  -v "./root":/root \
  --hostname symcon \
  --name symcon \
  -p 3777:3777 \
  tommi2day/symcon:$rel
```

### Run on Windows
As of writing, you cannot share /var/log/symcon on windows 
because symcon tries to create a symlink and failed there. 
To remedy this issue you may create a docker data container
```
rel=${1:-testing}
docker create  \
  -v /var/log/symcon \
  -v /var/lib/symcon \
  -v /root \
  --name symcon_data_$rel \
  tommi2day/symcon:$rel /bin/true
	
docker run -d \
  --volumes-from symcon_data_$rel \
  --hostname symcon \
  --name symcon \
  -p 3777:3777 \
  tommi2day/symcon:testing
```

### Maintenance
You have access to the container using standard docker commands. 

* change remote access password
    ```
    docker exec -it symcon set_password.sh
    ```
    then restart the container

* show logfiles
    ```
    docker exec -it symcon cat /var/log/logfile.log
     ```