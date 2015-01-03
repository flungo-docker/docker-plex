# Define some variables allowing configuration
PLEX_IMAGE:=plex
PLEX_BUILD_OPTIONS:=
PLEX_BUILD_DIR:=.
PLEX_BUILD_DEPENDENCIES:=Dockerfile start.sh .dockerignore
PLEX_RUN_OPTIONS:=
PLEX_HOSTNAME:=
PLEX_CONFIG:=
PLEX_DATA:=
PLEX_BIND:=32400

# Build PLEX_BUILD_OPTIONS
override PLEX_BUILD_OPTIONS+=-t $(PLEX_IMAGE)

# Plex only likes absolute paths for VOLUMES
override PLEX_CONFIG:=$(realpath $(PLEX_CONFIG))
override PLEX_DATA:=$(realpath $(PLEX_CONFIG))

# Build PLEX_RUN_OPTIONS
override PLEX_RUN_OPTIONS+=--detach
ifneq ($(PLEX_HOSTNAME),)
	PLEX_RUN_OPTIONS+=--hostname $(PLEX_HOSTNAME)
endif
ifneq ($(PLEX_CONFIG),)
	PLEX_RUN_OPTIONS+=--volume $(PLEX_CONFIG):/config
endif
ifneq ($(PLEX_DATA),)
	PLEX_RUN_OPTIONS+=--volume $(PLEX_DATA):/data
endif
ifneq ($(PLEX_BIND),)
	PLEX_RUN_OPTIONS+=--publish $(PLEX_BIND):32400
endif

.PHONY: build run

build: .build

.build: $(PLEX_BUILD_DEPENDENCIES)
	docker build $(PLEX_BUILD_OPTIONS) $(PLEX_BUILD_DIR)
	touch .build

run: build
	docker run $(PLEX_RUN_OPTIONS) $(PLEX_IMAGE)

all: run
