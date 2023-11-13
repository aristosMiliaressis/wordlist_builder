#!/bin/bash

if [ $# -eq 0 ]
then
	echo "USAGE: $0 [output_dir]"
	exit 1
fi

out_dir=$1
mkdir -p $out_dir/tech/
cd $out_dir
out_dir=`pwd`

tmp_dir=`mktemp -d`
trap "rm -rf $tmp_dir" EXIT

cd $tmp_dir

git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/assetnote/commonspeak2-wordlists
wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH

general=(
	"https://raw.githubusercontent.com/danielmiessler/RobotsDisallowed/master/top10000.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/raft-medium-files.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallshort.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/wellknown_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/ws-dirs_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/web-files_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/common-api-endpoints_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/graphql_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/jar_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/nginx_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/swagger_short.txt"
)

high_impact_lists=( 
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/swagger.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/config_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/git_config_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/htaccess_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/ini_long.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/apache.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/nginx_short.txt"
	"https://raw.githubusercontent.com/SooLFaa/fuzzing/master/webserver/iis.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/UnixDotfiles.fuzz.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/bak.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/Common-DB-Backups.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/hashicorp-vault.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/hashicorp-consul-api.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-ASP.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-JSP.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-PHP.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/CommonBackdoors-PL.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/vulnerability-scan_j2ee-websites_WEB-INF.txt"
	"https://raw.githubusercontent.com/aristosMiliaressis/wordlist_builder/master/temp/high-impact-files.txt"
	"https://raw.githubusercontent.com/aristosMiliaressis/wordlist_builder/master/temp/high-impact-endpoints.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/zip_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/sql_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/rar_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/env_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/common-db-backups_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/conf_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/k8s_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/mdb_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/mdf_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/reverse-proxy-inconsistencies_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/proxy-conf_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/debug_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/jar_short.txt"
)

file_lists=(
	"https://wordlists-cdn.assetnote.io/data/manual/raft-medium-files.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/xml_filenames.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_xml_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_txt_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_html_htm_2023_06_28.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/yaml_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/yml_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/txt_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/tpl_short.txt"
)

directory_lists=(
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-directories.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-lowercase-2.3-big.txt"
	#"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/KitchensinkDirectories.fuzz.txt"
)

iis_asp_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_aspx_asp_cfm_svc_ashx_asmx_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/asp_lowercase.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/aspx_lowercase.txt"
	"https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/master/wordswithext/aspx.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/IIS.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/iis-systemweb.txt"
	"https://raw.githubusercontent.com/SooLFaa/fuzzing/master/webserver/iis.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/windows-asp_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/windows-aspx_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/wsdl_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/webconfig_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/svc_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/sln_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/csproj_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/pdb_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/ashx_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/asmx_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/ascx_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/asax_short.txt"
)
tomcat_jsp_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_jsp_jspa_do_action_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/do.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/jsp.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/tomcat.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/ApacheTomcat.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/WebTechnologyPaths-Trickest-Wordlists/tomcat-all-levels.txt"
	"https://raw.githubusercontent.com/aristosMiliaressis/wordlist_builder/master/temp/tomcat-examples.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/springboot_short.txt"
)
apache_php_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_php_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_cgi_pl_2023_06_28.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/php.txt"
	"https://wordlists-cdn.assetnote.io/data/manual/pl.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/Apache.fuzz.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/apache.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/symphony_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/drupal_long.txt"
)
django_wordlists=(
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/django_long.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/py_short.txt"
)
flask_wordlists=(
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/py_short.txt"
)
nginx_wordlists=(
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/nginx.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/nginx_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/swagger_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/reverse-proxy-inconsistencies_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/proxy-conf_short.txt"
)
rails_wordlists=(
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/ror.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/ruby_rails_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/ror_short.txt"
	"https://raw.githubusercontent.com/six2dez/OneListForAll/main/dict/rails_short.txt"
)

api_wordlists=(
	"https://wordlists-cdn.assetnote.io/data/automated/httparchive_apiroutes_2023_06_28.txt"
	"https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/api/api-endpoints.txt"
)

read_from_stdin() {
	while read line
	do
	  echo "$line"
	done < "${1:-/dev/stdin}"
}

normalize_prefix() {
	read_from_stdin | sed 's/\r\n/\n/g' | sed 's/\n\//\n/g'
}

filter_junk() {
	#| LC_ALL='en_US.UTF-8' rev | cut -d '/' -f 1 | cut -d '\' -f 1 | LC_ALL='en_US.UTF-8' rev \
	read_from_stdin \
		| grep -iP '^[A-Z0-9\._\- \(\)/~]+$' \
		| grep -Ev '.{100,}' \
		| grep -v '\.\.' \
		| grep -v '\.\/' \
		| grep -v '\- ' \
		| filter_recursive_deadends \
		| awk '!x[$0]++'
}

filter_files() {
	read_from_stdin \
		| grep -Ev '\.(css|js|png|jpg|jpeg|woff|gif|ico|ttf|woff2|eot|pdf)' 2>/dev/null
}

