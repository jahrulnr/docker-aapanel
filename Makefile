VMTag=vm:1.0
VMName=vm

build-vm:
	docker build ./vm/ --tag ${VMTag}
up-vm: build-vm
	docker-compose up --build -d && docker-compose logs -f
down-vm:
	docker-compose down --remove-orphans
clean-vm: down-vm
	docker rmi -f $(shell docker images -q ${VMTag})
bash-vm:
	docker exec -it ${VMName} bash

prune-images:
	docker image prune -a