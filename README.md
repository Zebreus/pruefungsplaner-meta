# pruefungsplaner-meta
This project manages the parts of the pruefungsplaner

## Application structure
The pruefungsplaner consists of three services ([backend](https://github.com/Zebreus/pruefungsplaner-backend), [auth](https://github.com/Zebreus/pruefungsplaner-auth), [scheduler](https://github.com/Zebreus/pruefungsplaner-scheduler) )and the [frontend](https://github.com/Zebreus/pruefungsplaner). They communicate via jsonrpc an authenticate with signed json web tokens.

There also is a [simple commandline client to retrieve scheduled plans from the backend](https://github.com/Zebreus/pruefungsplaner-cli).

The definiton of the shared datamodel is stored in [a seperate repository](https://github.com/Zebreus/pruefungsplaner-datamodel)

## Running the application

### Start the prufungsplaner
To start the pruefungsplaner just run
```bash
docker-compose up
```
This will start a webserver on (http://localhost:80) with the pruefungsplaner and all required services.

You can add `-d` to that command to start in background.
If you want to use an encrypted connection, try an reverse proxy like traefik.

### Use the pruefungsplaner
Visit (http://localhost:80) and use the interface.

### Stop the pruefungsplaner
Use
```bash
docker-compose down
```
to stop the pruefungsplaner.

### Persistent data
By default all data is gone, when you down the docker container. To prevent this you can set the storage directory to your mounted working directory by adding `--storage /data` to the backend options in [docker-compose.yml](docker-compose.yml).

### Initial data
To load initial csv files that are in `./initialFiles` add `--initial-files /data/initialFiles` to the backend options.

### Retrieve csv files
You can retrieve the scheduled csv files with the cli, try for help

```bash
docker run --rm -it madmanfred/pruefungsplaner-cli --help
```

### Configuration options
You can add commandline options to the services in the dockerfile.

All pruefungsplaner services support a `--help` option to describe all available options. 
```bash
# Commands to list options for the services
docker run --rm -it madmanfred/pruefungsplaner-backend --help
docker run --rm -it madmanfred/pruefungsplaner-auth --help
docker run --rm -it madmanfred/pruefungsplaner-scheduler --help
```
All options can also be set via a configuration file, a example for these is in the git repository for each service.

The frontend can be configured with the URLs for the backend services via environment variables. See `docker-compose.yml` for an example.

## CI/CD pipeline
CI/CD is done with [concourse](https://concourse-ci.org/).

### Setup pipeline
Setting up the pipeline is quite easy.

#### Set docker credentials
Set your [dockerhub](https://hub.docker.com/) username and password in `credentials.yaml` and define the names of the containers that will be pushed. You also have to create the containers on dockerhub, before you can run them.

#### Set git credentials
Check the git urls in `credentials.yaml` and set ssh keys with permissions to read and write. If you can only pull from the git repos, the integration probably wont work, you should fork thos repos.

#### Deploy pipeline
If you already have a concourse server just deploy the pipeline with credentials.yml:

```
fly -t YOUR_LOGIN set-pipeline -p pruefungsplaner -c pipeline.yml --check-creds --load-vars-from credentials.yml
```

##### Local concourse server
If you dont have a concourse server you can quickly start one with docker-compose, as described in the concourse [quickstart](https://concourse-ci.org/quick-start.html). This basically boils down to:
```bash
mkdir -p concourse-ci && cd concourse-ci
wget https://concourse-ci.org/docker-compose.yml
docker-compose up -d
cd ..
```

Then you download the fly executable from (http://localhost:8080) and login and deploy the pipeline
```bash
fly -t test login -c http://localhost:8080 -u test -p test
fly -t test set-pipeline -p pruefungsplaner -c pipeline.yml --check-creds --load-vars-from credentials.yml
```

### Continous testing
The pipeline runs automated tests for all projects with tests

### Continous integration
The pipeline detects updates in git repos that are included as submodules in the project. For example if you update pruefungsplaner-datamodel, which is a submodule of pruefungsplaner-backend, it will be automatically updated there as well, if it does not break any tests.

### Continous deployment
The pipeline automatically produces and uploades docker containers to the tags specified in `credentials.yaml`.
