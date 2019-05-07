all: hiveserver
hiveserver: build push clean
.PHONY: build push clean

SPARK_VER = 2.4.0
HADOOP_VER = 3.1.1
HIVE_VER = 3.1.1
SCALA_VER = 2.11
BASE_IMAGE = centos7.5.1804

HIVE_VERSION= 3.1.1
IMAGE_TAG = hive-$(HIVE_VERSION)

IMAGE_NAME = hiveserver
REGISTRY = docker.io
REPO = praves77

DOCKER = docker

build:
	$(DOCKER) build \
		--build-arg SPARK_VER=${SPARK_VER} \
		--build-arg HADOOP_VER=${HADOOP_VER} \
		--build-arg HIVE_VER=${HIVE_VER} \
		--build-arg SCALA_VER=${SCALA_VER} \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		-t $(REGISTRY)/$(REPO)/$(IMAGE_NAME) .
	$(DOCKER) tag $(REGISTRY)/$(REPO)/$(IMAGE_NAME) $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

push:
	$(DOCKER) push $(REGISTRY)/$(REPO)/$(IMAGE_NAME)
	$(DOCKER) push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

clean:
	$(DOCKER) rmi $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG) || :
	$(DOCKER) rmi $(REGISTRY)/$(REPO)/$(IMAGE_NAME) || :