grep_high_impact_extensions() {
	grep -hirE '\.(log|ovpn|bz2|tgz|bzip2|pem|crt|key|gzip|settings|setting|passwd|sh|pac|swp|sav|bak|backup|tar|zip|7z|gz|lz|xz|z|rar|war|db|sqlite|sqlitedb|sqlite3|mdb|sql|ini|cfg|conf|config|properties|ppk|env|rdp|pgp|psql)~?$' \
		| filter_junk
}

grep_all_extensions() {
	grep -hirE '\.(log|bz2|tgz|bzip2|pac|key|gzip|txt|inc|passwd|out|pac|swp|sav|lst|bak|backup|bkpold|tar|zip|7z|gz|rar|iso|db|sqlite|sqlite3|mdb|sql|ini|conf|cfg|config|properties|json|xml|dtd|xslt|yml|yaml|csv|dat|xls|xlsx|pem|crt|ppk|sh|exs|env|tpl|swf|reg|rdp|pwl|pub|old|cache|pgp|psql|site|dtd|xslt|war|default|bkp|sav|lst|img|cur|ai|data|bat|bin|msi|tmp|eml|epl|ssi|ssf)~?$' \
		| filter_junk
}

filter_recursive_deadends() {
	read_from_stdin \
		| grep -Eiv '^(img|image|images|font|fonts|css|style|styles|resources|assets)[\/]*$'
}

lowercase() {
	read_from_stdin | tr '[:upper:]' '[:lower:]' | awk '!x[$0]++'
}

filter_duplicates() {
	temp=`mktemp`
	cat $1 | awk '!x[$0]++' > $temp
	cat $temp > $1
	rm $temp
}

deduplicate() {
	temp=`mktemp`
	cat $2 > $temp
	cat $1 | anew -q $temp
}

export -f read_from_stdin
export -f normalize_prefix
export -f filter_junk
export -f filter_files
export -f grep_high_impact_extensions
export -f grep_all_extensions
export -f filter_recursive_deadends
export -f filter_duplicates
export -f deduplicate

echo "${high_impact_lists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | filter_junk | anew -q $out_dir/high_impact.txt"

grep_high_impact_extensions | anew -q $out_dir/high_impact.txt
filter_duplicates $out_dir/high_impact.txt

cat $out_dir/high_impact.txt | lowercase > $out_dir/high_impact_lowercase.txt

echo "${file_lists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | anew -q $out_dir/large_files.txt"

grep_all_extensions | anew -q $out_dir/large_files.txt
filter_duplicates $out_dir/large_files.txt
#deduplicate $out_dir/large_files.txt $out_dir/high_impact.txt > $out_dir/dedublicated_large_files.txt

echo "${directory_lists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | filter_recursive_deadends | filter_files | anew -q $out_dir/directories.txt"

filter_duplicates $out_dir/directories.txt

cat $out_dir/directories.txt | lowercase > $out_dir/directories_lowercase.txt

echo "${iis_asp_wordlists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | anew -q $out_dir/tech/iis_asp.txt"

 grep -a -hirE '\.(asp|aspx|ashx|asmx|wsdl|wadl|axd|asax)$' \
	| filter_junk >>  $out_dir/tech/iis_asp.txt
filter_duplicates $out_dir/tech/iis_asp.txt

echo "${tomcat_jsp_wordlists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | anew -q $out_dir/tech/tomcat_jsp.txt"

grep -a -hirE '\.(jsp|jspa|do|action)$' \
	| filter_junk  >>  $out_dir/tech/tomcat_jsp.txt
filter_duplicates $out_dir/tech/tomcat_jsp.txt

echo "${apache_php_wordlists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | anew -q $out_dir/tech/apache_php.txt"

grep -a -hirE '\.(php|cgi)$' \
	| filter_junk  >>  $out_dir/tech/apache_php.txt
filter_duplicates $out_dir/tech/apache_php.txt

echo "${nginx_wordlists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | anew -q $out_dir/tech/nginx.txt"
filter_duplicates $out_dir/tech/nginx.txt

echo "${django_wordlists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | anew -q $out_dir/tech/django.txt"
filter_duplicates $out_dir/tech/django.txt

# # for list in "${flask_wordlists[@]}"
# # do
	# # temp=`mktemp`
	# # curl -s $list -o $temp
	# # cat $temp | normalize_prefix | filter_junk | anew -q $out_dir/tech/flask.txt
	# # rm $temp
# # done
# # filter_duplicates $out_dir/tech/flask.txt

# # for list in "${express_wordlists[@]}"
# # do
	# # temp=`mktemp`
	# # curl -s $list -o $temp
	# # cat $temp | normalize_prefix | filter_junk | anew -q $out_dir/tech/express.txt
	# # rm $temp
# # done
# # filter_duplicates $out_dir/tech/express.txt

echo "${rails_wordlists[@]}" \
	| tr  ' ' '\n' \
	| parallel -j+0 "curl -s {} | normalize_prefix | filter_junk | anew -q $out_dir/tech/rails.txt"
filter_duplicates $out_dir/tech/rails.txt

cd - >/dev/null
