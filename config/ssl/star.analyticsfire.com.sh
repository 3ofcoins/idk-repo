
#!/bin/sh
set -e -x
[ -f star_analyticsfire_com.key ] || openssl genrsa -out star_analyticsfire_com.key 2048
[ -f star_analyticsfire_com.csr ] || openssl req -new -text -out star_analyticsfire_com.csr -key star_analyticsfire_com.key -config star_analyticsfire_com.cnf
[ -f star_analyticsfire_com.crt ] || openssl x509 -req -days 3650 -text -extensions v3_req \
    -extfile star_analyticsfire_com.cnf -in star_analyticsfire_com.csr -signkey star_analyticsfire_com.key -out star_analyticsfire_com.crt
ruby -rjson -e 'puts JSON[{common_name:"*.analyticsfire.com"}.merge(Hash[Dir["star_analyticsfire_com.*"].reject { |f| f =~ /(~|\.json)$/ }.map {|fn| [fn.sub("star_analyticsfire_com.",""), File.read(fn)]}])]' > star_analyticsfire_com.json
