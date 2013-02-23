all: coffee compass copy

coffee:
	@echo "\n# compile coffeescripts"
	node_modules/.bin/coffee --compile --output www/compiled/js src/coffee;

compass:
	@echo "\n# compile css with compass"
	cd src; compass clean; compass compile --force; cd -;

copy:
	@echo "\n# copy files to www folder"
	mkdir -p www
	cp src/index.html www


################
# LOCAL SERVER #
################

server:
	@echo "\n# run server"
	cd www; python -m SimpleHTTPServer 5000; cd -;

weinre:
	@echo "\n# run weinre debug server on port 7000"
	npm install weinre
	node node_modules/weinre/weinre --boundHost -all- --verbose true --httpPort 7000 --reuseAddr true --readTimeout 1 --deathTimeout 5


#################
# WATCH CHANGES #
#################

watch:
	@echo "\n# watch coffee-script and compass FOR THE ENGLISH VERSION!"
	node_modules/.bin/coffee --compile --watch --output www/compiled/js src/coffee &
	cd src; compass watch; cd -;



