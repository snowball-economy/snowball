
NODEJS_IMG := docker.io/node:18-alpine
MONGO_IMG := docker.io/mongo:4.4.18
MONGOEXPRESS_IMG := docker.io/mongo-express

install:
	docker run -ti --rm --name=snowball -v $(PWD):/root --workdir=/root $(NODEJS_IMG) sh -c 'apk add --no-cache git; yarn install'

upgrade:
	docker run -ti --rm --name=snowball -v $(PWD):/root --workdir=/root $(NODEJS_IMG) sh -c 'apk add --no-cache git; yarn upgrade'

dev:
	docker network inspect dev >/dev/null 2>&1 || \
		docker network create dev
	docker container inspect mongo >/dev/null 2>&1 || \
		docker run -d --rm --name=mongo --net=dev -p 27017:27017 $(MONGO_IMG)
	docker container inspect mongo-express >/dev/null 2>&1 || \
		docker run -d  --rm --name=mongo-express --net=dev -p 8081:8081 -e ME_CONFIG_MONGODB_SERVER=mongo $(MONGOEXPRESS_IMG)

run-dev: dev
	docker run -ti --rm --name=snowball --net=dev -p 3000:3000 -v $(PWD):/root --workdir=/root $(NODEJS_IMG) yarn run dev


# Cleanup
devclean:
	- docker rm -ivf mongo mongo-express
	- docker network rm -f dev

clean: devclean
	- docker run -ti --rm -v $(PWD):/root --workdir=/root $(NODEJS_IMG) yarn cache clean
	- rm -rf node_modules/ .next/ .npm/
