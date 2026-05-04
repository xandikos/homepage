BASEDIR=$(CURDIR)
OUTPUTDIR=$(BASEDIR)/site

SSH_HOST=rhonwyn.jelmer.uk
SSH_PORT=22
SSH_USER=jelmer
SSH_TARGET_DIR=/var/www/xandikos.org

html:
	mkdocs build
	$(MAKE) $(OUTPUTDIR)/manpage.html

$(OUTPUTDIR)/manpage.html: xandikos/man/xandikos.8
	man2html -r $< > $@

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

serve:
	mkdocs serve

publish: html

ssh_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR) --cvs-exclude

rsync_upload: ssh_upload

docker:
	docker build -t ghcr.io/xandikos/homepage .
	docker push ghcr.io/xandikos/homepage

.PHONY: html help clean serve publish ssh_upload rsync_upload docker
