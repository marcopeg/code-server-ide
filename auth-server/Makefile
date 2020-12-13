all: run

name ?= auth-passwd
registry ?= marcopeg
version ?= 0.0.7

image:
	$(call blue, "Building docker image...")
	docker build -t ${registry}/${name}:${version} -f Dockerfile .
	docker tag ${registry}/${name}:${version} ${registry}/${name}:latest
	$(MAKE) clean

run: image
	$(call blue, "Running Docker image locally...")
	docker run -i -t --rm -p 8080:8080 ${registry}/${name}:${version} 

publish: image
	$(call blue, "Publishing Docker image to registry...")
	docker tag ${registry}/${name}:${version} ${registry}/${name}:latest
	docker push ${registry}/${name}:${version} 
	docker push ${registry}/${name}:latest

clean: 
	@rm -f app 

define blue
	@tput setaf 6
	@echo $1
	@tput sgr0
endef
