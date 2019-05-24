all: hiveserver
hiveserver: build push clean
.PHONY: build push clean

# Base image of the container
# BASE_IMAGE = centos:centos7.5.1804
BASE_IMAGE = openjdk:8-jre

SPARK_VER = 2.4.0
SCALA_VER = 2.11
# HADOOP_VER = 2.9.2
# HIVE_VER = 2.3.4
HADOOP_VER = 3.1.2
HIVE_VER = 3.1.1

# hive service's image and tag
IMAGE_NAME = hiveserver
IMAGE_TAG = hive-$(HIVE_VER)

# Container registry info
DOCKER = docker
REGISTRY = docker.io
REPO = praves77

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
	$(DOCKER) push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):latest
	$(DOCKER) push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

clean:
	# $(DOCKER) rmi $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG) || :
	# $(DOCKER) rmi $(REGISTRY)/$(REPO)/$(IMAGE_NAME):latest || :
