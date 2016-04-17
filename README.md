#Swarthmore Course Review (SwatCoRe)   [![Build Status](https://api.travis-ci.org/rrshaban/SwatCoRe.svg?branch=master)](https://travis-ci.org/rrshaban/SwatCoRe)

The production branch of this repo is auto-deployed to https://www.swatcoursereview.com/

Want to contribute? Contact swatcoreteam@gmail.com or submit an issue/pull request.

##Troubleshoot:
####Starting postgres
`postgres -D /usr/local/var/postgres`

####No file postmaster.pid
`pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`

####Starting server
If you see this:
	`start_tcp_server: no acceptor`,
do this:
	`ps ax | grep rails
	kill -9 [x]`
