.PHONY: appraisal bundle config test

appraisal:
	@bundle exec appraisal install

bundle:
	@bundle install

config: appraisal bundle
	@dropdb --if-exists rein_test
	@createdb rein_test

test:
	@bundle exec rake test
