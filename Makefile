
install:
	docker run -ti --rm --name=snowball -v $(PWD):/root --workdir=/root node:16-alpine sh -c 'apk add --no-cache git; yarn install'

deps:
	docker network inspect dev >/dev/null 2>&1 || docker network create dev
	docker inspect --type=container mongo >/dev/null 2>&1 || docker run -d --rm --name=mongo --net=dev -p 27017:27017 docker.io/mongo:4.4.18
	docker inspect --type=container mongo-express >/dev/null 2>&1 || docker run -d  --rm --name=mongo-express --net=dev -p 8081:8081 -e ME_CONFIG_MONGODB_SERVER=mongo docker.io/mongo-express

run-dev: deps
	docker run -ti --rm --name=snowball --net=dev -v $(PWD):/root --workdir=/root -p 3000:3000 docker.io/node:16-alpine yarn run dev

clean:
	docker run -ti --rm -v $(PWD):/root --workdir=/root node:16-alpine yarn cache clean
	rm -rf node_modules/
	rm -rf .next/
	docker rm -ivf mongo mongo-express
	docker network rm -f dev
