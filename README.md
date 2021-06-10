# pruefungsplaner-meta
This project manages the parts of the pruefungsplaner

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

