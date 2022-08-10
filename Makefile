-include .env

install: install.etc install.opt install.ser

install.etc:
	mkdir -p ${DIR_ETC}/docker-autostart/
	mkdir -p ${DIR_ETC}/docker-autostart/pre.d/
	touch ${DIR_ETC}/docker-autostart/buffer

install.opt:
	mkdir -p ${DIR_OPT}/docker-autostart/bin

	cat ./bin/pre | sed -e "s|DIR_PRE_D|${DIR_ETC}/docker-autostart/pre.d/*|g" > ./bin/pre.tmp
	cp ./bin/pre.tmp ${DIR_OPT}/docker-autostart/bin/pre
	rm ./bin/pre.tmp
	chmod +x ${DIR_OPT}/docker-autostart/bin/pre

	cat ./bin/start | sed -e "s|DIR_BUFFER|$(DIR_ETC)/docker-autostart/buffer|g" > ./bin/start.tmp
	cp ./bin/start.tmp ${DIR_OPT}/docker-autostart/bin/start
	rm ./bin/start.tmp
	chmod +x ${DIR_OPT}/docker-autostart/bin/start

	cat ./bin/stop | sed -e "s|DIR_BUFFER|$(DIR_ETC)/docker-autostart/buffer|g" > ./bin/stop.tmp
	cp ./bin/stop.tmp ${DIR_OPT}/docker-autostart/bin/stop
	rm ./bin/stop.tmp
	chmod +x ${DIR_OPT}/docker-autostart/bin/stop

install.ser:
	mkdir -p ${DIR_SER}
	cat ./service/docker-autostart.service | sed -e "s|DIR_OPT|$(DIR_OPT)/docker-autostart/bin|g" > ./service/docker-autostart.service.tmp
	cp ./service/docker-autostart.service.tmp ${DIR_SER}/docker-autostart.service
	rm ./service/docker-autostart.service.tmp
	chmod +x ${DIR_SER}/docker-autostart.service
	systemctl daemon-reload
	systemctl enable docker-autostart

install.example:
	cp ./pre.d/* ${DIR_ETC}/docker-autostart/pre.d/

.PHONY: install
