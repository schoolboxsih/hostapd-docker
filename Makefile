IMGNAME = hostapd
IMGTAG = latest
WLAN_INT = wlp2s0
HOTSPOT_INT = w_ap_admin
CHANNEL = 11
.PHONY: all build test taglatest

all: build test
sloshed: kill delete

build:
	@docker build -t $(IMGNAME):$(IMGTAG) \
    --build-arg wlan_int=$(WLAN_INT) \
    --build-arg channel=$(CHANNEL) \
    --build-arg hotspot_int=$(HOTSPOT_INT) .

run:
	sudo docker run -t \
        --name $(IMGNAME)_run \
	-e INTERFACE=$(WLAN_INT) \
	-e CHANNEL=$(CHANNEL) \
	--privileged \
	--net host \
	$(IMGNAME):$(IMGTAG)

kill:
	@docker kill $(IMGNAME)_run

delete:
	@docker container rm $(IMGNAME)_run

push:
	docker push schoolboxsih/$(IMGNAME):$(VERSION)
